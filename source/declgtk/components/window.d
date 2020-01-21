module declgtk.components.window;

import declgtk.components.component;
import declui.components.window : IWindow;
import gtk.Window;

/**
A GTK window.
*/
class GtkWindow : GtkComponent, IWindow
{
	private Window _window;

	this()
	{
		_window = new Window("untitled");
	}

	override Window getWidget()
	{
		return _window;
	}

	override string title()
	{
		return _window.getTitle();
	}

	override void title(string title)
	{
		_window.setTitle(title);
	}
}
