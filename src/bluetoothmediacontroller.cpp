/*
    bluetoothmediacontroller.cpp

    Class definition for BluetoothMediaController.
*/

#include "bluetoothmediacontroller.h"
#include <iostream>

BluetoothMediaController::BluetoothMediaController(QObject *parent)
    : QObject(parent),
    m_playing(false),
    m_duration(0),
    m_position(0),
    systemBus(QDBusConnection::systemBus()),
    m_mediaPlayerInterface(nullptr),
    m_mediaInfoInterface(nullptr),
    m_deviceInterface(nullptr)
{
    // init system dbus connection
    if (!systemBus.isConnected())
    {
        std::cerr << "Cannot connect to the D-Bus system bus" << std::endl;
        emit errorOccurred("Cannot connect to the D-Bus system bus");
        return;
    }

    // this sets all values to default for non connected
    disconnectDevice();

    // set up timer to periodically update status
    connect(&updateTimer, &QTimer::timeout, this, &BluetoothMediaController::updatePlaybackStatus);
    updateTimer.start(1000); // update every second

    connect(this, &BluetoothMediaController::errorOccurred, this, &BluetoothMediaController::internalErrorHandle);

    threadWorker.moveToThread(&networkThread);
    networkThread.start();

    // attempt to connect to last device
    QSettings settings("config.ini", QSettings::IniFormat);
    QString lastDevice = settings.value("Bluetooth/LastConnectedDevice", "").toString();
    if (!lastDevice.isEmpty())
        connectToDevice(lastDevice);
}

BluetoothMediaController::~BluetoothMediaController()
{
    networkThread.quit();
    networkThread.wait();

    delete m_mediaPlayerInterface;
    delete m_mediaInfoInterface;

    updateTimer.stop();
}

bool BluetoothMediaController::isConnected() const
{
    return m_connected;
}

// Playback control methods
void BluetoothMediaController::play()
{
    if (!m_connected)
        return;

    QDBusReply<void> reply = m_mediaPlayerInterface->call("Play");

    if (reply.isValid())
    {
        std::cout << "Play command sent successfully." << std::endl;
        m_playing = true;
        emit playingChanged();
    }
    else
    {
        emit errorOccurred(reply.error().message());
    }
}

void BluetoothMediaController::pause()
{
    if (!m_connected)
        return;

    QDBusReply<void> reply = m_mediaPlayerInterface->call("Pause");

    if (reply.isValid())
    {
        std::cout << "Pause command sent successfully." << std::endl;
        m_playing = false;
        emit playingChanged();
    }
    else
    {
        emit errorOccurred(reply.error().message());
    }
}

void BluetoothMediaController::stop()
{
    if (!m_connected)
        return;

    QDBusReply<void> reply = m_mediaPlayerInterface->call("Stop");

    if (reply.isValid())
    {
        std::cout << "Stop command sent successfully." << std::endl;
        m_playing = false;
        emit playingChanged();
    }
    else
    {
        emit errorOccurred(reply.error().message());
    }
}

void BluetoothMediaController::next()
{
    if (!m_connected)
        return;

    QDBusReply<void> reply = m_mediaPlayerInterface->call("Next");

    if (reply.isValid())
    {
        std::cout << "Next command sent successfully." << std::endl;
        m_playing = true; // are we sure it will be playing though?
        emit trackChanged();
        emit positionChanged();
    }
    else
    {
        emit errorOccurred(reply.error().message());
    }
}

void BluetoothMediaController::previous()
{
    if (!m_connected)
        return;

    QDBusReply<void> reply = m_mediaPlayerInterface->call("Previous");

    if (reply.isValid())
    {
        std::cout << "Previous command sent successfully." << std::endl;
        m_playing = true;
        emit trackChanged(); // not guaranteed but does it matter?
        emit positionChanged();
    }
    else
    {
        emit errorOccurred(reply.error().message());
    }
}

void BluetoothMediaController::seek(int positionMs)
{
    if (!m_connected)
        return;

    std::cout << "Seek called to " << positionMs << " ms" << std::endl;
    // TODO: Call Seek() on the DBus MediaPlayer interface
    m_position = positionMs;
    emit positionChanged();
}

