using Microsoft.Extensions.Logging;
using System;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using SystemTools.CrossPlatform.Shared;
using SystemTools.CrossPlatform.Services;

namespace SystemTools.CrossPlatform.Services;

// ============================================================================
// p2-01 项 49：ClassIsland 内存自动清理（源锚点 E:\My Github Projects\SystemTools\Services\ClassIslandMemoryAutoCleanupService.cs 全 127 行）
// ============================================================================
// 已批实现口径（尚书省裁定 3 = p2-05 §3 方案 B；06 条目 49）：
//  1. 托管 GC 链 + 阈值测量三平台执行（源 :103-116/:112-116 全 BCL，逐行随源保留）。
//  2. 守卫位置事实校正（p2-05 §3.1）：源 :96-99 的 Windows 运行时守卫位于 GC 块之前——
//     源实现非 Windows 上整体不执行（含 GC）。本实现将平台差异收敛至工作集调用点：
//     GC/测量先于平台判断执行，工作集修剪经 IProcessMemoryMaintenanceService 仅 Windows 适配器生效
//     （与 02 v2 §3「非 Windows 跳过工作集仅 GC」表述的差异按 p2-05 §3.1 留痕）。
//  3. 工作集修剪经插件本地抽象 IProcessMemoryMaintenanceService（非宿主 API，见接口注记）：
//     工作集修剪经 ProcessMemoryMaintenanceNative（运行期 IsWindows 分派）承载；
//     非 Windows 适配器 no-op 留痕（TryTrimWorkingSet=false）。
//  4. 降级口径（06 条目 49 三选一分支）：采用「不可用时只跳过工作集操作并保留 GC/测量」分支——
//     本服务为 30 秒周期任务，不周期性 Toast；修剪不可用经日志留痕（WorkingSetTrimmed=False）。
//  5. 配置成员 AutoCleanupClassIslandMemory 经 GlobalConstants.MainConfig?.Data 读取（源 :27 随源；
//     MainConfigData 增补段见 ConfigHandlers\MainConfigData.cs，尚书省预批，p2-05 §2.1 #10）。
//  6. 源 :103 的 Process 未释放：改为 using 逐周期释放（防御性资源适配，零行为变化，D 类注记）。
// ============================================================================
public class ClassIslandMemoryAutoCleanupService(
    ILogger<ClassIslandMemoryAutoCleanupService> logger,
    IProcessMemoryMaintenanceService processMemoryMaintenance)
{
    private readonly ILogger<ClassIslandMemoryAutoCleanupService> _logger = logger;
    private readonly IProcessMemoryMaintenanceService _processMemoryMaintenance = processMemoryMaintenance;
    private readonly object _sync = new();
    private CancellationTokenSource? _cts;
    private Task? _workerTask;

    private const long ThresholdBytes = 500L * 1024 * 1024;

    public void ApplyConfig()
    {
        var enabled = GlobalConstants.MainConfig?.Data.AutoCleanupClassIslandMemory == true;
        if (enabled)
        {
            Start();
            return;
        }

        Stop();
    }

    public void Start()
    {
        lock (_sync)
        {
            if (_workerTask is { IsCompleted: false })
            {
                return;
            }

            _cts = new CancellationTokenSource();
            _workerTask = Task.Run(() => RunAsync(_cts.Token));
        }
    }

    public void Stop()
    {
        CancellationTokenSource? cts;
        Task? worker;
        lock (_sync)
        {
            cts = _cts;
            worker = _workerTask;
            _cts = null;
            _workerTask = null;
        }

        if (cts == null)
        {
            return;
        }

        try { cts.Cancel(); } catch { }
        cts.Dispose();

        if (worker != null)
        {
            try { worker.Wait(1000); } catch { }
        }
    }

    private async Task RunAsync(CancellationToken cancellationToken)
    {
        using var timer = new PeriodicTimer(TimeSpan.FromSeconds(30));

        try
        {
            while (await timer.WaitForNextTickAsync(cancellationToken))
            {
                TryCleanupOnce();
            }
        }
        catch (OperationCanceledException)
        {
            // Ignore cancellation.
        }
    }

    private void TryCleanupOnce()
    {
        try
        {
            // 守卫位置校正（口径 2）：阈值测量与托管 GC 链先于平台差异点，三平台执行。
            using var process = Process.GetCurrentProcess();
            process.Refresh();
            var privateMemory = process.PrivateMemorySize64;

            if (privateMemory <= ThresholdBytes)
            {
                return;
            }

            var before = GC.GetTotalMemory(true);
            GC.Collect(GC.MaxGeneration, GCCollectionMode.Aggressive, true);
            GC.WaitForPendingFinalizers();
            GC.Collect(GC.MaxGeneration, GCCollectionMode.Aggressive, true);
            var after = GC.GetTotalMemory(true);

            // 工作集调用点（口径 3）：平台差异在此收敛——Windows 适配器实际修剪，
            // 非 Windows 适配器 no-op 返回 false（口径 4：仅跳过工作集操作并保留 GC/测量）。
            var workingSetTrimmed = _processMemoryMaintenance.TryTrimWorkingSet(process.Handle);

            _logger.LogInformation(
                "ClassIsland 内存自动清理已执行。PrivateMemory={PrivateMemoryBytes}B ManagedBefore={ManagedBefore}B ManagedAfter={ManagedAfter}B WorkingSetTrimmed={WorkingSetTrimmed}",
                privateMemory, before, after, workingSetTrimmed);
        }
        catch (Exception ex)
        {
            _logger.LogDebug(ex, "ClassIsland 内存自动清理执行失败，将在下次周期继续。");
        }
    }
}