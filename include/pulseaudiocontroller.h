#ifndef PULSEAUDIOCONTROLLER_H
#define PULSEAUDIOCONTROLLER_H

#include <QObject>
#include <QQmlEngine>
#include <pulse/pulseaudio.h>

class PulseAudioController : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    Q_PROPERTY(bool ready READ isReady NOTIFY readyChanged)
    Q_PROPERTY(QStringList sinks READ sinks NOTIFY sinksChanged)
    Q_PROPERTY(int defaultSink READ defaultSink NOTIFY defaultSinkChanged)
    Q_PROPERTY(qreal defaultSinkVolume READ defaultSinkVolume NOTIFY defaultSinkVolumeChanged)
    Q_PROPERTY(QStringList sources READ sources NOTIFY sourcesChanged)
    Q_PROPERTY(int defaultSource READ defaultSource NOTIFY defaultSourceChanged)
    Q_PROPERTY(qreal defaultSourceVolume READ defaultSourceVolume NOTIFY defaultSourceVolumeChanged)

    explicit PulseAudioController(QObject *parent = nullptr);
    ~PulseAudioController();

    Q_INVOKABLE bool isReady() const;
    Q_INVOKABLE QStringList sinks() const;
    Q_INVOKABLE int defaultSink() const;
    Q_INVOKABLE qreal defaultSinkVolume() const;
    Q_INVOKABLE QStringList sources() const;
    Q_INVOKABLE int defaultSource() const;
    Q_INVOKABLE qreal defaultSourceVolume() const;

    Q_INVOKABLE void setDefaultSink(int index);
    Q_INVOKABLE void setDefaultSource(int index);
    Q_INVOKABLE void setDefaultSinkVolume(qreal volume);
    Q_INVOKABLE void setDefaultSourceVolume(qreal volume);

signals:
    void readyChanged();
    void sinksChanged();
    void defaultSinkChanged();
    void defaultSinkVolumeChanged();
    void sourcesChanged();
    void defaultSourceChanged();
    void defaultSourceVolumeChanged();
    void errorOccurred(const QString &message);

private:
    pa_threaded_mainloop *m_mainloop;
    pa_context *m_context;

    bool m_ready;
    QStringList m_sinks;
    int m_defaultSink;
    qreal m_defaultSinkVolume;
    QStringList m_sources;
    int m_defaultSource;

    static void contextStateCallback(pa_context *c, void *userdata);
    static void sinkInfoCallback(pa_context *c, const pa_sink_info *i, int eol, void *userdata);
    static void sourceInfoCallback(pa_context *c, const pa_source_info *i, int eol, void *userdata);
    static void serverInfoCallback(pa_context *c, const pa_server_info *i, void *userdata);

    void connectPulseAudio();
    void disconnectPulseAudio();
    void updateSinks();
    void updateSources();

private slots:
    void internalErrorHandle(const QString &message);
};

#endif // PULSEAUDIOCONTROLLER_H
