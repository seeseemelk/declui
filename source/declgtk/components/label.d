module declgtk.components.label;

import declgtk.components.component;
import declui.components.label : ILabel;
import gtk.Label;

/**
A GTK label
*/
class GtkLabel : GtkComponent!Label, ILabel
{
	override Label createInstance()
	{
		return new Label("");
	}

	override string text()
	{
		assert(0);
		//return _label.getText();
	}

	override void text(string text)
	{
		queueSetter(label => label.setText(text));
	}
}
