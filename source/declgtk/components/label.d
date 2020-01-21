module declgtk.components.label;

import declgtk.components.component;
import declui.components.label : ILabel;
import gtk.Label;

/**
A GTK label
*/
class GtkLabel : GtkComponent, ILabel
{
	private Label _label;

	this()
	{
		_label = new Label("");
	}

	override Label getWidget()
	{
		return _label;
	}

	override string text()
	{
		return _label.getText();
	}

	override void text(string text)
	{
		_label.setText(text);
	}
}
