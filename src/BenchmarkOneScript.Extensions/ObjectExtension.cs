#if NET6_0_OR_GREATER
using OneScript.Contexts;
#endif

using ScriptEngine.Machine;
using ScriptEngine.Machine.Contexts;

namespace BenchmarkOneScript.Extensions;

[ContextClass("РасширениеОбъекта")]
public class ObjectExtension : AutoContext<ObjectExtension>
{
    [ContextProperty("ХешКод", "HashCode")]
    public string HashCode => _Object.GetHashCode().ToString("X");
    
    IValue _Object;

    public ObjectExtension(IValue Object)
    {
        _Object = Object;
    }

    [ScriptConstructor]
    public static ObjectExtension Constructor(IValue type)
    {
        return new ObjectExtension(type);
    }
}