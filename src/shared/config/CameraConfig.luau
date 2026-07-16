--!strict

--[[
    CameraConfig
    Centralized configurations for camera offsets, limits, and behavior.
]]

export type CameraConfig = {
	DEFAULT_DISTANCE: number,
	SHOULDER_OFFSET: Vector3,
	MIN_PITCH: number,
	MAX_PITCH: number,
	LOOK_SENSITIVITY: number,
	COLLISION_BUFFER: number,
}

local CameraConfig: CameraConfig = {
	DEFAULT_DISTANCE = 12.5,
	SHOULDER_OFFSET = Vector3.new(2, 1.5, 0),
	MIN_PITCH = -60,
	MAX_PITCH = 80,
	LOOK_SENSITIVITY = 0.15,
	COLLISION_BUFFER = 0.5,
}

return CameraConfig
