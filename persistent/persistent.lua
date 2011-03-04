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

This module create a way to persist variables in Ginga.
This is done with the persistent table.

The path to the file where the variables are saved is:
/usr/local/lib/ginga/files/contextmanager/persistent.ini
]]

require 'table_save-0_94'

-- Change the path to the place where you want to store the persistent table
local path = "/usr/local/lib/ginga/files/contextmanager/persistent.ini"


-- Try to load the file_persistent table
local file_persistent = table.load(path)

-- Could not load, create a new one
if file_persistent == nil then
    file_persistent = {
            shared = {},
            service = {},
            channel = {}
    }
end


-- Create the persistent table, a proxy table
persistent = {
    shared = {},
    service = {},
    channel = {}
}

-- Create the metatable for the persistent table
local meta_persistent = {
    __newindex = function()
        print("Unable to create variable")
        print("use the subtables service, channel or shared")
    end
}

setmetatable(persistent, meta_persistent)

-- Create the metatable for the internal tables
local meta_shared = {
    __index = function(t, k)
        return file_persistent.shared[k]
    end,
    
    __newindex = function(t, k, v)
        file_persistent.shared[k] = v -- update the original table
        save()                        -- update file
    end
}

setmetatable(persistent.shared, meta_shared)

local meta_service = {
    __index = function(t, k)
        return file_persistent.service[k]
    end,
    
    __newindex = function(t, k, v)
        file_persistent.service[k] = v -- update the original table
        save()                         -- update file
    end
}

setmetatable(persistent.service, meta_service)

local meta_channel = {
    __index = function(t, k)
        return file_persistent.channel[k]
    end,
    
    __newindex = function(t, k, v)
        file_persistent.channel[k] = v -- update the original table
        save()                         -- update file
    end
}

setmetatable(persistent.channel, meta_channel)


--- Function used to save the file_persistent table
function save()
    result = table.save(file_persistent, path)
    if result ~= 1 then
        print("Unable to save table persistent")
    end
end
