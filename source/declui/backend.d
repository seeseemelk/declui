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

	/// Creates a window.
	IWindow window();

	/// Creates a label.
	ILabel label();

	/// Creates a button.
	IButton button();
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

private auto createBackend()
{
	import declgtk.backend : GtkBackend;
	return new GtkBackend;
}
