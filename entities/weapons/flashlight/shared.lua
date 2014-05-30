if (SERVER) then

AddCSLuaFile ("shared.lua");

SWEP.Weight = 5; 
SWEP.AutoSwitchTo = false; 
SWEP.AutoSwitchFrom = false;
end
	
if ( CLIENT ) then

SWEP.PrintName = "Flashlight";
SWEP.Slot = 1;
SWEP.SlotPos = 7;
SWEP.DrawAmmo = false; 
SWEP.DrawCrosshair = false;  
end

SWEP.Author = "Devilsson2010"; 
SWEP.Contact = ""; 
SWEP.Purpose = "Assists in seeing things";
SWEP.Instructions = "Left click to turn on/off";

SWEP.Spawnable = true; 
SWEP.AdminSpawnable = true;

SWEP.ViewModel = "models/weapons/v_flashlight_on.mdl";
SWEP.WorldModel = "models/weapons/w_toolgun.mdl";

SWEP.Primary.ClipSize = -1; 
SWEP.Primary.DefaultClip = -1; 
SWEP.Primary.Automatic = false; 
SWEP.Primary.Ammo = "none"; 

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1; 
SWEP.Secondary.Automatic = false; 
SWEP.Secondary.Ammo = "none";

SWEP.IsOn = false
	
function SWEP:Reload() 
 end

function SWEP:Holster( wep )
	if(SERVER) then
	    self.IsOn = false
		self.Owner:Flashlight(false)
		self.Owner:AllowFlashlight(false)
		end
	return true
	end
	
function SWEP:PrimaryAttack()
	if (SERVER) then
		self.Owner:AllowFlashlight(true)
	    self.IsOn = !self.IsOn
	    self.Owner:Flashlight(self.IsOn) 
    end
end

function SWEP:SecondaryAttack()
end


if(SERVER) then
	--AddCSLuaFile ("shared.lua");
	include('battery_charger.lua')
end

SWEP.BatteryDrainer = nil
SWEP.Charger = nil

SWEP.MaxEnergy = 100
SWEP.MinEnergy = 0

SWEP.AmmoString = "flashlight_energy"

if(CLIENT) then
	function SWEP:CustomAmmoDisplay()
		self.AmmoDisplay = self.AmmoDisplay or {}

		self.AmmoDisplay.Draw = true
	
		self.AmmoDisplay.PrimaryClip = self:Ammo1() or 0
		self.AmmoDisplay.PrimaryAmmo = -1
		self.AmmoDisplay.SecondaryAmmo = -1

		return 	self.AmmoDisplay
	end
end

function SWEP:Initialize()
	if(CLIENT) then return end

	Msg("Initializing!\n")

	--start out with maximum energy
	self:GivePrimaryAmmo(self.MaxEnergy)

	--set up the battery drainer
	--drain 2 energy per second
	self.BatteryDrainer = BatteryCharger:new()
	self.BatteryDrainer.EnergyPerCycle = 2
	self.BatteryDrainer.CycleSeconds = 1

	--set up the battery charger
	--charge 1 energy per second
	self.Charger = BatteryCharger:new()
	self.Charger.EnergyPerCycle = 1
	self.Charger.CycleSeconds = 1
end

-----------------------------------------------------------
-- Think drains battery energy
-----------------------------------------------------------
function SWEP:Think()
	
	if( self:Ammo1() <=0 ) then 
		self.Weapon:SetNextPrimaryFire( CurTime() + 8.2 ) 
	end

	if(SERVER) then
	n = 0
		--drain energy from the battery if the flashlight is on
		if(self.IsOn) then
			local amount = self.BatteryDrainer:GetChargeAmount()
			if(amount > 0) then
				self:TakePrimaryAmmo(amount)
				if(self:Ammo1() <=0) then
				if n == 0 then
				n = n + 1
				timer.Create("NoMorePower", .5, 1, NumReset())
				self.IsOn = !self.IsOn
				self.Owner:Flashlight(self.IsOn)
				else end			
			end
		end
	end
end
end

function NumReset()
n = 0
timer.Destroy("NoMorePower")
end
	
function SWEP:Ammo1()
	return self.Weapon:GetNetworkedInt(self.AmmoString)
end

function SWEP:TakePrimaryAmmo(num)
	if(self:Ammo1() <= self.MinEnergy) then
		self.Weapon:SetNetworkedInt(self.AmmoString, self.MinEnergy)
		return
	end

	self.Weapon:SetNetworkedInt(self.AmmoString, math.Clamp(self:Ammo1() - num, self.MinEnergy, 

self.MaxEnergy))
end

function SWEP:GivePrimaryAmmo(num)
	if(self:Ammo1() >= self.MaxEnergy) then return end

	self.Weapon:SetNetworkedInt(self.AmmoString, math.Clamp(self:Ammo1() + num, self.MinEnergy, 

self.MaxEnergy))
end

function RegenerateEnergy()
	if(SERVER) then
		--loop through all of the players
		for i,ply in pairs(player.GetAll()) do
			local flashlight = ply:GetWeapon("flashlight")

			if(flashlight:IsValid()) then
				if(flashlight.IsOn ~= true) then
			--regenerate energy every EnergyRegenCycleSeconds
					local amount = flashlight.Charger:GetChargeAmount()
					if(amount > 0) then
						flashlight:GivePrimaryAmmo(amount)
					end
				end
			end
		end
	end
end

	hook.Add("Think", "flashlight_regenerate_energy", RegenerateEnergy)
