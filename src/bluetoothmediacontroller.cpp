/*
    bluetoothmediacontroller.cpp

    Class definition for BluetoothMediaController.
*/

#include "bluetoothmediacontroller.h"

BluetoothMediaController::BluetoothMediaController(QObject *parent)
    : QObject(parent),
    m_playing(false),
    m_duration(0),
    m_position(0)
{
    // TODO: Initialize DBus connection and proxies here
    // For example, connect to system bus and prepare MediaPlayer1 interface
}

// Playback control methods
void BluetoothMediaController::play() {
    std::cout << "Play called" << std::endl;
    // TODO: Call Play() on the DBus MediaPlayer interface
    m_playing = true;
    emit playingChanged();
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
    // TODO: Initialize DBus interface for this device
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
