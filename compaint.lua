local ver = 4.0
if not fs.exists("./comlib.lua") then
    local htg = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/comlib.lua")
    local htf = fs.open("./comlib.lua","w")
    local x,y = term.getSize()
    local ax = x - 17
    htf.write(htg.readAll())
    htf.close()
    term.setCursorPos(ax,y)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    term.write("comlib downloaded")
    print(" ")
    term.setCursorPos(1,y)
    htg.close()
end
local comlib = require "comlib"
local btable = {
    [1] = colors.white,
    [2] = colors.orange,
    [3] = colors.magenta,
    [4] = colors.lightBlue,
    [5] = colors.yellow,
    [6] = colors.lime,
    [7] = colors.pink,
    [8] = colors.gray,
    [9] = colors.lightGray,
    [10] = colors.cyan,
    [11] = colors.purple,
    [12] = colors.blue,
    [13] = colors.brown,
    [14] = colors.green,
    [15] = colors.red,
    [16] = colors.black
}
local toHex = {
    [colors.white] = "0",
    [colors.orange] = "1",
    [colors.magenta] = "2",
    [colors.lightBlue] = "3",
    [colors.yellow] = "4",
    [colors.lime] = "5",
    [colors.pink] = "6",
    [colors.gray] = "7",
    [colors.lightGray] = "8",
    [colors.cyan] = "9",
    [colors.purple] = "a",
    [colors.blue] = "b",
    [colors.brown] = "c",
    [colors.green] = "d",
    [colors.red] = "e",
    [colors.black] = "f"
}
local fromHex = {
    ["0"] = colors.white,
    ["1"] = colors.orange,
    ["2"] = colors.magenta,
    ["3"] = colors.lightBlue,
    ["4"] = colors.yellow,
    ["5"] = colors.lime,
    ["6"] = colors.pink,
    ["7"] = colors.gray,
    ["8"] = colors.lightGray,
    ["9"] = colors.cyan,
    ["a"] = colors.purple,
    ["b"] = colors.blue,
    ["c"] = colors.brown,
    ["d"] = colors.green,
    ["e"] = colors.red,
    ["f"] = colors.black
}
local tx,ty = term.getSize()
if comlib.update("https://raw.githubusercontent.com/Apethesis/CC-Code/main/compaint.lua",ver) == true then
	error("Update Complete",0)
end
print("This program is still in beta, and isn't stable.")
print("Do you wish to continue? (yes/no)")
local beta = read()
if beta == "no" then
    os.queueEvent("terminate")
end
term.clear()
local map = {}
if fs.exists("./save.cimg") then
    local loadsave = fs.open("./save.cimg","r")
    local msave = textutils.unserialize(loadsave.readAll())
    map = msave
    loadsave.close()
    term.clear()
    for x,_temp in pairs(map) do
        for y,data in pairs(_temp) do
            comlib.prite(x,y," ",toHex[colors.white],data)
        end
    end
end
local colr = colors.white
for i = 1,16 do
    comlib.prite(i,1," ",toHex[colors.white],toHex[btable[i]])
end
function clrbutton(_,_,x,y)
    if btable[x] and y == 1 then
        colr = toHex[btable[x]]
    end
    local ax = tx - 17
    comlib.prite(ax,ty,"Changed color to "..colr)
end
function draw(_,button,x,y)
    if button == 1 then
        if y > 1 then
            comlib.prite(x,y," ",toHex[colors.white],colr)
            map[x] = map[x] or {}
            map[x][y] = colr
            local ax = tx - 17
            comlib.prite(ax,ty,"Drew at x"..x.." y"..y.."        ")
        end
    elseif button == 2 then
        if y > 1 then
            comlib.prite(x,y," ")
            map[x] = map[x] or {}
            map[x][y] = toHex[colors.black]
            local ax = tx - 17
            comlib.prite(ax,ty,"Erased x"..x.." y"..y.."        ")
        end
    end
end
function sbug()
    local ay = ty - 1
    comlib.prite(tx,ay,colr)
    sleep(0.1)
end
function save()
    local autosave = fs.open("./save.cimg","w")
    local poet = textutils.serialize(map,{ compact = true })
    autosave.write(poet)
    autosave.close()
end
function savecheck(_,key,_)
    if key == keys.s then
        save()
        local ax = tx - 17
        comlib.prite(ax,ty,"Saved                      ")
    end
end
function clearmap(_,key,_)
    if key == keys.c then
        map = {}
        
        term.clear()
        for i = 1,16 do
            comlib.prite(i,1," ",toHex[colors.white],toHex[btable[i]])
        end
        local ax = tx - 17
        comlib.prite(ax,ty,"Cleared                      ")
        comlib.prite(tx-12,1,"ComPaint v"..ver)
        save()
    end
end
function fillBackground(_,key,_)
    if key == keys.f then
        for a = 1,tx do
            for b = 2,ty do
                map[a] = map[a] or {}
                map[a][b] = colr
                comlib.prite(a,b," ",toHex[colors.white],colr)
            end
        end
    end
end
comlib.prite(tx-12,1,"ComPaint v"..ver)
while true do
	--[[
    local _, key, _ = os.pullEvent("key")
	local event, button, x, y = os.pullEvent("mouse_click")
	local eventType, _, _, _, _ = os.pullEvent()
    parallel.waitForAny(clrbutton,draw,sbug,termcheck,savecheck,clearmap)
    sleep(0.1)
	--]]
	local event = table.pack(os.pullEventRaw())
    if event[1] == "mouse_click" then
        draw(table.unpack(event))
        clrbutton(table.unpack(event))
    elseif event[1] == "mouse_drag" then
        draw(table.unpack(event))
    elseif event[1] == "terminate" then
        save() 
        term.clear()
        term.setCursorPos(1, 1)
        error("", 0)
    elseif event[1] == "key" then
        clearmap(table.unpack(event))
	    savecheck(table.unpack(event))
        fillBackground(table.unpack(event))
	end
    sleep()
end
