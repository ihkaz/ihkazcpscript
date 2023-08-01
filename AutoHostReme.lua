--[[
Credit Source Code :
https://t.me/poriporimuka
https://github.com/ihkaz
https://t.me/ihkazscript
Please Do Not Reupload/Give Credit Thanks:)
]]


local count = 0
local drop
local dropMode = false
local xs, ys = 0, 0
local arrow = false
local delays = 0
local syslog = "`7[`4ihkazzzz``]"

function log(str)
    LogToConsole(syslog .. str)
end

log("are you Hoster? Can u Donate me in World : `4IHKAZS")

log("Oke Now You Can Use This Scrip,Good Luck!, type: `4/helps`` if u have a problem!")

log("Report Me if u found some bugs")

function delay()
    if dropMode then
        delays = 100
    else
        delays = 1000
    end
    return delays
end

function leftorright()
    if arrow then
        return xs + 2
    else
        return xs - 2
    end
end

function h()
    LogToConsole(count)
end

function pathPOS(x, y, jumlah, id)
    if math.abs(GetLocal().posX // 32 - x) > 11 or math.abs(GetLocal().posY // 32 - y) > 10 then
        return nil
    end
    if GetTiles(x, y).collidable then
        return nil
    end
    local Z = 0
    if not GetTiles(x + 1, y).collidable then
        Z = 0
    elseif not GetTiles(x - 1, y).collidable then
        Z = -2
    else
        return nil
    end
    SendPacketRaw(false, { type = 0, x = (x + Z) * 32, y = (y - 0) * 32, state = (Z == 1 and 48 or 32) })
    SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|" .. id .. "|\nitem_count|" .. jumlah .. "\n\n")
end

function collect(a, b, c)
    local tiles = {
        [1] = a,
        [2] = b,
        [3] = c,
    }
    for _, obj in pairs(GetObjectList()) do
        for _, tile in pairs(tiles) do
            if obj.posX // 32 == tile then
                local pkt = {}
                pkt.type = 11
                pkt.value = obj.id
                pkt.x = obj.posX
                pkt.y = obj.posY
                SendPacketRaw(false, pkt)
            end
        end
    end
end

function lock(a, b, c)
    local count = 0
    local tilelock = {
        [1] = a,
        [2] = b,
        [3] = c,
    }

    for _, lock in pairs(GetObjectList()) do
        if lock.itemid == 242 or lock.itemid == 1796 or lock.itemid == 7188 then
            if lock.posX // 32 == tilelock[1] or lock.posX // 32 == tilelock[2] or lock.posX // 32 == tilelock[3] then
                if lock.itemid == 242 then
                    count = count + lock.amount
                elseif lock.itemid == 1796 then
                    count = count + lock.amount * 100
                elseif lock.itemid == 7188 then
                    count = count + lock.amount * 10000
                end
            end
        end
    end

    return count
end

AddHook(function(a)
    if a.type == 3 and a.value == 18 then
        for _, display in pairs(GetTiles()) do
            if display.fg == 1422 then
                if display.x == a.px then
                    collect(a.px, a.px - 1, a.px + 1)
                    xs, ys = a.px, a.py
                    drop = lock(a.px, a.px - 1, a.px + 1)
                    log("Collected: `9" .. drop .. " Wls")
                end
            end
        end
    end
    return false
end, "OnSendPacketRaw")

AddHook(function(type, pkt)
    if pkt:find("/w") then
        drop = drop * 2
        bgl = math.floor(drop / 10000)
        drop = drop - bgl * 10000
        dl = math.floor(drop / 100)
        wl = drop % 100
        dropMode = true
        return true
    end

    if pkt:find("/x3") then
        drop = drop * 3
        bgl = math.floor(drop / 10000)
        drop = drop - bgl * 10000
        dl = math.floor(drop / 100)
        wl = drop % 100
        dropMode = true
        return true
    end

    if pkt:find("/helps") then
        log("Here your command u can use! :\n`4/w`` | For dropping bet to player if you lose\n`4/x3`` | For dropping bet to player and auto X3 if player got `20 `419 `428``\n`4/posdrop`` | For change position to the left/right")
        return true
    end

    if pkt:find("/posdrop") then
        if arrow then
            arrow = false
            log("`7Lock will drop to `4Right Position")
        else
            arrow = true
            log("`7Lock will drop to `4Left Position")
            return true
        end
    end
    return false
end, "OnSendPacket")

while true do
    Sleep(delay())
    if dropMode then
        Sleep(delay())
        if bgl > 0 then
            pathPOS(leftorright(), ys, bgl, 7188)
            Sleep(delay())
        end
        if dl > 0 then
            pathPOS(leftorright(), ys, dl, 1796)
            Sleep(delay())
        end
        if wl > 0 then
            pathPOS(leftorright(), ys, wl, 242)
            Sleep(delay())
        end
        log("Success Dropped Lock To Player")
        drop = nil
        dropMode = false
    end
end