module declgtk.components.button;

import declgtk.components.component;
import declgtk.queue;
import declui.components.button;
import gtk.Button;

/**
A GTK button
*/
class GtkButton : GtkWidgetComponent!Button, IButton
{
	private string _text = "Untitled Label";
	private void delegate() _onClick;

	override Button createInstance()
	{
		auto button = new Button(_text);
		button.addOnClicked((button)
		{
			_onClick();
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

	override void delegate() onClick()
	{
		return _onClick;
	}

	override void onClick(void delegate() clicked)
	{
		_onClick = clicked;
	}
}
