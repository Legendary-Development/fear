include( "shared.lua" )



////////////////////////////////////
////////////////////////////////////
//HUD DRAWING
////////////////////////////////////
////////////////////////////////////

usermessage.Hook("ScreenScare", function()

local Derx = vgui.Create( "DFrame" ) -- Creates the frame itself
Derx:SetPos( 0,0 ) -- Position on the players screen

Derx:SetSize(ScrW(), ScrH() ) -- Size of the frame
Derx:SetTitle( "" ) -- Title of the frame
Derx:SetVisible( true )
Derx:SetDraggable( false ) -- Draggable by mouse?
Derx:ShowCloseButton( false )
  Derx.Paint = function()
	surface.SetDrawColor( 0, 205, 55, 10 )
	surface.DrawRect( 0, 0, Derx:GetWide(), Derx:GetTall() )
	surface.SetDrawColor( 0, 205, 55, 10 )
	surface.DrawOutlinedRect( 0, 0, Derx:GetWide(), Derx:GetTall() )
end	-- Show the close button?
Derx:MakePopup() -- Show the frame

DermaImage = vgui.Create( "DImage", Derx )
DermaImage:SetPos( 0,0 )                         // Set position
DermaImage:SetSize(1300,900)                          // OPTIONAL: Use instead of SizeToContents() if ( you know/want to fix the size
DermaImage:SetImage( "gman.png" )         // Set the material - relative to /materials/ directory
 
surface.PlaySound("jumpscare.mp3")
timer.Simple(.2, function() Derx:Close() end)
end)

usermessage.Hook("Blink", function()

local xx = vgui.Create( "DFrame" ) -- Creates the frame itself
xx:SetPos( 0,0 ) -- Position on the players screen

xx:SetSize(ScrW(), ScrH() ) -- Size of the frame
xx:SetTitle( "" ) -- Title of the frame
xx:SetVisible( true )
xx:SetDraggable( false ) -- Draggable by mouse?
xx:ShowCloseButton( false )
xx.Paint = function()
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, xx:GetWide(), xx:GetTall() )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( 0, 0, xx:GetWide(), xx:GetTall() )
end	-- Show the close button?


timer.Simple(.1, function() xx:Close() end)
end)

function GM:RenderScreenspaceEffects()
 -- Change to HUDPaint or Think if this does not exist.
	if (LocalPlayer():GetVelocity():Length() > 180) then
		DrawMotionBlur( 0.01, 0.1, 0.01)
	end
	if (LocalPlayer():GetVelocity():Length() > 250) then
		DrawMotionBlur( 0.12, 0.7, 0.01)
	end
end
usermessage.Hook("VicWin", function(um)

net.Start( "VictimsWin" )
net.SendToServer()

end)
