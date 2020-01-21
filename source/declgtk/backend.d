module declgtk.backend;

import declgtk.components;
import declui.backend;
import declui.components.window;
import gio.Application;

/**
Creates GTK components.
*/
class GtkBackend : ComponentBackend
{
	private Application _application;

	override void run(string[] args, IWindow window)
	{
		_application = new Application("dlang.decluiApplication", GApplicationFlags.FLAGS_NONE);
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
}
