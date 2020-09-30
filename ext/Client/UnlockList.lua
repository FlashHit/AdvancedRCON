class 'UnlockList'

function UnlockList:__init()
	print("Initializing UnlockList")
	self:RegisterVars()
	self:RegisterEvents()
end
function UnlockList:RegisterVars()
	self.unlockList = {}
	self.mode = "all"
end
function UnlockList:RegisterEvents()
	NetEvents:Subscribe("Server:UnlockMode", function(args)
		self.mode = args[1]
	end)
	NetEvents:Subscribe("Server:UnlockListAdd", function(args)
		table.insert(self.unlockList, args[1])
	end)
	NetEvents:Subscribe("Server:UnlockListRemove", function(args)
		table.remove(self.unlockList, args[1])
	end)
	NetEvents:Subscribe("Server:UnlockListClear", function(args)
		self.unlockList = {}
	end)
	NetEvents:Subscribe("Server:UnlockListSet", function(args)
		self.unlockList = args
	end)
	NetEvents:Subscribe("Server:GetUnlockMode", function(args)
		self.mode = args[1]
	end)
	NetEvents:Subscribe("Server:GetUnlockList", function(args)
		self.unlockList = args
	end)
	Events:Subscribe('Partition:Loaded', function(partition)
		for _,instance in pairs(partition.instances) do
			if instance:Is("VeniceSoldierCustomizationAsset") and self.mode ~= "all" then
				instance = VeniceSoldierCustomizationAsset(instance)
				local weaponTable = CustomizationTable(instance.weaponTable)
				for i,unlockPart in pairs(weaponTable.unlockParts) do
					local unlockPart = CustomizationUnlockParts(unlockPart)
					unlockPart:MakeWritable()
					for index = #unlockPart.selectableUnlocks, 1, -1 do
						if unlockPart.selectableUnlocks[index] == nil then
							unlockPart.selectableUnlocks:erase(index)
						elseif has_value(self.unlockList, UnlockAssetBase(unlockPart.selectableUnlocks[index]).debugUnlockId) then
							if self.mode == "whitelist" then
								if i == 1 then
									local customizationTable = CustomizationTable(VeniceSoldierWeaponCustomizationAsset(SoldierWeaponData(SoldierWeaponBlueprint(SoldierWeaponUnlockAsset(unlockPart.selectableUnlocks[index]).weapon).object).customization).customization)
									for a,unlock in pairs(customizationTable.unlockParts) do
										local customizationUnlockParts = CustomizationUnlockParts(unlock)
										customizationUnlockParts:MakeWritable()
										for b = #customizationUnlockParts.selectableUnlocks, 1, -1 do
											if customizationUnlockParts.selectableUnlocks[b] == nil then
												customizationUnlockParts.selectableUnlocks:erase(b)
											elseif has_value(self.unlockList, UnlockAssetBase(customizationUnlockParts.selectableUnlocks[b]).debugUnlockId) then
											else
												customizationUnlockParts.selectableUnlocks:erase(b)
											end
										end
									end
								end
							elseif self.mode == "blacklist" then
								unlockPart.selectableUnlocks:erase(index)
							end
						else
							if self.mode == "whitelist" then
								unlockPart.selectableUnlocks:erase(index)
							elseif self.mode == "blacklist" then
								if i == 1 then
									local customizationTable = CustomizationTable(VeniceSoldierWeaponCustomizationAsset(SoldierWeaponData(SoldierWeaponBlueprint(SoldierWeaponUnlockAsset(unlockPart.selectableUnlocks[index]).weapon).object).customization).customization)
									for a,unlock in pairs(customizationTable.unlockParts) do
										local customizationUnlockParts = CustomizationUnlockParts(unlock)
										customizationUnlockParts:MakeWritable()
										for b = #customizationUnlockParts.selectableUnlocks, 1, -1 do
											if customizationUnlockParts.selectableUnlocks[b] == nil then
												customizationUnlockParts.selectableUnlocks:erase(b)
											elseif has_value(self.unlockList, UnlockAssetBase(customizationUnlockParts.selectableUnlocks[b]).debugUnlockId) then
												customizationUnlockParts.selectableUnlocks:erase(b)
											end
										end
									end
								end
							end
						end
					end
				end
				local specializationTable = CustomizationTable(instance.specializationTable)
				for i,unlockPart in pairs(specializationTable.unlockParts) do
					unlockPart:MakeWritable()
					for index = #unlockPart.selectableUnlocks, 1, -1 do
						if unlockPart.selectableUnlocks[index] == nil then
							unlockPart.selectableUnlocks:erase(index)
						elseif has_value(self.unlockList, UnlockAssetBase(unlockPart.selectableUnlocks[index]).debugUnlockId) then
							if self.mode == "blacklist" then
								unlockPart.selectableUnlocks:erase(index)
							end
						else
							if self.mode == "whitelist" then
								unlockPart.selectableUnlocks:erase(index)
							end
						end
					end
				end
			end
			if instance:Is("VeniceVehicleCustomizationAsset") and self.mode ~= "all" then
				instance = VeniceVehicleCustomizationAsset(instance)
				local customizationTable = CustomizationTable(instance.customization)
				for i,unlockPart in pairs(customizationTable.unlockParts) do
					unlockPart:MakeWritable()
					for index = #unlockPart.selectableUnlocks, 1, -1 do
						if unlockPart.selectableUnlocks[index] == nil then
							unlockPart.selectableUnlocks:erase(index)
						elseif has_value(self.unlockList, UnlockAssetBase(unlockPart.selectableUnlocks[index]).debugUnlockId) then
							if self.mode == "blacklist" then
								unlockPart.selectableUnlocks:erase(index)
							end
						else
							if self.mode == "whitelist" then
								unlockPart.selectableUnlocks:erase(index)
							end
						end
					end
				end
			end
		end
	end)
end
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

g_UnlockList = UnlockList()