using System;
using System.Threading.Tasks;
using ClassIsland.Core.Abstractions.Automation;
using ClassIsland.Core.Attributes;
using ClassIsland.Shared;
using ClassIsland.Platforms.Abstraction.Services;
using Microsoft.Extensions.Logging;

namespace SystemTools.CrossPlatform.Actions;

[ActionInfo("SystemTools.CrossPlatform.FullscreenClock", "沉浸式时钟", "\uE4D2", false)]
public class FullscreenClockAction(ILogger<FullscreenClockAction> logger) : ActionBase
{
    private readonly ILogger<FullscreenClockAction> _logger = logger;
    private const string ClockUrl = "https://clock.qqhkx.com/";

    protected override async Task OnInvoke()
    {
        _logger.LogDebug("FullscreenClockAction OnInvoke 开始");

        try
        {
            _logger.LogInformation("正在打开沉浸式时钟: {Url}", ClockUrl);

            // 降级口径适配（p0-03 A10 / 02 §2.5 建议，04-spec 已批）：源实现经进程启动并按
            // Shell 语义打开 URL，此处改经宿主 ILauncherService.LaunchUrl 三平台打开；
            // 获取失败时与源失败路径一致：记录日志并抛出行动错误。
            var launcher = IAppHost.GetService<ILauncherService>()
                ?? throw new InvalidOperationException("无法获取 ILauncherService，无法打开沉浸式时钟");
            await launcher.LaunchUrl(ClockUrl);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "打开沉浸式时钟失败");
            throw;
        }

        await base.OnInvoke();
        _logger.LogDebug("FullscreenClockAction OnInvoke 完成");
    }
}
