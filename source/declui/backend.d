module declui.backend;

import declui.components;

/**
The backend for a given UI toolkit.
It is used to create compoonents and to enter the main event loop.
*/
interface ComponentBackend
{
	/// Enters the main event loop for the backend.
	void run(string[] args, IWindow window);

	/// Creates a window.
	IWindow window();

	/// Creates a label.
	ILabel label();
}

private static ComponentBackend _backend = null;
/// Gets the backend used to create compoonents.
ComponentBackend dui()
{
	import declgtk.backend : GtkBackend;
	if (_backend is null)
		_backend = new GtkBackend;
	return _backend;
}
