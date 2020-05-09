module declui.backend;

import declui.components;

/**
The backend for a given UI toolkit.
It is used to create compoonents and to enter the main event loop.
*/
interface ToolkitBackend
{
	/// Enters the main event loop for the backend.
	void run(string[] args, IWindow window);

	ToolkitWidgets getWidgets();
}

/**
An interface that can create widgets for a backend.
*/
interface ToolkitWidgets
{
	/// Creates a window.
	IWindow window();

	/// Creates a label.
	ILabel label();

	/// Creates a button.
	IButton button();

	/// Creates a menubar.
	IMenuBar menubar();

	/// Creates a menu.
	IMenu menu();

	/// Creates a menu button.
	IMenuButton menubutton();

	/// Creates a text area.
	ITextArea textarea();
}

private static ToolkitBackend _backend = null;

/// Gets the backend used to create compoonents.
ToolkitBackend dui()
{
	if (_backend is null)
	{
		_backend = createBackend();
	}
	return _backend;
}

version(unittest) private ToolkitBackend createBackend()
{
	import declui.testing : TestingBackend;
	return new TestingBackend;
}
else private ToolkitBackend createBackend()
{
	import std.process : environment;
	import std.stdio : stderr;
	import core.stdc.stdlib : exit;

	auto toolkit = environment.get("DECLUI_TOOLKIT", "gtk");
	if (toolkit !in _toolkits)
	{
		stderr.writefln!"Error: there is no toolkit registered under the name '%s'."(toolkit);
		stderr.writeln("The following toolkits are available:");
		foreach (name, _; _toolkits)
			stderr.writefln!"  - %s"(name);
		exit(1);
	}

	return _toolkits[toolkit]();
}

alias ToolkitFactory = ToolkitBackend function();
private ToolkitFactory[string] _toolkits;

/**
Registers a new toolkit backend that can be used to run the app.
Params:
  factory = The factory that can create a toolkit backend.
  name = The name of the backend.
*/
void registerToolkit(string name, ToolkitFactory factory)
{
	_toolkits[name] = factory;
}
