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
    systemBus(QDBusConnection::systemBus())
{
    // init system dbus connection
    if (!systemBus.isConnected())
    {
        std::cerr << "Cannot connect to the D-Bus system bus" << std::endl;
        emit errorOccurred("Cannot connect to the D-Bus system bus");
        return;
    }
}

// Playback control methods
void BluetoothMediaController::play()
{
    QDBusReply<void> reply = m_mediaPlayerInterface->call("Play");

    if (reply.isValid())
    {
        std::cout << "Play command sent successfully." << std::endl;
        m_playing = true;
        emit playingChanged();
    }
    else
    {
        std::cerr << "Error: " << reply.error().message().toStdString() << std::endl;
    }
}

void BluetoothMediaController::pause()
{
    QDBusReply<void> reply = m_mediaPlayerInterface->call("Pause");

    if (reply.isValid())
    {
        std::cout << "Pause command sent successfully." << std::endl;
        m_playing = false;
        emit playingChanged();
    }
    else
    {
        std::cerr << "Error: " << reply.error().message().toStdString() << std::endl;
    }
}

void BluetoothMediaController::stop()
{
    QDBusReply<void> reply = m_mediaPlayerInterface->call("Stop");

    if (reply.isValid())
    {
        std::cout << "Stop command sent successfully." << std::endl;
        m_playing = false;
        emit playingChanged();
    }
    else
    {
        std::cerr << "Error: " << reply.error().message().toStdString() << std::endl;
    }
}

void BluetoothMediaController::next()
{
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
        std::cerr << "Error: " << reply.error().message().toStdString() << std::endl;
    }
}

void BluetoothMediaController::previous()
{
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
        std::cerr << "Error: " << reply.error().message().toStdString() << std::endl;
    }
}

void BluetoothMediaController::seek(int positionMs)
{
    std::cout << "Seek called to " << positionMs << " ms" << std::endl;
    // TODO: Call Seek() on the DBus MediaPlayer interface
    m_position = positionMs;
    emit positionChanged();
}

// Device management
void BluetoothMediaController::connectToDevice(const QString &deviceAddress)
{
    std::cout << "Connect to device: " << deviceAddress.toStdString() << std::endl;
    m_deviceAddress = deviceAddress;

    const QString service = "org.bluez";
    const QString path = "/org/bluez/hci0/dev_" + m_deviceAddress.replace(":", "_") + "/avrcp/player0";
    const QString interface = "org.bluez.MediaPlayer1";

    m_mediaPlayerInterface = new QDBusInterface(service, path, interface, systemBus, this);
    if (!m_mediaPlayerInterface->isValid())
    {
        std::cerr << "Failed to create D-Bus interface for device" << std::endl;
        emit errorOccurred("Failed to create D-Bus interface for device");
        return;
    }

    emit deviceChanged();
}

void BluetoothMediaController::disconnectDevice()
{
    std::cout << "Disconnect device" << std::endl;
    // TODO: Clear DBus interface and reset state
    m_deviceAddress.clear();
    m_playing = false;
    emit deviceChanged();
    emit playingChanged();
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
    return m_deviceAddress; // TODO: replace with friendly name if available
}
