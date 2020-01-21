module app;
import declui;

private class EmptyWindow : Component!"emptywindow"
{

}

void main(string[] args)
{
	dui.run(args, new EmptyWindow);
}
