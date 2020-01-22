module declgtk.backend;

import declgtk.components;
import declgtk.queue;
import declui.backend;
import declui.components.window;
import gio.Application : GioApplication = Application;
import gtk.Application : Application, GApplicationFlags;
import gtk.ApplicationWindow : ApplicationWindow;

import std.exception;

private static bool _started = false;

/**
Determines whether or not GTK has already been started.
Returns: `true` if GTK was started, `false` if it has not yet been started.
*/
bool isGTKStarted()
{
	return _started;
}

/**
Creates GTK components.
*/
class GtkBackend : ToolkitBackend
{
	private Application _application;
	private void delegate()[] callbacks;

	/// Queues a callback to be run on the GTK event loop.
	void queue(void delegate() callback)
	{
		callbacks ~= callback;
	}

	override void run(string[] args, IWindow window)
	{
		GtkWindow gtkWindow = cast(GtkWindow) window.getInternal();
		assert(gtkWindow !is null, "window is not a GtkWindow");

		_application = new Application("dlang.decluiApplication", GApplicationFlags.FLAGS_NONE);
		_application.addOnActivate((gioApp)
		{
			gtkWindow.setApplication(_application);
			gtkWindow.visible = true;
			executeGtkQueue();
		});
		_application.run(args);
	}

	override GtkWindow window()
	{
		return new GtkWindow;
	}

	override GtkLabel label()
	{
		return new GtkLabel;
	}

	override GtkButton button()
	{
		return new GtkButton;
	}
}
