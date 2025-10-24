#ifndef PULSEAUDIOCONTROLLER_H
#define PULSEAUDIOCONTROLLER_H

#include <QObject>
#include <QQmlEngine>
#include <QVector>
#include <pulse/pulseaudio.h>

struct AudioDevice
{
    Q_GADGET
    Q_PROPERTY(bool sink MEMBER sink) // false for source
    Q_PROPERTY(QString name MEMBER name)
    Q_PROPERTY(int index MEMBER index)
    Q_PROPERTY(qreal volume MEMBER volume) // 0.0 - 1.0
    Q_PROPERTY(bool isDefault MEMBER isDefault)

public:
    bool sink;
    QString name;
    int index;
    qreal volume;
    bool isDefault;
};

class PulseAudioController : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    Q_PROPERTY(bool ready READ isReady NOTIFY readyChanged)
    Q_PROPERTY(QVector<AudioDevice> sinks READ sinks NOTIFY sinksChanged)
    Q_PROPERTY(QVector<AudioDevice> sources READ sources NOTIFY sourcesChanged)

    explicit PulseAudioController(QObject *parent = nullptr);
    ~PulseAudioController();

    Q_INVOKABLE bool isReady() const;
    Q_INVOKABLE QVector<AudioDevice> sinks() const;
    Q_INVOKABLE AudioDevice defaultSink() const;
    Q_INVOKABLE QVector<AudioDevice> sources() const;
    Q_INVOKABLE AudioDevice defaultSource() const;

    Q_INVOKABLE void setDefaultSink(int index);
    Q_INVOKABLE void setDefaultSource(int index);
    Q_INVOKABLE void setSinkVolume(int index, qreal volume);
    Q_INVOKABLE void setSourceVolume(int index, qreal volume);


signals:
    void readyChanged();
    void sinksChanged();
    void defaultSinkChanged();
    void sourcesChanged();
    void defaultSourceChanged();
    void errorOccurred(const QString &message);
    void startUpdates(); // for when updates need to be called from a PA thread

private:
    pa_threaded_mainloop *m_mainloop;
    pa_context *m_context;

    bool m_ready;
    QVector<AudioDevice> m_sinks;
    QVector<AudioDevice> m_sources;

    static void contextStateCallback(pa_context *c, void *userdata);
    static void sinkInfoCallback(pa_context *c, const pa_sink_info *i, int eol, void *userdata);
    static void sourceInfoCallback(pa_context *c, const pa_source_info *i, int eol, void *userdata);
    static void serverInfoCallback(pa_context *c, const pa_server_info *i, void *userdata);
    static void subscribeCallback(pa_context *c, pa_subscription_event_type_t t, uint32_t index, void *userdata);

    void connectPulseAudio();
    void disconnectPulseAudio();
    void updateSinks();
    void updateSources();

private slots:
    void internalErrorHandle(const QString &message);
    void internalReadyStateHandle();
    void internalStartUpdatesHandle();
};

#endif // PULSEAUDIOCONTROLLER_H
