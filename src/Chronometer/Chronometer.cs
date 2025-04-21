using System;
using System.IO;
using System.Reflection;
using ScriptEngine.Machine.Contexts;

#if NET6_0_OR_GREATER
using OneScript.Contexts;
#endif

namespace OscriptChronometer
{
    [ContextClass("Хронометр", "Chronometer")]
    public class Chronometer : AutoContext<Chronometer>
    {

        [ContextProperty("Наносекунд", "Nanoseconds")]
        public decimal Nanoseconds { get; private set; }

        private Perfolizer.Horology.StartedClock _Clock;

        static Chronometer()
        {
            AppDomain.CurrentDomain.AssemblyResolve += AssemblyResolve;
        }

        [ScriptConstructor]
        public static Chronometer Constructor()
        {
            return new Chronometer();
        }

        [ContextMethod("Старт", "Start")]
        public void Start()
        {
            _Clock = Perfolizer.Horology.Chronometer.Start();
        }

        [ContextMethod("Стоп", "Stop")]
        public void Stop()
        {
            var clockElapsed = _Clock.GetElapsed();
            Nanoseconds = (decimal) clockElapsed.GetNanoseconds();
        }

        static Assembly AssemblyResolve(object sender, ResolveEventArgs args)
        {
            var assembly = Assembly.GetExecutingAssembly();
            string libPath = Path.Combine(
                    Path.GetDirectoryName(assembly.Location),
                    new AssemblyName(args.Name).Name + ".dll");

            return Assembly.LoadFile(libPath);
        }
    }
}
