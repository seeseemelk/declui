module declui.components.component;

import declui.backend;
import declui.parser;
import std.traits;
import std.format;
import std.meta;

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
}

abstract class Component(string file) : ReturnType!(__traits(getMember, ComponentBackend, parseDUI!file.name))
{
	enum tag = parseDUI!file;
	//alias factory = __traits(getMember, dui(), tag.name);
	alias Type = ReturnType!(__traits(getMember, dui(), tag.name));

	private Type _instance;

	this()
	{
		_instance = __traits(getMember, dui, tag.name)();
		enum tag = parseDUI!file;
		static foreach (attribute; tag.attributes)
		{
			__traits(getMember, this, attribute.name)(attribute.value);
		}
	}

	static foreach (member; __traits(allMembers, Type))
	{
		alias argType = Alias!(ReturnType!(__traits(getMember, Type, member)).stringof);
		pragma(msg, member);

		mixin(format!`
			%s %s()
			{
				return _instance.%s();
			}

			void %s(%s value)
			{
				_instance.%s(value);
			}
			`(argType, member, member, member, argType, member));
	}
}
