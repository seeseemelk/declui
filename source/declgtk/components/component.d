module declgtk.components.component;

import declgtk.componentproxy;
import declgtk.queue;
import declui.components.component;
import gtk.Widget;

/**
An interface that defines some basic methods that can be used without requiring
instantiation the underlying template.
*/
interface IGtkComponent
{
	Widget getWidget();
}

/**
A Component with a GTK backend.
*/
abstract class GtkComponent(Type) : IGtkComponent, IComponent
{
	private Type _widget;

	/// Initialises the component.
	final void initialise()
	{
		_widget = createInstance();
		_visible = true;
		_widget.show();
	}

	/// Returns the internal widget.
	override final Type getWidget()
	{
		if (_widget is null)
			initialise();
		assert(_widget !is null, "Widget was not correctly created");
		return _widget;
	}

	/// Queues a setter to be executed.
	protected void queue(void delegate(Type) callback)
	{
		queueOnGtk(
		{
				callback(getWidget);
		});
	}

	/// Creates and returns an new instance of this type.
	protected abstract Type createInstance();

	override IComponent getInternal()
	{
		return this;
	}

	/*
	Methods common for all Gtk Widgets
	*/
	private bool _visible = false;
	override void visible(bool visible)
	{
		_visible = visible;
		queue((widget)
		{
			if (_visible)
				widget.show();
			else
				widget.hide();
		});
	}

	override bool visible()
	{
		return _visible;
	}
}
