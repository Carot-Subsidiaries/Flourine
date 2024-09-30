local zip = game:HttpGet("https://nightly.link/Carot-Subsidiaries/Flourine/workflows/build/master/Latest.zip", true)

local zzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Carot-Subsidiaries/loadZip/refs/heads/master/zzlib.lua"), "loadZip")()

loadstring(zzlib.unzip(zip, "flourine.lua"), "Flourine")()
