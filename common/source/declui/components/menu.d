/**
Contains interfaces needed to build a menu.
*/
module declui.components.menu;

import declui.components.component;

/**
A menubar that is generally displayed at the the top of a window. Note that this
might not always be the case. On certain platforms the menubar might be
displayed somewhere else, such as at the very top of the screen.
*/
interface IMenuBar : IComponent
{
	/// Adds a menu to the menubar.
	void add(IMenu menu);
}

/**
A menu or submenu.
*/
interface IMenu : IComponent
{
	/// Gets the text for this menu.
	string text();

	/// Sets the text for this menu.
	void text(string);

	/// Adds a submenu to the menu.
	void add(IMenu menu);

	/// Adds a menu button to the menu.
	void add(IMenuButton button);
}

/**
A clickable button that is part of a menu.
*/
interface IMenuButton : IComponent
{
	/// Gets the text for this menu.
	string text();

	/// Sets the text for this menu.
	void text(string);

	/// Gets the callback that is executed when the button is clicked.
	void delegate() onClick();

	/// Sets the callback that is executed when the button is clicked.
	void onClick(void delegate() callback);
}
