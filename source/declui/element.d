module declui.element;

public import declui : AppData;
public import gtk.Widget;

void setWidgetVisibility(Widget widget, bool visible)
{
	if (visible)
		widget.show();
	else
		widget.hide();
}

abstract class Element
{
	void id(string id)
	{
		_id = id;
	}

	string id() const pure
	{
		return _id;
	}

	abstract Widget asGTK();

private:
	string _id;
}