/*
Utility functions for the GTK DeclUI backend
*/
module declgtk.util;

import declgtk.components.component;
import declui.components.component;
import gtk.Application : Application;

import std.conv;

/**
An interface that can be used to access the GTK application class.
*/
interface IApplicationProxy
{
	/**
	Returns the GTK application instances.
	*/
	Application application() pure nothrow @safe @nogc
	out (v; v !is null);
}

/**
Casts an `IComponent` to a `GtkWidgetComponent`.
If the component itself cannot be cast, it will try to cast it's internal component.
Note that this method should only ever be executed from the GTK main thread.
*/
IGtkWidgetComponent asGtk(IComponent component)
{
    return asGtk!IGtkWidgetComponent(component);
}

/**
Casts an `IComponent` to a `GtkComponent`.
If the component itself cannot be cast, it will try to cast it's internal component.
Note that this method should only ever be executed from the GTK main thread.
*/
T asGtk(T)(IComponent component)
{
    if (cast(T) component !is null)
        return cast(T) component;

    auto internal = component.getInternal();
    assert(cast(T) internal !is null,
            text("Cannot turn a ", typeof(internal).stringof, " into a component"));
    return cast(T) internal;
}
