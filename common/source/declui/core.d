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

private template symbolOfTag(Tag tag)
{
	alias symbolOfTag = __traits(getMember, dui, tag.name);
}

private template typeOfTag(Tag tag)
{
	alias typeOfTag = ReturnType!(symbolOfTag!tag);
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

	private struct IdContainer
	{
		static foreach (tagged; tag.findIds)
		{
			mixin(format!`private %s _%s;`(
				fullyQualifiedName!(typeOfTag!tagged),
				tagged.id
			));

			mixin(format!
				`private void %s(%s value)
				{
					_%s = value;
				}`(
				tagged.id,
				fullyQualifiedName!(typeOfTag!tagged),
				tagged.id
			));

			mixin(format!
				`auto %s()
				{
					return _%s;
				}`(
				tagged.id,
				tagged.id
			));
		}
	}

	/**
	A struct containing a reference to all children by their id.
	*/
	IdContainer byId;

    /**
    Creates the component and all child components.
    */
	this(EventHandler)(EventHandler eventHandler)
	{
		_instance = __traits(getMember, dui, tag.name)();
        static foreach (attribute; tag.attributes)
        {
			static if (attribute.type == AttributeType.string)
				__traits(getMember, _instance, attribute.name)(attribute.value);
			else static if (attribute.type == AttributeType.boolean)
				__traits(getMember, _instance, attribute.name)(attribute.value.parse!bool);
			else static if (attribute.type == AttributeType.integer)
				__traits(getMember, _instance, attribute.name)(attribute.value.parse!int);
			else static if (attribute.type == AttributeType.callback)
				__traits(getMember, _instance, attribute.name)(&__traits(getMember, eventHandler, attribute.value));
			else
				static assert(0, "Unsupported type " ~ attribute.type);
        }

        static if (tag.children.length > 0)
        {
			static foreach (child; tag.children)
			{
				registerChild!(child)(new ComponentFromTag!(child)(eventHandler));
			}
        }
	}

	private void registerChild(Tag tag, C)(C component)
	{
		_instance.add(component);
		static if (tag.id.length > 0)
		{
			__traits(getMember, byId, tag.id) = component;
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
}

/**
This class will parse a DUI file and automatically create a user interface based
on that DUI file.

Type Params:
  file = The name of the DUI file. This file should be present in the views
         directory and end with the `.dui` extension.
*/
abstract class Component(string file) : ComponentFromTag!(parseDUI!file)
{
	private enum tag = parseDUI!file;

	/// Instantiates a DUI file.
	this()
	{
		super(this);
	}

	static foreach (callback; tag.findCallbacks)
	{
		mixin(format!"abstract void %s();"(callback));
	}
}

@("IContainer can have children")
unittest
{
	enum tag = Tag("window", "", [], [Tag("label")]); // @suppress(dscanner.suspicious.unused_variable)
	static struct EventHandler {}
	new ComponentFromTag!(tag)(EventHandler());
}

@("Non-IContainers cannot have children")
unittest
{
	enum tag = Tag("label", "", [], [Tag("label")]); // @suppress(dscanner.suspicious.unused_variable)
	static struct EventHandler {}
	assert(!__traits(compiles, new ComponentFromTag!tag(EventHandler())), "Did compile Component, but shouldn't have");
}