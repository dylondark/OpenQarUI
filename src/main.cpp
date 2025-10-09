#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "bluetoothmediacontroller.h"
#include "pulseaudiocontroller.h"
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    // Register font from resources
    int id = QFontDatabase::addApplicationFont(":/fonts/NotoSans-Regular.ttf");
    QString family = QFontDatabase::applicationFontFamilies(id).at(0);

    // Set as default
    QFont defaultFont(family, 12);
    app.setFont(defaultFont);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    BluetoothMediaController bmc;
    qmlRegisterSingletonInstance<BluetoothMediaController>("OpenQarUI", 1, 0, "BluetoothMediaController", &bmc);
    PulseAudioController pac;
    qmlRegisterSingletonInstance<PulseAudioController>("OpenQarUI", 1, 0, "PulseAudioController", &pac);

    engine.loadFromModule("OpenQarUI", "Main");

    return app.exec();
}
