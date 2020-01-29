module declui.components.label;

import declui.components.component;

/**
A piece of text.
This text cannot be modified by a user.
*/
interface ILabel : IComponent
{
	/// Gets the text shown in the component.
	string text();

	/// Sets the text shown in the component.
	void text(string text);
}
