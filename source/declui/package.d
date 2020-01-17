module declui;

import declui.parser;
import declui.elements.window;
import gio.Application : GioApplication = Application;
import gtk.Application;
import std.string;
import std.conv;
import pegged.grammar;
public import declui.element;

/*__gshared GApplication application;

void runDUI(void function() callback)
{
	application = new GApplication("be.seeseemelk.dui", GApplicationFlags.FLAGS_NONE);
	application.addOnActivate(delegate void(GioApplication app)
	{
		callback();
	});
	return application.run(System.args);
}*/
/*
class Document(filename)
{
	this()
	{

	}
}
*/

/*string createClass(string filename, DUI content)
{
	return "class " ~ filename ~ `
	{
	}`
}

string document(string filename)()
{
	enum content = DUI(import(filename ~ ".dui"));
	return createClass(filename, content);

	//pragma(msg, content);
}*/

/*private string[string] parseAttributes(ParseTree element)
{
	string[string] attributes;
	foreach (child; element.children)
	{
		if (child.name == "DUI.AttributeList")
		{
			foreach (attribute; child.children)
			{
				attributes[attribute.matches[0]] = attribute.matches[1];
			}
		}
	}
	return attributes;
}*/

class AppData
{
	Application application;
	GioApplication gioApplication;
}

interface RunnableDocument
{
	void run(AppData app);
}

static string getAbstractMethodString(ParseTree attribute)()
{
	enum name = attribute.matches[0];
	enum value = attribute.matches[1];
	return "abstract void " ~ value ~ "();";
}

private string[] getCallbacks(ParseTree content)()
{
	string[] callbacks;
	static foreach (child; content.children[0].children)
	{
		static if (child.name == "DUI.AttributeList")
		{
			static foreach (attribute; child.children)
			{
				static if (attribute.children[0].children[0].name == "DUI.Callback")
				{
					callbacks ~= getAbstractMethodString!(attribute);
				}
			}
		}
	}

	static foreach (child; content.children)
	{
		static if (child.name == "DUI.Element")
		{
			callbacks ~= getCallbacks!(child);
		}
	}

	return callbacks;
}

class Document(string filename) : RunnableDocument
{
	enum content = DUI(import(filename ~ ".dui"));
	pragma(msg, content.toString);

	this()
	{
	}

	static foreach (callback; getCallbacks!(content))
	{
		mixin(callback);
	}

	void run(AppData appdata)
	{
		root = createElement!(content.children[0])(appdata);
		root.visible = true;
	}

private:
	Window root;
	Element[string] elements;

	auto createElement(ParseTree content)(AppData appdata)
	{
		enum var = "el";
		enum type = content.matches[0];
		
		mixin(`
		import declui.elements.` ~ type.toLower() ~ `;
		auto ` ~ var ~ ` = new ` ~ type ~ `(appdata);
		`);
		
		static foreach (child; content.children[0].children)
		{
			static if (child.name == "DUI.AttributeList")
			{
				static foreach (attribute; child.children)
				{
					static assert(__traits(compiles, parseAttribute!(var, attribute)));
					mixin(parseAttribute!(var, attribute));
				}
			}
		}

		static foreach (child; content.children)
		{
			static if (child.name == "DUI.Element")
			{
				{
					auto childElement = createElement!(child)(appdata);
					mixin(var).add(childElement);
				}
			}
		}

		mixin(var).visible = true;

		return mixin(var);
	}

	static string parseAttribute(string var, ParseTree attribute)()
	{
		enum name = attribute.matches[0];
		enum value = attribute.matches[1];
		enum valueType = attribute.children[0].children[0].name;
		static if (valueType == "DUI.Callback")
			return var ~ "." ~ name ~ "(&this." ~ value ~ ");";
		else
			return var ~ "." ~ name ~ "(" ~ value ~ ");";
	}
}

void runGUI(string[] args, RunnableDocument document)
{
	scope appdata = new AppData();
	appdata.application = new Application("be.seeseemelk.dui", GApplicationFlags.FLAGS_NONE);
	appdata.application.addOnActivate(delegate void(GioApplication app) {
		appdata.gioApplication = app;
		document.run(appdata);
	});
	appdata.application.run(args);
}