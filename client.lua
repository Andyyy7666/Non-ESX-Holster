--[[ 

Author: Otacon 
Modified by: Andyyy

Original github link: https://github.com/Dr-Otacon/esx_holster
Modified version github link: https://github.com/Andyyy7666/Non-ESX-Holster

Support: https://discord.green/andys-development


DON'T CHANGE ANYTHING IF YOU DON'T KNOW WHAT YOU'RE DOING!
CHANGE STUFF IN config.lua

]]--

--- VISUAL WEAPONS ----

SETTINGS = {
	back_bone = 24816,
	x = 0.3,  --- Neagtive up; positive down
	y = -0.15,   --- negative is away from body   - positive is in body 
	z = -0.10,   -- positive left --- negative right
	x_rotation = 180.0,
	y_rotation = 145.0,
	z_rotation = 0.0,
	compatable_weapon_hashes = {
			-- assault rifles:
			["w_sg_pumpshotgunmk2"] = GetHashKey("WEAPON_PUMPSHOTGUN_MK2"),
			["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
			["w_ar_assaultrifle"] = GetHashKey("WEAPON_ASSAULTRIFLE"),
			["w_sg_pumpshotgun"] = GetHashKey("WEAPON_PUMPSHOTGUN"),
			["w_ar_carbinerifle"] = GetHashKey("WEAPON_CARBINERIFLE"),
			["w_ar_assaultrifle_smg"] = GetHashKey("WEAPON_COMPACTRIFLE"),
			["w_sb_smg"] = GetHashKey("WEAPON_SMG"),
			["w_sb_pdw"] = GetHashKey("WEAPON_COMBATPDW"),
			["w_mg_mg"] = GetHashKey("WEAPON_MG"),
			["w_sb_gusenberg"] = GetHashKey("WEAPON_GUSENBERG"),
			["w_ar_advancedrifle"] = GetHashKey("WEAPON_ADVANCEDRIFLE"),
			["w_sr_sniperrifle"] = GetHashKey("WEAPON_SNIPERRIFLE"),
			["w_ar_assaultriflemk2"] = GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),
			["w_mg_combatmgmk2"] = GetHashKey("WEAPON_COMBATMG_MK2"),
			["w_ar_musket"] = GetHashKey("WEAPON_MUSKET"),
			["w_ar_specialcarbine"] = GetHashKey("WEAPON_SPECIALCARBINE"),
			["w_sb_smgmk2"] = GetHashKey("WEAPON_SMG_MK2"),
			["w_ar_specialcarbinemk2"] = GetHashKey("WEAPON_SPECIALCARBINE_MK2"),
	}
}

attached_weapons = {}
-------END VISUAL WEAPONS
 
--- Variables ------
holstered  = true
PlayerData = {}

hasWeaponL = false
hasWeapon = false
hasWeaponCop = false
currWeapon = GetHashKey("WEAPON_UNARMED")
weaponL = GetHashKey("WEAPON_UNARMED")
animateTrunk = false
has_weapon_on_back = false
racking = false
holster = 0
blocked = false
ped = nil
-----------------------

RegisterNetEvent('playerLoaded')
AddEventHandler('playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

 -- MAIN FUNCTION
 Citizen.CreateThread(function()
	local newWeapon = GetHashKey("WEAPON_UNARMED")
	while true do
		Citizen.Wait(1)
		ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(ped, true) then
			newWeapon = GetSelectedPedWeapon(ped)
			if newWeapon ~= currWeapon then
				if checkWeaponLarge(ped, newWeapon) then
					if hasWeaponL then
						holsterWeaponL(ped, currWeapon)
					else
						if hasWeapon then
							holsterWeapon(ped, currWeapon)
						elseif hasWeaponCop then
							holsterWeaponCop(ped, currWeapon)
						end
					end
					drawWeaponLarge(ped, newWeapon)
				elseif holster >= 1 and holster <= 4 then
					if hasWeaponL then
						holsterWeaponL()
					elseif hasWeapon then
						holsterWeapon(ped, currWeapon)
					elseif hasWeaponCop then
						holsterWeaponCop(ped, currWeapon)
					end
				else
					if hasWeaponL then
						holsterWeaponL()
					elseif hasWeapon then
						holsterWeapon(ped, currWeapon)
					elseif hasWeaponCop then
						holsterWeaponCop(ped, currWeapon)
					end
					drawWeapon(ped, newWeapon)
				end
				currWeapon = newWeapon
			end
		else
			hasWeapon = false
			hasWeaponCop = false
		end
		if racking then
			rackWeapon()
		end
	end
end)

--Command to rack weapon in vehicle
RegisterCommand('rack', function()
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
	racking = true
end, false)

-------------WEAPON ON BACK VISUAL-----------
Citizen.CreateThread(function()
  	while true do
		local me = GetPlayerPed(-1)
		Citizen.Wait(10)
		---------------------------------------
		-- attach if player has large weapon --
		---------------------------------------
		for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
			if weaponL == wep_hash and has_weapon_on_back and HasPedGotWeapon(me, wep_hash, false) then
				if not attached_weapons[wep_name] then
					AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
				end
			end
		end
		--------------------------------------------
		-- remove from back if equipped / dropped --
		--------------------------------------------
		for name, attached_object in pairs(attached_weapons) do
			-- equipped? delete it from back:
			if not has_weapon_on_back then -- equipped or not in weapon wheel
				DeleteObject(attached_object.handle)
				attached_weapons[name] = nil
			end
		end
  		Wait(0)
  	end
end)