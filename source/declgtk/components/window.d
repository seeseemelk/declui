module declgtk.components.window;

import declgtk.components.component;
import declui.components.component;
import declui.components.window : IWindow;
import gtk.Application : Application;
import gtk.Window;
import gtk.ApplicationWindow : ApplicationWindow;

/**
A GTK window.
*/
class GtkWindow : GtkComponent!Window, IWindow
{
	private Application _application;

	override Window createInstance()
	{
		if (_application is null)
			return new Window("Untitled");
		else
			return new ApplicationWindow(_application);
	}

	void setApplication(Application application)
	{
		_application = application;
	}

	override string title()
	{
		assert(0);
		//return getWidget().getTitle();
	}

	override void title(string title)
	{
		queueSetter(window => window.setTitle(title));
	}

	override void add(IComponent child)
	{
		assert(0);
	}
}
