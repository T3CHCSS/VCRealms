local RoRooms = require(script.Parent.Parent.Parent.Parent.Parent)
local OnyxUI = require(RoRooms.Packages.OnyxUI)
local Fusion = require(RoRooms.Packages.Fusion)
local States = require(RoRooms.Client.UI.States)

local Children = Fusion.Children

local EmotesCategory = require(RoRooms.Client.UI.Components.EmotesCategory)
local EmoteCategoriesSidebar = require(RoRooms.Client.UI.Components.EmoteCategoriesSidebar)

return function(Scope: Fusion.Scope<any>, Props)
	local MenuOpen = Scope:Computed(function(Use)
		return Use(States.CurrentMenu) == script.Name
	end)

	local EmotesMenu = Scope:New "ScreenGui" {
		Name = "EmotesMenu",
		Parent = Props.Parent,
		Enabled = MenuOpen,
		ResetOnSpawn = false,

		[Children] = {
			Scope:AutoScaleFrame {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = Scope:Spring(
					Scope:Computed(function(Use)
						local YPos = Use(States.TopbarBottomPos)
						if not Use(MenuOpen) then
							YPos = YPos + 15
						end
						return UDim2.new(UDim.new(0.5, 0), UDim.new(0, YPos))
					end),
					Theme.SpringSpeed["1"],
					Theme.SpringDampening["1"]
				),
				BaseResolution = Vector2.new(739, 789),
				MinScale = 1,
				MaxScale = 1,

				[Children] = {
					Scope:MenuFrame {
						Size = UDim2.fromOffset(0, 0),
						GroupTransparency = Scope:Spring(
							Scope:Computed(function(Use)
								if Use(MenuOpen) then
									return 0
								else
									return 1
								end
							end),
							Theme.SpringSpeed["1"],
							Theme.SpringDampening["1"]
						),
						BackgroundTransparency = States.PreferredTransparency,
						AutomaticSize = Enum.AutomaticSize.XY,
						ListEnabled = true,

						[Children] = {
							Scope:TitleBar {
								Title = "Emotes",
								CloseButtonDisabled = true,
							},
							Scope:Frame {
								Size = UDim2.new(UDim.new(0, 0), UDim.new(0, 185)),
								AutomaticSize = Enum.AutomaticSize.X,
								ListEnabled = true,
								ListFillDirection = Enum.FillDirection.Horizontal,
								ListPadding = Scope:Computed(function(Use)
									return UDim.new(0, Use(Theme.Spacing["0.75"]))
								end),

								[Children] = {
									Scope:EmoteCategoriesSidebar {
										Size = UDim2.fromScale(0, 1),
									},
									Scope:Scroller {
										Name = "EmotesList",
										Size = Scope:Computed(function(Use)
											return UDim2.new(UDim.new(0, 260), UDim.new(1, 0))
										end),
										ScrollBarThickness = Theme.StrokeThickness["1"],
										ScrollBarImageColor3 = Theme.Colors.NeutralContent.Dark,
										Padding = Scope:Computed(function(Use)
											return UDim.new(0, Use(Theme.StrokeThickness["1"]))
										end),
										ListEnabled = true,
										ListPadding = Scope:Computed(function(Use)
											return UDim.new(0, Use(Theme.Spacing["1"]))
										end),
										ListFillDirection = Enum.FillDirection.Horizontal,
										ListWraps = true,

										[Children] = {
											Scope:ForPairs(
												RoRooms.Config.Systems.Emotes.Categories,
												function(Name: string, Category)
													return Name,
														Scope:EmotesCategory {
															CategoryName = Name,
															LayoutOrder = Category.LayoutOrder,
														}
												end
											),
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}

	local DisconnectFocusedCategory = Scope:Observer(States.EmotesMenu.FocusedCategory):onChange(function()
		local EmotesList = EmotesMenu.AutoScaleFrame.MenuFrame.Contents.Frame.EmotesList
		local Category = EmotesList:FindFirstChild(`{Use(States.EmotesMenu.FocusedCategory)}EmotesCategory`)
		if Category then
			EmotesList.CanvasPosition = Vector2.new(0, 0)
			EmotesList.CanvasPosition = Vector2.new(0, Category.AbsolutePosition.Y - EmotesList.AbsolutePosition.Y)
		end
	end)

	EmotesMenu:GetPropertyChangedSignal("Parent"):Connect(function()
		if EmotesMenu.Parent == nil then
			DisconnectFocusedCategory()
		end
	end)

	return EmotesMenu
end
