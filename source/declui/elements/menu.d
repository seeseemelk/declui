module declui.elements.menu;

import declui.element;
import gtk.MenuItem : GtkMenu = MenuItem;

class Menu : Element
{
	this(AppData appdata)
	{
		_menu = new GtkMenu();
		visible = true;
	}

	void visible(bool visible)
	{
		_menu.setWidgetVisibility(visible);
	}

	bool visible()
	{
		return _menu.isVisible();
	}

	void text(string text)
	{
		_menu.setName(text);
	}

	void add(Element element)
	{
		_menu.add(element.asGTK);
	}

	override Widget asGTK()
	{
		return _menu;
	}

private:
	GtkMenu _menu;
}