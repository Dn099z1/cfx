-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("party")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARTY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Party2",function(source,Message)
	-- SendNUIMessage({ action = "open" })
	SendNUIMessage({ name = "Open", payload = vSERVER.GetRooms() })
	SetNuiFocus(true,true)
end)

RegisterNUICallback("GetRooms",function(Data,Callback)
	print("GetRooms: "..json.encode(vSERVER.GetRooms()))
	print("GetRooms: "..json.encode(Data))
	SendNUIMessage({ name = "Open", payload = vSERVER.GetRooms() })
	SetNuiFocus(true,true)
end)

RegisterNUICallback("s",function(Data,Callback)
	SendNUIMessage({ name = "Open", payload = vSERVER.GetMembers("Yuri",Data["id"]) })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEROOM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CreateRoom",function(Data,Callback)
	Callback(vSERVER.Create(Data["Id"],Data["name"],Data["password"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXITROOM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ExitRoom",function(Data,Callback)
	Callback(vSERVER.Exit())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTERROOM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("EnterRoom",function(Data,Callback)
	Callback(vSERVER.Enter(Data["name"],Data["password"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Party2","Abrir grupos.","keyboard","J")