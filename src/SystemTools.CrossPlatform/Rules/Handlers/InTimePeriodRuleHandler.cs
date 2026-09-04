using System;
using ClassIsland.Core;
using ClassIsland.Core.Abstractions.Services;
using ClassIsland.Shared;
using SystemTools.CrossPlatform.Rules;

namespace SystemTools.CrossPlatform.Rules.Handlers;

/// <summary>
/// 「是否在某时间段」规则处理器。抽取自源插件同名文件（源形态为 Plugin 分部类静态方法，
/// 依 p1-05 §3.2 命名空间镜像规则适配为独立处理器类型，方法体逐行保留源实现）。
/// </summary>
public static class InTimePeriodRuleHandler
{
    public static bool Handle(object? settings)
    {
        if (settings is not InTimePeriodRuleSettings ruleSettings ||
            !TimeSpan.TryParse(ruleSettings.StartTime, out var start) ||
            !TimeSpan.TryParse(ruleSettings.EndTime, out var end))
        {
            return false;
        }

        var current = IAppHost.TryGetService<IExactTimeService>()?.GetCurrentLocalDateTime().TimeOfDay ?? DateTime.Now.TimeOfDay;
        if (start <= end)
        {
            return current >= start && current <= end;
        }

        return current >= start || current <= end;
    }
}
