module declui.components.container;

import declui.components.component;

/**
A container is a type of component that is capable of having child components.
*/
interface IContainer : IComponent
{
    /**
    Adds a child component to the component.
    Params:
      child = The child component to add.
    */
    void add(IComponent child);
}
