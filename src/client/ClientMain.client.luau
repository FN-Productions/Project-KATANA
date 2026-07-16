--!strict

--[[
    ClientMain
    Roblox client entry point. Requires and runs the client bootstrapper.
]]

local Client = script.Parent
local ClientBootstrap = require(Client:WaitForChild("boot"):WaitForChild("ClientBootstrap"))

ClientBootstrap.start()
