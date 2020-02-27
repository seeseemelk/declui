module declgtk.components.menu;

import declgtk.components.component;
import declgtk.util;
import declui.components.menu;
import gio.Menu;
import gio.MenuItem;

/**
A GTK menubar.
*/
class GtkMenuBar : GtkComponent!Menu, IMenuBar
{
	override Menu createInstance()
	{
		return new Menu();
	}

	override void add(IMenu menu)
	{
		auto gtkMenu = asGtk!GtkMenu(menu);
		queue(menu => menu.appendSubmenu(gtkMenu.text, gtkMenu.getWidget));
	}
}

/**
A GTK menu.
*/
class GtkMenu : GtkComponent!Menu, IMenu
{
	private string _text;

	override Menu createInstance()
	{
		return new Menu();
	}

	override string text()
	{
		return _text;
	}

	override void text(string text)
	{
		_text = text;
	}

	override void add(IMenu menu)
	{
		assert(0);
	}

	override void add(IMenuButton menubutton)
	{
		
	}
}

/**
A GTK menu button.
*/
class GtkMenuButton : GtkComponent!MenuItem, IMenuButton
{
	private string _text;

	override MenuItem createInstance()
	{
		return new MenuItem("(menu)", "");
	}

	override string text()
	{
		return _text;
	}

	override void text(string text)
	{
		_text = text;
	}

	override void delegate() onClick()
	{
		assert(0);
	}

	override void onClick(void delegate() callback)
	{

	}
}
