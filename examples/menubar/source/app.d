module app;

import declui;
import std.conv;

private class MyWindow : Component!"helloworld"
{
	override void pressed()
	{
		byId.label.text = "Pressed the menu button";
	}
}

void main(string[] args)
{
	dui.run(args, new MyWindow);
}
