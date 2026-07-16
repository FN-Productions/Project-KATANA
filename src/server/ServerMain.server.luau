--!strict

--[[
    ServerMain
    Roblox server entry point. Requires and runs the server bootstrapper.
]]

local Server = script.Parent
local ServerBootstrap = require(Server:WaitForChild("boot"):WaitForChild("ServerBootstrap"))

ServerBootstrap.start()
