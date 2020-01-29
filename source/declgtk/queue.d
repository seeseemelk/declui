/**

*/
module declgtk.queue;

private void delegate()[] callbacks;

/**
Queues a callback on the GTK event loop.
*/
void queueOnGtk(void delegate() callback)
{
	callbacks ~= callback;
}

/**
Executes all GTK callbacks.
*/
void executeGtkQueue()
{
	auto oldCallbacks = callbacks;
	callbacks = [];
	foreach (callback; oldCallbacks)
	{
		callback();
	}
}
