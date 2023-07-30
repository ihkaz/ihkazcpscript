--[[
Credit Source Code :
https://dsc.gg/pangerans
https://t.me/ihkazscript
Real Discord Username : ihkaz
{Please dont delete this / add credit if u take the code}
]]

LogToConsole("`7Credit Source Code :"")
LogToConsole("`7https://dsc.gg/pangerans")
LogToConsole("`7https://t.me/ihkazscript")
LogToConsole("`7Real Discord Username : ihkaz")

local left = false
local right = false
local leftx
local lefty
local rightx
local righty

function check(setx, sety)
    local hasil
    if not setx and not sety then
        hasil = "`5Click For Set``"
    else
        hasil = setx .. "," .. sety
    end
    return hasil
end

function oit()
    local h = {}
    h.v0 = "OnDialogRequest"
    h.v1 = [[
set_default_color|`o
add_label_with_icon|big|`9Set The Display ``|left|1442
add_spacer|small|
add_button|left_pos|`7Left : (]]..check(leftx, lefty)..[[)|
add_button|right_pos|`7Right : (]]..check(rightx, righty)..[[)|
add_smalltext|`7After click u must punch the display box
add_spacer|small|
end_dialog|WrenchShortcut|Cancel|
add_quick_exit
]]
    SendVariant(h)
end

AddHook(function(type, pkt)
    if type == 2 and pkt:find("/setdisplay") then
        oit()
    end

    if type == 2 and pkt:find("left_pos") then
        left = true
        LogToConsole("Punch Display")
    end
    if type == 2 and pkt:find("right_pos") then
        right = true
        LogToConsole("Punch Display")
    end
    return false
end, "OnSendPacket")

AddHook(function(a)
    if a.type == 3 and a.value == 18 then
        for _, display in pairs(GetTiles()) do
            if display.fg == 1422 then
                if display.x == a.px then
                    if left and not right then
                        leftx = a.px
                        lefty = a.py
                        left = false
                        oit()
                        LogToConsole("Success Set Left Pos `2(" .. a.px .. "," .. a.py .. ")")
                    elseif right and not left then
                        rightx = a.px
                        righty = a.py
                        right = false
                        oit()
                        LogToConsole("Success Set Right Pos `2(" .. a.px .. "," .. a.py .. ")")
                    end
                end
            end
        end
    end
    return false
end, "OnSendPacketRaw")
