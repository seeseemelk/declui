module declui.elements.label;

import declui.element;
import gtk.Label : GtkLabel = Label;

class Label : Element
{
	this(AppData appdata)
	{
		_label = new GtkLabel("No text");
		_label.show();
	}

	void visible(bool visible)
	{
		_label.setWidgetVisibility(visible);
	}

	bool visible()
	{
		return _label.isVisible();
	}

	void text(string text)
	{
		_label.setText(text);
	}

	string text()
	{
		return _label.getText();
	}

	override Widget asGTK()
	{
		return _label;
	}

private:
	GtkLabel _label;
}