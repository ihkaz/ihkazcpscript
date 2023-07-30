--[[
Command :
{•} /add {text} - Adding Filter Text
{•} /listfilter - Checking Filter Text

Feature :
[•] Auto Ban If player type text u filter/add 
]]
local antitext = {} LogToConsole("Script By `4iHkaz#8706") function wrench(__,_)
            SendPacket(2,"action|dialog_return\ndialog_name|popup\nnetID|".._.."|\nbuttonClicked|"..__)
  end AddHook(function(type,str) if str:find("/add (.+)") then kata = str:match("/add (.+)") table.insert(antitext,kata) LogToConsole("Sukses Menambah Filter : `4"..kata) return true end if str:find("/listfilter") then LogToConsole("List Filter : `5"..table.concat(antitext," ")) return true end return false end,"OnSendPacket")AddHook(function(var) if var.v1 == "OnTalkBubble" then for __,_ in pairs(antitext) do if var.v3:find(_) then wrench("world_ban",var.v2) end end end return false end,"OnVariant")
