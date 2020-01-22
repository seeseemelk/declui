module declgtk.components.window;

import declgtk.components.component;
import declgtk.util;
import declui.components.component;
import declui.components.window : IWindow;
import gtk.Application : Application;
import gtk.Window;
import gtk.ApplicationWindow : ApplicationWindow;
import gtk.VBox;

/**
A GTK window.
*/
class GtkWindow : GtkComponent!VBox, IWindow
{
	private Application _application;
	private Window _window;
	private string _title = "Untitled Window";

	private Window createWindow()
	{
		if (_application is null)
			return new Window(_title);
		else
			return new ApplicationWindow(_application);
	}

	override VBox createInstance()
	{
		_window = createWindow();
		auto vbox = new VBox(true, 3);
		_window.add(vbox);
		return vbox;
	}

	void setApplication(Application application)
	{
		_application = application;
	}

	override string title()
	{
		return _title;
	}

	override void title(string title)
	{
		_title = title;
		queue(widget => _window.setTitle(title));
	}

	override void add(IComponent child)
	{
		queue(widget => widget.add(child.asGtk.getWidget()));
	}

	override void visible(bool visible)
	{
		super.visible = visible;
		queue((widget)
		{
			if (visible)
				_window.show();
			else
				_window.hide();
		});
	}
}
