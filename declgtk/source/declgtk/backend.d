module declgtk.backend;

import declgtk.components;
import declgtk.queue;
import declgtk.util;
import declui.backend;
import declui.components.window;
import gtk.Application : Application, GApplicationFlags;
import gtk.ApplicationWindow : ApplicationWindow;
import gio.Application : GioApplication = Application;

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
class GtkBackend : ToolkitBackend, ToolkitWidgets, IApplicationProxy
{
	private Application _application;
	private GioApplication _gioApplication;
	private void delegate()[] callbacks;

	/// Queues a callback to be run on the GTK event loop.
	void queue(void delegate() callback)
	{
		callbacks ~= callback;
	}

	override void run(string[] args, IWindow window)
	{
		version(linux)
		{
			version (DMD)
			{
				import etc.linux.memoryerror : registerMemoryErrorHandler;
				registerMemoryErrorHandler();
			}
		}

		GtkWindow gtkWindow = cast(GtkWindow) window.getInternal();
		assert(gtkWindow !is null, "window is not a GtkWindow");

		_application = new Application("dlang.declui.app", GApplicationFlags.FLAGS_NONE);
		_application.addOnActivate((gioApp)
		{
			_gioApplication = gioApp;
			gtkWindow.setApplication(this);
			gtkWindow.visible = true;
			executeGtkQueue();
		});
		_application.run(args);
	}

	override ToolkitWidgets getWidgets()
	{
		return this;
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

	override GtkMenuBar menubar()
	{
		return new GtkMenuBar;
	}

	override GtkMenu menu()
	{
		return new GtkMenu;
	}

	override GtkMenuButton menubutton()
	{
		return new GtkMenuButton;
	}

	override GtkTextArea textarea()
	{
		return new GtkTextArea;
	}

	override Application application()
	{
		return _application;
	}

	override GioApplication gioApplication()
	{
		return _gioApplication;
	}
}

shared static this()
{
	registerToolkit("gtk", () => new GtkBackend);
}
