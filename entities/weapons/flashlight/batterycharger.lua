-------------------------------------------------------------------------------
-- battery_charger.lua
-- Author: mrflippy
-- Date: 6.18.2007
-- A small object to handle periodic energy/ammo regeneration or drain. Set
--   the variables and call GetChargeAmount() to return the amount that has
--   charged in the time period.
-------------------------------------------------------------------------------

BatteryCharger = {}
BatteryCharger.__index = BatteryCharger

--How much energy to recharge per cycle
BatteryCharger.EnergyPerCycle = 1

--How long a cycle is in seconds
BatteryCharger.CycleSeconds = 1

--accumulates fractional values
BatteryCharger.Accumulator = 0

--holds the next cycle time
BatteryCharger.NextTime = 0

function BatteryCharger:new()
	local charger = {}
	setmetatable(charger, BatteryCharger)

	return charger
end

--returns the amount to charge
--intended to be called in a think function
function BatteryCharger:GetChargeAmount()
	local rechargeAmount = 0

	if(CurTime() >= self.NextTime) then
		--set the next recharge time
		self.NextTime = CurTime() + self.CycleSeconds

		--handle recharging now

		if(self.Accumulator >= 1) then
			rechargeAmount = self.Accumulator
			self.Accumulator = 0
		else
			self.Accumulator = self.Accumulator + self.EnergyPerCycle
		end

	end
	
	return rechargeAmount
end