// Device management
void BluetoothMediaController::connectToDevice(const QString &deviceAddress)
{
    disconnectDevice();

    std::cout << "Connect to device: " << deviceAddress.toStdString() << std::endl;
    m_deviceAddress = deviceAddress;

    const QString service = "org.bluez";

    // get managed objects from bluez
    QDBusInterface manager(service, "/", "org.freedesktop.DBus.ObjectManager", systemBus);
    if (!manager.isValid())
    {
        emit errorOccurred("Failed to create D-Bus ObjectManager interface");
        return;
    }

    QDBusMessage msg = manager.call("GetManagedObjects");
    if (msg.type() == QDBusMessage::ErrorMessage || msg.arguments().isEmpty())
    {
        emit errorOccurred("Failed to get managed objects from BlueZ");
        return;
    }

    QDBusArgument dbusArg = msg.arguments().at(0).value<QDBusArgument>();
    QMap<QDBusObjectPath, QMap<QString, QVariantMap>> managedObjects;
    dbusArg >> managedObjects;

    // find the base device with matching mac
    QString devicePath;
    QString playerPath;
    QString normalizedAddr = deviceAddress;
    normalizedAddr.replace(":", "_");

    for (auto it = managedObjects.begin(); it != managedObjects.end(); ++it)
    {
        const QDBusObjectPath &objectPath = it.key();
        const QMap<QString, QVariantMap> &interfaces = it.value();

        // Check if this is a Device1 object with matching Address
        if (interfaces.contains("org.bluez.Device1"))
        {
            const QVariantMap &deviceProps = interfaces.value("org.bluez.Device1");
            QString addr = deviceProps.value("Address").toString();
            QString addrNorm = addr;
            addrNorm.replace(":", "_");

            if (addrNorm == normalizedAddr)
            {
                devicePath = objectPath.path();
            }
        }

        // Check for a MediaPlayer1 object under this device
        if (interfaces.contains("org.bluez.MediaPlayer1"))
        {
            QString objPath = objectPath.path();
            if (objPath.contains(normalizedAddr))
            {
                playerPath = objPath;
            }
        }
    }

    if (devicePath.isEmpty())
    {
        emit errorOccurred("Could not find device path for " + deviceAddress);
        return;
    }
    if (playerPath.isEmpty())
    {
        emit errorOccurred("Could not find media player path for " + deviceAddress);
        return;
    }

    // --- connect to interfaces ---

    QString interface = "org.bluez.MediaPlayer1";

    // media player interface
    m_mediaPlayerInterface = new QDBusInterface(service, playerPath, interface, systemBus, this);
    if (!m_mediaPlayerInterface->isValid())
    {
        emit errorOccurred("Failed to create D-Bus MediaPlayer interface");
        return;
    }

    // media info interface (Properties on the player path)
    interface = "org.freedesktop.DBus.Properties";
    m_mediaInfoInterface = new QDBusInterface(service, playerPath, interface, systemBus, this);
    if (!m_mediaInfoInterface->isValid())
    {
        emit errorOccurred("Failed to create D-Bus properties interface");
        return;
    }

    // device interface (Properties on the device path)
    m_deviceInterface = new QDBusInterface(service, devicePath, interface, systemBus, this);
    if (!m_deviceInterface->isValid())
    {
        emit errorOccurred("Failed to create D-Bus device interface");
        return;
    }

    // --- verify connections ---
    // test if device is connected
    QDBusReply<QDBusVariant> reply = m_deviceInterface->call("Get", "org.bluez.Device1", "Connected");
    if (!reply.isValid() || !reply.value().variant().toBool())
    {
        emit errorOccurred("Device " + deviceAddress + " is not connected");
        return;
    }

    // test if media player works
    reply = m_mediaInfoInterface->call("Get", "org.bluez.MediaPlayer1", "Track");
    if (!reply.isValid())
    {
        emit errorOccurred("Device " + deviceAddress + " is not a media device");
        return;
    }

    // battery (optional)
    QDBusReply<QDBusVariant> batteryReply = m_deviceInterface->call("Get", "org.bluez.Battery1", "Percentage");
    m_batteryLevel = batteryReply.isValid() ? batteryReply.value().variant().toInt() : -1;

    // device name
    reply = m_deviceInterface->call("Get", "org.bluez.Device1", "Name");
    m_deviceName = reply.value().variant().toString();

    m_connected = true;
    emit deviceChanged();

    updatePlaybackStatus();

    // Save in settings
    QSettings settings("config.ini", QSettings::IniFormat);
    settings.setValue("Bluetooth/LastConnectedDevice", m_deviceAddress);
}


void BluetoothMediaController::disconnectDevice()
{
    if (m_mediaPlayerInterface != nullptr)
        delete m_mediaPlayerInterface;
    m_mediaPlayerInterface = nullptr;
    if (m_mediaInfoInterface != nullptr)
        delete m_mediaInfoInterface;
    m_mediaInfoInterface = nullptr;
    if (m_deviceInterface != nullptr)
        delete m_deviceInterface;
    m_deviceInterface = nullptr;

    // reset all properties to state for non connected device
    m_title.clear();
    m_artist.clear();
    m_album.clear();
    m_coverURL.clear();
    m_duration = 0;
    m_position = 0;
    m_deviceAddress.clear();
    m_playing = false;
    m_connected = false;
    m_batteryLevel = -1;
    m_deviceName.clear();
    emit trackChanged();
    emit deviceChanged();
    emit playingChanged();
}

