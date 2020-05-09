/**
Contains functions that are used while running unittests.
*/
module declui.testing;

import declui.backend;
import declui.components;

import std.format;
import std.traits;
import std.typecons;

/**
A backend that automatically stubs out every instantiation method.
*/
class TestingBackend : ToolkitBackend, ToolkitWidgets
{
	override void run(string[] args, IWindow window)
	{
		assert(0, "Run is not supported during testing");
	}

	override ToolkitWidgets getWidgets()
	{
		return this;
	}

	static foreach (member; __traits(derivedMembers, ToolkitWidgets))
	{
		static if (member != "run")
		{
			mixin(format!`
				%s %s()
				{
					return createMockInstance!(%s);
				}
				`(
				fullyQualifiedName!(ReturnType!(__traits(getMember, ToolkitWidgets, member))),
				member,
				fullyQualifiedName!(ReturnType!(__traits(getMember, ToolkitWidgets, member))))
			);
		}
	}
}

private abstract class AutoMock(Type) : Type
{
	override IComponent getInternal() pure
	{
		return this;
	}
}

private Type createMockInstance(Type)()
{
	return new BlackHole!(Type);
}
