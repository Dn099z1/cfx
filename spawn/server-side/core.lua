-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("spawn",Creative)
vRPC = Tunnel.getInterface("VRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Selected = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkPerm()
	local source = source
	local user_id = vRP.Passport(source)
	if vRP.HasGroup(user_id,"Admin") then
	return true
	end
end

function Creative.Characters()
	local Character = {}
	local source = source
	local License = vRP.Identities(source)
	local Consult = vRP.Query("characters/Characters",{ license = License })

	TriggerEvent("vRP:BucketServer",source,"Enter",source)

	if Consult[1] then
		for _,v in pairs(Consult) do
			local Datatable = vRP.UserData(v["id"],"Datatable")
			if Datatable then
				table.insert(Character,{
					["Passport"] = v["id"],
					["Skin"] = Datatable["Skin"],
					["Nome"] = v["name"].." "..v["name2"],
					["Sexo"] = v["sex"],
					["Banco"] = v["bank"],
					["Blood"] = Sanguine(v["blood"]),
					["Clothes"] = vRP.UserData(v["id"],"Clothings"),
					["Barber"] = vRP.UserData(v["id"],"Barbershop"),
					["Tattoos"] = vRP.UserData(v["id"],"Tatuagens")
				})
			end
		end
	end
	
	return Character
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CharacterChosen(Passport)
	local source = source
	local License = vRP.Identities(source)
	local Consult = vRP.Query("characters/UserLicense",{ id = Passport, license = License })
	if Consult[1] then
		TriggerEvent("vRP:BucketServer",source,"Exit")
		vRP.CharacterChosen(source,Passport)
		SetPlayerRoutingBucket(source,0)
	else
		DropPlayer(source,"Conectando em personagem irregular.")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.NewCharacter(Name,Name2,Sex)
	local source = source
	if not Selected[source] then
		Selected[source] = true

		local License = vRP.Identities(source)
		local Account = vRP.Account(License)
		local AmountCharacters = parseInt(Account["chars"])
		local Characters = vRP.Query("characters/countPersons",{ license = License })

		if vRP.LicensePremium(License) then
			AmountCharacters = AmountCharacters + AmountCharactersPremium
		end

		if parseInt(AmountCharacters) <= parseInt(Characters[1]["qtd"]) then
			TriggerClientEvent("Notify",source,"amarelo","Limite de personagem atingido.",3000)
			Selected[source] = nil
			return
		end

		local Sexo = "F"
		if Sex == "mp_m_freemode_01" then
			Sexo = "M"
		end

		vRP.Query("characters/newCharacter",{ license = License, name = Name, name2 = Name2, sex = Sexo, phone = vRP.GeneratePhone(), blood = math.random(4) })

		local Consult = vRP.Query("characters/lastCharacters",{ license = License })
		if Consult[1] then
			TriggerEvent("vRP:BucketServer",source,"Exit")
			vRP.CharacterChosen(source,Consult[1]["id"],Sex)
			
		end

		Selected[source] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
    if "spawn" == Resource then
        Wait(1000)
        print("Autenticado com sucesso pelo Sr Vinix!!!.")
    end
end)


function Creative.FinshSpawn()
	local source = source
	SetPlayerRoutingBucket(source,0)
	vRP.stopAnim(source,false)
end

RegisterCommand('mundo',function(source,args,rawCommand)
    local user_id = vRP.Passport(source)
    local source = source
    local perm = vRP.HasPermission(user_id,"Admin")

    if vRP.Passport(source) then
        if args[1] then
           SetPlayerRoutingBucket(source,(parseInt(args[1])))
        TriggerClientEvent("Notify",source,"sucesso","Você foi para o mundo <b>"..args[1].."</b> !",2000)
        else 
            TriggerClientEvent("Notify",source,"negado","Você não tem permissão.",2000)
            SetPlayerRoutingBucket(source,0)
        end
    end
end)