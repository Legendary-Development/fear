include( 'shared.lua' )

function FlashlightBind( ply, bind, pressed )
    if not pressed then return false end
	
	if (bind == "impulse 100") then return true end
	end
	hook.Add( "PlayerBindPress", "SWEP FlashlightBind", FlashlightBind )
