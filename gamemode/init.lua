//Things still to do:
/*resource.AddFile("models/half-life/mrfriendly.mdl")
resource.AddFile("models/weapons/v_flashlight_on.mdl")

resource.AddFile("materials/models/mrfriendly/belly.vtf")
resource.AddFile("materials/models/mrfriendly/black.vtf")
resource.AddFile("materials/models/mrfriendly/butt.vtf")
resource.AddFile("materials/models/mrfriendly/face.vtf")
resource.AddFile("materials/models/mrfriendly/mouth.vtf")
resource.AddFile("materials/models/mrfriendly/rightleg.vtf")
resource.AddFile("materials/models/mrfriendly/rleg.vtf")
resource.AddFile("materials/models/mrfriendly/spine.vtf")
resource.AddFile("materials/models/mrfriendly/tentacle.vtf")
resource.AddFile("materials/models/mrfriendly/tentfront.vtf")
resource.AddFile("materials/models/mrfriendly/torsoside.vtf")
resource.AddFile("materials/flashlight.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/arm2.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/arm2_normal.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/arm2_ref.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/beam1.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/bulb.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/flare.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/flashlight_hud.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/flashlight2.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/flashlight2_death.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/flashlight2_hud.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/flashlight2_local.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/flashlight2_normal.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/flashlight2_ref.vtf")
resource.AddFile("materials/models/weapons/v_flashlight/flashlightw.vtf")

resource.AddFile("materials/gman.png")
resource.AddFile("materials/scpeye/eyeview.vtf")

resource.AddFile("sound/npc/fr_attack.wav")
resource.AddFile("sound/npc/fr_groan1.wav")
resource.AddFile("sound/npc/fr_groan2.wav")

resource.AddFile("sound/nil_alone.wav")
resource.AddFile("sound/nil_deceive.wav")
resource.AddFile("sound/nil_done.wav")
resource.AddFile("sound/nil_freeman.wav")
resource.AddFile("sound/nil_last.wav")
resource.AddFile("sound/nil_laugh1.wav")
resource.AddFile("sound/nil_laugh2.wav")
resource.AddFile("sound/nil_man_notman.wav")
resource.AddFile("sound/nil_now_die.wav")
resource.AddFile("sound/nil_slaves.wav")
resource.AddFile("sound/nil_thelast.wav")
resource.AddFile("sound/nil_thetruth.wav")
resource.AddFile("sound/nil_thieves.wav")
resource.AddFile("sound/nil_win.wav")

resource.AddFile("sound/waterdrops.mp3")
resource.AddFile("sound/smokealarm.mp3")
resource.AddFile("sound/cellardoorslam.mp3")
resource.AddFile("sound/scary.mp3")
resource.AddFile("sound/strange.mp3")
resource.AddFile("sound/shot.mp3")
resource.AddFile("sound/buzzsaw.mp3")
resource.AddFile("sound/chainsaw.mp3")
resource.AddFile("sound/jumpscare.mp3")
resource.AddFile("sound/buzzin2.mp3")
resource.AddFile("sound/horrorbuzz.mp3")
*/
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

include("shared.lua")

include("player.lua")



function SpawnGProp()
PrintMessage(HUD_PRINTTALK, "Gprop Spawn Ran")
   	local Spawns = {
	Vector(-2825.641357, 1420.374146, -3504.891846);
	Vector(-3366.608398, 1450.263184, -3523.183350);
	Vector(-5391.474121, 693.360962, -3518.278564);
	Vector(-4493.145996, 439.987610, -3521.404053);
	Vector(-3952.261963, 582.641602, -3519.968750);
	Vector(-3802.943604, 1792.913818, -3507.057617);
	Vector(-2268.290039, 1683.261597, 69.526070);
	Vector(-1944.526611, 4118.445801, 83.076447);
	Vector(-201.243225, 3668.999023, 87.421951);
	Vector(-2071.832275, 2530.378418, 65.843414);
	Vector(-2807.138672, -295.113617, 106.355247);
	Vector(-3002.123779, 558.179932, 61.393742);
	Vector(-4178.655273, 2861.287354, 54.987335);
	Vector(-5955.591797, 2358.774658, -96.954010);
	Vector(-5057.796875, 2933.024170, 65.260193);
	Vector(-6776.100586, 2178.492432, 67.716553);
	Vector(-6641.131836, 2950.413818, 57.023567);
	Vector(-5462.553223, 7227.875977, 145.432922);
}


