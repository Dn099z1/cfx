-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
local Config = module("party" ,"config/core")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vCLIENT= Tunnel.getInterface("party")
Creative = {}
Tunnel.bindInterface("party",Creative)

Amounts = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Create(Name,Passport)
    local source = source 
    local Passport = vRP.Passport(source)
    if Passport and not Config["Users"][Passport] then
        Amounts = Amounts + 1
        Config["Room"][Amounts] = {
            ["Created"] = Passport,
            ["Identity"] =  vRP.Fullname(Passport),
            ["Name"] =  Name,
            ["Passport"] = Passport,
            ["Users"] = {
                [Passport] = source
            }
        }
        Config["Users"][Passport] = Amounts
        return true
    end
    return false
end

RegisterCommand("verparty", function(a, b)
    print(json.encode(Config["Room"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMEMBERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetMembers(Name,Number)
    local source = source 
    local Passport = vRP.Passport(source)
    if Passport and Config["Room"][Number] and Config["Room"][Number]["Users"] then
        Room = {}
        for OthenPassport,v in pairs(Config["Room"][Number]["Users"]) do
            Room[#Room+1] = {
                ["id"] = OthenPassport,
                ["name"] =  vRP.Fullname(OthenPassport),
            }
        end
        return {
            ["Users"] = Room,
            ["Created"] =  Config["Room"][Number]["Created"],
            ["Identity"] =  Name,
            ["Name"] = Passport,
            ["Count"] = Passport,
        }
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETROOMS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetRooms()
    local source = source 
    local Passport = vRP.Passport(source)
    if Passport then
        local Rooms = {}
        for Index,v in  pairs(Config["Room"]) do
            Rooms[#Rooms+1] = {
                ["Id"] = Index,
                ["Room"] = v["Name"],
                ["Name"] = v["Identity"],
                ["Password"] = v["Password"] or false,
                ["Members"] = CountTable(v["Users"]),
            }
        end
        return {
            ["group"] = Config["Users"][Passport] or false,
            ["room"] = Rooms
        }
    end
end