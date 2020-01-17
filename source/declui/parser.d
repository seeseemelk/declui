/**
Contains the pegged grammar to parse a DUI file.
*/
module declui.parser;

import pegged.grammar;

mixin(grammar(`
DUI:
	# Base types
	Element       <  Descriptor | Descriptor :'{' Element* :'}'
	Descriptor    <  identifier ('#' identifier)? ( :'(' AttributeList :')' )?
	AttributeList <  (Attribute :','?)*
	Attribute     <  identifier :'=' Value

	# Value types
	Value         <  String / Callback / Number / Bool
	String        <~ doublequote (!doublequote Char)* doublequote
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
	Number        <- [0-9]+
	Hex           <- [0-9a-fA-F]+
	Callback      <  identifier
`));

unittest
{
	import std.stdio : writeln;

	string input = "anIdentifier { anotherIdentifier#name (attr=\"wow\",id=myId) }";
	assert(DUI(input).successful);
}