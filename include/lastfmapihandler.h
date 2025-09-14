/*
    lastfmapihandler.h

    Class declaration for LastFMAPIHandler.
*/

#ifndef LASTFMAPIHANDLER_H
#define LASTFMAPIHANDLER_H

#include <QObject>

class LastFMAPIHandler : public QObject
{
    Q_OBJECT
public:
    explicit LastFMAPIHandler(QObject *parent = nullptr);

signals:
};

#endif // LASTFMAPIHANDLER_H
