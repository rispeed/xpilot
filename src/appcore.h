#ifndef APP_CORE_H
#define APP_CORE_H

#include <QObject>
#include <QDir>
#include <QFile>

#include "src/network/networkmanager.h"
#include "src/config/appconfig.h"

namespace xpilot
{
    enum class NotificationType
    {
        Info,
        Warning,
        Error,
        TextMessage,
        ServerMessage,
        RadioMessageSent,
        RadioMessageReceived
    };

    class AppCore : public QObject
    {
        Q_OBJECT

    signals:
        void serverListDownloaded(int count);
        void serverListDownloadError();

    public slots:
        void SaveConfig();

    public:
        AppCore(QObject *owner = nullptr);
        void DownloadServerList();
    };
}

#endif
