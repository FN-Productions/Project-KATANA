--!strict

--[[
    AnimationConfig
    Centralized configurations for character locomotion animation IDs.
    NOTE: These animation asset IDs are temporary placeholders and will be replaced by custom Project KATANA assets in future iterations.
]]

export type AnimationConfig = {
	Idle: string,
	Walk: string,
	Fall: string,
}

local AnimationConfig: AnimationConfig = {
	Idle = "rbxassetid://180435571",
	Walk = "rbxassetid://180435792",
	Fall = "rbxassetid://180436148",
}

return AnimationConfig
