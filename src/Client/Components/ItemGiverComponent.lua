local Players = game:GetService("Players")

local RoRooms = require(script.Parent.Parent.Parent.Parent)
local Component = require(RoRooms.Packages.Component)
local OnyxUI = require(RoRooms.Packages.OnyxUI)
local Fusion = require(RoRooms.Packages.Fusion)
local States = require(RoRooms.Client.UI.States)
local ItemsController = require(RoRooms.Client.Items.ItemsController)
local AttributeValue = require(RoRooms.Shared.ExtPackages.AttributeValue)

local New = Fusion.New
local Computed = Fusion.Computed
local Hydrate = Fusion.Hydrate

local ItemGiverComponent = Component.new {
	Tag = "RR_ItemGiver",
}

function ItemGiverComponent:GiveItem(Player: Player)
	if Player == Players.LocalPlayer then
		ItemsController:ToggleEquipItem(Use(self.ItemId))
	end
end

function ItemGiverComponent:GetProximityPrompt()
	local ProximityPrompt = self.Instance:FindFirstChild("RR_ItemGiverPrompt")
	if not ProximityPrompt then
		ProximityPrompt = New "ProximityPrompt" {
			Name = "RR_ItemGiverPrompt",
			Parent = self.Instance,
			ActionText = "",
			RequiresLineOfSight = false,
			MaxActivationDistance = 7.5,
		}
	end

	Hydrate(ProximityPrompt) {
		Enabled = Computed(function()
			return Use(self.Item) ~= nil
		end),
		ActionText = Computed(function()
			if Use(self.Item) then
				if Use(self.Equipped) then
					return "Unequip"
				else
					return "Equip"
				end
			else
				return Use(self.ItemId)
			end
		end),
		ObjectText = Computed(function()
			if Use(self.Item) then
				return Use(self.Item).Name
			else
				return "Invalid item"
			end
		end),
	}

	return ProximityPrompt
end

function ItemGiverComponent:Start()
	self.ProximityPrompt = self:GetProximityPrompt()

	self.ProximityPrompt.Triggered:Connect(function(Player: Player)
		self:GiveItem(Player)
	end)
end

function ItemGiverComponent:Construct()
	self.ItemId = AttributeValue(self.Instance, "RR_ItemId")
	self.Item = Computed(function()
		return RoRooms.Config.Systems.Items.Items[Use(self.ItemId)]
	end)
	self.Equipped = Computed(function()
		return table.find(Use(States.EquippedItems), Use(self.ItemId)) ~= nil
	end)

	if not Use(self.ItemId) then
		warn("No RR_ItemId attribute defined for ItemGiver", self.Instance)
	end
	if not Use(self.Item) then
		warn("Could not find item from RR_ItemId", Use(self.ItemId), self.Instance)
	end
end

function ItemGiverComponent:Stop()
	self.DisconnectLevelMetObserver()
end

return ItemGiverComponent
