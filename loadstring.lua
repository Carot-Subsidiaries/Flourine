local zip = game:HttpGet("https://nightly.link/Carot-Subsidiaries/Flourine/workflows/build/master/Latest.zip", true)

local zzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Carot-Subsidiaries/loadZip/refs/heads/master/zzlib.lua"), "loadZip")()

if --[[(identifyexecutor() == "Wave" and not odecompile) or ]](not decompile and env.getscriptbytecode and env.request) and true then
    getgenv().odecompile = loadstring(game:HttpGet("https://github.com/Carot-Subsidiaries/Flourine/raw/refs/heads/master/decompiler.lua"), "Konstant")()
end

loadstring(zzlib.unzip(zip, "flourine.lua"), "Flourine")()
