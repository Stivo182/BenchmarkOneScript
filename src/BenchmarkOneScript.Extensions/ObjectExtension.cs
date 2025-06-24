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

    public ObjectExtension(IValue obj)
    {
        _Object = obj;
    }

    [ScriptConstructor]
    public static ObjectExtension Constructor(IValue obj)
    {
        return new ObjectExtension(obj);
    }
}