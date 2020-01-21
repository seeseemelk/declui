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

/**
This class will parse a DUI file and automatically create a user interface based
on that DUI file.

Type Params:
  file = The name of the DUI file. This file should be present in the views
         directory and end with the `.dui` extension.
*/
abstract class Component(string file) : ReturnType!(__traits(getMember, ToolkitBackend, parseDUI!file.name))
{
	/*
	These are all compile-time constructs that will automatically create the
	class according to the DUI file passed in as a type argument.
	*/
	private enum tag = parseDUI!file;
	alias Type = ReturnType!(__traits(getMember, dui(), tag.name));

	private Type _instance;

    /**
    Creates the component and all child components.
    */
	this()
	{
		enum tag = parseDUI!file;
        _instance = instantiateTag!tag;
	}

    private auto instantiateTag(Tag tag)()
    {
        auto instance = __traits(getMember, dui, tag.name)();
        static foreach (attribute; tag.attributes)
        {
            static if (attribute.name != "id")
            {
                __traits(getMember, instance, attribute.name)(attribute.value);
            }
        }

        if (tag.children.length > 0)
        {
            static assert(is(instance == IContainer), "A '" ~ typeof(instance).stringof ~ "' cannot have child components");
        }
        return instance;
    }

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
	Here are normal, non-compile-time constructs that are common to every
	component.
	*/
	/*private string _id;

	/// Returns the ID of the component.
	public string id()
	{
		return _id;
	}

	/// Sets the ID of the component.
	public void id(string id)
	{
		_id = id;
	}*/
}
