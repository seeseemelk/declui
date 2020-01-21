module declgtk.components.component;

import declgtk.componentproxy;
import declui.components.component;
import gtk.Widget;

alias Setter(T) = void delegate(T);

/**
A Component with a GTK backend.
*/
abstract class GtkComponent(Type) : IComponent
{
	private Type _widget;
	private Setter!Type[] _setterCallbacks;

	/// Initialises the component.
	void initialise()
	{
		_widget = createInstance();
		executeSetters();
	}

	/// Executes all queued setters.
	void executeSetters()
	{
		const queued = _setterCallbacks;
		_setterCallbacks = [];

		foreach (callback; queued)
			callback(_widget);
	}

	/// Returns the internal widget.
	Type getWidget()
	{
		if (_widget is null)
			initialise();
		assert(_widget !is null, "Widget was not correctly created");
		return _widget;
	}

	/// Queues a setter to be executed.
	protected void queueSetter(Setter!Type callback)
	{
		_setterCallbacks ~= callback;
	}

	/// Creates and returns an new instance of this type.
	protected abstract Type createInstance();

	override IComponent getInternal()
	{
		return this;
	}

	private bool _visible = false;
	override void visible(bool visible)
	{
		_visible = visible;
		queueSetter(widget => widget.setVisible(visible));
	}

	override bool visible()
	{
		return _visible;
	}
}
