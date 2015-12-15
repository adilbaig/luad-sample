import luad.all;

void main()
{
	
	//See samples here : http://jakobovrum.github.io/LuaD/
	
	auto lua = new LuaState;
	lua.openLibs();

	lua.doString(`print("Calling the lua.doString function")`);

	auto print = lua.get!LuaFunction("print");
	print("hello, world!");
	
	/*
	 One problem with having a common LuaState is that it needs to be initialized on every request. Otherwise requests from one user 
	 will override requests from another user.
	 
	 Or, preopen a set of LuaStates and reset their globals to zero whenever a new connection is opened. 
	 Is this more overhead than required?
	 
	 Generally, there is a problem of security if LuaState can be written to. This needs to be checked.
	 */
	lua[1] = true;
	lua["test"] = 1.5;
	lua["globals"] = lua.globals;
	lua["array"] = [2];
	lua.doString(`
	    -- note that _G is a standard loopback reference to the global table
	    assert(test == 1.5)
	    assert(globals == _G)
	    assert(_G[1] == true)
	    assert(array[1] == 2)
	    
	    x = 10
	    local i = 1        -- local to the chunk
	    
	    while i<=x do
	      local x = i*2    -- local to the while body
	      print(x)         --> 2, 4, 6, 8, ...
	      i = i + 1
	    end
	    
	    if i > 20 then
	      local x          -- local to the "then" body
	      x = 20
	      print(x + 2)
	    else
	      print(x)         --> 10  (the global one)
	    end
	    
	    print(x)
	    
	    local a = 1
		local b = 2
		local c = 3
	    do
	      local a2 = 2*a
	      local d = sqrt(b^2 - 4*a*c)
	      x1 = (-b + d)/a2
	      x2 = (-b - d)/a2
	    end          -- scope of a2 and d ends here
	    print(x1, x2)
	`);
}