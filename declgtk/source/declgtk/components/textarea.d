module declgtk.components.textarea;

import declgtk.components.component;
import declui.components.textarea;
import gtk.TextView;

/**
A GTK TextView
*/
final class GtkTextArea : GtkComponent!TextView, ITextArea
{
	override TextView createInstance()
	{
		return new TextView;
	}

	override string text()
	{
		assert(0, "Not yet implemented");
	}

	override void text(string text)
	{
		assert(0, "Not yet implemented");
	}

	private bool _monospace;
	override bool monospace()
	{
		return _monospace;
	}

	override void monospace(bool monospaced)
	{
		_monospace = monospace;
		queue(widget => widget.setMonospace(monospaced));
	}
}
