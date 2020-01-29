module declgtk.components.button;

import declgtk.components.component;
import declgtk.queue;
import declui.components.button : IButton;
import gtk.Button;

/**
A GTK button
*/
class GtkButton : GtkComponent!Button, IButton
{
	private string _text = "Untitled Label";
	private void delegate() _clicked;

	override Button createInstance()
	{
		auto button = new Button(_text);
		button.addOnClicked((button)
		{
			_clicked();
			executeGtkQueue();
		});
		return button;
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

	override void delegate() click()
	{
		return _clicked;
	}

	override void click(void delegate() clicked)
	{
		_clicked = clicked;
	}
}
