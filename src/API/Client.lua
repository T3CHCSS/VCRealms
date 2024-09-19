local SOURCE = script.Parent.SourceCode
local PACKAGES = script.Parent.Parent
local SHARED = SOURCE.Shared
local CLIENT = SOURCE.Client
local DEFAULT_CONTROLLERS =
	{ "UIController", "BloxstrapController", "ComponentsController", "DefaultsController", "UpdatesController" }

local Config = require(script.Parent.Config)
local Knit = require(PACKAGES.Knit)
local Loader = require(PACKAGES.Loader)
local FindFeatureFromModule = require(SHARED.FindFeatureFromModule)

local RoRoomsClient = {
	Started = false,
	Config = Config,
}

function RoRoomsClient:Start()
	assert(not self.Started, "RoRooms already started.")
	self.Started = true

	Loader.LoadDescendants(CLIENT, function(Descendant)
		if Descendant:IsA("ModuleScript") and Descendant.Name:match("Controller$") ~= nil then
			local Feature = FindFeatureFromModule(Descendant)

			if
				table.find(DEFAULT_CONTROLLERS, Descendant.Name)
				or (Feature and Config.Config.Systems[Feature].Enabled == true)
			then
				return Knit.CreateController(require(Descendant))
			else
				return false
			end
		else
			return false
		end
	end)

	Knit.Start()
end

return RoRoomsClient
