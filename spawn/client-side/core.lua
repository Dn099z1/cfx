-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Camera = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN:OPENED
-----------------------------------------------------------------------------------------------------------------------------------------


local Anims = {
	{ ["Dict"] = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", ["Name"] = "hi_dance_crowd_17_v2_male^2" },
	{ ["Dict"] = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", ["Name"] = "high_center_down" },
	{ ["Dict"] = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", ["Name"] = "med_center_up" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Locate = {
	{ ["x"] = -2205.92, ["y"] = -370.48, ["z"] = 13.29, ["name"] = "Great Ocean", ["hash"] = 1 },
	{ ["x"] = -250.35, ["y"] = 6209.71, ["z"] = 31.49, ["name"] = "Duluoz Avenue", ["hash"] = 2 },
	{ ["x"] = 1694.37, ["y"] = 4794.66, ["z"] = 41.92, ["name"] = "Grapedseed Avenue", ["hash"] = 3 },
	{ ["x"] = 1858.94, ["y"] = 3741.78, ["z"] = 33.09, ["name"] = "Armadillo Avenue", ["hash"] = 4 },
	{ ["x"] = 328.0, ["y"] = 2617.89, ["z"] = 44.48, ["name"] = "Senora Road", ["hash"] = 5 },
	{ ["x"] = 308.33, ["y"] = -232.25, ["z"] = 54.07, ["name"] = "Hawick Avenue", ["hash"] = 6 },
	{ ["x"] = 449.71, ["y"] = -659.27, ["z"] = 28.48, ["name"] = "Integrity Way", ["hash"] = 7 }
}
AddEventHandler("onResourceStart",function(Resource)
	if "spawn" == Resource then
		TriggerEvent("spawn:Opened")
	end
end)
RegisterCommand("spawn",function()	
	if vSERVER.checkPerm() then
		
		TriggerEvent("spawn:Opened")
	end
end)

AddEventHandler("spawn:Opened",function()
	local Ped = PlayerPedId()
	SetEntityCoords(Ped,233.85,-1387.59,29.55,false,false,false,false)
	LocalPlayer["state"]:set("Invincible",true,true)
	LocalPlayer["state"]:set("Invisible",true,true)
	SetEntityVisible(Ped,false,false)
	FreezeEntityPosition(Ped,true)
	SetEntityInvincible(Ped,true)
	SetEntityHeading(Ped,136.07)
	SetEntityHealth(Ped,101)
	SetPedArmour(Ped,0)

	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	SetCamCoord(Camera,232.0,-1388.64,30.45)
	RenderScriptCams(true,true,0,true,true)
	SetCamRot(Camera,0.0,0.0,320.0,2)
	SetCamActive(Camera,true)

	Characters = vSERVER.Characters()
	if parseInt(#Characters) > 0 then
		Customization(Characters[1])
	end

	Wait(5000)

	SendNUIMessage({ Action = "Spawn", Table = Characters })
	SetNuiFocus(true,true)

	if IsScreenFadedOut() then
		DoScreenFadeIn(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CharacterChosen",function(Data,Callback)
	if vSERVER.CharacterChosen(Data["Passport"]) then
		SendNUIMessage({ Action = "Close" })
		vSERVER.FinshSpawn()
	end
	Characters = vSERVER.Characters()
	if parseInt(#Characters) > 0 then
		Customization(Characters[1])
	end
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("NewCharacter",function(Data,Callback)
	vSERVER.NewCharacter(Data["name"],Data["lastname"],Data["sex"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SWITCHCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("SwitchCharacter",function(Data,Callback)
	for _,v in pairs(Characters) do
		if v["Passport"] == Data["Passport"] then
			Customization(v,true)
			-- break
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN:FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:Finish")
AddEventHandler("spawn:Finish",function(Open,Barbershop)
	if Open then
		-- Locate[1] = { ["Coords"] = Barbershop, ["name"] = "" }

		for Number,v in ipairs(Locate) do
			local Road = GetStreetNameAtCoord(v["x"],v["Y"],v["z"])
			Locate[Number]["name"] = GetStreetNameFromHashKey(Road)
		end

		SetCamCoord(Camera,Locate[1]["x"],Locate[1]["y"],Locate[1]["z"] + 1)
		SendNUIMessage({ Action = "Location", Table = Locate })
		LocalPlayer["state"]:set("Invisible",true,true)
		SetEntityVisible(PlayerPedId(),false,false)
		SetCamRot(Camera,0.0,0.0,0.0,2)
	else
		SetEntityVisible(PlayerPedId(),true,false)
		LocalPlayer["state"]:set("Invisible",false,true)
		SendNUIMessage({ Action = "Close" })
		TriggerEvent("hud:Active",true)
		SetNuiFocus(false,false)
		vSERVER.FinshSpawn()
		if DoesCamExist(Camera) then
			RenderScriptCams(false,false,0,false,false)
			SetCamActive(Camera,false)
			DestroyCam(Camera,false)
			Camera = nil
		end

		if Barbershop then
			TriggerServerEvent("vRP:BucketClient","Enter")
			TriggerEvent("barbershop:Opem","open")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Spawn",function(Data,Callback)
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	SetEntityVisible(PlayerPedId(),true,false)
	LocalPlayer["state"]:set("Invisible",false,true)
	SendNUIMessage({ Action = "Close" })
	TriggerEvent("hud:Active",true)
	SetNuiFocus(false,false)
	vSERVER.FinshSpawn()
	Callback("Ok")

	Characters = vSERVER.Characters()
	if parseInt(#Characters) > 0 then
		Customization(Characters[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Chosen",function(Data,Callback)
	local Ped = PlayerPedId()
	local Index = Data["index"]

	SetEntityCoords(Ped,Locate[Index]["x"],Locate[Index]["y"],Locate[Index]["z"] - 1)
	SetCamCoord(Camera,Locate[Index]["x"],Locate[Index]["y"],Locate[Index]["z"] + 1)
	SetCamRot(Camera,0.0,0.0,0.0,2)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMIZATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Customization(Table,Check)
	if LoadModel(Table["Skin"]) then
		if Check then
			if GetEntityModel(PlayerPedId()) ~= GetHashKey(Table["Skin"]) then
				SetPlayerModel(PlayerId(),Table["Skin"])
				SetPedComponentVariation(PlayerPedId(),5,0,0,1)
			end
		else
			SetPlayerModel(PlayerId(),Table["Skin"])
			SetPedComponentVariation(PlayerPedId(),5,0,0,1)
		end

		local Ped = PlayerPedId()
		local Random = math.random(#Anims)
		if LoadAnim(Anims[Random]["Dict"]) then
			TaskPlayAnim(Ped,Anims[Random]["Dict"],Anims[Random]["Name"],8.0,8.0,-1,1,0,0,0,0)
		end

		exports["skinshop"]:Apply(Table["Clothes"],Ped)
		exports["barbershop"]:Apply(Table["Barber"],Ped)

		for Index,Overlay in pairs(Table["Tattoos"]) do
			AddPedDecorationFromHashes(Ped,Overlay,Index)
		end

		SetEntityVisible(Ped,true,false)
		LocalPlayer["state"]:set("Invisible",false,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN:INCREMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:Increment")
AddEventHandler("spawn:Increment",function(Tables)
	for _,v in pairs(Tables) do
		Locate[#Locate + 1] = { ["Coords"] = v["Coords"], ["name"] = "" }
	end
end)