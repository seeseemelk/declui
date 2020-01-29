module declui.components.component;

/**
A single component of a window.
*/
interface IComponent
{
	/**
	Sets the visibility of the component.
	Params:
	visible = `true` if the component should be visible, `false` if it should be invisible.
	*/
	void visible(bool visible);

	/**
	Gets the visibility of the component.
	*/
	bool visible();

	/**
	Returns the component owned by the backend.
	*/
	IComponent getInternal() pure;
}
