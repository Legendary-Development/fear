
SWEP.Base = "weapon_base"

SWEP.Author	= "Whiterabbit"
SWEP.Contact	= "Workshop"
SWEP.Purpose	= "Beat them to death with a skull"
SWEP.Instructions	= "Melee away"

SWEP.Category = "Melee"

SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip	= false
SWEP.ViewModel	= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel	= "models/weapons/w_grenade.mdl"
SWEP.UseHands = true

SWEP.Spawnable	= true
SWEP.AdminOnly	= false

SWEP.Primary.ClipSize	= -1	-- Size of a clip
SWEP.Primary.DefaultClip	= 0	-- Default number of bullets in a clip
SWEP.Primary.Automatic	= true	-- Automatic/Semi Auto
SWEP.Primary.Ammo	= "none"
SWEP.Primary.Damage = 35
SWEP.Primary.Delay = 0.7

SWEP.Secondary.ClipSize	= -1	-- Size of a clip
SWEP.Secondary.DefaultClip	= 0	-- Default number of bullets in a clip
SWEP.Secondary.Automatic	= true	-- Automatic/Semi Auto
SWEP.Secondary.Ammo	= "none"

SWEP.HoldType_Active = 'melee'
SWEP.HoldType_Inactive = 'slam'


local sound_single = Sound("Weapon_Crowbar.Single")

function SWEP:SetupDataTables()
	self:NetworkVar('Bool',0,'IsMelee')
end

function SWEP:Initialize()
	self:ToggleMeleeMode(false)
end

function SWEP:PrimaryAttack()

	-- Make sure we can shoot first
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime()+self.Primary.Delay)
	
	if not IsValid(self.Owner) then return end
	
	--Sound of swinging
	self:EmitSound(sound_single)
	
	--Lagcomp before trace
	self.Owner:LagCompensation(true)
	
	--Trace to see what we hit if anything
	local ShootPos = self.Owner:GetShootPos()
	local ShootDest = ShootPos + (self.Owner:GetAimVector() * 70)
	local tr_main = util.TraceLine({start=ShootPos, endpos=ShootDest, filter=self.Owner, mask=MASK_SHOT_HULL})
	local tr_hull = util.TraceHull({start=ShootPos, endpos=ShootDest, mins=Vector(-8,-8,-8), maxs=Vector(8,8,8), filter=self.Owner, mask=MASK_SHOT_HULL})
	
	local HitEnt = IsValid(tr_main.Entity) and tr_main.Entity or tr_hull.Entity
	
	--Trace is done, turn off lagcomp
	self.Owner:LagCompensation(false)

	--If we hit something (including world)
	if IsValid(HitEnt) or tr_main.HitWorld then
	
		--Animate view model
		self:SendWeaponAnim( ACT_VM_HITCENTER )

		--Only do once/server
		if not (CLIENT and (not IsFirstTimePredicted())) then
			--Setup effect
			local edata = EffectData()
			edata:SetStart(ShootPos)
			edata:SetOrigin(tr_main.HitPos)
			edata:SetNormal(tr_main.Normal)
			edata:SetEntity(HitEnt)
			--Hit ragdoll or player, do blood
			if HitEnt:IsPlayer() or HitEnt:IsNPC() or HitEnt:GetClass() == "prop_ragdoll" then
				util.Effect("BloodImpact", edata)
				-- do a bullet for blood decals
				self.Owner:FireBullets({Num=1, Src=ShootPos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=0})
			else
				--Hit something other than player or ragdoll
				util.Effect("Impact", edata)
			end
		end
	else
		--Didn't hit anything, miss animation
		self:SendWeaponAnim( ACT_VM_MISSCENTER )
	end

	--Animate
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

	--Damage entity
	if HitEnt and HitEnt:IsValid() then
		local dmg = DamageInfo()
		dmg:SetDamage(self.Primary.Damage)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamageForce(self.Owner:GetAimVector() * 1500)
		dmg:SetDamagePosition(self.Owner:GetPos())
		dmg:SetDamageType(DMG_CLUB)
		HitEnt:DispatchTraceAttack(dmg, ShootPos + (self.Owner:GetAimVector() * 3), ShootDest)
	end

end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Temp_SetHoldType(ht)
	self.LastHoldType = ht
	--temp fix until the update introduces shared setholdtype
	if not self.SetHoldType then
		self:SetWeaponHoldType(ht)
		if SERVER then
			self:HoldTypeNotify()
		end
	else
		self:SetHoldType(ht)
	end
end

function SWEP:ToggleMeleeMode(bActive)
	self:SetIsMelee(bActive)
	self:Temp_SetHoldType(bActive and self.HoldType_Active or self.HoldType_Inactive)
end

--[[function SWEP:Think()
	--print("Setting hold type on",self,"owned by",self.Owner,"to",self:GetIsMelee() and self.HoldType_Active or self.HoldType_Inactive)
	self:SetWeaponHoldType( self:GetIsMelee() and self.HoldType_Active or self.HoldType_Inactive )
end]]

function SWEP:SetNextReload(t)
	self.NextReloadTime = t
end
function SWEP:CanReload()
	if not self.NextReloadTime then return true end
	return self.NextReloadTime<=CurTime()
end
function SWEP:CanPrimaryAttack()
	--Can only attack when the weapon is raised
	if not self:GetIsMelee() then return false end
	--Normal delay of attacks
	return self:GetNextPrimaryFire()<=CurTime()
end

print("SkullWep shared ran")
