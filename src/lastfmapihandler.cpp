/*
    lastfmapihandler.cpp

    Class definition for LastFMAPIHandler.
*/

#include "lastfmapihandler.h"

LastFMAPIHandler::LastFMAPIHandler(QObject *parent)
    : QObject{parent}
{}

QString LastFMAPIHandler::callAPI(QString method, QString user, QMap<QString, QString> params)
{
    // Implementation for calling Last.fm API would go here.
    // This is a placeholder implementation.
    Q_UNUSED(method);
    Q_UNUSED(user);
    Q_UNUSED(params);
    return QString();
}

QString LastFMAPIHandler::getTrackCoverArt(QString track, QString artist)
{
    return callAPI("track.getInfo", "", {{"track", track}, {"artist", artist}});
}
