--[[
	New Dex
	Final Version

	Maintained by @ILiekCarot
	Developed by Moon
	Contributions skidded off Infinite Yield: @Toon-arch & @joeengo(kinda)
	
	Dex is a debugging suite designed to help the user debug games and find any potential vulnerabilities.
]]

local nodes = {}
local selection
local cloneref = cloneref or function(...) return ... end