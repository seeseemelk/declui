module declgtk.components.button;

import declgtk.components.component;
import declui.components.button : IButton;
import gtk.Button;

/**
A GTK button
*/
class GtkButton : GtkComponent!Button, IButton
{
	private string _text = "Untitled Label";

	override Button createInstance()
	{
		return new Button(_text);
	}

	override string text()
	{
		return _text;
	}

	override void text(string text)
	{
		_text = text;
		queue(widget => widget.setLabel(text));
	}
}
