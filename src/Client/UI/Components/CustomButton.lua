local RoRooms = require(script.Parent.Parent.Parent.Parent.Parent)
local OnyxUI = require(RoRooms.Packages.OnyxUI)
local Fusion = require(RoRooms.Packages.Fusion)

local Button = require(script.Parent.Button)

export type Props = Button.Props & {}

return function(Scope: Fusion.Scope<any>, Props: Props)
	local Color = Scope:EnsureValue(Props.Color, Theme.Util.Colors.Neutral.Main)
	local IsHovering = Scope:EnsureValue(Props.IsHovering, false)

	return Button(Util.CombineProps(Props, {
		Color = Color,
		CornerRadius = Scope:Computed(function(Use)
			return UDim.new(0, Use(Theme.CornerRadius["2"]))
		end),
		PaddingTop = Scope:Computed(function(Use)
			return UDim.new(0, Use(Theme.Spacing["0.5"]))
		end),
		PaddingBottom = Scope:Computed(function(Use)
			return UDim.new(0, Use(Theme.Spacing["0.5"]))
		end),
		PaddingLeft = Scope:Computed(function(Use)
			return UDim.new(0, Use(Theme.Spacing["0.5"]))
		end),
		PaddingRight = Scope:Computed(function(Use)
			return UDim.new(0, Use(Theme.Spacing["0.5"]))
		end),

		IsHovering = IsHovering,
	}))
end
