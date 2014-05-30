include('shared.lua')

SWEP.PrintName	= "Skull"
SWEP.Slot	= 0
SWEP.SlotPos	= 10
SWEP.DrawAmmo	= false
SWEP.DrawCrosshair	= true
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = true
SWEP.SwayScale	= 1.0	-- The scale of the viewmodel sway
SWEP.BobScale	= 1.0	-- The scale of the viewmodel bob

SWEP.RenderGroup = RENDERGROUP_OPAQUE

-- Override this in your SWEP to set the icon in the weapon selection
SWEP.WepSelectIcon	= surface.GetTextureID( "weapons/swep" )

SWEP.WorldSkullRotation = Angle(-45,90,0)
SWEP.WorldSkullOffset = Vector(0,2.8,-0.2)

SWEP.ViewSkullRotation = Angle(0,-65,180)
SWEP.ViewSkullOffset = Vector(3,5,-1)

SWEP.VM_Lowered_Offset = Vector(0,0,1)
SWEP.VM_Raised_Offset = Vector(0,3,0)

SWEP.VM_Lowered_AngleOffset = Angle(5,0,0)
SWEP.VM_Raised_AngleOffset = Angle(17,0,0)

killicon.AddFont('skullwep', 'HL2MPTypeDeath', '5', Color(0,180,0,255))

--stupid netowkring workaround
net.Receive("skullwep_changeholdtype", function(len)
	local ent = net.ReadEntity()
	local ht = net.ReadString()
	
	if IsValid(ent) then
		--print("SKULL : Set holdtype from network",ht)
		ent:Temp_SetHoldType(ht)
	end
end)

function SWEP:Reload()
	--serverside
end

function SWEP:DrawWorldModel()
	
	--if we don't have a model then make it
	if not IsValid(self.SkullModel) then
		self.SkullModel = ClientsideModel("models/Gibs/HGIBS.mdl", RENDERGROUP_OPAQUE)
		self.SkullModel:SetNoDraw(true)
	end
	
	--Make sure we still have the model
	if IsValid(self.SkullModel) then
	
		--Default shit for fallback
		local HandPos = self:GetPos()
		local HandAng = self:GetAngles()
		
		--Get the players hand
		if IsValid(self.Owner) then
			local AttID = self.Owner:LookupAttachment('anim_attachment_RH')
			if AttID then
			--We have an ID so we should definitely be able to get the attachment
				local Att = self.Owner:GetAttachment( AttID )
				HandPos,HandAng = Att.Pos,Att.Ang
				
				--Store directions before rotation
				local HandFwd = HandAng:Forward()
				local HandRight = HandAng:Right()
				local HandUp = HandAng:Up()
				
				--Rotate by offset
				HandAng:RotateAroundAxis(HandAng:Right(), self.WorldSkullRotation.p)
				HandAng:RotateAroundAxis(HandAng:Up(), self.WorldSkullRotation.y)
				HandAng:RotateAroundAxis(HandAng:Forward(), self.WorldSkullRotation.r)
				
				--Position by offset
				HandPos = HandPos + HandAng:Forward()*self.WorldSkullOffset.y + HandAng:Right()*self.WorldSkullOffset.x + HandAng:Up()*self.WorldSkullOffset.z
			else
				--where the fuck do we draw?
			end
		end
	
		--Draw it at the position and angle we worked out
		self.SkullModel:SetPos(HandPos)
		self.SkullModel:SetAngles(HandAng)
		self.SkullModel:DrawModel()
		
	end
	
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:Holster()
	if IsValid(self.SkullModel) then
		self.SkullModel:Remove()
	end
	self.SkullModel = nil
	
	--restore viewmodel material backup (it should have already been restored in post draw view model)
	if IsValid(self.Owner) and IsValid(self.Owner:GetViewModel()) then
		self.Owner:GetViewModel():SetMaterial("")
	end
end

function SWEP:OwnerChanged()
	--remove skull when it is picked up, so it gets recreated
	if IsValid(self.SkullModel) then
		self.SkullModel:Remove()
	end
	self.SkullModel = nil
end

function SWEP:GetViewModelPosition(pos,Ang)

	local ang = Angle(Ang.p,Ang.y,Ang.r)

	--todo, lower when not IsMelee
	if self:GetIsMelee() then
		pos = pos + Ang:Forward()*self.VM_Raised_Offset.y + Ang:Right()*self.VM_Raised_Offset.x + Ang:Up()*self.VM_Raised_Offset.z
		
		ang:RotateAroundAxis(ang:Right(),self.VM_Raised_AngleOffset.p)
		ang:RotateAroundAxis(ang:Up(),self.VM_Raised_AngleOffset.y)
		ang:RotateAroundAxis(ang:Forward(),self.VM_Raised_AngleOffset.r)
	else
		pos = pos + Ang:Forward()*self.VM_Lowered_Offset.y + Ang:Right()*self.VM_Lowered_Offset.x + Ang:Up()*self.VM_Lowered_Offset.z
		
		ang:RotateAroundAxis(ang:Right(),self.VM_Lowered_AngleOffset.p)
		ang:RotateAroundAxis(ang:Up(),self.VM_Lowered_AngleOffset.y)
		ang:RotateAroundAxis(ang:Forward(),self.VM_Lowered_AngleOffset.r)
	end
	return pos,ang
end

function SWEP:PreDrawViewModel(vm,ply,wep)
	--Hide the crowbar, but keep our c_hands
	vm:SetMaterial( "engine/occlusionproxy" )
end
function SWEP:PostDrawViewModel(vm,ply,wep)
	--Restore the viewmodel material since
	vm:SetMaterial("")
	
	--if we don't have a model then make it
	if not IsValid(self.SkullModel) then
		self.SkullModel = ClientsideModel("models/Gibs/HGIBS.mdl", RENDERGROUP_OPAQUE)
		self.SkullModel:SetNoDraw(true)
	end
	
	--Make sure we still have the model
	if IsValid(self.SkullModel) then
		--Default shit for fallback
		local HandPos = self:GetPos()
		local HandAng = self:GetAngles()
		
		--Get the players hand
		if IsValid(self.Owner) then
			if IsValid(self.Owner:GetViewModel()) then
				--local Att = self.Owner:GetViewModel():GetBonePosition(23) -- GetAttachment(1)
				HandPos,HandAng = self.Owner:GetViewModel():GetBonePosition(23) -- Att.Pos,Att.Ang
				
				--Store directions before rotation
				local HandFwd = HandAng:Forward()
				local HandRight = HandAng:Right()
				local HandUp = HandAng:Up()
				
				--Rotate by offset
				HandAng:RotateAroundAxis(HandAng:Right(), self.ViewSkullRotation.p)
				HandAng:RotateAroundAxis(HandAng:Up(), self.ViewSkullRotation.y)
				HandAng:RotateAroundAxis(HandAng:Forward(), self.ViewSkullRotation.r)
				
				--Position by offset
				HandPos = HandPos + HandAng:Forward()*self.ViewSkullOffset.y + HandAng:Right()*self.ViewSkullOffset.x + HandAng:Up()*self.ViewSkullOffset.z
			else
				--where the fuck do we draw?
			end
		end
	
		--Draw it at the position and angle we worked out
		self.SkullModel:SetPos(HandPos)
		self.SkullModel:SetAngles(HandAng)
		self.SkullModel:DrawModel()
	end
end

print("SkullWep cl_init ran")
