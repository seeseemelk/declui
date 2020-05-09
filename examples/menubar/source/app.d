module app;

import declui;
import std.conv;
import std.stdio;

private class MyWindow : Component!"helloworld"
{
	override void pressedMenuButton()
	{
		byId.label.text = "Pressed the menu button";
		writeln("Pressed a button");
	}
}

void main(string[] args)
{
	dui.run(args, new MyWindow);
}
