#include "pulseaudiocontroller.h"
#include <QDebug>

PulseAudioController::PulseAudioController(QObject *parent)
    : QObject(parent),
    m_mainloop(nullptr),
    m_context(nullptr),
    m_ready(false)
{
    connect(this, &PulseAudioController::errorOccurred, this, &PulseAudioController::internalErrorHandle);
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

QVector<AudioDevice> PulseAudioController::sinks() const
{
    return m_sinks;
}

AudioDevice PulseAudioController::defaultSink() const
{
    for (const auto &sink : m_sinks)
    {
        if (sink.isDefault)
            return sink;
    }

    return {true, "NULL", -1, 0.0, false}; // if there is no default
}

QVector<AudioDevice> PulseAudioController::sources() const
{
    return m_sources;
}

AudioDevice PulseAudioController::defaultSource() const
{
    for (const auto &source : m_sources)
    {
        if (source.isDefault)
            return source;
    }

    return {false, "NULL", -1, 0.0, false}; // if there is no default
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
    for (auto &sink : m_sinks)
    {
        if (sink.isDefault)
        {
            sink.volume = volume;
            emit defaultSinkVolumeChanged();
            return;
        }
    }
}

void PulseAudioController::setDefaultSourceVolume(qreal volume)
{
    for (auto &source : m_sources)
    {
        if (source.isDefault)
        {
            source.volume = volume;
            emit defaultSourceVolumeChanged();
            return;
        }
    }
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
    // get 'this' object (this is a static function)
    auto self = static_cast<PulseAudioController*>(userdata);

    // check if end of list
    if (eol != 0)
    {
        // done
        emit self->sinksChanged();
        return;
    }

    // check if info is valid
    if (!i)
        return;

    AudioDevice thisSink = {true, QString(i->name), static_cast<int>(i->index), 0.0, false};

    // add to list or update existing
    bool found = false;
    for (auto &sink : self->m_sinks)
    {
        if (sink.index == thisSink.index)
        {
            // update existing
            sink.name = thisSink.name;
            found = true;
            break;
        }
    }
    if (!found)
    {
        // new sink
        self->m_sinks.append(thisSink);
    }

    if (i->index == self->defaultSink().index)
    {
        // Update default sink volume
        if (i->volume.channels > 0)
        {
            // Average volume across channels
            uint32_t totalVolume = 0;
            for (int ch = 0; ch < i->volume.channels; ++ch)
                totalVolume += i->volume.values[ch];
            qreal avgVolume = static_cast<qreal>(totalVolume) / i->volume.channels / PA_VOLUME_NORM;
            self->setDefaultSinkVolume(avgVolume);
            emit self->defaultSinkVolumeChanged();
        }
    }
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
    pa_threaded_mainloop_lock(m_mainloop);
    pa_context_get_sink_info_list(m_context, &PulseAudioController::sinkInfoCallback, this);
    pa_threaded_mainloop_unlock(m_mainloop);
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
