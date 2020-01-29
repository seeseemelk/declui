/**
A clickable button component.
*/
module declui.components.button;

import declui.components.component;

/**
A clickable button.
*/
interface IButton : IComponent
{
    /// Gets the text displayed on the button.
    string text();

    /// Sets the text displayed on the button.
    void text(string text);

	/// Gets the callback that is executed when the button is pressed.
	void delegate() click();

	/// Sets the callback that is executed when the button is pressed.
	void click(void delegate() callback);
}
