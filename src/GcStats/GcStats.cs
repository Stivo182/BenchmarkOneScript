// Portions of this code are derived from `BenchmarkDotNet` (https://github.com/dotnet/BenchmarkDotNet),
// Copyright (c) 2013–2024 .NET Foundation and contributors. MIT License.

using System;
using System.IO;
using System.Reflection;
using ScriptEngine.Machine.Contexts;

#if NET6_0_OR_GREATER
using OneScript.Contexts;
#endif

namespace GcStatsOneScript
{
    [ContextClass("СтатистикаСборщикаМусора", "GarbageCollectionStats")]
    public class GcStats : AutoContext<GcStats>
    {

        [ContextProperty("ВыделеноБайт", "AllocatedBytes")]
        public decimal AllocatedBytes { get; private set; }

        [ContextProperty("СборокПоколения0", "Gen0")]
        public int Gen0Collections { get; private set; }

        [ContextProperty("СборокПоколения1", "Gen1")]
        public int Gen1Collections { get; private set; }

        [ContextProperty("СборокПоколения2", "Gen2")]
        public int Gen2Collections { get; private set; }

        private int _StartGen0Collections;
        private int _StartGen1Collections;
        private int _StartGen2Collections;
        private decimal _StartAllocatedBytes;

        static GcStats()
        {
            AppDomain.CurrentDomain.AssemblyResolve += AssemblyResolve;
        }

        [ScriptConstructor]
        public static GcStats Constructor()
        {
            return new GcStats();
        }

        [ContextMethod("Начать", "Start")]
        public void Start()
        {
            Gen0Collections = 0;
            Gen1Collections = 0;
            Gen2Collections = 0;
            AllocatedBytes = 0;

            // this will force GC.Collect, so we want to do this before collecting collections counts
            long? allocatedBytes = GetAllocatedBytes();

            _StartGen0Collections = GC.CollectionCount(0);
            _StartGen1Collections = GC.CollectionCount(1);
            _StartGen2Collections = GC.CollectionCount(2);
            _StartAllocatedBytes = (decimal)allocatedBytes;
        }

        [ContextMethod("Завершить", "Stop")]
        public void Stop()
        {
            Gen0Collections = Math.Max(0, GC.CollectionCount(0) - _StartGen0Collections);
            Gen1Collections = Math.Max(0, GC.CollectionCount(1) - _StartGen1Collections);
            Gen2Collections = Math.Max(0, GC.CollectionCount(2) - _StartGen2Collections);
            AllocatedBytes = Math.Max(0, (decimal)GetAllocatedBytes() - _StartAllocatedBytes);
        }

        private long? GetAllocatedBytes()
        {
            // "This instance Int64 property returns the number of bytes that have been allocated by a specific
            // AppDomain. The number is accurate as of the last garbage collection." - CLR via C#
            // so we enforce GC.Collect here just to make sure we get accurate results
            GC.Collect();

#if NET6_0_OR_GREATER
            return GC.GetTotalAllocatedBytes(precise: true);
#else
            if (GcHelpers.GetTotalAllocatedBytesDelegate != null) // it's .NET Core 3.0 with the new API available
                return GcHelpers.GetTotalAllocatedBytesDelegate.Invoke(true); // true for the "precise" argument

            if (GcHelpers.CanUseMonitoringTotalAllocatedMemorySize) // Monitoring is not available in Mono, see http://stackoverflow.com/questions/40234948/how-to-get-the-number-of-allocated-bytes-
                return AppDomain.CurrentDomain.MonitoringTotalAllocatedMemorySize;

            if (GcHelpers.GetAllocatedBytesForCurrentThreadDelegate != null)
                return GcHelpers.GetAllocatedBytesForCurrentThreadDelegate.Invoke();

            return null;
#endif
        }

        static Assembly AssemblyResolve(object sender, ResolveEventArgs args)
        {
            var assembly = Assembly.GetExecutingAssembly();
            string libPath = Path.Combine(
                    Path.GetDirectoryName(assembly.Location),
                    new AssemblyName(args.Name).Name + ".dll");

            return Assembly.LoadFile(libPath);
        }

#if !NET6_0_OR_GREATER
        // Separate class to have the cctor run lazily, to avoid enabling monitoring before the benchmarks are ran.
        private static class GcHelpers
        {
            // do not reorder these, CheckMonitoringTotalAllocatedMemorySize relies on GetTotalAllocatedBytesDelegate being initialized first
            public static readonly Func<bool, long> GetTotalAllocatedBytesDelegate = CreateGetTotalAllocatedBytesDelegate();
            public static readonly Func<long> GetAllocatedBytesForCurrentThreadDelegate = CreateGetAllocatedBytesForCurrentThreadDelegate();
            public static readonly bool CanUseMonitoringTotalAllocatedMemorySize = CheckMonitoringTotalAllocatedMemorySize();

            private static Func<bool, long> CreateGetTotalAllocatedBytesDelegate()
            {
                try
                {
                    // this method is not a part of .NET Standard so we need to use reflection
                    var method = typeof(GC).GetTypeInfo().GetMethod("GetTotalAllocatedBytes", BindingFlags.Public | BindingFlags.Static);

                    if (method == null)
                        return null;

                    // we create delegate to avoid boxing, IMPORTANT!
                    var del = (Func<bool, long>)method.CreateDelegate(typeof(Func<bool, long>));

                    // verify the api works
                    return del.Invoke(true) >= 0 ? del : null;
                }
                catch
                {
                    return null;
                }
            }

            private static Func<long> CreateGetAllocatedBytesForCurrentThreadDelegate()
            {
                try
                {
                    // this method is not a part of .NET Standard so we need to use reflection
                    var method = typeof(GC).GetTypeInfo().GetMethod("GetAllocatedBytesForCurrentThread", BindingFlags.Public | BindingFlags.Static);

                    if (method == null)
                        return null;

                    // we create delegate to avoid boxing, IMPORTANT!
                    var del = (Func<long>)method.CreateDelegate(typeof(Func<long>));

                    // verify the api works
                    return del.Invoke() >= 0 ? del : null;
                }
                catch
                {
                    return null;
                }
            }

            private static bool CheckMonitoringTotalAllocatedMemorySize()
            {
                try
                {
                    // we potentially don't want to enable monitoring if we don't need it
                    if (GetTotalAllocatedBytesDelegate != null)
                        return false;

                    // check if monitoring is enabled
                    if (!AppDomain.MonitoringIsEnabled)
                        AppDomain.MonitoringIsEnabled = true;

                    // verify the api works
                    return AppDomain.MonitoringIsEnabled && AppDomain.CurrentDomain.MonitoringTotalAllocatedMemorySize >= 0;
                }
                catch
                {
                    return false;
                }
            }
        }
#endif

    }
}
