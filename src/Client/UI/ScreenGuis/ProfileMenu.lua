local RoRooms = require(script.Parent.Parent.Parent.Parent.Parent)
local Frame = require(script.Parent.Parent.Parent.Parent.Shared.ExtPackages.OnyxUI.Packages.OnyxUI.Components.Frame)

local Shared = RoRooms.Shared
local Client = RoRooms.Client
local Config = RoRooms.Config

local Fusion = require(Shared.ExtPackages.OnyxUI.Packages.Fusion)
local OnyxUI = require(Shared.ExtPackages.OnyxUI)
local States = require(Client.UI.States)
local SharedData = require(Shared.SharedData)
local Modifier = require(OnyxUI.Utils.Modifier)
local Themer = require(OnyxUI.Utils.Themer)

local Children = Fusion.Children
local New = Fusion.New
local Computed = Fusion.Computed
local Spring = Fusion.Spring
local Value = Fusion.Value

local AutoScaleFrame = require(OnyxUI.Components.AutoScaleFrame)
local MenuFrame = require(OnyxUI.Components.MenuFrame)
local TitleBar = require(OnyxUI.Components.TitleBar)
local TextInput = require(OnyxUI.Components.TextInput)
local Button = require(OnyxUI.Components.Button)

return function(Props)
	local MenuOpen = Computed(function()
		return States.CurrentMenu:get() == script.Name
	end)

	local NicknameText = Value("")
	local StatusText = Value("")

	if States.PlayerDataService then
		States.PlayerDataService.UserProfile:Observe(function(UserProfile: { [any]: any })
			NicknameText:set(UserProfile.Nickname)
			StatusText:set(UserProfile.Status)
		end)
	end

	local ProfileMenu = New "ScreenGui" {
		Name = "ProfileMenu",
		Parent = Props.Parent,
		Enabled = MenuOpen,
		ResetOnSpawn = false,

		[Children] = {
			AutoScaleFrame {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = Spring(
					Computed(function()
						local YPos = States.TopbarBottomPos:get()
						if not MenuOpen:get() then
							YPos = YPos + 15
						end
						return UDim2.new(UDim.new(0.5, 0), UDim.new(0, YPos))
					end),
					Themer.Theme.SpringSpeed["1"],
					Themer.Theme.SpringDampening
				),
				BaseResolution = Vector2.new(739, 789),

				[Children] = {
					MenuFrame {
						Size = UDim2.fromOffset(270, 0),
						GroupTransparency = Spring(
							Computed(function()
								if MenuOpen:get() then
									return 0
								else
									return 1
								end
							end),
							Themer.Theme.SpringSpeed["1"],
							Themer.Theme.SpringDampening
						),
						BackgroundTransparency = States.PreferredTransparency,

						[Children] = {
							Modifier.ListLayout {
								Padding = Computed(function()
									return UDim.new(0, Themer.Theme.Spacing["1"]:get())
								end),
							},

							TitleBar {
								Title = "Profile",
								CloseButtonDisabled = true,
							},
							Frame {
								Size = UDim2.fromScale(1, 0),

								[Children] = {
									Modifier.ListLayout {},

									TextInput {
										Name = "NicknameInput",
										PlaceholderText = "Nickname",
										CharacterLimit = SharedData.NicknameCharLimit,
										Size = UDim2.fromScale(1, 0),
										AutomaticSize = Enum.AutomaticSize.Y,
										Text = NicknameText,

										OnFocusLost = function()
											if States.UserProfileService then
												States.UserProfileService:SetNickname(NicknameText:get())
											end
										end,
									},
									TextInput {
										Name = "StatusInput",
										PlaceholderText = "Status",
										Text = StatusText,
										CharacterLimit = SharedData.StatusCharLimit,
										TextWrapped = true,
										Size = UDim2.new(UDim.new(1, 0), UDim.new(0, 60)),
										AutomaticSize = Enum.AutomaticSize.Y,

										OnFocusLost = function()
											if States.UserProfileService then
												States.UserProfileService:SetStatus(StatusText:get())
											end
										end,
									},
								},
							},
							Button {
								Name = "EditAvatarButton",
								Contents = { "rbxassetid://13285615740", "Edit Avatar" },
								Size = UDim2.fromScale(1, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								Visible = Computed(function()
									return Config.ProfilesSystem.AvatarEditorCallback ~= nil
								end),

								OnActivated = function()
									States.CurrentMenu:set()
									Config.ProfilesSystem.AvatarEditorCallback()
								end,
							},
						},
					},
				},
			},
		},
	}

	return ProfileMenu
end
