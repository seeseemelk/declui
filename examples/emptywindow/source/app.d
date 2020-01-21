module app;
import declui.components.component;
import declui.backend;

private class EmptyWindow : Component!"emptywindow"
{

}

void main(string[] args)
{
	dui.run(args, new EmptyWindow);
}
