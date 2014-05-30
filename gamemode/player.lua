local ply = FindMetaTable("Player")

local teams = {}

teams[0] = {name = "Victims", color = Vector( .2, .2, 1.0 ) }


function ply:SetGamemodeTeam( n )
	if not teams[n] then return end
	
	self:SetTeam( n )
	
	self:SetPlayerColor( teams[n].color )
	
	return true
end
