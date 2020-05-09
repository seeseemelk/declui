module declgtk.components.menu;

import declgtk.components.component;
import declgtk.util;
import declgtk.queue;
import declui.components.menu;
import gtk.Application : Application;
import gio.Menu;
import gio.MenuItem;
import gio.SimpleAction;
import gio.Application : GioApplication = Application;
import std.uuid;

/**
A GTK menubar.
*/
class GtkMenuBar : GtkComponent!Menu, IMenuBar, IApplicationProxy
{
	private IApplicationProxy _application;

	override Menu createInstance()
	{
		return new Menu();
	}

	override void add(IMenu menu)
	{
		auto gtkMenu = asGtk!GtkMenu(menu);
		gtkMenu.application = this;
		queue(menu => menu.appendSubmenu(gtkMenu.text, gtkMenu.getWidget));
	}

	void application(IApplicationProxy app)
	{
		_application = app;
	}

	override Application application() pure @nogc @safe nothrow
	{
		return _application.application();
	}

	override GioApplication gioApplication()
	{
		return _application.gioApplication;
	}
}

/**
A GTK menu.
*/
class GtkMenu : GtkComponent!Menu, IMenu, IApplicationProxy
{
	private string _text;
	private IApplicationProxy _application;

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
		gtkMenuButton.application = this;
		queue((widget)
		{
			auto menuWidget = gtkMenuButton.getWidget();
			assert(menuWidget !is null, "Menu widget is null");
			widget.appendItem(menuWidget);
		});
	}

	void application(IApplicationProxy app)
	{
		_application = app;
	}

	override Application application() pure @nogc @safe nothrow
	{
		return _application.application();
	}

	override GioApplication gioApplication()
	{
		return _application.gioApplication;
	}
}

/**
A GTK menu button.
*/
class GtkMenuButton : GtkComponent!MenuItem, IMenuButton, IApplicationProxy
{
	private string _text;
	private immutable string _uuid;
	private IApplicationProxy _application;

	this()
	{
		_uuid = randomUUID().toString();
	}

	override MenuItem createInstance()
	{
		return new MenuItem("(unnamed menubutton)", "app." ~ _uuid);
	}

	override string text()
	{
		return _text;
	}

	override void text(string text)
	{
		_text = text;
		queue((widget)
		{
			widget.setLabel(text);
		});
	}

	override void delegate() onClick()
	{
		assert(0);
	}

	override void onClick(void delegate() callback)
	{
		queue((MenuItem widget)
		{
			MenuItem item = widget;
			auto action = new SimpleAction(_uuid, null);
			action.addOnActivate((variant, action)
			{
				callback();
				executeGtkQueue();
			});
			gioApplication.addAction(action);
		});
	}

	void application(IApplicationProxy app)
	{
		_application = app;
	}

	override Application application()
	{
		return _application.application;
	}

	override GioApplication gioApplication()
	{
		return _application.gioApplication;
	}
}
