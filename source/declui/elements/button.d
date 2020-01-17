module declui.elements.button;

import declui.element;
import gtk.Button : GtkButton = Button;
import gdk.Event;
import std.functional;

class Button : Element
{
	this(AppData appdata)
	{
		_button = new GtkButton("Wow");
		_button.show();
	}

	void visible(bool visible)
	{
		_button.setWidgetVisibility(visible);
	}

	bool visible()
	{
		return _button.isVisible();
	}

	void onClick(void delegate() callback)
	{
		bool delegate(Event, Widget) dlg = (event, widget) {
			callback();
			return false;
		};

		_button.addOnButtonPress(dlg);
	}

	override Widget asGTK()
	{
		return _button;
	}

private:
	GtkButton _button;
}