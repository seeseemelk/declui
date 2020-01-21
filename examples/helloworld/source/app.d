module app;

import declui;

private class MyWindow : Component!"helloworld"
{
	/*override void clicked()
	{
		import std.stdio : writeln;
		writeln("Button was pressed");
	}*/
}

void main(string[] args)
{
	dui.run(args, new MyWindow);
}
