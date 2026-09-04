using System;
using SystemTools.CrossPlatform.Rules;

namespace SystemTools.CrossPlatform.Rules.Handlers;

/// <summary>
/// 「程序正在运行」规则处理器。抽取自源插件同名文件（源形态为 Plugin 分部类静态方法，
/// 依 p1-05 §3.2 命名空间镜像规则适配为独立处理器类型，方法体逐行保留源实现）。
/// </summary>
public static class ProcessRunningRuleHandler
{
    public static bool Handle(object? settings)
    {
        if (settings is not ProcessRunningRuleSettings ruleSettings ||
            string.IsNullOrWhiteSpace(ruleSettings.ProcessName))
        {
            return false;
        }

        var processName = ruleSettings.ProcessName.Trim();
        if (processName.EndsWith(".exe", StringComparison.OrdinalIgnoreCase))
        {
            processName = processName[..^4];
        }

        try
        {
            return System.Diagnostics.Process.GetProcessesByName(processName).Length > 0;
        }
        catch
        {
            return false;
        }
    }
}
