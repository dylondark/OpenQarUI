#ifndef BLUETOOTHMEDIACONTROLLER_H
#define BLUETOOTHMEDIACONTROLLER_H

#include <QObject>

class BluetoothMediaController : public QObject
{
    Q_OBJECT
public:
    explicit BluetoothMediaController(QObject *parent = nullptr);

signals:
};

#endif // BLUETOOTHMEDIACONTROLLER_H
