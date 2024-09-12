local RoRooms = require(script.Parent.Parent.Parent.Parent.Parent)

local OnyxUI = require(RoRooms.Packages.OnyxUI)
local Fusion = require(RoRooms.Packages.Fusion)
local States = require(RoRooms.Client.UI.States)

local Children = Fusion.Children

local BaseButton = require(OnyxUI.Components.BaseButton)
local Icon = require(OnyxUI.Components.Icon)
local Base = require(OnyxUI.Components.Base)

return function(Props)
	Props.SizeMultiplier = Scope:EnsureValue(Props.SizeMultiplier, "number", 1)
	Props.IconImage = Scope:EnsureValue(Props.IconImage, "string", "")
	Props.MenuName = Scope:EnsureValue(Props.MenuName, "string", "")
	Props.Icon = Scope:EnsureValue(Props.Icon, "string", "")
	Props.IconFilled = Scope:EnsureValue(Props.IconFilled, "string", "")
	local IndicatorEnabled = Scope:EnsureValue(Props.IndicatorEnabled, "boolean", false)
	local IndicatorColor = Scope:EnsureValue(Props.IndicatorColor, "Color3", Color3.fromRGB(255, 255, 255))

	local IsHovering = Scope:Value(false)
	local IsHolding = Scope:Value(false)
	local MenuOpen = Scope:Computed(function(Use)
		return Use(States.CurrentMenu) == Use(Props.MenuName)
	end)

	return BaseButton {
		Name = "TopbarButton",
		BackgroundColor3 = Theme.Colors.BaseContent.Main,
		BackgroundTransparency = Scope:Computed(function(Use)
			if Use(IsHovering) or Use(MenuOpen) then
				return 0.9
			else
				return 1
			end
		end),
		Size = Scope:Computed(function(Use)
			local BaseSize = UDim2.fromOffset(45, 45)
			local SizeMultiplier = Use(Props.SizeMultiplier)
			return UDim2.fromOffset(BaseSize.X.Offset * SizeMultiplier, BaseSize.Y.Offset * SizeMultiplier)
		end),
		AutomaticSize = Enum.AutomaticSize.None,
		LayoutOrder = Props.LayoutOrder,
		CornerRadius = Scope:Computed(function(Use)
			return UDim.new(0, Theme.CornerRadius["Full"]:get())
		end),

		IsHovering = IsHovering,
		IsHolding = IsHolding,
		OnActivated = function()
			if Use(States.CurrentMenu) == Use(Props.MenuName) then
				States.CurrentMenu:set()
			else
				States.CurrentMenu:set(Use(Props.MenuName))
				if Use(States.ScreenSize).Y < 900 then
					States.ItemsMenu.Open:set()
				end
			end
		end,

		[Children] = {
			Icon {
				Name = "Icon",
				Image = Scope:Computed(function(Use)
					if Use(MenuOpen) then
						return Use(Props.IconFilled)
					else
						return Use(Props.Icon)
					end
				end),
				Size = UDim2.fromOffset(30, 30),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
			},
			Base {
				Name = "Indicator",
				BackgroundTransparency = 0,
				BackgroundColor3 = IndicatorColor,
				Size = UDim2.fromOffset(12, 3),
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
				CornerRadius = Scope:Computed(function(Use)
					return UDim.new(0, Use(Theme.CornerRadius.Full))
				end),
				Visible = IndicatorEnabled,
			},
		},
	}
end
