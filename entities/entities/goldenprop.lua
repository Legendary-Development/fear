if (SERVER) then
AddCSLuaFile()
end
ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "GoldenProp"
ENT.Author = "Legend"
ENT.Purpose = "Press e"
ENT.Instructions = "Fucking press e"

ENT.Spawnable = false
ENT.AdminSpawnable = true

function ENT:Initialize()
 
	self:SetModel( "models/shadertest/vertexlitmaskedenvmappedtexdet.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS ) 
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Use( activator, caller  )
self:Remove()

umsg.Start("VicWin", caller);

umsg.End()

end
