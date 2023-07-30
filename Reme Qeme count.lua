--[[
Credit Source Code :
https://dsc.gg/pangerans
https://t.me/ihkazscript
Real Discord Username : ihkaz
{Please dont delete this / add credit if u take the code}

How To Use:
- "/change" and see the logs

]]

local remecount = true
local qemecount = false
local hasil
local game

function talkbubble(id, str)
    SendVariant({v0 = "OnTalkBubble", v1 = id, v2 = str})
end

function qemefunc(number)
    if number >= 10 then
        hasil = string.sub(number, -1)
    else
        hasil = number
    end
    return hasil
end

function remefunc(number)
    if number == 19 or number == 28 or number == 0 then
        hasil = 0
    else
        num1 = math.floor(number / 10)
        num2 = number % 10
        hasil = string.sub(num1 + num2, -1)
    end
    return hasil
end

function counts(number)
    if remecount and not qemecount then
        game = "`7REME``"
        return remefunc(number)
    else
        game = "`4QEME``"
        return qemefunc(number)
    end
end

AddHook(function(type, pkt)
    if pkt:find("/change") then
        if remecount and not qemecount then
            remecount = false
            qemecount = true
            LogToConsole("`7Change To Qeme Mode")
            return true
        else
            remecount = true
            qemecount = false
            LogToConsole("`7Change To Reme Mode")
            return true
        end
    end
    return false
end, "OnSendPacket")

AddHook(function(var)
    if var.v1 == "OnConsoleMessage" then
        LogToConsole("`7[`6ihkazscript``] " .. var.v2)
        return true
    end
    if var.v1 == "OnTalkBubble" then
        if var.v3:find("spun the wheel") then
            num = string.gsub(string.gsub(var.v3:match("and got (.+)"), "!%]", ""), "`", "")
            onlynumber = string.sub(num, 2)
            clearspace = string.gsub(onlynumber, " ", "")
            counts(tonumber(clearspace))
            talkbubble(var.v2, "[" .. game .. "]" .. var.v3 .. "[" .. hasil .. "``]")
            return true
        end
    end
    return false
end, "OnVariant")
