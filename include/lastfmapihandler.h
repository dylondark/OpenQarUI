/*
    lastfmapihandler.h

    Class declaration for LastFMAPIHandler.
*/

#ifndef LASTFMAPIHANDLER_H
#define LASTFMAPIHANDLER_H

#include <QObject>
#include <QMap>
#include <QNetworkAccessManager>

class LastFMAPIHandler : public QObject
{
    Q_OBJECT
public:
    explicit LastFMAPIHandler(QObject *parent = nullptr);

    QString getTrackCoverArt(QString track, QString artist, QString album);

signals:

private:
    QNetworkAccessManager *m_manager;

    QString callAPI(QString method, QString user, QMap<QString, QString> params);
};

#endif // LASTFMAPIHANDLER_H
