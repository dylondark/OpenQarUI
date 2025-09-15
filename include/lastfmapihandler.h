/*
    lastfmapihandler.h

    Class declaration for LastFMAPIHandler.
*/

#ifndef LASTFMAPIHANDLER_H
#define LASTFMAPIHANDLER_H

#include <QObject>
#include <QMap>

class LastFMAPIHandler : public QObject
{
    Q_OBJECT
public:
    explicit LastFMAPIHandler(QObject *parent = nullptr);

signals:

private:
    QString callAPI(QString method, QString user, QMap<QString, QString> params);
};

#endif // LASTFMAPIHANDLER_H
