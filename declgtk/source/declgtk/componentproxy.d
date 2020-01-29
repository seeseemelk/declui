module declgtk.componentproxy;

import declui.backend;

struct ComponentProxy(Type, args...)
{
    private Type _value;
    private void delegate(Type)[] _queue;

    public void queue(void delegate(Type) callback)
    {
        _queue ~= callback;
    }

    public void execute()
    {
        createValue();
        foreach (callback; _queue)
        {
            callback(_value);
        }
    }

    private void createValue()
    {
        if (_value !is null)
            return;
        _value = new Type(args);
    }
}
