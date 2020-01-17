module declui.elements.window;

import declui;
import declui.element;
import declui.elements.menu;
import gtk.ApplicationWindow;
import gtk.Box;
import gtk.MenuBar;

class Window : Element
{
	this(AppData appdata)
	{
		_window = new ApplicationWindow(appdata.application);
		_box = new Box(GtkOrientation.VERTICAL, 3);
		_box.setHomogeneous(true);
		_window.add(_box);
		_window.show();
		_box.show();
	}

	void visible(bool visible)
	{
		_window.setWidgetVisibility(visible);
	}

	bool visible()
	{
		return _window.isVisible();
	}

	void title(string name)
	{
		_window.setTitle(name);
	}

	void add(Element element)
	{
		if (cast(Menu) element !is null)
			_window.add(element.asGTK);
		//else
			//_box.add(element.asGTK());
	}

	override Widget asGTK()
	{
		return _window;
	}

private:
	ApplicationWindow _window;
	Box _box;
	
}