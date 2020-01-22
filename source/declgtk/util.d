/*
Utility functions for the GTK DeclUI backend
*/
module declgtk.util;

import declgtk.components.component;
import declui.components.component;

import std.conv;

/**
Casts an `IComponent` to a `GtkComponent`.
If the component itself cannot be cast, it will try to cast it's internal component.
Note that this method should only ever be executed from the GTK main thread.
*/
IGtkComponent asGtk(IComponent component)
{
    if (cast(IGtkComponent) component !is null)
        return cast(IGtkComponent) component;

    auto internal = component.getInternal();
    assert(cast(IGtkComponent) internal !is null,
            text("Cannot turn a ", typeof(internal).stringof, " into a component"));
    return cast(IGtkComponent) internal;
}
