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
    explicit PulseAudioController(QObject *parent = nullptr);

signals:
};

#endif // PULSEAUDIOCONTROLLER_H
