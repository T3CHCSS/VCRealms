local RoRooms = require(script.Parent.Parent.Parent.Parent.Parent)
local OnyxUI = require(RoRooms.Packages.OnyxUI)
local Fusion = require(RoRooms.Packages.Fusion)
local States = require(RoRooms.Client.UI.States)

local Children = Fusion.Children

local EmoteButton = require(RoRooms.Client.UI.Components.EmoteButton)

return function(Scope: Fusion.Scope<any>, Props)
	local CategoryName = Scope:EnsureValue(Props.CategoryName, "General")
	local Name = Scope:EnsureValue(Props.Name, `{Use(Props.CategoryName)}EmotesCategory`)
	local Size = Scope:EnsureValue(Props.Size, UDim2.fromScale(1, 0))
	local AutomaticSize = Scope:EnsureValue(Props.AutomaticSize, Enum.AutomaticSize.Y)
	local LayoutOrder = Scope:EnsureValue(Props.LayoutOrder, 0)

	local Category = Scope:Computed(function(Use)
		return RoRooms.Config.Systems.Emotes.Categories[Use(Props.CategoryName)]
	end)

	return Frame {
		Name = Props.Name,
		Size = Props.Size,
		AutomaticSize = Props.AutomaticSize,
		LayoutOrder = Props.LayoutOrder,
		ListEnabled = true,

		[Children] = {
			Frame {
				Name = "Title",
				ListEnabled = true,
				ListFillDirection = Enum.FillDirection.Horizontal,
				ListPadding = Scope:Computed(function(Use)
					return UDim.new(0, Use(Theme.Spacing["0.25"]))
				end),

				[Children] = {
					Icon {
						Image = Scope:Computed(function(Use)
							if Use(Category) and Use(Category).Icon then
								return Use(Category).Icon
							else
								return "rbxassetid://17266112920"
							end
						end),
						Size = Scope:Computed(function(Use)
							return UDim2.fromOffset(Use(Theme.TextSize["1"]), Use(Theme.TextSize["1"]))
						end),
					},
					Text {
						Text = Props.CategoryName,
					},
				},
			},
			Frame {
				Name = "Emotes",
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				ListEnabled = true,
				ListPadding = Scope:Computed(function(Use)
					return UDim.new(0, Use(Theme.Spacing["0.75"]))
				end),
				ListFillDirection = Enum.FillDirection.Horizontal,
				ListWraps = true,

				[Children] = {
					Scope:ForPairs(RoRooms.Config.Systems.Emotes.Emotes, function(EmoteId, Emote)
						local EmoteCategory = Emote.Category
						if EmoteCategory == nil then
							EmoteCategory = "General"
						end

						if EmoteCategory == Use(Props.CategoryName) then
							return EmoteId,
								EmoteButton {
									EmoteId = EmoteId,
									Emote = Emote,
									Color = Emote.TintColor,

									Callback = function()
										if Use(States.ScreenSize).Y <= 500 then
											States.CurrentMenu:set()
										end
									end,
								}
						else
							return EmoteId, nil
						end
					end),
				},
			},
		},
	}
end
