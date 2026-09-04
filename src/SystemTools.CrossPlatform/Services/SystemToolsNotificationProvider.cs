using ClassIsland.Core.Abstractions.Services.NotificationProviders;
using ClassIsland.Core.Attributes;
using ClassIsland.Core.Models.Notification;
using System;
using SystemTools.CrossPlatform.Controls.Notifications;

namespace SystemTools.CrossPlatform.Services;

[NotificationProviderInfo("44BB7B21-9831-4446-B3B6-3A4D7D1BE402", "SystemTools 通知", "\uE9FB", "来自 SystemTools 插件的提醒。")]
[NotificationChannelInfo("DD9150A5-A457-45CA-B1B5-393699CFB083", "SystemTools", "\uE9FB", "SystemTools 通用通知渠道")]
[NotificationChannelInfo(AiReplyChannelId, "AI 回复通知", "\uEFFF", "AI 回复完成时显示回复内容。")]
public class SystemToolsNotificationProvider : NotificationProviderBase
{
    public const string AiReplyChannelId = "4BEE12E4-AB5A-4193-8E8E-1651C23228F3";

    public void ShowAiReplyNotification(string reply)
    {
        var notificationText = NormalizeAiReply(reply);
        if (notificationText.Length == 0)
        {
            return;
        }

        var request = new NotificationRequest
        {
            MaskContent = NotificationContent.CreateTwoIconsMask("有新的AI回复…", factory: content =>
            {
                content.Duration = TimeSpan.FromSeconds(1);
                content.IsSpeechEnabled = false;
            }),
            OverlayContent = new NotificationContent(new AiReplyNotificationContent(notificationText))
            {
                Duration = AiReplyNotificationContent.EstimateDisplayDuration(notificationText),
                SpeechContent = notificationText,
                IsSpeechEnabled = true
            },
            ChannelId = Guid.Parse(AiReplyChannelId)
        };

        Channel(AiReplyChannelId).ShowNotification(request);
    }

    internal static string NormalizeAiReply(string reply)
    {
        return string.Join(
                " ",
                (reply ?? string.Empty)
                .Replace("#", string.Empty, StringComparison.Ordinal)
                .Replace("*", string.Empty, StringComparison.Ordinal)
                .Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries))
            .Trim();
    }
}
