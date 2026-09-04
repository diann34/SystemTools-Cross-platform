using System;
using ClassIsland.Core;
using ClassIsland.Core.Abstractions.Services;
using ClassIsland.Shared;
using SystemTools.CrossPlatform.Rules;

namespace SystemTools.CrossPlatform.Rules.Handlers;

/// <summary>
/// 「正在使用某课程表」规则处理器。抽取自源插件同名文件（源形态为 Plugin 分部类静态方法，
/// 依 p1-05 §3.2 命名空间镜像规则适配为独立处理器类型，方法体逐行保留源实现）。
/// </summary>
public static class UsingClassPlanRuleHandler
{
    public static bool Handle(object? settings)
    {
        if (settings is not UsingClassPlanRuleSettings ruleSettings ||
            !Guid.TryParse(ruleSettings.ClassPlanId, out var classPlanId))
        {
            return false;
        }

        var profile = IAppHost.TryGetService<IProfileService>()?.Profile;
        if (profile == null || !profile.ClassPlans.TryGetValue(classPlanId, out var classPlan))
        {
            return false;
        }

        return classPlan.IsActivated;
    }
}