local ent = ents.Create("goldenprop") -- This creates our zombie entity
ent:SetPos( table.Random( Spawns ) )

ent:Spawn()
ent:Activate()

end
SpawnGProp()


function GM:PlayerSpawn(ply)

local characters = {
	"models/player/breen.mdl";
	"models/player/barney.mdl";
	"models/player/eli.mdl";
	"models/player/kleiner.mdl";
	"models/player/monk.mdl";
	"models/player/odessa.mdl";
	"models/player/magnusson.mdl";
	};
	ply:PrintMessage(HUD_PRINTTALK, "Player Spawn Ran")
ply:SetModel( table.Random(characters) )
ply:Give("skullwep")
ply:Give("flashlight")
ply:AllowFlashlight(false)

end

round = {}

-- Variables
round.Break	= 15	-- 30 second breaks
round.Time	= 300	-- 5 minute rounds

-- Read Variables
round.TimeLeft = -1
round.Breaking = false

function round.Broadcast(Text)
	for k, v in pairs(player.GetAll()) do
		v:ConCommand("play buttons/button17.wav")
		v:ChatPrint(Text)
	end
end

function round.Begin()
	-- Your code
	-- (Anything that may need to happen when the round begins)
	for k, v in pairs(player.GetAll()) do
		v:Spawn()
		v:Freeze(false)
	end
	round.Broadcast("Round starting! Round ends in " .. round.Time .. " seconds!")
	round.TimeLeft = round.Time
end

function round.End(winloose)
	-- Your code
	-- (Anything that may need to happen when the round ends)
	for k, v in pairs(player.GetAll()) do
		v:Kill()
		v:Freeze(true)
	end
	if(winloose == 1) then
	round.Broadcast("The victims have lost. Next round in".. round.Break .." seconds!")
	end
	if(winloose == 2)then
	round.Broadcast("The victims defeated the evil within. Brace for harder scares in: ".. round.Break .." seconds!")
	round.Breaking = true
	SpawnGProp()
	end
	round.TimeLeft = round.Break
end

function round.Handle()
PrintMessage(HUD_PRINTTALK, "Round handle Ran")
	if (round.TimeLeft == -1) then -- Start the first round
		round.Begin()
		return
	end
	
	round.TimeLeft = round.TimeLeft - 1
	
	if (round.TimeLeft == 0) then
		if (round.Breaking) then
			round.Begin()
			round.Breaking = false
		else
			round.End(1)//1 is a loss
			round.Breaking = true
		end
	end
end
timer.Create("round.Handle", 1, 0, round.Handle)

util.AddNetworkString( "VictimsWin" )
  
net.Receive("VictimsWin", function( length, client )
round.Broadcast(client:Nick().." has found the golden prop!")
       round.End(2)
   end)
   

	local scaredvoicesMale = {
		"vo/npc/male01/help01.wav";
		"vo/npc/male01/moan01.wav"; 
		"vo/npc/male01/no01.wav";
		"vo/npc/male01/no02.wav";
		"vo/npc/male01/ohno.wav";
		"vo/npc/male01/uhoh.wav";
		"vo/npc/male01/wetrustedyou01.wav";
		"vo/npc/male01/wetrustedyou02.wav";
	};




	function dropWeapon( victim )
		victim:StripWeapons( );
		victim:EmitSound( table.Random( scaredvoicesMale ), 100, 100 ); -- Audio volume needed
		victim:AllowFlashlight( false )
