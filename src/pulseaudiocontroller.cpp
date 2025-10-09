#include "pulseaudiocontroller.h"
#include <QDebug>

PulseAudioController::PulseAudioController(QObject *parent)
    : QObject(parent),
    m_mainloop(nullptr),
    m_context(nullptr),
    m_ready(false),
    m_defaultSink(-1),
    m_defaultSource(-1)
{
    connectPulseAudio();
}

PulseAudioController::~PulseAudioController()
{
    disconnectPulseAudio();
}

/* -------------------- Connection Management -------------------- */

void PulseAudioController::connectPulseAudio()
{
    if (m_ready)
        return; // already connected

    m_mainloop = pa_threaded_mainloop_new();
    if (!m_mainloop) {
        qWarning() << "Failed to create PulseAudio mainloop";
        emit errorOccurred("Failed to create PulseAudio mainloop");
        return;
    }

    pa_mainloop_api *api = pa_threaded_mainloop_get_api(m_mainloop);
    m_context = pa_context_new(api, "QtPulseAudioController");

    if (!m_context) {
        qWarning() << "Failed to create PulseAudio context";
        emit errorOccurred("Failed to create PulseAudio context");
        pa_threaded_mainloop_free(m_mainloop);
        m_mainloop = nullptr;
        return;
    }

    pa_context_set_state_callback(m_context, &PulseAudioController::contextStateCallback, this);

    if (pa_context_connect(m_context, nullptr, PA_CONTEXT_NOFLAGS, nullptr) < 0) {
        qWarning() << "Failed to connect to PulseAudio server";
        emit errorOccurred("Failed to connect to PulseAudio server");
        disconnectPulseAudio();
        return;
    }

    if (pa_threaded_mainloop_start(m_mainloop) < 0) {
        qWarning() << "Failed to start PulseAudio mainloop";
        emit errorOccurred("Failed to start PulseAudio mainloop");
        disconnectPulseAudio();
        return;
    }

    // Successfully initiated connection
    m_ready = true;
    emit readyChanged();

    // TODO: populate initial sinks and sources
    updateSinks();
    updateSources();
}

void PulseAudioController::disconnectPulseAudio()
{
    if (m_context) {
        pa_context_disconnect(m_context);
        pa_context_unref(m_context);
        m_context = nullptr;
    }

    if (m_mainloop) {
        pa_threaded_mainloop_stop(m_mainloop);
        pa_threaded_mainloop_free(m_mainloop);
        m_mainloop = nullptr;
    }

    m_ready = false;
    m_sinks.clear();
    m_sources.clear();
    m_defaultSink = -1;
    m_defaultSource = -1;

    emit readyChanged();
    emit sinksChanged();
    emit sourcesChanged();
    emit defaultSinkChanged();
    emit defaultSourceChanged();
}

/* -------------------- Getters -------------------- */

bool PulseAudioController::isReady() const
{
    return m_ready;
}

QStringList PulseAudioController::sinks() const
{
    return m_sinks;
}

int PulseAudioController::defaultSink() const
{
    return m_defaultSink;
}

qreal PulseAudioController::defaultSinkVolume() const
{
    return 0.0; // stub
}

QStringList PulseAudioController::sources() const
{
    return m_sources;
}

int PulseAudioController::defaultSource() const
{
    return m_defaultSource;
}

qreal PulseAudioController::defaultSourceVolume() const
{
    return 0.0; // stub
}

/* -------------------- Setters -------------------- */

void PulseAudioController::setDefaultSink(int index)
{
    Q_UNUSED(index);
    // stub
}

void PulseAudioController::setDefaultSource(int index)
{
    Q_UNUSED(index);
    // stub
}

void PulseAudioController::setDefaultSinkVolume(qreal volume)
{
    Q_UNUSED(volume);
    // stub
}

void PulseAudioController::setDefaultSourceVolume(qreal volume)
{
    Q_UNUSED(volume);
    // stub
}

/* -------------------- Callbacks & Internal -------------------- */

void PulseAudioController::contextStateCallback(pa_context *c, void *userdata)
{
    Q_UNUSED(c);
    Q_UNUSED(userdata);
    // stub
}

void PulseAudioController::sinkInfoCallback(pa_context *c, const pa_sink_info *i, int eol, void *userdata)
{
    Q_UNUSED(c);
    Q_UNUSED(i);
    Q_UNUSED(eol);
    Q_UNUSED(userdata);
    // stub
}

void PulseAudioController::sourceInfoCallback(pa_context *c, const pa_source_info *i, int eol, void *userdata)
{
    Q_UNUSED(c);
    Q_UNUSED(i);
    Q_UNUSED(eol);
    Q_UNUSED(userdata);
    // stub
}

void PulseAudioController::serverInfoCallback(pa_context *c, const pa_server_info *i, void *userdata)
{
    Q_UNUSED(c);
    Q_UNUSED(i);
    Q_UNUSED(userdata);
    // stub
}

void PulseAudioController::updateSinks()
{
    // stub
}

void PulseAudioController::updateSources()
{
    // stub
}

void PulseAudioController::internalErrorHandle(const QString &message)
{
    qWarning() << "PulseAudio error:" << message;
    emit errorOccurred(message);
}