QVariantList BluetoothMediaController::getConnectedDevices()
{
    QVariantList deviceList;

    QDBusInterface manager("org.bluez", "/", "org.freedesktop.DBus.ObjectManager", systemBus);
    if (!manager.isValid())
    {
        emit errorOccurred("Failed to create D-Bus ObjectManager interface");
        return deviceList;
    }

    QDBusMessage msg = manager.call("GetManagedObjects");
    if (msg.type() == QDBusMessage::ErrorMessage)
    {
        emit errorOccurred("Failed to get managed objects from BlueZ: "
                           + msg.errorMessage());
        return deviceList;
    }

    if (msg.arguments().isEmpty())
    {
        emit errorOccurred("GetManagedObjects returned no arguments");
        return deviceList;
    }

    // Unpack the nested map: a{oa{sa{sv}}}
    QDBusArgument dbusArg = msg.arguments().at(0).value<QDBusArgument>();
    QMap<QDBusObjectPath, QMap<QString, QVariantMap>> managedObjects;
    dbusArg >> managedObjects;

    for (auto it = managedObjects.begin(); it != managedObjects.end(); ++it)
    {
        const QDBusObjectPath &objectPath = it.key(); // <-- full device path
        const QMap<QString, QVariantMap> &interfaces = it.value();

        if (!interfaces.contains("org.bluez.Device1"))
            continue;

        const QVariantMap &deviceProps = interfaces.value("org.bluez.Device1");

        QString address   = deviceProps.value("Address").toString();
        QString name      = deviceProps.value("Name").toString();
        bool connected    = deviceProps.value("Connected").toBool();
        if (!connected)
            continue; // only list connected devices

        QVariantMap deviceInfo;
        deviceInfo["address"]   = address;
        deviceInfo["name"]      = name;
        deviceInfo["path"]      = objectPath.path();  // <-- full D-Bus path

        deviceList.append(deviceInfo);
    }

    if (deviceList.isEmpty())
        emit errorOccurred("No paired devices found");

    return deviceList;
}

// Status queries
bool BluetoothMediaController::isPlaying() const
{
    return m_playing;
}

QString BluetoothMediaController::title() const
{
    return m_title;
}

QString BluetoothMediaController::artist() const
{
    return m_artist;
}

QString BluetoothMediaController::album() const
{
    return m_album;
}

QString BluetoothMediaController::coverURL()
{
    return m_coverURL;
}

int BluetoothMediaController::duration() const
{
    return m_duration;
}

int BluetoothMediaController::position() const
{
    return m_position;
}

QString BluetoothMediaController::deviceName() const
{
    return m_deviceName;
}

int BluetoothMediaController::batteryLevel() const
{
    return m_batteryLevel;
}

void BluetoothMediaController::updatePlaybackStatus()
{
    if (m_mediaInfoInterface == nullptr)
        return;

    QMetaObject::invokeMethod(&threadWorker, [=]() {
        // track information
        QDBusReply<QDBusVariant> reply = m_mediaInfoInterface->call("Get", "org.bluez.MediaPlayer1", "Track");
        // check for error in reply
        if (!reply.isValid())
        {
            emit errorOccurred(reply.error().message());
            return;
        }
        QVariant var = reply.value().variant();
        QDBusArgument arg = var.value<QDBusArgument>();
        QVariantMap map = qdbus_cast<QVariantMap>(arg);

        m_title = map.value("Title").toString();
        m_artist = map.value("Artist").toString();
        m_album = map.value("Album").toString();
        m_duration = map.value("Duration").toInt(); // in ms

        // track position
        reply = m_mediaInfoInterface->call("Get", "org.bluez.MediaPlayer1", "Position");
        if (!reply.isValid())
        {
            emit errorOccurred(reply.error().message());
            return;
        }
        m_position = reply.value().variant().toInt(); // in ms

        // playback status
        reply = m_mediaInfoInterface->call("Get", "org.bluez.MediaPlayer1", "Status");
        if (!reply.isValid())
        {
            emit errorOccurred(reply.error().message());
            return;
        }
        QString status = reply.value().variant().toString();
        m_playing = (status == "playing");

        // get battery level
        QDBusReply<QDBusVariant> batteryReply = m_deviceInterface->call("Get", "org.bluez.Battery1", "Percentage");
        m_batteryLevel = batteryReply.isValid() ? batteryReply.value().variant().toInt() : -1;

        emit trackChanged();
        emit positionChanged();

        m_coverURL = lfm.getTrackCoverArt(m_title, m_artist, m_album);

        // return placeholder image if no valid URL retrieved
        if (!m_coverURL.contains("https://"))
            m_coverURL = "qrc:/images/placeholder.png";

        emit coverArtRetrieved();
    });
}

void BluetoothMediaController::internalErrorHandle(const QString& message)
{
    std::cerr << "BluetoothMediaController error: " << message.toStdString() << std::endl;
    disconnectDevice();
}
