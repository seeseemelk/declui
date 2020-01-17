module declui.elements.menubutton;

import declui.element;
import gtk.MenuButton : GtkMenuButton = MenuButton;

class MenuButton : Element
{
	this(AppData appdata)
	{
		_button = new GtkMenuButton();
		visible = true;
	}

	void visible(bool visible)
	{
		_button.setWidgetVisibility(visible);
	}

	bool visible()
	{
		return _button.isVisible();
	}

	override Widget asGTK()
	{
		return _button;
	}

private:
	GtkMenuButton _button;
}