#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "bluetoothmediacontroller.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    BluetoothMediaController bmc;
    qmlRegisterSingletonInstance<BluetoothMediaController>("OpenQarUI", 1, 0, "BluetoothMediaController", &bmc);

    engine.loadFromModule("OpenQarUI", "Main");

    return app.exec();
}
