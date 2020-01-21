module declgtk.components.component;

import declui.components.component;
import gtk.Widget;

/**
A Component with a GTK backend.
*/
abstract class GtkComponent : IComponent
{
	/// Returns the GTK widget object representing this component.
	abstract Widget getWidget();

	override void visible(bool visible)
	{
		getWidget().setVisible(visible);
	}

	override bool visible()
	{
		return getWidget().getVisible();
	}
}
