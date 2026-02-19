#if NETCOREAPP
using OneScript.Contexts;
#endif

using ScriptEngine.Machine;
using ScriptEngine.Machine.Contexts;

namespace BenchmarkOneScript.Extensions;

[ContextClass("РасширениеТипа")]
public class TypeExtension : AutoContext<TypeExtension>
{
    [ContextProperty("Источник", "Source")]
    public string Source =>
#if NETCOREAPP
        AttachedScriptsFactory.GetModuleOfType(_type.ToString())?.Source?.Location ?? "";
#else
        AttachedScriptsFactory.GetModuleOfType(_type.ToString())?.ModuleInfo?.Origin ?? "";
#endif
    
    IValue _type;

    public TypeExtension(IValue type)
    {
        _type = type;
    }

    [ScriptConstructor]
    public static TypeExtension Constructor(IValue type)
    {
        return new TypeExtension(type);
    }
}