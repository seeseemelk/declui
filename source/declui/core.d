/**
Contains the core Component class.
This class will adapt itself at compile-time to a given DUI script.
*/
module declui.core;

import declui.components.component;
import declui.components.container;
import declui.backend;
import declui.parser;

import std.traits;
import std.format;
import std.conv;

/**
An interface that provides methods for every callback that is in tag.
*/
interface EventHandler(Tag tag)
{
	static foreach (callback; tag.findCallbacks)
	{
		mixin(format!"void %s();"(callback));
	}
}

/**
This class will create a component from a Tag tree.
*/
class ComponentFromTag(Tag tag) : ReturnType!(__traits(getMember, ToolkitBackend, tag.name))
{
	/*
	These are all compile-time constructs that will automatically create the
	class according to the DUI file passed in as a type argument.
	*/
	alias Type = ReturnType!(__traits(getMember, dui(), tag.name));

	private Type _instance;

    /**
    Creates the component and all child components.
    */
	this()
	{
		_instance = __traits(getMember, dui, tag.name)();
        static foreach (attribute; tag.attributes)
        {
            static if (attribute.name != "id")
            {
                __traits(getMember, _instance, attribute.name)(attribute.value);
            }
        }

        static if (tag.children.length > 0)
        {
            static assert(isAssignable!(IContainer, typeof(_instance)), text("A component of type '",
					typeof(_instance).stringof,
					"' cannot have child components"));
			static foreach (child; tag.children)
			{
				_instance.add(new ComponentFromTag!child);
			}
        }
	}

	/*
	Auto-generated getters and setters.
	*/
	static foreach (memberName; __traits(allMembers, Type))
	{
		static foreach (member; __traits(getOverloads, Type, memberName))
		{
			static if (Parameters!member.length > 0)
			{
				mixin(`
					override %s %s(%s value)
					{
						return _instance.%s(value);
					}
					`.format(ReturnType!member.stringof, memberName, Parameters!member[0].stringof, memberName)
				);
			}
			else
			{
				mixin(`
					override %s %s()
					{
						return _instance.%s();
					}
					`.format(ReturnType!member.stringof, memberName, memberName)
				);
			}
		}
	}

	/*
	Auto-generated event handlers
	*/
}

/**
This class will parse a DUI file and automatically create a user interface based
on that DUI file.

Type Params:
  file = The name of the DUI file. This file should be present in the views
         directory and end with the `.dui` extension.
*/
class Component(string file) : ComponentFromTag!(parseDUI!file)
{
}

@("IContainer can have children")
unittest
{
	enum tag = Tag("window", [], [Tag("label")]); // @suppress(dscanner.suspicious.unused_variable)
	assert(__traits(compiles, ComponentFromTag!tag), "Failed to compile Component");
}

@("Non-IContainers cannot have children")
unittest
{
	enum tag = Tag("label", [], [Tag("label")]); // @suppress(dscanner.suspicious.unused_variable)
	assert(!__traits(compiles, ComponentFromTag!tag), "Did compile Component, but shouldn't have");
}
