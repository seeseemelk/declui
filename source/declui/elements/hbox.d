module declui.elements.hbox;

import declui.element;
import gtk.Box : GtkBox = Box;

class Box : Element
{
	this(AppData data, GtkOrientation orientation)
	{
		_box = new GtkBox(orientation, 3);
		_box.setHomogeneous(true);
		_box.show();
	}

	void visible(bool visible)
	{
		_box.setWidgetVisibility(visible);
	}

	bool visible()
	{
		return _box.isVisible();
	}

	void add(Element element)
	{
		_box.add(element.asGTK);
	}

	override Widget asGTK()
	{
		return _box;
	}

private:
	GtkBox _box;
}

class HBox : Box
{
	this(AppData data)
	{
		super(data, GtkOrientation.HORIZONTAL);
	}
}