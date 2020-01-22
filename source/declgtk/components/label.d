module declgtk.components.label;

import declgtk.components.component;
import declui.components.label : ILabel;
import gtk.Label;

/**
A GTK label
*/
class GtkLabel : GtkComponent!Label, ILabel
{
	private string _text = "Untitled Label";

	override Label createInstance()
	{
		return new Label(_text);
	}

	override string text()
	{
		return _text;
	}

	override void text(string text)
	{
		_text = text;
		queue(widget => widget.setText(text));
	}
}
