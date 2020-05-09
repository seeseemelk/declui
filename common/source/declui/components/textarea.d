module declui.components.textarea;

import declui.components.component;

/**
A multiline text field.
*/
interface ITextArea : IComponent
{
	/// Gets the text shown in this text area.
	string text();

	/// Sets the text shown in this text area.
	void text(string text);

	/**
	Returns `true` if the text is being shown in a monospaced font,
	`false` if it isn't.
	*/
	bool monospace();

	/// Sets whether the text should be shown in a monospaced font or not.
	void monospace(bool monospaced);
}
