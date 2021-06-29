--[[ 

Author: Otacon 
Modified by: Andyyy

Original github link: https://github.com/Dr-Otacon/esx_holster
Modified version github link: https://github.com/Andyyy7666/Non-ESX-Holster

Support: https://discord.green/andys-development


DON'T CHANGE ANYTHING IF YOU DON'T KNOW WHAT YOU'RE DOING!
CHANGE STUFF IN config.lua

]]--

-----------------LARGE WEAPON STUFF ------------------------------
function drawWeaponLarge(ped, newWeapon)
	------Check if weapon is on back -------
	if has_weapon_on_back and newWeapon == weaponL then
		drawWeaponOnBack()
		has_weapon_on_back = false
		return
	end

	local door = isNearDoor()
	if (door == 'driver' or door == 'passenger') then
		blocked = true
		local coordA = GetEntityCoords(ped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorOpen(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorOpen(vehicle, 1, false, false)
			end
		end
		removeWeaponOnBack()
		startAnim("mini@repair", "fixing_a_ped")
		SetCurrentPedWeapon(ped, newWeapon, true)
		blocked = false
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorShut(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorShut(vehicle, 1, false, false)
			end
		end
		weaponL = newWeapon
		hasWeaponL = true
	elseif not isNearTrunk() then
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
		ShowNotification('You need to be at a trunk to draw that weapon!')
	else
		blocked = true
		removeWeaponOnBack()
		startAnim("mini@repair", "fixing_a_ped")
		blocked = false
		local coordA = GetEntityCoords(ped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			SetVehicleDoorShut(vehicle, 5, false, false)
		end
		weaponL = newWeapon
		hasWeaponL = true
	end
end


--- Checks if large weapon
function checkWeaponLarge(ped, newWeapon)
	for i = 1, #weaponsLarge do
		if GetHashKey(weaponsLarge[i]) == newWeapon then
			return true
		end
	end
	return false
end


--------------START WEAPON ON BACK-------------------------
--- Pulls weapon from back and puts in hands
function holsterWeaponL()
	SetCurrentPedWeapon(ped, weaponL, true)
	pos = GetEntityCoords(ped, true)
	rot = GetEntityHeading(ped)
	blocked = true
	TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", pos, 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
	Citizen.Wait(500)
	SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
	placeWeaponOnBack()
	Citizen.Wait(1500)
	ClearPedTasks(ped)
	blocked = false
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
	hasWeaponL = false
end

--- Pulls weapon from back and puts in hands
function drawWeaponOnBack()
	pos = GetEntityCoords(ped, true)
	rot = GetEntityHeading(ped)
	blocked = true
	loadAnimDict( "reaction@intimidation@1h" )
	TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", pos, 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
	removeWeaponOnBack()
	SetCurrentPedWeapon(ped, weaponL, true)
	Citizen.Wait(2000)
	ClearPedTasks(ped)
	blocked = false
	hasWeaponL = true
end

--- Removes model of weapon from back
function removeWeaponOnBack()
	print("REMOVING WEAPON MODEL FROM BACK")
	has_weapon_on_back = false
end

-- Places model of weapon on back
function placeWeaponOnBack()
	print("PLACING WEAPON MODEL ON BACK")
	has_weapon_on_back = true
end

--- Starts animation for trunk
function startAnim(lib, anim)
	RequestAnimDict(lib)
	while not HasAnimDictLoaded( lib) do
		Citizen.Wait(1)
	end

	TaskPlayAnim(ped, lib ,anim ,8.0, -8.0, -1, 0, 0, false, false, false )
	Citizen.Wait(2500)
	ClearPedTasksImmediately(ped)
end


function rackWeapon()
	local door = isNearDoor()
	if (door == 'driver' or door == 'passenger') then
		blocked = true
		local coordA = GetEntityCoords(ped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorOpen(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorOpen(vehicle, 1, false, false)
			end
		end
		removeWeaponOnBack()
		startAnim("mini@repair", "fixing_a_ped")
		blocked = false
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorShut(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorShut(vehicle, 1, false, false)
			end
		end
		WeaponL = GetHashKey("WEAPON_UNARMED")
		
	elseif isNearTrunk() then
		blocked = true
		removeWeaponOnBack()
		startAnim("mini@repair", "fixing_a_ped")
		blocked = false
		local coordA = GetEntityCoords(ped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			SetVehicleDoorShut(vehicle, 5, false, false)
		end
		WeaponL = GetHashKey("WEAPON_UNARMED")
		hasWeaponL = false
	else
		ShowNotification('You need to be at a trunk to put away your weapon!')
	end
	racking = false
end
-------------END WEAPON ON BACK--------------

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end
	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end

--------END WEAPON ON BACK VISUAL -----------------------------

--- Checks if player is near trunk
function isNearTrunk()
	local coordA = GetEntityCoords(ped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
	local vehicle = getVehicleInDirection(coordA, coordB)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		local trunkpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
		local lTail = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_l"))
		local rTail = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_r"))
		local playerpos = GetEntityCoords(ped, 1)
		local distanceToTrunk = GetDistanceBetweenCoords(trunkpos, playerpos, 1)
		local distanceToLeftT = GetDistanceBetweenCoords(lTail, playerpos, 1)
		local distanceToRightT = GetDistanceBetweenCoords(rTail, playerpos, 1)
		if distanceToTrunk < 1.5 then
			SetVehicleDoorOpen(vehicle, 5, false, false)
			return true
		elseif distanceToLeftT < 1.5 and distanceToRightT < 1.5 then
			SetVehicleDoorOpen(vehicle, 5, false, false)
			return true
		else
			return
		end
	end
end

function isNearDoor()
	local coordA = GetEntityCoords(ped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
	local vehicle = getVehicleInDirection(coordA, coordB)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		local dDoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_dside_f"))
		local pDoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_pside_f"))
		local playerpos = GetEntityCoords(ped, 1)
		local distanceToDriverDoor = GetDistanceBetweenCoords(dDoor, playerpos, 1)
		local distanceToPassengerDoor = GetDistanceBetweenCoords(pDoor, playerpos, 1)
		if distanceToDriverDoor < 2.0 then
			return 'driver'
		elseif distanceToPassengerDoor < 2.0 then
			return 'passenger'
		else
			return
		end
	end
end

-- Gets vehicle for trunk
function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, ped, 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end
------------- END LARGE WEAPON STUFF ----------------------------

------------- START GANG WEAPON ---------------------------------------------------------------
-- Holsters all other weapons
function holsterWeapon(ped, currentWeapon)
	if checkWeaponLarge(ped, currentWeapon) then
		placeWeaponOnBack()
	elseif checkWeapon(ped, currentWeapon) then
		SetCurrentPedWeapon(ped, currentWeapon, true)
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
		Citizen.Wait(500)
		SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
		Citizen.Wait(1500)
		ClearPedTasks(ped)
		blocked = false
    elseif checkWeaponCop(ped, currentWeapon) then
        SetCurrentPedWeapon(ped, currentWeapon, true)
        pos = GetEntityCoords(ped, true)
        rot = GetEntityHeading(ped)
        blocked = true
        TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
        Citizen.Wait(500)
        TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
        Citizen.Wait(30)
        SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
        Citizen.Wait(70)
        ClearPedTasks(ped)
        blocked = false
    end
	hasWeapon = false
end

--Draws all other weapons
function drawWeapon(ped, newWeapon)
	if newWeapon == GetHashKey("WEAPON_UNARMED") then
		return
	end
	if checkWeapon(ped, newWeapon) then
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
		loadAnimDict( "reaction@intimidation@1h" )
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
		SetCurrentPedWeapon(ped, newWeapon, true)
		Citizen.Wait(600)
		ClearPedTasks(ped)
		blocked = false
    else
		SetCurrentPedWeapon(ped, newWeapon, true)
	end
    if checkWeaponCop(ped, newWeapon) then
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
        loadAnimDict("rcmjosh4")
		loadAnimDict( "reaction@intimidation@cop@unarmed" )
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
        Citizen.Wait(200)
        TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
		SetCurrentPedWeapon(ped, newWeapon, true)
		Citizen.Wait(400)
		ClearPedTasks(ped)
		blocked = false
	else
		SetCurrentPedWeapon(ped, newWeapon, true)
	end
	hasWeapon = true
end

function checkWeapon(ped, newWeapon)
	for i = 1, #weaponsFull do
		if GetHashKey(weaponsFull[i]) == newWeapon then
			return true
		end
	end
	return false
end
------------- STOP GANG WEAPON ----------------------------------------------------------------

------------- START COP WEAPON ---------------------------------------------------------------
-- Holsters all other weapons
function holsterWeaponCop(ped, currentWeapon)
	if checkWeaponLarge(ped, currentWeapon) then
		placeWeaponOnBack()
	elseif checkWeapon(ped, currentWeapon) then
		SetCurrentPedWeapon(ped, currentWeapon, true)
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
		Citizen.Wait(500)
		SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
		Citizen.Wait(1500)
		ClearPedTasks(ped)
		blocked = false
    elseif checkWeaponCop(ped, currentWeapon) then
        SetCurrentPedWeapon(ped, currentWeapon, true)
        pos = GetEntityCoords(ped, true)
        rot = GetEntityHeading(ped)
        blocked = true
        TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
        Citizen.Wait(500)
        TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
        Citizen.Wait(30)
        SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
        Citizen.Wait(70)
        ClearPedTasks(ped)
        blocked = false
    end
	hasWeaponCop = false
end

--Draws all other weapons
function drawWeaponCop(ped, newWeapon)
	if newWeapon == GetHashKey("WEAPON_UNARMED") then
		return
	end
	if checkWeapon(ped, newWeapon) then
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
		loadAnimDict( "reaction@intimidation@1h" )
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
		SetCurrentPedWeapon(ped, newWeapon, true)
		Citizen.Wait(600)
		ClearPedTasks(ped)
		blocked = false
    else
		SetCurrentPedWeapon(ped, newWeapon, true)
	end
    if checkWeaponCop(ped, newWeapon) then
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
        loadAnimDict("rcmjosh4")
		loadAnimDict( "reaction@intimidation@cop@unarmed" )
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
        Citizen.Wait(200)
        TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
		SetCurrentPedWeapon(ped, newWeapon, true)
		Citizen.Wait(400)
		ClearPedTasks(ped)
		blocked = false
	else
		SetCurrentPedWeapon(ped, newWeapon, true)
	end
	hasWeaponCop = true

end

function checkWeaponCop(ped, newWeapon)
	for i = 1, #weaponsCop do
		if GetHashKey(weaponsCop[i]) == newWeapon then
			return true
		end
	end
	return false
end
------------- STOP COP WEAPON ----------------------------------------------------------------


--------- BLOCKS PLAYER ACTIONS -----------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
            if blocked then
                DisableControlAction(1, 25, true )
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
                DisableControlAction(1, 23, true)
				DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
				DisableControlAction(1, 182, true)  -- Disables L
				DisablePlayerFiring(ped, true) -- Disable weapon firing
            end
    end
end)



--Loads Animation Dictionary
function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end