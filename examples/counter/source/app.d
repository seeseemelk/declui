module app;

import declui;
import std.conv;

private class MyWindow : Component!"helloworld"
{
	private int _clickCount = 0;

	private void updateLabel()
	{
		byId.count.text = text("Count: ", _clickCount);
	}

	override void clickedIncrease()
	{
		_clickCount++;
		updateLabel();
	}

	override void clickedDecrease()
	{
		_clickCount--;
		updateLabel();
	}
}

void main(string[] args)
{
	dui.run(args, new MyWindow);
}
