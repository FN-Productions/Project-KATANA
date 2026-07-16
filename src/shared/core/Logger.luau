--!strict

--[[
    Logger
    Centralized logging utility for Project KATANA.

    All systems should use this module instead of directly calling print().
]]

export type Logger = {
	info: (message: string) -> (),
	warn: (message: string) -> (),
	error: (message: string) -> (),
	debug: (message: string) -> (),
}

local DEBUG_ENABLED = true

local Logger: Logger = {
	info = function(message: string): ()
		print(`[KATANA][INFO] {message}`)
	end,

	warn = function(message: string): ()
		warn(`[KATANA][WARN] {message}`)
	end,

	error = function(message: string): ()
		warn(`[KATANA][ERROR] {message}`)
	end,

	debug = function(message: string): ()
		if DEBUG_ENABLED then
			print(`[KATANA][DEBUG] {message}`)
		end
	end,
}

return Logger
