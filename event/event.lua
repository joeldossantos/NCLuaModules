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

Event is a module to simulate the NCLua event module.

With this module is possible to test receiving and posting events from and
to the NCL presentation engine.
]]

module('event', package.seeall)


-- table with the event hadler functions
local event_handlers = {}


--- Regiter a event hadler, making it availiable to receive and event.
-- @param f function registered as a hadler
-- @param c event class
-- @param t event type
-- @param i event interface (area or property)
-- @param a event action
function register(f, c, t, i, a)
    if type(f) == 'function' then
        local aux = {f=f, c=c, t=t, i=i, a=a}
        table.insert(event_handlers, aux)
    else
        print('The first argument must be a function')
    end
end


--- Choose the handler functions capable to handle the event received.
-- Once a function is choosed, send the event to the lua script.
-- @param event the event to pass to the lua script
function send(event)
    for i=1, table.maxn(event_handlers), 1 do
        if (event_handlers[i].c and event_handlers[i].c ~= event.class) then
            -- the event don't match the handler
            -- do nothing
        elseif (event_handlers[i].t and event_handlers[i].t ~= event.type) then
            -- the event don't match the handler
            -- do nothing
        elseif (event_handlers[i].a and event_handlers[i].a ~= event.action) then
            -- the event don't match the handler
            -- do nothing
        elseif (event_handlers[i].i and 
                ((event.name and event_handlers[i].i ~= event.name) or
                (event.label and event_handlers[i].i ~= event.label))) then
            -- the event don't match the handler
            -- do nothing
        elseif (event_handlers[i].a and event_handlers[i].a ~= event.action) then
            -- the event don't match the handler
            -- do nothing
        else
            -- the event match the hadler
            event_handlers[i].f(event)
        end
    end
end


--- Posts an event. The default direction is out.
-- @param arg1, arg2 the direction and event table or just the vent table
function post(arg1, arg2)
    local direction
    local event
    
    if type(arg1) == 'string' then
        direction = arg1
        if type(arg2) == 'table' then
            event = arg2
        else
            print('The second argument must be a table')
            return
        end
    elseif type(arg1) == 'table' then
        direction = 'out'
        event = arg1
    else
        print('The arguments are a string and a table')
        return
    end
    
    if direction == 'in' then
        send(event)
    elseif direction == 'out' then
        if event.label then
            print('out: '..event.class..', '..event.type..', '..event.label..', '..event.action)
        elseif event.name then
            print('out: '..event.class..', '..event.type..', '..event.name..', '..event.action)
        else
            print('out: '..event.class..', '..event.type..', '..event.action)
        end
    else
        print('Unvalid direction')
    end
end
