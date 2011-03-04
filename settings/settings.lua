--[[
Copyright (C) 2009 Peta5 - Nós fazemos TV digital (www.peta5.com.br)

This Game is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2 of the License.

This Game is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details:
http://www.gnu.org/licenses/gpl-2.0.txt
-----------------------------------------------------------

This module create a way to read the system variables
(applications/x-ginga-settings) of Ginga-NCL.
This is done with the settings table.

OBS.: This version implements the settings table only for the system,
default and user variables.

The path to the file where the variables are saved is:
/usr/local/lib/ginga/files/contextmanager/contexts.ini (system and default)
/usr/local/lib/ginga/files/contextmanager/users.ini (user)
]]

-- Change the path to the place where you want to store the persistent table
local path_context = "/usr/local/lib/ginga/files/contextmanager/contexts.ini"
local path_users = "/usr/local/lib/ginga/files/contextmanager/users.ini"


--- Function to load the settings table
function load_table(context, users)
    
    loaded_table = {
        system = {},
        default = {},
        user = {}
    }
 
-- reads the context.ini file and populates the table   
    for line in io.lines(context) do
    	prefix, key, value = string.match(line, "(%a+)%.(.+)%s*=%s*(.*)")
    	if prefix == "default" then
    		key = string.gsub(key," ","")
    		value = string.gsub(value," ","")
    		loaded_table.default[key] = value
    	elseif prefix == "system" then
    		key = string.gsub(key," ","")
    		value = string.gsub(value," ","")
    		loaded_table.system[key] = value
    	end
    end
    
-- reads the users.ini file and populates the table      
    a, str = io.input(users):read("*line","*line")
    a = nil --to empty variable
    
    -- x, y, z = unknown variables
    x, y, location, age, z, genre = string.match(str,
    							"(%d+)%s*(%a+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%a+)")
    loaded_table.user.age = age
    loaded_table.user.location = location
    loaded_table.user.genre = genre
    
    return loaded_table
end

-- Create the table file_settings (data from the file)
local file_settings = load_table(path_context, path_users)

-- Create the settings table, a proxy table
settings = {
    system = {},
    default = {},
    user = {}
}

-- Create the metatable for the settings table
local meta_settings = {
    __newindex = function()
        print("This table can not receive values.")
    end
}

setmetatable(settings, meta_settings)

-- Create the metatable for the internal tables
local meta_system = {
    __index = function(t, k)
        return file_settings.system[k]
    end,
    
    __newindex = function()
        print("This table can not receive values.")
    end
}

setmetatable(settings.system, meta_system)

local meta_default = {
    __index = function(t, k)
        return file_settings.default[k]
    end,
    
    __newindex = function()
        print("This table can not receive values.")
    end
}

setmetatable(settings.default, meta_default)

local meta_user = {
    __index = function(t, k)
        return file_settings.user[k]
    end,
    
    __newindex = function()
        print("This table can not receive values.")
    end
}

setmetatable(settings.user, meta_user)
