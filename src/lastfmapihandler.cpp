/*
    lastfmapihandler.cpp

    Class definition for LastFMAPIHandler.
*/

#include "lastfmapihandler.h"
#include <QUrlQuery>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QNetworkReply>
#include <QSettings>
#include <QEventLoop>
#include <QJsonArray>

LastFMAPIHandler::LastFMAPIHandler(QObject *parent)
    : QObject{parent},
    m_manager(new QNetworkAccessManager(this))
{}

QString LastFMAPIHandler::callAPI(QString method, QString user, QMap<QString, QString> params)
{
    // Base URL for Last.fm API
    const QString baseUrl = "http://ws.audioscrobbler.com/2.0/";

    QUrl url(baseUrl);
    QUrlQuery query;

    // Common parameters
    query.addQueryItem("method", method);
    query.addQueryItem("format", "json");

    // api key
    QSettings settings("config.ini", QSettings::IniFormat);
    QString apiKey = settings.value("API/LastFMKey", "default-value").toString();
    query.addQueryItem("api_key", apiKey);

    // Add user‑specific params (if any)
    if (!user.isEmpty())
        query.addQueryItem("user", user);

    // Add the custom parameters passed in
    for (auto it = params.constBegin(); it != params.constEnd(); ++it)
        query.addQueryItem(it.key(), it.value());

    url.setQuery(query);

    QNetworkRequest request(url);
    // Optionally set headers
    request.setHeader(QNetworkRequest::UserAgentHeader,
                      "OpenQarUI/1.0");

    // Send the request – we use GET here
    QNetworkReply *reply = m_manager->get(request);

    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();  // blocks until reply is done

    reply->deleteLater();

    return reply->readAll();
}

QString LastFMAPIHandler::getTrackCoverArt(QString track, QString artist)
{
    // cut off everything in artist after first comma
    if (artist.contains(","))
        artist = artist.section(',', 0, 0).trimmed();

    QString jsonString = callAPI("track.getInfo", "", {{"track", track}, {"artist", artist}, {"autocorrect", "1"}});

    // Parse the JSON response
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(jsonString.toUtf8(), &parseError);

    if (parseError.error != QJsonParseError::NoError || !doc.isObject())
    {
        qWarning() << "Failed to parse JSON:" << parseError.errorString();
        return QString();
    }

    QJsonObject trackObj = doc.object().value("track").toObject();
    QJsonObject albumObj = trackObj.value("album").toObject();
    QJsonArray images = albumObj.value("image").toArray();

    // Get the largest image (last one in array)
    if (!images.isEmpty())
    {
        QJsonObject lastImage = images.last().toObject();
        QString coverUrl = lastImage.value("#text").toString();
        return coverUrl;
    }

    // No cover art found
    return QString();
}
