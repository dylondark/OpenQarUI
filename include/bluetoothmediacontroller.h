/*
    bluetoothmediacontroller.h

    Class declaration for BluetoothMediaController.
*/

#ifndef BLUETOOTHMEDIACONTROLLER_H
#define BLUETOOTHMEDIACONTROLLER_H

#include <QObject>
#include <QtDBus/QtDBus>
#include <QTimer>
#include "threadworker.h"
#include "lastfmapihandler.h"

class BluetoothMediaController : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(bool connected READ isConnected NOTIFY deviceChanged)
    Q_PROPERTY(bool playing READ isPlaying NOTIFY playingChanged)
    Q_PROPERTY(QString title READ title NOTIFY trackChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY trackChanged)
    Q_PROPERTY(QString album READ album NOTIFY trackChanged)
    Q_PROPERTY(int duration READ duration NOTIFY trackChanged) // in ms
    Q_PROPERTY(int position READ position NOTIFY positionChanged) // in ms
    Q_PROPERTY(QString deviceName READ deviceName NOTIFY deviceChanged)
    Q_PROPERTY(QString coverURL READ coverURL NOTIFY coverArtRetrieved)

    // ctor
    explicit BluetoothMediaController(QObject *parent = nullptr);

    // dtor
    ~BluetoothMediaController();

    // Playback controls
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void seek(int positionMs); // optional

    // Device management
    Q_INVOKABLE void connectToDevice(const QString &deviceAddress);
    Q_INVOKABLE void disconnectDevice();

    // Status queries (if needed from C++, mostly properties are enough)
    bool isConnected() const;
    bool isPlaying() const;
    QString title() const;
    QString artist() const;
    QString album() const;
    QString coverURL();
    int duration() const;
    int position() const;
    QString deviceName() const;

signals:
    void playingChanged();
    void trackChanged();
    void positionChanged();
    void deviceChanged();
    void errorOccurred(const QString &message);
    void coverArtRetrieved();

private:
    bool m_connected;
    QString m_deviceAddress;
    QString m_deviceName;
    bool m_playing;
    QString m_title;
    QString m_artist;
    QString m_album;
    QString m_coverURL;
    int m_duration;
    int m_position;
    QTimer updateTimer;
    ThreadWorker threadWorker;
    QThread networkThread;
    LastFMAPIHandler lfm;

    // DBus interface/proxy objects
    QDBusConnection systemBus;
    QDBusInterface* m_mediaPlayerInterface;
    QDBusInterface* m_mediaInfoInterface;
    QDBusInterface* m_deviceInterface;

    void updatePlaybackStatus();
    void updateTrackInfo();
    void handleDbusSignal(...); // callback for DBus properties change
    void internalErrorHandle(const QString& message);

};

#endif // BLUETOOTHMEDIACONTROLLER_H
