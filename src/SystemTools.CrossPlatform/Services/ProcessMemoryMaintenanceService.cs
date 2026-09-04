using System;

namespace SystemTools.CrossPlatform.Services;

/// <summary>
/// 进程内存维护默认实现。
/// <para>
/// 平台差异在 ProcessMemoryMaintenanceNative 内以运行期判断收敛（Windows → psapi 工作集修剪；
/// 非 Windows → no-op 返回 false），DI 注册面可无条件注册
/// AddSingleton&lt;IProcessMemoryMaintenanceService, ProcessMemoryMaintenanceService&gt;()，
/// 无需平台条件代码。
/// </para>
/// </summary>
public sealed class ProcessMemoryMaintenanceService : IProcessMemoryMaintenanceService
{
    public bool TryTrimWorkingSet(IntPtr processHandle)
        => ProcessMemoryMaintenanceNative.TryTrimWorkingSet(processHandle);
}
