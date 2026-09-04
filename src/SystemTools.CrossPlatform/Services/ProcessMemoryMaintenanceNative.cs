using System;
using System.Runtime.InteropServices;

namespace SystemTools.CrossPlatform.Services;

// ============================================================================
// 进程工作集修剪原生适配（单一 net10.0 产物，运行期平台分派）
// ============================================================================
// 由多 TFM 时代的条件文件对（ProcessMemoryMaintenanceNativeWindows.cs / NativeNoOp.cs）合并而来：
// - Windows：psapi!EmptyWorkingSet 实际修剪（DllImport 惰性解析，仅在 Windows 上被调用）；
// - 非 Windows：恒返回 false（no-op 留痕，由调用方记 WorkingSetTrimmed=False 日志；
//   Linux/macOS 无等价用户态强制工作集清理语义）。
// 失败一律返回 false，不向调用方抛异常（06 条目 49 降级口径：跳过工作集操作、保留 GC/测量）。
// ============================================================================
internal static class ProcessMemoryMaintenanceNative
{
    [DllImport("psapi.dll", SetLastError = true)]
    private static extern bool EmptyWorkingSet(IntPtr hProcess);

    internal static bool TryTrimWorkingSet(IntPtr processHandle)
    {
        if (!OperatingSystem.IsWindows() || processHandle == IntPtr.Zero)
        {
            return false;
        }

        try
        {
            return EmptyWorkingSet(processHandle);
        }
        catch
        {
            return false;
        }
    }
}
