Config = {}
Config = {
    ["Room"] = {},
    ["Users"] = {}
}

local Function = {
    ["create"] = function (source,Passport,Message)
        local Name = Message[2]
        if Name and not Config["Users"][Passport] and not Config["Room"][Name] < 5 then
            Config["Room"][Name]= {}
            Config["Users"][Passport]= Name
            Config["Room"][Name][Passport] = source
            TriggerClientEvent("Notify", source,"Grupos","Grupo <b>"..Name.."</b> criado.","verde",5000)
        end
    end,
    ["add"] = function(source, Passport, Message)
        local Name = Config["Users"][Passport]
        local OtherPassport = parseInt(Message[2])
        local OtherSource = vRP.Source(OtherPassport)
        if Name and OtherSource and Config["Room"][Name] and not Config["Users"][OtherPassport] and CountTable(Config["Room"][Name]) < 5 then
            Config["Users"][OtherPassport] = Name
            Config["Room"][Name][OtherPassport] = OtherSource
            TriggerClientEvent("Notify", source, "Grupos", "Passaporte <b>"..OtherPassport.."</b> adicionado.", "amarelo", 5000)
        end
    end,
    ["rem"] = function(source, Passport, Message)
        local Name = Config["Users"] [Passport]
        local OtherPassport = parseInt(Message[2])
        local OtherSource = vRP.Source(OtherPassport)
        if Name and OtherSource and Config["Users"][OtherPassport] and Config["Users"][OtherPassport]  == Name then
            if Config["Room"][Name] and Config["Room"][Name][OtherPassport] then
                
                -- Config["Users"][OtherPassport] = Name
                -- Config["Room"][Name][OtherPassport] = OtherSource
                TriggerClientEvent("Notify", source, "Grupos", "Passaporte <b>"..OtherPassport.."</b> removido.", "amarelo", 5000)
                if CountTable(Config["Room"][Name]) <= 0 then
                end
            end
        end
    end
}
return Config