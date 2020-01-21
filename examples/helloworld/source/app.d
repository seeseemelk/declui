module app;
import declui;
import declui.elements.label;

private class MyWindow : Document!"helloworld"
{
	override void clicked()
	{
		import std.stdio : writeln;
		writeln("Button was pressed");
	}
}

void main(string[] args)
{
	auto window = new MyWindow;
	runGUI(args, window);
}
