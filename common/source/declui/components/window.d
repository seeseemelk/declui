/**
A window component.
*/
module declui.components.window;

import declui.components.component;
import declui.components.container;

/**
Represents a graphical window.
*/
interface IWindow : IComponent, IContainer
{
	/// Gets the current title of the window.
	string title();

	/// Sets the new title of the window.
	void title(string title);
}
