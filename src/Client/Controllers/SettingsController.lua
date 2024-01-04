local RoRooms = require(game:GetService("ReplicatedStorage").RoRooms)

local Shared = RoRooms.Shared
local Client = RoRooms.Client
local Packages = RoRooms.Packages

local Knit = require(Packages.Knit)

local SettingsMenu = require(Client.UI.ScreenGuis.SettingsMenu)

local UIController = require(Client.Controllers.UIController)

local SettingsController = {
  Name = "SettingsController"
}

function SettingsController:KnitStart()
  UIController = Knit.GetController("UIController")

  UIController:MountUI(SettingsMenu {})
end

function SettingsController:KnitInit()
  
end

return SettingsController