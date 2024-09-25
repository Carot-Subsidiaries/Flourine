local linkToZip = "https://nightly.link/Carot-Subsidiaries/Flourine/workflows/build/master/Latest.zip"

local zzlib = loadstring(game:HttpGet("https://github.com/Carot-Subsidiaries/loadZip/raw/refs/heads/master/inflate-bwo.lua"), "loadZip")()

loadstring(zzlib.unzip(linkToZip, "lua-5.3.4/README"), "Flourine")()