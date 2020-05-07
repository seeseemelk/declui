module declgtk.components.menu;

import declgtk.components.component;
import declgtk.util;
import declui.components.menu;
import gtk.Application : Application;
import gio.Menu;
import gio.MenuItem;
import std.uuid;

/**
A GTK menubar.
*/
class GtkMenuBar : GtkComponent!Menu, IMenuBar
{
	private Application _application;

	override Menu createInstance()
	{
		return new Menu();
	}

	override void add(IMenu menu)
	{
		auto gtkMenu = asGtk!GtkMenu(menu);
		gtkMenu.menubar = this;
		queue(menu => menu.appendSubmenu(gtkMenu.text, gtkMenu.getWidget));
	}

	void application(Application app)
	{
		_application = app;
	}

	Application application()
	{
		return _application;
	}
}

/**
A GTK menu.
*/
class GtkMenu : GtkComponent!Menu, IMenu
{
	private string _text;
	private GtkMenuBar _menubar;

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
		auto gtkMenuButton = menubutton.asGtk!GtkMenuButton;
		gtkMenuButton.menubar = this;
		queue((widget)
		{
			auto menuWidget = gtkMenuButton.getWidget();
			assert(menuWidget !is null, "Menu widget is null");
			widget.appendItem(menuWidget);
		});
	}

	void menubar(GtkMenuBar menubar)
	{
		_menubar = menubar;
	}
}

/**
A GTK menu button.
*/
class GtkMenuButton : GtkComponent!MenuItem, IMenuButton
{
	private string _text;
	private immutable string _uuid;
	private GtkMenuBar _menubar;

	this()
	{
		_uuid = randomUUID().toString();
	}

	override MenuItem createInstance()
	{
		return new MenuItem("(unnamed menubutton)", _uuid);
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
		queue((MenuItem widget)
		{
			//Application application = _menubar.application();
			//application.add
		});
	}

	void menubar(GtkMenuBar menubar)
	{
		_menubar = menubar;
	}
}
