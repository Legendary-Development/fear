AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

--stupid networking wrokaround
util.AddNetworkString("skullwep_changeholdtype")

SWEP.Weight	= 8
SWEP.AutoSwitchTo	= true
SWEP.AutoSwitchFrom	= false

function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:Reload()
	if self:CanReload() then
		self:SetNextReload(CurTime()+0.2)
		if not self:GetIsMelee() then
			self:ToggleMeleeMode(true)
		else
			self:ToggleMeleeMode(false)
		end
	end
end

function SWEP:HoldTypeNotify(ply)
	
	net.Start("skullwep_changeholdtype")
	
	net.WriteEntity(self)
	net.WriteString(self.LastHoldType)
	
	if IsValid(ply) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end


print("SkullWep init ran")
