local linkToZip = "https://nightly.link/Carot-Subsidiaries/Flourine/workflows/build/master/Latest.zip"

local zzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Carot-Subsidiaries/loadZip/refs/heads/master/zzlib.lua"), "loadZip")()

loadstring(zzlib.unzip(linkToZip, "flourine.lua"), "Flourine")()