victim:Flashlight(false)
	end
	
	function scarysounds( victim )
		local scarynoises = {
	"waterdrops.mp3";
	"cellardoorslam.mp3";
	"strange.mp3";
	"shot.mp3";
	"buzzsaw.mp3";
	"chainsaw.mp3";
	};
		victim:EmitSound(table.Random( scarynoises ), 100, 100)
	end
	
	function screenscare(victim)
	umsg.Start("ScreenScare", victim)
	umsg.End()
	end
	
	function gmanScare(victim)
	local tr = victim:GetEyeTrace() -- tr now contains a trace object
local ent = ents.Create("npc_gman") -- This creates our zombie entity
ent:SetPos(tr.HitPos) -- This positions the zombie at the place our trace hit.
local ang = victim:EyeAngles()
ang:RotateAroundAxis( ang:Forward(), 180 )
	ang:RotateAroundAxis( ang:Right(), 180 )
	
	ent:SetAngles(Angle(0, ang.y, 0))
ent:Spawn() 
timer.Simple(.4, function() ent:Remove() end)
	end
	
		function gmanKill(victim)
	local tr = victim:GetEyeTrace() -- tr now contains a trace object
local ent = ents.Create("npc_gman") -- This creates our zombie entity
ent:SetPos(tr.HitPos) -- This positions the zombie at the place our trace hit.
local ang = victim:EyeAngles()
ang:RotateAroundAxis( ang:Forward(), 180 )
	ang:RotateAroundAxis( ang:Right(), 180 )
	
	ent:SetAngles(Angle(0, ang.y, 0))
ent:Spawn()
victim:EmitSound("buzzin2.mp3", 100, 100)
victim:EmitSound("horrorbuzz.mp3", 100, 100)  
timer.Simple(2, function() victim:Kill() end)
timer.Simple(3, function() ent:Remove() end)
	end
	
	function horrorNPCSpawn(victim)

local ent = ents.Create("npc_horror") -- This creates our zombie entity
ent:SetPos(victim:GetPos() + victim:GetForward() * 50)
local ang = victim:EyeAngles()
ang:RotateAroundAxis( ang:Forward(), 180 )
	ang:RotateAroundAxis( ang:Right(), 180 )
	
ent:SetAngles(Angle(0, ang.y, 0))
ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
ent:Spawn()
ent:Activate()
victim:EmitSound("buzzin2.mp3", 300, 30)
victim:EmitSound("horrorbuzz.mp3", 300, 30) 
local LifeTime = {
15;
25;
50;
};
timer.Simple( table.Random(LifeTime) , function() ent:Remove() end)
end

	function AngelBreak( victim )
victim:PrintMessage(HUD_PRINTCENTER, "The Angel protected you from a scare!")
end



function 	nilSoundScare(victim)
	local nilsounds = {
"nil_alone.wav";
"nil_deceive.wav";
"nil_done.wav";
"nil_freeman.wav";
"nil_last.wav";
"nil_laugh1.wav";
"nil_laugh2.wav";
"nil_man_notman.wav";
"nil_now_die.wav";
"nil_slaves.wav";
"nil_thelast.wav";
"nil_thetruth.wav";
"nil_thieves.wav";
"nil_win.wav";
};

victim:EmitSound(table.Random( nilsounds ), 100, 100)
end

function slenderSpawn(victim)
local ent = ents.Create("npc_piratecatslenderman") -- This creates our zombie entity
ent:SetPos(victim:GetPos() + victim:GetForward() * 50)
local ang = victim:EyeAngles()
ang:RotateAroundAxis( ang:Forward(), 180 )
	ang:RotateAroundAxis( ang:Right(), 180 )
	
	ent:SetAngles(Angle(0, ang.y, 0))
ent:Spawn()
ent:Activate()
victim:EmitSound("buzzin2.mp3", 100, 30)
victim:EmitSound("horrorbuzz.mp3", 400, 30) 
local LifeTime = {
30;
60;
180;
};
timer.Simple( table.Random(LifeTime) , function() ent:Remove() end)
end

