import luad.all;

void main()
{
	
	//See samples here : http://jakobovrum.github.io/LuaD/
	
	auto lua = new LuaState;
	lua.openLibs();

	lua.doString(`print("Calling the lua.doString function")`);

	auto print = lua.get!LuaFunction("print");
	print("hello, world!");
	
	
	lua[1] = true;
	lua["test"] = 1.5;
	lua["globals"] = lua.globals;
	lua["array"] = [2];
	lua.doString(`
	    -- note that _G is a standard loopback reference to the global table
	    assert(test == 1.5)
	    assert(globals == _G)
	    assert(_G[1] == true)
	    assert(array[1] == 2.5)
	`);
}