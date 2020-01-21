module declui.components.window;

import declui.components.component;

/**
Represents a graphical window.
*/
interface IWindow : IComponent
{
	/// Gets the current title of the window.
	string title();

	/// Sets the new title of the window.
	void title(string title);
}
