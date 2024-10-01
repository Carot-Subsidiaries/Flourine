--[[
	Script Viewer App Module
	
	A script viewer that is basically a notepad
]]

-- Common Locals
local Main,Lib,Apps,Settings -- Main Containers
local Explorer, Properties, ScriptViewer, Notebook -- Major Apps
local API,RMD,env,service,plr,create,createSimple -- Main Locals

local function initDeps(data)
	Main = data.Main
	Lib = data.Lib
	Apps = data.Apps
	Settings = data.Settings

	API = data.API
	RMD = data.RMD
	env = data.env
	service = data.service
	plr = data.plr
	create = data.create
	createSimple = data.createSimple
end

local function initAfterMain()
	Explorer = Apps.Explorer
	Properties = Apps.Properties
	ScriptViewer = Apps.ScriptViewer
	Notebook = Apps.Notebook
end

local function main()
	local ScriptViewer = {}
	local window, codeFrame
	local PreviousScr = nil

	ScriptViewer.ViewScript = function(scr)
		local success, source = pcall(env.decompile or function() end, scr)
		if (not success or not source) and env.decompile == env.sdecompile then
            source, PreviousScr = "-- [FLOURINE] Source failed to decompile", nil
        else
            local success, source = pcall(env.sdecompile or function() end, scr)
            if (not success or not source) then
                source, PreviousScr = "-- [FLOURINE] Source failed to decompile", nil
            else
                source = "-- [FLOURINE] Source decompiled using fallback decompiler (courtesy of Konstant)\n" .. source
                PreviousScr = scr
            end
        end
		codeFrame:SetText(source:gsub("\0", "\\0")) -- Fix stupid breaking script viewer
		window:Show()
	end

	ScriptViewer.Init = function()
		window = Lib.Window.new()
		window:SetTitle("Script Viewer")
		window:Resize(500,400)
		ScriptViewer.Window = window

		codeFrame = Lib.CodeFrame.new()
		codeFrame.Frame.Position = UDim2.new(0,0,0,20)
		codeFrame.Frame.Size = UDim2.new(1,0,1,-20)
		codeFrame.Frame.Parent = window.GuiElems.Content

		-- TODO: REMOVE AND MAKE BETTER
		local copy = Instance.new("TextButton",window.GuiElems.Content)
		copy.BackgroundTransparency = 1
		copy.Size = UDim2.new(0.5,0,0,20)
		copy.Text = "Copy to Clipboard"
		copy.TextColor3 = Color3.new(1,1,1)

		copy.MouseButton1Click:Connect(function()
			local source = codeFrame:GetText()
			env.setclipboard(source)
		end)

		local save = Instance.new("TextButton",window.GuiElems.Content)
		save.BackgroundTransparency = 1
		save.Position = UDim2.new(0.35,0,0,0)
		save.Size = UDim2.new(0.3,0,0,20)
		save.Text = "Save to File"
		save.TextColor3 = Color3.new(1,1,1)

		save.MouseButton1Click:Connect(function()
			local source = codeFrame:GetText()
			local filename = "Place_"..game.PlaceId.."_Script_"..os.time()..".txt"

			env.writefile(filename, source)
			if env.movefileas then
				env.movefileas(filename, ".txt")
			end
		end)

		local dumpbtn = Instance.new("TextButton",window.GuiElems.Content)
		dumpbtn.BackgroundTransparency = 1
		dumpbtn.Position = UDim2.new(0.7,0,0,0)
		dumpbtn.Size = UDim2.new(0.3,0,0,20)
		dumpbtn.Text = "Dump Functions"
		dumpbtn.TextColor3 = Color3.new(1,1,1)

		dumpbtn.MouseButton1Click:Connect(function()
			if PreviousScr ~= nil then
				pcall(function()
                    -- thanks King.Kevin#6025 you'll obviously be credited (no discord tag since that can easily be impersonated)
                    local getgc = getgc or get_gc_objects
                    local getupvalues = (debug and debug.getupvalues) or getupvalues or getupvals
                    local getconstants = (debug and debug.getconstants) or getconstants or getconsts
                    local getinfo = (debug and (debug.getinfo or debug.info)) or getinfo
                    local original = ("\n-- // Function Dumper made by King.Kevin\n-- // Script Path: %s\n\n--[["):format(PreviousScr:GetFullName())
                    local dump = original
                    local functions, function_count, data_base = {}, 0, {}
                    function functions:add_to_dump(str, indentation, new_line)
                        local new_line = new_line or true
                        dump = dump .. ("%s%s%s"):format(string.rep("    ", indentation), tostring(str), new_line and "\n" or "")
                    end
                    function functions:get_function_name(func)
                        local n = getinfo(func).name
                        return n ~= "" and n or "Unknown Name"
                    end
                    function functions:dump_table(input, indent, index)
                        local indent = indent < 0 and 0 or indent
                        functions:add_to_dump(("%s [%s] %s"):format(tostring(index), tostring(typeof(input)), tostring(input)), indent - 1)
                        local count = 0
                        for index, value in pairs(input) do
                            count = count + 1
                            if type(value) == "function" then
                                functions:add_to_dump(("%d [function] = %s"):format(count, functions:get_function_name(value)), indent)
                            elseif type(value) == "table" then
                                if not data_base[value] then
                                    data_base[value] = true
                                    functions:add_to_dump(("%d [table]:"):format(count), indent)
                                    functions:dump_table(value, indent + 1, index)
                                else
                                    functions:add_to_dump(("%d [table] (Recursive table detected)"):format(count), indent)
                                end
                            else
                                functions:add_to_dump(("%d [%s] = %s"):format(count, tostring(typeof(value)), tostring(value)), indent)
                            end
                        end
                    end
                    function functions:dump_function(input, indent)
                        functions:add_to_dump(("\nFunction Dump: %s"):format(functions:get_function_name(input)), indent)
                        functions:add_to_dump(("\nFunction Upvalues: %s"):format(functions:get_function_name(input)), indent)
                        for index, upvalue in pairs(getupvalues(input)) do
                            if type(upvalue) == "function" then
                                functions:add_to_dump(("%d [function] = %s"):format(index, functions:get_function_name(upvalue)), indent + 1)
                            elseif type(upvalue) == "table" then
                                if not data_base[upvalue] then
                                    data_base[upvalue] = true
                                    functions:add_to_dump(("%d [table]:"):format(index), indent + 1)
                                    functions:dump_table(upvalue, indent + 2, index)
                                else
                                    functions:add_to_dump(("%d [table] (Recursive table detected)"):format(index), indent + 1)
                                end
                            else
                                functions:add_to_dump(("%d [%s] = %s"):format(index, tostring(typeof(upvalue)), tostring(upvalue)), indent + 1)
                            end
                        end
                        functions:add_to_dump(("\nFunction Constants: %s"):format(functions:get_function_name(input)), indent)
                        for index, constant in pairs(getconstants(input)) do
                            if type(constant) == "function" then
                                functions:add_to_dump(("%d [function] = %s"):format(index, functions:get_function_name(constant)), indent + 1)
                            elseif type(constant) == "table" then
                                if not data_base[constant] then
                                    data_base[constant] = true
                                    functions:add_to_dump(("%d [table]:"):format(index), indent + 1)
                                    functions:dump_table(constant, indent + 2, index)
                                else
                                    functions:add_to_dump(("%d [table] (Recursive table detected)"):format(index), indent + 1)
                                end
                            else
                                functions:add_to_dump(("%d [%s] = %s"):format(index, tostring(typeof(constant)), tostring(constant)), indent + 1)
                            end
                        end
                    end
                    for _, _function in pairs(getgc()) do
                        if typeof(_function) == "function" and getfenv(_function).script and getfenv(_function).script == PreviousScr then
                            functions:dump_function(_function, 0)
                            functions:add_to_dump("\n" .. ("="):rep(100), 0, false)
                        end
                    end
                    local source = codeFrame:GetText()
                    if dump ~= original then source = source .. dump .. "]]" end
                    codeFrame:SetText(source)
                end)
            end
		end)
	end

	return ScriptViewer
end

return {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
