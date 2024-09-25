import os

embedStr = "local EmbeddedModules = {\n"
files = os.listdir("modules")

def readfile(path):
    file = open(path,"r")
    str = file.read()
    file.close()
    return str

def addModuleFile(path, last):
    global embedStr

    moduleName = os.path.splitext(os.path.basename(path))[0]
    moduleSource = readfile(path)

    embedStr = embedStr + moduleName + ' = function()\n' + moduleSource + f'\nend{"" if last else ","}\n'

for i, filename in enumerate(files, 1):
    addModuleFile("modules/" + filename, i == len(files))

embedStr = embedStr + "}"
embedStr = embedStr + "\n\n" + readfile("main.lua")
embedStr = readfile("PresetText.lua") + "\n\n" + embedStr

file = open("flourine.lua","w")
file.write(embedStr)
file.close()