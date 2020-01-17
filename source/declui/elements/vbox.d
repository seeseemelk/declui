module declui.elements.vbox;

import declui.element;
import declui.elements.hbox;
import gtk.Box : GtkBox = Box;

class VBox : Box
{
	this(AppData data)
	{
		super(data, GtkOrientation.VERTICAL);
	}
}