function suitorSpawn(victim)
local ent = ents.Create("monster_amn_suitor") -- This creates our zombie entity
ent:SetPos(victim:GetPos() + victim:GetForward() * 50)
local ang = victim:EyeAngles()
ang:RotateAroundAxis( ang:Forward(), 180 )
	ang:RotateAroundAxis( ang:Right(), 180 )
	
	ent:SetAngles(Angle(0, ang.y, 0))
ent:Spawn()
ent:Activate()
victim:EmitSound("buzzin2.mp3", 500, 30)
victim:EmitSound("horrorbuzz.mp3", 500, 30) 
local LifeTime = {
30;
60;
180;
};
timer.Simple( table.Random(LifeTime) , function() ent:Remove() end)
end

function gruntSpawn(victim)
local ent = ents.Create("monster_amn_grunt") -- This creates our zombie entity
ent:SetPos(victim:GetPos() + victim:GetForward() * 50)
local ang = victim:EyeAngles()
ang:RotateAroundAxis( ang:Forward(), 180 )
	ang:RotateAroundAxis( ang:Right(), 180 )
	
	ent:SetAngles(Angle(0, ang.y, 0))
ent:Spawn()
ent:Activate()
victim:EmitSound("buzzin2.mp3", 500, 30)
victim:EmitSound("horrorbuzz.mp3", 500, 30) 
local LifeTime = {
30;
60;
180;
};
timer.Simple( table.Random(LifeTime) , function() ent:Remove() end)
end

function bruteSpawn(victim)
local ent = ents.Create("monster_amn_brute") -- This creates our zombie entity
ent:SetPos(victim:GetPos() + victim:GetForward() * 50)
local ang = victim:EyeAngles()
ang:RotateAroundAxis( ang:Forward(), 180 )
	ang:RotateAroundAxis( ang:Right(), 180 )
	
	ent:SetAngles(Angle(0, ang.y, 0))
ent:Spawn()
ent:Activate()
victim:EmitSound("buzzin2.mp3", 500, 30)
victim:EmitSound("horrorbuzz.mp3", 500, 30) 
local LifeTime = {
30;
60;
180;
};
timer.Simple( table.Random(LifeTime) , function() ent:Remove() end)
end



	//RANDOM SCARE FUNC
	//=============
	function ScareRandom( )

		local victim = table.Random( player.GetAll( ) );
		//PrintMessage( HUD_PRINTTALK, "Victim chosen: " .. ( IsValid( victim ) && victim:Nick( ) || "NO_NAME" ) ); -- Ternary operation to ensure no errors

		local scarechoice = math.random( 1, 13 ); -- No need to do table.Random when math.random uses whole numbers...
		
		//PrintMessage( HUD_PRINTTALK,"Scare chosen: " .. scarechoice );

		if ( scarechoice == 1 ) then
			dropWeapon( victim );

		elseif (scarechoice == 2 ) then
			scarysounds( victim );
		
		elseif(scarechoice == 3 )then
			screenscare( victim )
		
		elseif(scarechoice == 4 )then
			gmanScare( victim )
		
		elseif(scarechoice == 5)then
			gmanKill( victim )
	
		elseif(scarechoice == 6)then
			horrorNPCSpawn( victim )
		
		elseif(scarechoice == 7)then
			AngelBreak( victim )
		
		elseif(scarechoice == 8)then
			AngelBreak( victim )
	
		elseif(scarechoice == 9)then
			nilSoundScare(victim)
		
		elseif(scarechoice == 10)then
			slenderSpawn(victim)
	
		elseif(scarechoice == 11)then
			suitorSpawn(victim)
		
		elseif(scarechoice == 12)then
			gruntSpawn(victim)
		
		elseif(scarechoice == 13)then
			bruteSpawn(victim)
		end

		
	end
	
	
	function Blink()
	umsg.Start("Blink")
	umsg.End()
	end

timer.Create( "Blink", 9, 0, Blink );
timer.Create( "ScareRandomly", 15, 0, ScareRandom );
