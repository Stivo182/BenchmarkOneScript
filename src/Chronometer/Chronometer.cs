using System.Diagnostics;
using System.Runtime.CompilerServices;
using ScriptEngine.Machine.Contexts;

#if NET6_0_OR_GREATER
using OneScript.Contexts;
#endif

namespace OscriptChronometer
{
    [ContextClass("Хронометр", "Chronometer")]
    public class Chronometer : AutoContext<Chronometer>
    {
        private static readonly long Frequency = Stopwatch.Frequency;
        private static readonly double TicksToNs = 1_000_000_000.0 / Frequency;

        [ContextProperty("Наносекунд", "Nanoseconds")]
        public decimal Nanoseconds => (decimal) (_elapsedTicks * TicksToNs);

        private long _startTick;
        private long _elapsedTicks;
        private bool _isRunning;

        [ScriptConstructor]
        public static Chronometer Constructor()
        {
            return new Chronometer();
        }

        [ContextMethod("Старт", "Start")]
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Start()
        {
            if (!_isRunning)
            {     
                _startTick = GetTick();
                _isRunning = true;
            }
        }

        [ContextMethod("Стоп", "Stop")]
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Stop()
        {    
            if (_isRunning)
            {
                _elapsedTicks = GetTick() - _startTick;
                _isRunning = false;
            }      
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        private static long GetTick() => Stopwatch.GetTimestamp();
    }
}
