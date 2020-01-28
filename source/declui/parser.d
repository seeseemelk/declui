/**
Contains the pegged grammar to parse a DUI file.
*/
module declui.parser;

import pegged.grammar;
import std.format;
import std.algorithm;
import std.array;
import std.range;
import std.uni;

/**
Parses a DUI script.
Params:
  content = The content of the script.
*/
Tag parseDUIScript(string content)()
{
	const tree = DUI(content).children[0];
	static assert(tree.successful, tree.failMsg);
	return tree.parseTreeAsTag();
}

/**
Imports and parses a DUI script.
Param:
  content = The content of the script.
*/
Tag parseDUI(string file)()
{
	return parseDUIScript!(import(file ~ ".dui"));
}

/**
Finds all callbacks in for a given tag.
Param:
  tag = The tag that should be searched for callbacks.
Returns: A list of the name of each callback.
This list will not contain any dupliates.
*/
string[] findCallbacks(const Tag tag)
{
	return findAllCallbacks(tag)
		.dup
		.sort
		.uniq
		.array;
}

private const(string[]) findAllCallbacks(const Tag tag)
{
	auto callbacks = tag.attributes
		.filter!(attribute => attribute.type == AttributeType.callback)
		.map!(attribute => attribute.value)
		.array();

	foreach (child; tag.children)
	{
		callbacks ~= findAllCallbacks(child);
	}
	return callbacks;
}

private Tag parseTreeAsTag(const ParseTree tree)
{
	Tag tag = Tag(tree.matches[0]);

	// Parse attributes
	const descriptor = tree.children[0];
	if (descriptor.children.length > 0 && descriptor.children[0].name == "DUI.AttributeList")
	{
		foreach (child; descriptor.children[0].children)
		{
			auto value = child.children[1];

			tag.attributes ~= Attribute(child.children[0].matches[0], value.matches[0], value.attributeTypeOf());
		}
	}

	// Parse children
	foreach (childTree; tree.children)
	{
		if (childTree.name == "DUI.Element")
			tag.children ~= childTree.parseTreeAsTag();
	}

	return tag;
}

private AttributeType attributeTypeOf(const ParseTree tree)
{
	if (tree.name == "DUI.Value")
		return attributeTypeOf(tree.children[0]);
	switch (tree.name)
	{
		case "DUI.String":
			return AttributeType.string;
		case "DUI.Callback":
			return AttributeType.callback;
		case "DUI.Integer":
			return AttributeType.integer;
		case "DUI.Bool":
			return AttributeType.boolean;
		default:
			assert(0, "Unknown ParseTree type " ~ tree.name);
	}
}

private mixin(grammar(`
DUI:
	# Base types
	Element       <  Descriptor :'{' Element* :'}' / Descriptor
	Descriptor    <  identifier ('#' identifier)? ( :'(' AttributeList :')' )?
	AttributeList <  (Attribute :','?)*
	Attribute     <  Identifier :'=' Value

	# Value types
	Identifier    <  identifier
	Value         <  String / Callback / Integer / Bool
	String        <~ :doublequote (!doublequote Char)* :doublequote
	Char          <~
	              / backslash (
					/ doublequote
					/ quote
					/ backslash
					/ [bnfrt]
					/ [0-2][0-7][0-7]
					/ [0-7][0-7]?
					/ 'x' Hex Hex
					/ 'u' Hex Hex Hex Hex
					/ 'U' Hex Hex Hex Hex Hex Hex Hex Hex
					)
	              / .
	Bool          <- "true" / "false"
	Integer       <- [0-9]+
	Hex           <- '0x' [0-9a-fA-F]+
	Callback      <  identifier
`));


/**
A tag in a DUI file.
*/
struct Tag
{
	/// The name of the tag.
	string name;

	/// All attributes of a tag.
	//Attribute[string] attributes;
	Attribute[] attributes;

	/// All children of a tag.
	Tag[] children;

	/// Gets an attribute by its name.
	Attribute opIndex(string name) const pure @safe
	{
		foreach (Attribute attribute; attributes)
		{
			if (attribute.name == name)
				return attribute;
		}
		assert(0, "no such element " ~ name);
	}

	string toString(string indentation = "") const pure
	{
		return format!"%s%s%s%s\n"(indentation, name, attributesToString(), childrenToString(indentation));
	}

	private string attributesToString() const pure
	{
		if (attributes.length == 0)
			return " ()";

		return " (" ~ attributes
			.map!(attribute => format!`%s="%s"`(attribute.name, attribute.value))
			.join(", ") ~ ")";
	}

	private string childrenToString(string indents) const pure
	{
		if (children.length == 0)
			return " {}";

		return " {\n" ~ children
			.map!(tag => tag.toString(indents ~ "    "))
			.join() ~ indents ~ "}";
	}
}

/**
A attribute of a tag.
It contains an iddentifier and a value.
*/
struct Attribute
{
	/// The name of the attribute.
	string name;

	/// The value of the attribute.
	string value;

	/// The type of the attribute.
	AttributeType type;

	string toString() const pure
	{
		return format!`%s="%s"`(name, value);
	}
}

/**
An enumeration of all possible types of attribute.
*/
enum AttributeType
{
	string,
	integer,
	callback,
	boolean
}

@("Can parse the name of an element")
unittest
{
	const dui = parseDUIScript!"tagname {}";
	assert(dui.name == "tagname");
}

@("Can parse attributes of an element")
unittest
{
	const dui = parseDUIScript!`tagname (foo="bar", foo2="bar2")`;
	assert(dui.attributes.length == 2);
	assert(dui.attributes[0] == Attribute("foo", "bar", AttributeType.string));
	assert(dui.attributes[1] == Attribute("foo2", "bar2", AttributeType.string));
	assert(dui["foo"] == Attribute("foo", "bar", AttributeType.string));
}

@("Can parse children of an element")
unittest
{
	const dui = parseDUIScript!`parent (id="cool") { childA childB}`;
	assert(dui.children.length == 2, "Number of children is incorrect.");
	assert(dui.children[0].name == "childA", "Name of first child is incorrect");
	assert(dui.children[1].name == "childB", "Name of second child is incorrect");
}
