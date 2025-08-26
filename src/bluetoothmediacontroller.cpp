/*
    bluetoothmediacontroller.cpp

    Class definition for BluetoothMediaController.
*/

#include "bluetoothmediacontroller.h"

BluetoothMediaController::BluetoothMediaController(QObject *parent)
    : QObject(parent),
    m_playing(false),
    m_duration(0),
    m_position(0),
    systemBus(QDBusConnection::systemBus())
{
    // init system dbus connection
    if (!systemBus.isConnected()) {
        std::cerr << "Cannot connect to the D-Bus system bus" << std::endl;
        emit errorOccurred("Cannot connect to the D-Bus system bus");
        return;
    }
}

// Playback control methods
void BluetoothMediaController::play() {
    QDBusReply<void> reply = m_mediaPlayerInterface->call("Play");

    if (reply.isValid()) {
        std::cout << "Play command sent successfully." << std::endl;
        m_playing = true;
        emit playingChanged();
    } else {
        std::cerr << "Error: " << reply.error().message().toStdString() << std::endl;
    }
}

void BluetoothMediaController::pause() {
    std::cout << "Pause called" << std::endl;
    // TODO: Call Pause() on the DBus MediaPlayer interface
    m_playing = false;
    emit playingChanged();
}

void BluetoothMediaController::stop() {
    std::cout << "Stop called" << std::endl;
    // TODO: Call Stop() on the DBus MediaPlayer interface
    m_playing = false;
    emit playingChanged();
}

void BluetoothMediaController::next() {
    std::cout << "Next called" << std::endl;
    // TODO: Call Next() on the DBus MediaPlayer interface
}

void BluetoothMediaController::previous() {
    std::cout << "Previous called" << std::endl;
    // TODO: Call Previous() on the DBus MediaPlayer interface
}

void BluetoothMediaController::seek(int positionMs) {
    std::cout << "Seek called to " << positionMs << " ms" << std::endl;
    // TODO: Call Seek() on the DBus MediaPlayer interface
    m_position = positionMs;
    emit positionChanged();
}

// Device management
void BluetoothMediaController::connectToDevice(const QString &deviceAddress) {
    std::cout << "Connect to device: " << deviceAddress.toStdString() << std::endl;
    m_deviceAddress = deviceAddress;

    const QString service = "org.bluez";
    const QString path = "/org/bluez/hci0/dev_" + m_deviceAddress.replace(":", "_") + "/avrcp/player0";
    const QString interface = "org.bluez.MediaPlayer1";

    m_mediaPlayerInterface = new QDBusInterface(service, path, interface, systemBus, this);
    if (!m_mediaPlayerInterface->isValid()) {
        std::cerr << "Failed to create D-Bus interface for device" << std::endl;
        emit errorOccurred("Failed to create D-Bus interface for device");
        return;
    }

    emit deviceChanged();
}

void BluetoothMediaController::disconnectDevice() {
    std::cout << "Disconnect device" << std::endl;
    // TODO: Clear DBus interface and reset state
    m_deviceAddress.clear();
    m_playing = false;
    emit deviceChanged();
    emit playingChanged();
}

// Status queries
bool BluetoothMediaController::isPlaying() const {
    return m_playing;
}

QString BluetoothMediaController::title() const {
    return m_title;
}

QString BluetoothMediaController::artist() const {
    return m_artist;
}

QString BluetoothMediaController::album() const {
    return m_album;
}

int BluetoothMediaController::duration() const {
    return m_duration;
}

int BluetoothMediaController::position() const {
    return m_position;
}

QString BluetoothMediaController::deviceName() const {
    return m_deviceAddress; // TODO: replace with friendly name if available
}
