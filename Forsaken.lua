local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local OwnTheme = {
    TextColor = Color3.fromRGB(220, 220, 220),

    Background = Color3.fromRGB(15, 15, 15),
    Topbar = Color3.fromRGB(20, 20, 20),
    Shadow = Color3.fromRGB(10, 10, 10),

    NotificationBackground = Color3.fromRGB(15, 15, 15),
    NotificationActionsBackground = Color3.fromRGB(200, 200, 200),

    TabBackground = Color3.fromRGB(50, 50, 50),
    TabStroke = Color3.fromRGB(60, 60, 60),
    TabBackgroundSelected = Color3.fromRGB(160, 160, 160),
    TabTextColor = Color3.fromRGB(220, 220, 220),
    SelectedTabTextColor = Color3.fromRGB(40, 40, 40),

    ElementBackground = Color3.fromRGB(25, 25, 25),
    ElementBackgroundHover = Color3.fromRGB(30, 30, 30),
    SecondaryElementBackground = Color3.fromRGB(20, 20, 20),
    ElementStroke = Color3.fromRGB(40, 40, 40),
    SecondaryElementStroke = Color3.fromRGB(30, 30, 30),
            
    SliderBackground = Color3.fromRGB(40, 120, 200),
    SliderProgress = Color3.fromRGB(40, 120, 200),
    SliderStroke = Color3.fromRGB(48, 145, 230),

    ToggleBackground = Color3.fromRGB(20, 20, 20),
    ToggleEnabled = Color3.fromRGB(0, 120, 180),
    ToggleDisabled = Color3.fromRGB(80, 80, 80),
    ToggleEnabledStroke = Color3.fromRGB(0, 145, 220),
    ToggleDisabledStroke = Color3.fromRGB(105, 105, 105),
    ToggleEnabledOuterStroke = Color3.fromRGB(80, 80, 80),
    ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 50),

    DropdownSelected = Color3.fromRGB(30, 30, 30),
    DropdownUnselected = Color3.fromRGB(20, 20, 20),

    InputBackground = Color3.fromRGB(20, 20, 20),
    InputStroke = Color3.fromRGB(50, 50, 50),
    PlaceholderColor = Color3.fromRGB(150, 150, 150)
}

local Window = Rayfield:CreateWindow({
   Name = "Leafsaken",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Forsaken",
   LoadingSubtitle = "made by leafsaken on discord",
   Theme = "Green",

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BazingaHubbey",
      FileName = "Zingazurnacurba"
   },

   Discord = {
      Enabled = false,
      Invite = "7ya5axvynf",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "Leaf Hub",
      Subtitle = "Forsaken",
      Note = "idk whatsthe key either",
      FileName = "KeySistemOfLeaf",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"piggy"}
   }
})

Rayfield:Notify({
   Title = "Leaf... Notification",
   Content = "Thanks for using Leaf Hub.",
   Duration = 15,
   Image = "laugh",
})

local Tab = Window:CreateTab("Visuals", "view")

Tab:CreateSection("Players")

Tab:CreateLabel("This section is fully ESP, nothing else.", "target")

Tab:CreateDivider()

local PlayerEspRunning = false
local SurvivorAddedConn = nil
local KillerAddedConn = nil
local Highlights = {}

Tab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        local SurvivorsColor = Color3.fromRGB(72, 175, 240)
        local KillersColor = Color3.fromRGB(245, 85, 71)
        local OutlineColor = Color3.fromRGB(255, 255, 255)

        local FillTransparency = 0.8
        local OutlineTransparency = 0.6

        local PlayersFolder = workspace:FindFirstChild("Players")
        if not PlayersFolder then return end

        local function removeAllHighlights()
            for character, data in pairs(Highlights) do
                if data.Conn then data.Conn:Disconnect() end
                if data.Highlight then data.Highlight:Destroy() end
            end
            Highlights = {}
        end

        local function removeOtherHighlights(character)
            for _, obj in pairs(character:GetChildren()) do
                if obj:IsA("Highlight") then
                    obj:Destroy()
                end
            end
        end

        local function createHighlightForCharacter(character, fillColor)
            if not character then return end
            removeOtherHighlights(character)

            local highlight = Instance.new("Highlight")
            highlight.Name = "CustomHighlight"
            highlight.Adornee = character
            highlight.FillColor = fillColor
            highlight.OutlineColor = OutlineColor
            highlight.FillTransparency = FillTransparency
            highlight.OutlineTransparency = OutlineTransparency
            highlight.Parent = character

            local conn = character.ChildAdded:Connect(function(child)
                if child:IsA("Highlight") and child.Name ~= "CustomHighlight" then
                    child:Destroy()
                end
            end)

            Highlights[character] = {
                Highlight = highlight,
                Conn = conn
            }
        end

        local function highlightAll()
            for _, survivor in pairs(PlayersFolder.Survivors:GetChildren()) do
                createHighlightForCharacter(survivor, SurvivorsColor)
            end
            for _, killer in pairs(PlayersFolder.Killers:GetChildren()) do
                createHighlightForCharacter(killer, KillersColor)
            end
        end

        if Value and not PlayerEspRunning then
            PlayerEspRunning = true
            highlightAll()
            SurvivorAddedConn = PlayersFolder.Survivors.ChildAdded:Connect(function(child)
                createHighlightForCharacter(child, SurvivorsColor)
            end)
            KillerAddedConn = PlayersFolder.Killers.ChildAdded:Connect(function(child)
                createHighlightForCharacter(child, KillersColor)
            end)
        elseif not Value and PlayerEspRunning then
            PlayerEspRunning = false
            if SurvivorAddedConn then SurvivorAddedConn:Disconnect() SurvivorAddedConn = nil end
            if KillerAddedConn then KillerAddedConn:Disconnect() KillerAddedConn = nil end
            removeAllHighlights()
        end
    end,
})

local ESPEnabled = false
local Map
local ChildAddedConnection
local MapAncestryConnection
local ProgressConnections = {}

local function getMap()
    return workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map")
end

local function addHighlightToGenerator(generator)
    if generator.Name == "Generator" and generator:IsA("Model") then
        local progress = generator:FindFirstChild("Progress")
        if not progress or not progress:IsA("NumberValue") then return end
        if progress.Value >= 100 then return end

        local highlight = generator:FindFirstChildOfClass("Highlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(128, 0, 128)
            highlight.FillTransparency = 0.8
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0.6
            highlight.Parent = generator
        else
            highlight.Enabled = true
        end
    end
end

local function removeHighlightFromGenerator(generator)
    local highlight = generator:FindFirstChildOfClass("Highlight")
    if highlight then
        highlight.Enabled = false
    end
end

local function monitorGeneratorProgress(generator)
    if ProgressConnections[generator] then
        ProgressConnections[generator]:Disconnect()
        ProgressConnections[generator] = nil
    end

    local progress = generator:FindFirstChild("Progress")
    if not progress or not progress:IsA("NumberValue") then return end

    ProgressConnections[generator] = progress.Changed:Connect(function(newValue)
        if not ESPEnabled then return end
        if newValue >= 100 then
            removeHighlightFromGenerator(generator)
        else
            addHighlightToGenerator(generator)
        end
    end)
end

local function startMonitoringGenerator(generator)
    if generator.Name == "Generator" and generator:IsA("Model") then
        monitorGeneratorProgress(generator)
        if ESPEnabled then
            addHighlightToGenerator(generator)
        end
    end
end

local function stopMonitoringAll()
    for gen, conn in pairs(ProgressConnections) do
        conn:Disconnect()
        ProgressConnections[gen] = nil
    end
end

local function removeAllHighlights()
    if not Map then return end
    for _, generator in ipairs(Map:GetChildren()) do
        if generator.Name == "Generator" and generator:IsA("Model") then
            removeHighlightFromGenerator(generator)
        end
    end
end

local function setupMapMonitoring()
    Map = getMap()
    if not Map then return end

    for _, generator in ipairs(Map:GetChildren()) do
        startMonitoringGenerator(generator)
    end

    if ChildAddedConnection then ChildAddedConnection:Disconnect() end
    ChildAddedConnection = Map.ChildAdded:Connect(function(child)
        startMonitoringGenerator(child)
    end)

    if MapAncestryConnection then MapAncestryConnection:Disconnect() end
    MapAncestryConnection = Map.AncestryChanged:Connect(function()
        if not Map:IsDescendantOf(game) then
            removeAllHighlights()
            stopMonitoringAll()
            if ChildAddedConnection then ChildAddedConnection:Disconnect() ChildAddedConnection = nil end
            if MapAncestryConnection then MapAncestryConnection:Disconnect() MapAncestryConnection = nil end
            task.defer(monitorForNewMap)
        end
    end)
end

function monitorForNewMap()
    while ESPEnabled do
        local newMap = getMap()
        if newMap and newMap ~= Map then
            setupMapMonitoring()
            break
        end
        task.wait(1)
    end
end

Tab:CreateToggle({
    Name = "Generator ESP",
    CurrentValue = false,
    Flag = "ToggleESP",
    Callback = function(Value)
        ESPEnabled = Value
        if ESPEnabled then
            setupMapMonitoring()
            monitorForNewMap()
        else
            removeAllHighlights()
            stopMonitoringAll()
            if ChildAddedConnection then ChildAddedConnection:Disconnect() ChildAddedConnection = nil end
            if MapAncestryConnection then MapAncestryConnection:Disconnect() MapAncestryConnection = nil end
        end
    end,
})

local ItemEspRunning = false
local HighlightedItems = {}

Tab:CreateToggle({
    Name = "Items ESP",
    CurrentValue = false,
    Flag = "HighlightItemRoots",
    Callback = function(Value)
        local MapFolder = workspace.Map.Ingame
        local FillColor = Color3.new(1, 1, 0)
        local OutlineColor = Color3.new(1, 1, 1)
        local FillTransparency = 0.8
        local OutlineTransparency = 0.6

        local function clearAll()
            for itemRoot, highlight in pairs(HighlightedItems) do
                if highlight then
                    highlight:Destroy()
                end
            end
            HighlightedItems = {}
        end

        if Value and not ItemEspRunning then
            ItemEspRunning = true
            task.spawn(function()
                while ItemEspRunning do
                    for itemRoot, highlight in pairs(HighlightedItems) do
                        if not itemRoot or not itemRoot.Parent then
                            if highlight then
                                highlight:Destroy()
                            end
                            HighlightedItems[itemRoot] = nil
                        end
                    end

                    for _, tool in pairs(MapFolder:GetChildren()) do
                        if tool:IsA("Tool") then
                            local itemRoot = tool:FindFirstChild("ItemRoot")
                            if itemRoot and itemRoot:IsA("MeshPart") and not HighlightedItems[itemRoot] then
                                for _, obj in pairs(itemRoot:GetChildren()) do
                                    if obj:IsA("Highlight") then
                                        obj:Destroy()
                                    end
                                end

                                local highlight = Instance.new("Highlight")
                                highlight.Adornee = itemRoot
                                highlight.FillColor = FillColor
                                highlight.OutlineColor = OutlineColor
                                highlight.FillTransparency = FillTransparency
                                highlight.OutlineTransparency = OutlineTransparency
                                highlight.Parent = itemRoot

                                HighlightedItems[itemRoot] = highlight
                            end
                        end
                    end
                    task.wait(1)
                end
                clearAll()
            end)
        elseif not Value and ItemEspRunning then
            ItemEspRunning = false
        end
    end,
})

local Tab5 = Window:CreateTab("Player", "layers")

Tab5:CreateSection("Stamina System")

local sprinting = game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting
local m = require(sprinting)

m.StaminaLoss = 10
m.SprintSpeed = 24

local disable_stamina = false
local sprint_speed_override = false
local original_sprint_speed = m.SprintSpeed
local current_sprint_speed = 24

Tab5:CreateToggle({ 
   Name = "Disable Stamina Loss", 
   CurrentValue = false,
   Flag = "DisableStamina",
   Callback = function(value)
      disable_stamina = value
   end,
})

Tab5:CreateDivider()

Tab5:CreateToggle({
   Name = "Modify Stamina Speed",
   CurrentValue = false,
   Flag = "ToggleSprintSpeed",
   Callback = function(value)
      sprint_speed_override = value
      if value then
         original_sprint_speed = m.SprintSpeed
      else
         m.SprintSpeed = original_sprint_speed
      end
   end,
})

task.spawn(function()
   while task.wait() do
      if sprint_speed_override then
         m.SprintSpeed = current_sprint_speed
      end
   end
end)

Tab5:CreateSlider({
   Name = "Sprint Speed",
   Range = {24, 32},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 24,
   Flag = "SprintSpeedSlider",
   Callback = function(value)
      current_sprint_speed = value
      if sprint_speed_override then
         m.SprintSpeed = current_sprint_speed
      end
   end,
})

task.spawn(function()
   while task.wait() do
      if disable_stamina then
         m.StaminaLoss = 0
      else
         m.StaminaLoss = 10
      end
   end
end)

Tab5:CreateSection("Camera and other")

local fov_path = game:GetService("Players").LocalPlayer.PlayerData.Settings.Game
local fov_value = fov_path:WaitForChild("FieldOfView") -- ensure it exists
local original_fov = fov_value.Value
local fov_override = false
local current_fov = original_fov

Tab5:CreateToggle({
   Name = "Change FOV",
   CurrentValue = false,
   Flag = "ToggleFOV",
   Callback = function(value)
      fov_override = value
      if not value then
         fov_value.Value = original_fov
      end
   end,
})

Tab5:CreateSlider({
   Name = "Field of View",
   Range = {40, 120},
   Increment = 1,
   Suffix = "Degrees",
   CurrentValue = original_fov,
   Flag = "FOVSlider",
   Callback = function(value)
      current_fov = value
      if fov_override then
         fov_value.Value = current_fov
      end
   end,
})

task.spawn(function()
   while task.wait() do
      if fov_override then
         fov_value.Value = current_fov
      end
   end
end)

Tab5:CreateDivider()

Tab5:CreateToggle({ 
	Name = "Disable Collision For Killer Only Doors",
	CurrentValue = false,
	Flag = "ToggleKillerOnlyNoCollide",
	Callback = function(Value)
		if Value then
			_G._killeronlynocollide_connection = game:GetService("RunService").RenderStepped:Connect(function()
				for _, obj in pairs(workspace.Map.Ingame.Map.KillerOnlyEntrances:GetDescendants()) do
					if obj:IsA("BasePart") then
						obj.CanCollide = false
					end
				end
			end)
		else
			if _G._killeronlynocollide_connection then
				_G._killeronlynocollide_connection:Disconnect()
				_G._killeronlynocollide_connection = nil
			end
		end
	end,
})

Tab5:CreateToggle({
	Name = "Remove Directional Movement",
	CurrentValue = false,
	Flag = "ToggleDestroyDirectionalMovement",
	Callback = function(Value)
		if Value then
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("Folder") and descendant.Name == "SpeedMultipliers" then
					local directional_movement = descendant:FindFirstChild("DirectionalMovement")
					if directional_movement then
						directional_movement:Destroy()
					end
				end
			end

			_G._directional_listener = workspace.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("Folder") and descendant.Name == "SpeedMultipliers" then
					local directional_movement = descendant:FindFirstChild("DirectionalMovement")
					if directional_movement then
						directional_movement:Destroy()
					end
				elseif descendant.Name == "DirectionalMovement" and descendant.Parent and descendant.Parent.Name == "SpeedMultipliers" then
					descendant:Destroy()
				end
			end)
		else
			if _G._directional_listener then
				_G._directional_listener:Disconnect()
				_G._directional_listener = nil
			end
		end
	end,
})

Tab5:CreateToggle({
	Name = "Disable Slowness Effects",
	CurrentValue = false,
	Flag = "ToggleRestrictSpeedMultipliers",
	Callback = function(Value)
		if Value then
			_G._restrict_speedmultipliers_connections = {}

			local allowed_names = {
				Sprinting = true,
				Speed = true,
				Stunned = true,
				FixingGenerator = true,
				Emoting = true,
				Guest1337ChargeStart = true,
				Guest1337Charge = true,
				SpeedStatus = true,
				HitSpeedBonus = true
			}

			local function connect_folder(folder)
				local conn = folder.ChildAdded:Connect(function(child)
					if not allowed_names[child.Name] then
						print("Blocked and removed unauthorized child:", child:GetFullName())
						child:Destroy()
					end
				end)
				table.insert(_G._restrict_speedmultipliers_connections, conn)
			end

			for _, folder in ipairs(workspace:GetDescendants()) do
				if folder:IsA("Folder") and folder.Name == "SpeedMultipliers" then
					connect_folder(folder)
				end
			end

			_G._restrict_speedmultipliers_descendant = workspace.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("Folder") and descendant.Name == "SpeedMultipliers" then
					connect_folder(descendant)
				end
			end)
		else
			if _G._restrict_speedmultipliers_descendant then
				_G._restrict_speedmultipliers_descendant:Disconnect()
				_G._restrict_speedmultipliers_descendant = nil
			end

			if _G._restrict_speedmultipliers_connections then
				for _, conn in ipairs(_G._restrict_speedmultipliers_connections) do
					conn:Disconnect()
				end
				_G._restrict_speedmultipliers_connections = nil
			end
		end
	end,
})

Tab5:CreateDivider()

Tab5:CreateToggle({
	Name = "Disable Stun",
	CurrentValue = false,
	Flag = "ToggleDestroyStunnedInSpeedMultipliers",
	Callback = function(Value)
		if Value then
			_G._destroy_stunned_connections = {}

			local function connect_folder(folder)
				local conn = folder.ChildAdded:Connect(function(child)
					if child.Name == "Stunned" then
						print("Destroyed 'Stunned' inside:", folder:GetFullName())
						child:Destroy()
					end
				end)
				table.insert(_G._destroy_stunned_connections, conn)
			end

			for _, folder in ipairs(workspace:GetDescendants()) do
				if folder:IsA("Folder") and folder.Name == "SpeedMultipliers" then
					connect_folder(folder)
				end
			end

			_G._destroy_stunned_descendant = workspace.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("Folder") and descendant.Name == "SpeedMultipliers" then
					connect_folder(descendant)
				end
			end)
		else
			if _G._destroy_stunned_descendant then
				_G._destroy_stunned_descendant:Disconnect()
				_G._destroy_stunned_descendant = nil
			end

			if _G._destroy_stunned_connections then
				for _, conn in ipairs(_G._destroy_stunned_connections) do
					conn:Disconnect()
				end
				_G._destroy_stunned_connections = nil
			end
		end
	end,
})

Tab5:CreateLabel("Disable stun applies to both sides, be careful or dont.", "badge-help")

Tab5:CreateSection("Invisibility and other")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local IsPlaying = false
local AnimationTrack

local function SetupAnimation()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://75804462760596"
    AnimationTrack = Humanoid:LoadAnimation(Animation)
    AnimationTrack.Looped = false
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if IsPlaying then
            if not AnimationTrack or not AnimationTrack.IsPlaying then
                SetupAnimation()
                AnimationTrack:Play()
                AnimationTrack:AdjustSpeed(0)
            end
        elseif AnimationTrack and AnimationTrack.IsPlaying then
            AnimationTrack:Stop()
        end
    end
end)

Tab5:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Flag = "InvisibilityToggle",
    Callback = function(Value)
        IsPlaying = Value
    end,
})

Tab5:CreateSection("Blatant realli blatant")

local runs = game:GetService("RunService")
local pls = game:GetService("Players")
local lsp = pls.LocalPlayer
local wors = workspace

local cgn = nil

Tab5:CreateToggle({
	Name = "Cant Catch Me Mode",
	CurrentValue = false,
	Flag = "ccm_mode",
	Callback = function(v)
		if v then
			cgn = runs.RenderStepped:Connect(function()
				local sp = wors:FindFirstChild("Players") and wors.Players:FindFirstChild("Spectating")
				local sv = wors:FindFirstChild("Players") and wors.Players:FindFirstChild("Survivors")
				local kl = wors:FindFirstChild("Players") and wors.Players:FindFirstChild("Killers")
				if not sp or not sv or not kl then return end

				for _,m in ipairs(sp:GetChildren()) do
					if m:GetAttribute("Username") == lsp.Name then
						return
					end
				end

				local me = nil
				for _,m in ipairs(sv:GetChildren()) do
					if m:GetAttribute("Username") == lsp.Name then
						me = m
						break
					end
				end
				if not me or not me:FindFirstChild("HumanoidRootPart") then return end

				local c = nil
				local d = math.huge
				for _,k in ipairs(kl:GetChildren()) do
					if k:FindFirstChild("HumanoidRootPart") then
						local dist = (me.HumanoidRootPart.Position - k.HumanoidRootPart.Position).Magnitude
						if dist < d then
							d = dist
							c = k
						end
					end
				end

				if c and c:FindFirstChild("HumanoidRootPart") then
					local pos = c.HumanoidRootPart.CFrame.Position - c.HumanoidRootPart.CFrame.LookVector * 6
					me.HumanoidRootPart.CFrame = CFrame.new(pos, c.HumanoidRootPart.Position)
				end
			end)
		else
			if cgn then
				cgn:Disconnect()
				cgn = nil
			end
		end
	end
})

Tab5:CreateDivider()

Tab5:CreateButton({
    Name = "Pickup All Items",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local ingame_folder = workspace:FindFirstChild("Map")
        if not ingame_folder then return end
        ingame_folder = ingame_folder:FindFirstChild("Ingame")
        if not ingame_folder then return end

        local prompts = {}

        for _, descendant in ipairs(ingame_folder:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") then
                table.insert(prompts, descendant)
            end
        end

        table.sort(prompts, function(a, b)
            return (a.Parent.Position - hrp.Position).Magnitude < (b.Parent.Position - hrp.Position).Magnitude
        end)

        for _, prompt in ipairs(prompts) do
            local item_part = prompt.Parent
            if item_part and item_part:IsA("BasePart") then
                hrp.CFrame = item_part.CFrame + Vector3.new(0, 0, -2)
                task.wait(0.2)
                fireproximityprompt(prompt)
                task.wait(0.5)
            end
        end
    end,
})

Tab5:CreateButton({
    Name = "Teleport to Pizza",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local pizza = workspace:FindFirstChild("Map")
        if pizza then
            pizza = pizza:FindFirstChild("Ingame")
            if pizza then
                pizza = pizza:FindFirstChild("Pizza")
                if pizza and pizza:IsA("BasePart") then
                    hrp.CFrame = pizza.CFrame + Vector3.new(0, 3, 0) -- offset slightly above
                end
            end
        end
    end,
})

Tab5:CreateDivider()

local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Do1x1PopupsLoop = false

Tab5:CreateToggle({
	Name = "Auto 1x4 Popups",
	CurrentValue = false,
	Flag = "PopupCloser",
	Callback = function(value)
		Do1x1PopupsLoop = value
	end,
})

task.spawn(function()
	while true do
		if Do1x1PopupsLoop then
			local player = LocalPlayer
			local gui = player:FindFirstChild("PlayerGui")
			local container = gui and gui:FindFirstChild("TemporaryUI")

			if container then
				for _, i in ipairs(container:GetChildren()) do
					if i.Name == "1x1x1x1Popup" and i:IsA("GuiObject") then
						local centerX = i.AbsolutePosition.X + (i.AbsoluteSize.X / 2)
						local centerY = i.AbsolutePosition.Y + (i.AbsoluteSize.Y / 2) + 50

						VIM:SendMouseButtonEvent(centerX, centerY, Enum.UserInputType.MouseButton1.Value, true, i, 1)
						VIM:SendMouseButtonEvent(centerX, centerY, Enum.UserInputType.MouseButton1.Value, false, i, 1)
					end
				end
			end
		end
		task.wait(0.1)
	end
end)

Tab5:CreateButton({ 
	Name = "Disable John Doe Trail", 
	Callback = function()
		task.spawn(function()
			while true do
				task.wait(0.1)
				local trail = workspace:FindFirstChild("Players")
					and workspace.Players:FindFirstChild("Killers")
					and workspace.Players.Killers:FindFirstChild("JohnDoe")
					and workspace.Players.Killers.JohnDoe:FindFirstChild("JohnDoeTrail")

				if trail then
					trail:Destroy()
				end
			end
		end)
	end,
})

Tab5:CreateSection("Character Specific")

local e = false
local r
local c
local ccon

Tab5:CreateToggle({
   Name = "Disable Guest Block Animation",
   CurrentValue = false,
   Flag = "GuestBlockAnimation",
   Callback = function(f)
      if f then
         local a = game.Players.LocalPlayer
         local d = game:GetService("RunService")

         local function setchar()
            c = a.Character or a.CharacterAdded:Wait()
            ccon = c:WaitForChild("Humanoid")
         end

         setchar()

         r = d.RenderStepped:Connect(function()
            for _, g in ipairs(ccon:GetPlayingAnimationTracks()) do
               if g.Animation.AnimationId == "rbxassetid://72722244508749" then
                  g:Stop()
               end
            end
         end)

         a.CharacterAdded:Connect(function()
            setchar()
         end)

      else
         if r then
            r:Disconnect()
            r = nil
         end
      end
   end,
})

local q = false
local x
local y
local z

Tab5:CreateToggle({
   Name = "Disable Guest Punch Animation",
   CurrentValue = false,
   Flag = "guestblock",
   Callback = function(b)
      if b then
         local p = game.Players.LocalPlayer
         local u = game:GetService("RunService")

         local function j()
            y = p.Character or p.CharacterAdded:Wait()
            z = y:WaitForChild("Humanoid")
         end

         j()

         x = u.RenderStepped:Connect(function()
            for _, v in ipairs(z:GetPlayingAnimationTracks()) do
               if v.Animation.AnimationId == "rbxassetid://87259391926321" then
                  v:Stop()
               end
            end
         end)

         p.CharacterAdded:Connect(function()
            j()
         end)

      else
         if x then
            x:Disconnect()
            x = nil
         end
      end
   end,
})

local RunService = game:GetService("RunService")

local TripmineFollowing = false
local Connection = nil

Tab5:CreateToggle({
    Name = "Scary Subspace Tripmines",
    CurrentValue = false,
    Flag = "SubspaceTripmineFollower",
    Callback = function(Value)
        TripmineFollowing = Value

        if Value then
            Connection = RunService.RenderStepped:Connect(function()
                local Map = workspace:FindFirstChild("Map")
                if not Map then return end
                local Ingame = Map:FindFirstChild("Ingame")
                if not Ingame then return end

                local PlayersFolder = workspace:FindFirstChild("Players")
                if not PlayersFolder then return end
                local KillersFolder = PlayersFolder:FindFirstChild("Killers")
                if not KillersFolder then return end

                local Killer = nil
                for _, Obj in ipairs(KillersFolder:GetChildren()) do
                    if Obj:FindFirstChild("HumanoidRootPart") then
                        Killer = Obj
                        break
                    end
                end

                if not Killer then return end
                local HRP = Killer:FindFirstChild("HumanoidRootPart")
                if not HRP then return end

                for _, Tripmine in ipairs(Ingame:GetChildren()) do
                    if Tripmine.Name == "SubspaceTripmine" and Tripmine:IsA("Model") then
                        if not Tripmine.PrimaryPart then
                            Tripmine.PrimaryPart = Tripmine:FindFirstChildWhichIsA("BasePart")
                            if not Tripmine.PrimaryPart then
                                -- skip this tripmine if no primary part found
                            else
                                -- continue with code below
                                local Angle = math.random() * 2 * math.pi
                                local Radius = 1 + math.random()
                                local Offset = Vector3.new(math.cos(Angle) * Radius, -3, math.sin(Angle) * Radius)
                                local TargetPosition = HRP.Position + Offset
                                local TargetCFrame = CFrame.new(TargetPosition, HRP.Position)

                                local CurrentCFrame = Tripmine.PrimaryPart.CFrame
                                local SmoothCFrame = CurrentCFrame:Lerp(TargetCFrame, 0.1)

                                Tripmine:SetPrimaryPartCFrame(SmoothCFrame)
                            end
                        else
                            local Angle = math.random() * 2 * math.pi
                            local Radius = 1 + math.random()
                            local Offset = Vector3.new(math.cos(Angle) * Radius, -3, math.sin(Angle) * Radius)
                            local TargetPosition = HRP.Position + Offset
                            local TargetCFrame = CFrame.new(TargetPosition, HRP.Position)

                            local CurrentCFrame = Tripmine.PrimaryPart.CFrame
                            local SmoothCFrame = CurrentCFrame:Lerp(TargetCFrame, 0.1)

                            Tripmine:SetPrimaryPartCFrame(SmoothCFrame)
                        end
                    end
                end
            end)
        else
            if Connection then
                Connection:Disconnect()
                Connection = nil
            end
        end
    end,
})

Tab5:CreateLabel("Basically your Subspace Tripmine follows the killer.", "annoyed")

Tab5:CreateDivider()

Tab5:CreateToggle({
    Name = "Auto Ghostburger When Last Man Standing",
    CurrentValue = false,
    Flag = "AutoGhostburgerToggle",
    Callback = function(Value)
        ghostburger_loop = Value

        if Value then
            task.spawn(function()
                while ghostburger_loop do
                    local sound = workspace:FindFirstChild("Themes") and workspace.Themes:FindFirstChild("LastSurvivor")
                    if sound and sound:IsA("Sound") then
                        local remote = game:GetService("ReplicatedStorage")
                            :WaitForChild("Modules")
                            :WaitForChild("Network")
                            :WaitForChild("RemoteEvent")
                        remote:FireServer("UseActorAbility", "Ghostburger")
                    end
                    wait() -- yields each loop
                end
            end)
        end
    end,
})

Tab5:CreateLabel("It uses ghostburger when it can when it's LMS, not just once.", "rewind")

local Tab2 = Window:CreateTab("Animations", "building")

Tab2:CreateSection("Silly Bomboclat")

Tab2:CreateKeybind({
	Name = "Fake Block",
	CurrentKeybind = "Y",
	HoldToInteract = false,
	Flag = "play_y_animation_keybind",
	Callback = function()
		local players = game:GetService("Players")
		local local_player = players.LocalPlayer
		local animation_id = "rbxassetid://72722244508749"

		local current_character = local_player.Character
		if not current_character then return end

		local current_humanoid = current_character:FindFirstChildOfClass("Humanoid")
		if not current_humanoid then return end

		local animation = Instance.new("Animation")
		animation.Name = "KeybindAnimation"
		animation.AnimationId = animation_id
		animation.Parent = current_humanoid

		local current_track = current_humanoid:LoadAnimation(animation)
		if not current_track then
			animation:Destroy()
			return
		end

		current_track:Play()
	end,
})

Tab2:CreateKeybind({
	Name = "Ragdoll",
	CurrentKeybind = "C",
	HoldToInteract = false,
	Flag = "force_ragdoll_keybind",
	Callback = function()
		local players = game:GetService("Players")
		local local_player = players.LocalPlayer
		local ragdoll_module = require(game.ReplicatedStorage.Modules.Ragdolls)

		local character = local_player.Character
		if not character then return end
		local humanoid = character:FindFirstChild("Humanoid")
		if not humanoid then return end

		local is_ragdolling = character:GetAttribute("Ragdolling")
		
		if is_ragdolling then
			ragdoll_module:Disable(character)
		else
			ragdoll_module:Enable(character, false)
		end
	end,
})


Tab2:CreateKeybind({
	Name = "Spin",
	CurrentKeybind = "J",
	HoldToInteract = false,
	Flag = "SmoothSpinKeybind",
	Callback = function()
		local players = game:GetService("Players")
		local local_player = players.LocalPlayer
		local run_service = game:GetService("RunService")

		local character = local_player.Character or local_player.CharacterAdded:Wait()
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local start_cf = hrp.CFrame
		local duration = 0.8
		local steps = 60
		local angle_per_step = 360 / steps

		for i = 1, steps do
			local angle = math.rad(angle_per_step * i)
			local rotated_cf = start_cf * CFrame.Angles(0, angle, 0)
			hrp.CFrame = rotated_cf
			task.wait(duration / steps)
		end
	end,
})

Tab2:CreateDivider()

Tab2:CreateLabel("Do NOT use Spin while having shiftlock on.", "brush")

local Tab8 = Window:CreateTab("Blatant", "angry")

Tab8:CreateSection("Uh my gud.")

-- Unique variables for Shedletsky Auto Slash
local ShedletskyAutoSlash_Players = game:GetService("Players")
local ShedletskyAutoSlash_ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShedletskyAutoSlash_StarterPlayer = game:GetService("StarterPlayer")
local ShedletskyAutoSlash_RunService = game:GetService("RunService")
local ShedletskyAutoSlash_LocalPlayer = ShedletskyAutoSlash_Players.LocalPlayer
local ShedletskyAutoSlash_RemoteEvent = ShedletskyAutoSlash_ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
local ShedletskyAutoSlash_Cam = workspace.CurrentCamera
ShedletskyAutoSlash_StarterPlayer.EnableMouseLockOption = true
local ShedletskyAutoSlash_Character = ShedletskyAutoSlash_LocalPlayer.Character or ShedletskyAutoSlash_LocalPlayer.CharacterAdded:Wait()
local ShedletskyAutoSlash_Rotating = false
local ShedletskyAutoSlash_CurrentTarget = nil

-- Settings variables
local ShedletskyAutoSlash_Distance = 5
local ShedletskyAutoSlash_Enabled = false

-- Connection variables to store connections for cleanup
local ShedletskyAutoSlash_CharacterConnection = nil
local ShedletskyAutoSlash_RenderConnection = nil
local ShedletskyAutoSlash_MainLoopConnection = nil
local ShedletskyAutoSlash_RemoteConnection = nil

-- Function to start the auto slash system
local function StartShedletskyAutoSlash()
    if ShedletskyAutoSlash_Enabled then return end -- Already running
    
    ShedletskyAutoSlash_Enabled = true
    
    -- Character connection
    ShedletskyAutoSlash_CharacterConnection = ShedletskyAutoSlash_LocalPlayer.CharacterAdded:Connect(function(Char)
        ShedletskyAutoSlash_Character = Char
    end)
    
    -- Render connection for camera rotation
    ShedletskyAutoSlash_RenderConnection = ShedletskyAutoSlash_RunService.RenderStepped:Connect(function()
        if ShedletskyAutoSlash_Rotating and ShedletskyAutoSlash_CurrentTarget and ShedletskyAutoSlash_CurrentTarget:FindFirstChild("HumanoidRootPart") then
            local CamPos = ShedletskyAutoSlash_Cam.CFrame.Position
            local TargetPos = ShedletskyAutoSlash_CurrentTarget.HumanoidRootPart.Position
            ShedletskyAutoSlash_Cam.CFrame = CFrame.new(CamPos, TargetPos)
        end
    end)
    
    -- Main loop connection
    ShedletskyAutoSlash_MainLoopConnection = task.spawn(function()
        while ShedletskyAutoSlash_Enabled do
            task.wait(0.1)
            if ShedletskyAutoSlash_Character and ShedletskyAutoSlash_Character:FindFirstChild("HumanoidRootPart") then
                local HRP = ShedletskyAutoSlash_Character.HumanoidRootPart
                local KillersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
                if KillersFolder then
                    for _, Killer in ipairs(KillersFolder:GetChildren()) do
                        if Killer:IsA("Model") and Killer:FindFirstChild("HumanoidRootPart") then
                            local Distance = (Killer.HumanoidRootPart.Position - HRP.Position).Magnitude
                            local SpeedMultipliers = Killer:FindFirstChild("SpeedMultipliers")
                            local HasSprinting = SpeedMultipliers and SpeedMultipliers:FindFirstChild("Sprinting")
                            if Distance <= ShedletskyAutoSlash_Distance and not HasSprinting then
                                ShedletskyAutoSlash_RemoteEvent:FireServer("UseActorAbility", "Slash")
                                ShedletskyAutoSlash_CurrentTarget = Killer
                                ShedletskyAutoSlash_Rotating = true
                                task.delay(2, function()
                                    ShedletskyAutoSlash_Rotating = false
                                    ShedletskyAutoSlash_CurrentTarget = nil
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Remote event connection
    ShedletskyAutoSlash_RemoteConnection = ShedletskyAutoSlash_RemoteEvent.OnClientEvent:Connect(function(Action, Ability, Sender)
        if Sender ~= ShedletskyAutoSlash_LocalPlayer then return end
        if Action == "UseActorAbility" and Ability == "Slash" then
            -- Optional: Do something when you trigger slash
        end
    end)
end

-- Function to stop the auto slash system
local function StopShedletskyAutoSlash()
    ShedletskyAutoSlash_Enabled = false
    
    -- Disconnect all connections
    if ShedletskyAutoSlash_CharacterConnection then
        ShedletskyAutoSlash_CharacterConnection:Disconnect()
        ShedletskyAutoSlash_CharacterConnection = nil
    end
    
    if ShedletskyAutoSlash_RenderConnection then
        ShedletskyAutoSlash_RenderConnection:Disconnect()
        ShedletskyAutoSlash_RenderConnection = nil
    end
    
    if ShedletskyAutoSlash_MainLoopConnection then
        task.cancel(ShedletskyAutoSlash_MainLoopConnection)
        ShedletskyAutoSlash_MainLoopConnection = nil
    end
    
    if ShedletskyAutoSlash_RemoteConnection then
        ShedletskyAutoSlash_RemoteConnection:Disconnect()
        ShedletskyAutoSlash_RemoteConnection = nil
    end
    
    -- Reset state variables
    ShedletskyAutoSlash_Rotating = false
    ShedletskyAutoSlash_CurrentTarget = nil
end

-- Create the toggle
Tab8:CreateToggle({
    Name = "Shedletsky Auto Slash",
    CurrentValue = false,
    Flag = "ShedletskyAutoSlashToggle",
    Callback = function(Value)
        if Value then
            StartShedletskyAutoSlash()
        else
            StopShedletskyAutoSlash()
        end
    end,
})

-- Create the distance slider
Tab8:CreateSlider({
    Name = "Slash Distance",
    Range = {5, 15},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 5,
    Flag = "ShedletskySlashDistanceSlider",
    Callback = function(Value)
        ShedletskyAutoSlash_Distance = Value
    end,
})

Tab8:CreateLabel("This feature is experimental.", "sword")

Tab8:CreateDivider()

local rs = game:GetService("ReplicatedStorage")
local ps = game:GetService("Players")
local lp = ps.LocalPlayer
local ev = rs:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

local st = {
	Jason = 0.8,
	JohnDoe = 1,
	c00lkidd = 0.8,
	["1x1x1x1"] = 1,
	Shedletsky = 1.5,
	TwoTime = 1,
	Guest1337 = 1,
	Chance = 1.5
}

local ac = false

local function fx()
	for _,m in ipairs(workspace.Players.Survivors:GetChildren()) do
		if m:GetAttribute("Username") == lp.Name then
			return m,"s"
		end
	end
	for _,m in ipairs(workspace.Players.Killers:GetChildren()) do
		if m:GetAttribute("Username") == lp.Name then
			return m,"k"
		end
	end
end

local function fy(a,b)
	local z
	local d = math.huge
	for _,n in ipairs(b:GetChildren()) do
		if n:FindFirstChild("HumanoidRootPart") then
			local r = (n.HumanoidRootPart.Position - a.HumanoidRootPart.Position).Magnitude
			if r < d then
				d = r
				z = n
			end
		end
	end
	return z
end

local function rz(tg,tm)
	local a,_ = fx()
	if not a then return end
	local h = a:FindFirstChild("HumanoidRootPart")
	if not h or not tg or not tg:FindFirstChild("HumanoidRootPart") then return end

	local s = tick()
	while tick() - s < tm do
		if not tg or not tg:FindFirstChild("HumanoidRootPart") then return end
		if not h then return end

		local p1 = h.Position
		local p2 = tg.HumanoidRootPart.Position
		local dir = (p2 - p1).Unit
		local look = CFrame.new(p1, Vector3.new(p1.X + dir.X, p1.Y, p1.Z + dir.Z))
		h.CFrame = h.CFrame:Lerp(look, 0.9)

		task.wait()
	end
end

ev.OnClientEvent:Connect(function(...)
	local args = {...}
	if not ac then return end
	if #args < 1 then return end
	if args[1] ~= "UseActorAbility" then return end

	local blocklist = {
		Block = true,
		Reroll = true,
		CoinFlip = true,
		Ritual = true,
        EatFriedChicken = true,
        HatFix = true
	}

	if #args >= 2 and blocklist[args[2]] then
		return
	end

	local a,t = fx()
	if not a then return end

	local id = a.Name
	local tm = st[id]
	if not tm then return end
	if not a:FindFirstChild("HumanoidRootPart") then return end

	if t == "s" then
		local k = fy(a,workspace.Players.Killers)
		if k then rz(k,tm) end
	elseif t == "k" then
		local s = fy(a,workspace.Players.Survivors)
		if s then rz(s,tm) end
	end
end)

Tab8:CreateToggle({
	Name = "Aimbot",
	CurrentValue = false,
	Flag = "rotate_cam",
	Callback = function(v)
		ac = v
	end,
})

Tab8:CreateButton({
	Name = "Kill All Survivors",
	Callback = function()
		local rs = game:GetService("ReplicatedStorage")
		local plrs = workspace:WaitForChild("Players")
		local net = rs:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

		local lp = game:GetService("Players").LocalPlayer
		local lpname = lp.Name

		local function tp(k, s)
			local hrp = k:FindFirstChild("HumanoidRootPart")
			local shrp = s:FindFirstChild("HumanoidRootPart")
			if not hrp or not shrp then return end
			while s.Parent == plrs.Survivors do
				local pos = shrp.CFrame
				local backpos = pos * CFrame.new(0, 0, 1)
				hrp.CFrame = backpos
				net:FireServer("UseActorAbility", "Slash")
				task.wait(0.1)
			end
		end

		local killers = plrs:FindFirstChild("Killers")
		local survivors = plrs:FindFirstChild("Survivors")
		if killers and survivors then
			for _, k in pairs(killers:GetChildren()) do
				local att = k:GetAttribute("Username")
				if att == lpname then
					while true do
						local survlist = survivors:GetChildren()
						if #survlist == 0 then break end
						local s = survlist[math.random(#survlist)]
						tp(k, s)
					end
				end
			end
		end
	end,
})

Tab8:CreateDivider()

Tab8:CreateButton({
	Name = "Guest 1337 Punch Giver",
	Callback = function()
		local rs = game:GetService("ReplicatedStorage")
		local r = rs:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
		local lp = game.Players.LocalPlayer
		local w = workspace
		local s = w.Players.Survivors
		local k = w.Players.Killers
		local rsrv = game:GetService("RunService")

		local done = false
		local anims = {
			["81362825527808"] = true,
			["126830014841198"] = true,
			["105458270463374"] = true,
			["18886068630"] = true,
			["126355327951215"] = true,
			["121086746534252"] = true,
			["98456918873918"] = true
		}

		for _, p in pairs(s:GetChildren()) do
			if p:GetAttribute("Username") == lp.Name then
				local all = {}
				for _, a in pairs(s:GetChildren()) do table.insert(all, a) end
				for _, b in pairs(k:GetChildren()) do table.insert(all, b) end

				for _, char in pairs(all) do
					local prev = {}
					local con
					con = rsrv.RenderStepped:Connect(function()
						if done then
							con:Disconnect()
							return
						end
						local hum = char:FindFirstChildOfClass("Humanoid")
						local hrp1 = char:FindFirstChild("HumanoidRootPart")
						local lpchar = lp.Character
						local hrp2 = lpchar and lpchar:FindFirstChild("HumanoidRootPart")
						if hum and hrp1 and hrp2 then
							local cur = {}
							for _, t in pairs(hum:GetPlayingAnimationTracks()) do
								local id = t.Animation.AnimationId
								local num = id:match("rbxassetid://(%d+)")
								if num then cur[num] = true end
							end
							for num in pairs(cur) do
								if anims[num] and not prev[num] then
									done = true
									con:Disconnect()
									task.spawn(function()
										r:FireServer("UseActorAbility", "Block")
										local old = hrp2.CFrame
										local t0 = tick()
										while tick() - t0 < 1 do
											if not hrp1 or not hrp1.Parent then break end
											hrp2.CFrame = hrp1.CFrame + hrp1.CFrame.LookVector * 6.5
											task.wait()
										end
										hrp2.CFrame = old
									end)
									break
								end
							end
							prev = cur
						end
					end)
				end
			end
		end
	end,
})

Tab8:CreateLabel("Waits for killers M1 and teleports infront of them and blocks, has a 72% chance of working.", "angry")

Tab8:CreateButton({ 
    Name = "Slash Killers Buttcheeks as Shedletsky", 
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local StarterPlayer = game:GetService("StarterPlayer")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
        local Cam = workspace.CurrentCamera
        StarterPlayer.EnableMouseLockOption = true
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Rotating = false
        local CurrentTarget = nil
        
        LocalPlayer.CharacterAdded:Connect(function(char)
            Character = char
        end)
        
        RunService.RenderStepped:Connect(function()
            if Rotating and CurrentTarget and CurrentTarget:FindFirstChild("HumanoidRootPart") then
                local CamPos = Cam.CFrame.Position
                local TargetPos = CurrentTarget.HumanoidRootPart.Position
                Cam.CFrame = CFrame.new(CamPos, TargetPos)
            end
        end)
        
        local function TeleportBehind(targetModel)
            local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local targetHRP = targetModel:FindFirstChild("HumanoidRootPart")
            if not targetHRP then return end
            
            -- Get the target's facing direction (LookVector)
            local targetLookVector = targetHRP.CFrame.LookVector
            -- Position behind the target (opposite of where they're facing)
            local behindPosition = targetHRP.Position - (targetLookVector * 3) -- 3 studs behind
            -- Keep the same Y level as the target
            behindPosition = Vector3.new(behindPosition.X, targetHRP.Position.Y, behindPosition.Z)
            
            -- Set player position behind target, facing the target
            hrp.CFrame = CFrame.new(behindPosition, targetHRP.Position)
        end
        
        local function FindClosestKiller()
            local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
            if not HRP then return nil end
            local KillersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
            if not KillersFolder then return nil end
            
            local closestKiller = nil
            local shortestDist = math.huge
            
            for _, Killer in ipairs(KillersFolder:GetChildren()) do
                if Killer:IsA("Model") and Killer:FindFirstChild("HumanoidRootPart") then
                    local dist = (Killer.HumanoidRootPart.Position - HRP.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestKiller = Killer
                    end
                end
            end
            
            return closestKiller
        end
        
        local target = FindClosestKiller()
        if not target then return end
        
        CurrentTarget = target
        Rotating = true
        
        local startTime = tick()
        while tick() - startTime < 2 do
            TeleportBehind(target)
            RemoteEvent:FireServer("UseActorAbility", "Slash")
            task.wait(0.1)
        end
        
        Rotating = false
        CurrentTarget = nil
    end,
})

Tab8:CreateLabel("Basically you tp behind killer and slash that ass.", "frown")

local Tab3 = Window:CreateTab("Generators", "sliders-vertical")

Tab3:CreateSection("What is a Generator? Skibidi balls.")

local ShouldAutoGenerate = false
local GeneratorSpeed = 2.5
local HumanizerDelay = 0

local AutoGeneratorRunning = false

local function StartAutoGenerator()
	if AutoGeneratorRunning then return end
	AutoGeneratorRunning = true
	task.spawn(function()
		while AutoGeneratorRunning and ShouldAutoGenerate do
			local LocalPlayer = game.Players.LocalPlayer
			local PuzzleUI = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI")

			if not PuzzleUI then
				task.wait(0.2)
			elseif not PuzzleUI.Enabled then
				task.wait(0.2)
			else
				local TotalWaitTime = GeneratorSpeed
				if math.random() < 0.5 then
					TotalWaitTime = TotalWaitTime + HumanizerDelay
				end
				task.wait(TotalWaitTime)

				local Character = LocalPlayer.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local MapFolder = workspace:FindFirstChild("Map") 
					and workspace.Map:FindFirstChild("Ingame") 
					and workspace.Map.Ingame:FindFirstChild("Map")

				if HumanoidRootPart and MapFolder then
					local ClosestGenerator = nil
					local ShortestDistance = math.huge

					for _, Generator in ipairs(MapFolder:GetChildren()) do
						if Generator.Name == "Generator"
							and Generator:FindFirstChild("Progress")
							and Generator.Progress.Value < 100
							and Generator:FindFirstChild("Remotes")
							and Generator.Remotes:FindFirstChild("RE") then

							local Distance = (Generator.Main.Position - HumanoidRootPart.Position).Magnitude
							if Distance < ShortestDistance then
								ShortestDistance = Distance
								ClosestGenerator = Generator
							end
						end
					end

					if ClosestGenerator then
						pcall(function()
							ClosestGenerator.Remotes.RE:FireServer()
						end)
					end
				else
					task.wait(0.2)
				end
			end
		end
	end)
end

local function StopAutoGenerator()
	AutoGeneratorRunning = false
end

Tab3:CreateToggle({
	Name = "Auto Generator",
	CurrentValue = false,
	Flag = "auto_generator_toggle",
	Callback = function(State)
		ShouldAutoGenerate = State
		if State then
			StartAutoGenerator()
		else
			StopAutoGenerator()
		end
	end,
})

Tab3:CreateDivider()

Tab3:CreateSlider({
	Name = "Generator Speed",
	Range = {2.5, 15},
	Increment = 0.5,
	Suffix = "Seconds",
	CurrentValue = 2.5,
	Flag = "auto_generator_speed",
	Callback = function(Value)
		GeneratorSpeed = Value
	end,
})

Tab3:CreateSlider({
	Name = "Speed Humanizer",
	Range = {0, 5},
	Increment = 1,
	Suffix = "Randomizer",
	CurrentValue = 0,
	Flag = "auto_generator_humanizer",
	Callback = function(Value)
		HumanizerDelay = Value
	end,
})

Tab3:CreateParagraph({Title = "🛒 💩 👧", Content = "Speed humanizer has a 50% chance, if it wins the 50% chance it will add the number of seconds you chose in the slider to your generator speed. If it cannot win then it will apply your normal Generator Speed, basically to make your Generator look more like it's being made by a human."})

Tab3:CreateDivider()

local HttpService = game:GetService("HttpService")
local background = game:GetService("ReplicatedStorage").Modules.Misc.FlowGameManager.PuzzleUI.Container.GridHolder.Background
local original_image = background.Image
local original_zindex = background.ZIndex
local original_transparency = background.ImageTransparency
local original_scaletype = background.ScaleType

local base_url = "https://github.com/jzexok/Forsaken/raw/main/Silly/"
local api_url = "https://api.github.com/repos/jzexok/Forsaken/contents/Silly"

local image_paths = {}
local image_urls = {}
local options = {}

local success, response = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(api_url))
end)

if success and type(response) == "table" then
    for _, file in ipairs(response) do
        local name = file.name
        if name:match("%.png$") or name:match("%.jpg$") or name:match("%.jpeg$") then
            local display_name = name:gsub("%.%w+$", "") -- Remove file extension
            table.insert(options, display_name)
            image_paths[display_name] = name
            image_urls[display_name] = base_url .. name
        end
    end
else
    warn("Failed to fetch image list from GitHub.")
end

local selected_image = options[1] or ""

local function download_file(path, url)
    if not isfile(path) then
        local content = game:HttpGet(url)
        writefile(path, content)
    end
end

for name, path in pairs(image_paths) do
    download_file(path, image_urls[name])
end

Tab3:CreateDropdown({
    Name = "Background",
    Options = options,
    CurrentOption = {selected_image},
    MultipleOptions = false,
    Flag = "PuzzleBGDropdown",
    Callback = function(option)
        selected_image = option[1]
    end,
})

Tab3:CreateToggle({
    Name = "Replace Puzzle Background",
    CurrentValue = false,
    Flag = "replace_puzzle_bg",
    Callback = function(state)
        if state then
            local chosen_path = image_paths[selected_image]
            if chosen_path then
                background.Image = getcustomasset(chosen_path)
                background.ZIndex = 7
                background.ImageTransparency = 0.6
                background.ScaleType = Enum.ScaleType.Stretch
            end
        else
            background.Image = original_image
            background.ZIndex = original_zindex
            background.ImageTransparency = original_transparency
            background.ScaleType = original_scaletype
        end
    end,
})

Tab3:CreateLabel("Might have to toggle it again when you change background.", "vibrate")

local Tab4 = Window:CreateTab("Miscallaneous", "thermometer")

Tab4:CreateSection("Oglum yatagimi ac")

local RunService = game:GetService("RunService")

do
    local ToggleCurbaModernFilm = false
    local ScreenGuiCurba, VideoFrameCurba, BounceSpeedCurba, ConnectionCurba

    Tab4:CreateToggle({
        Name = "Curba Modern Film",
        CurrentValue = false,
        Flag = "ToggleErenKarayilan",
        Callback = function(Value)
            ToggleCurbaModernFilm = Value

            if ToggleCurbaModernFilm then
                local function DownloadFile(Path, Link)
                    local Content = game:HttpGet(Link)
                    writefile(Path, Content)
                end

                if not isfile("ErenKarayilan.mp4") then
                    DownloadFile("ErenKarayilan.mp4", "https://github.com/jzexok/Forsaken/blob/main/Silly/ErenKarayilan.mp4?raw=true")
                end

                if not ScreenGuiCurba then
                    ScreenGuiCurba = Instance.new("ScreenGui")
                    ScreenGuiCurba.Name = "VideoGUI1"
                    ScreenGuiCurba.IgnoreGuiInset = true
                    ScreenGuiCurba.ResetOnSpawn = false
                    ScreenGuiCurba.Parent = game:GetService("CoreGui")

                    VideoFrameCurba = Instance.new("VideoFrame")
                    VideoFrameCurba.Name = "ErenKarayilanVideo"
                    VideoFrameCurba.Size = UDim2.new(0, 300, 0, 200)
                    local ScreenSize = workspace.CurrentCamera.ViewportSize
                    VideoFrameCurba.Position = UDim2.new(0, (ScreenSize.X - 300) / 2, 0, (ScreenSize.Y - 200) / 2)
                    VideoFrameCurba.BackgroundTransparency = 1
                    VideoFrameCurba.Video = getcustomasset("ErenKarayilan.mp4")
                    VideoFrameCurba.Looped = true
                    VideoFrameCurba.Volume = 8
                    VideoFrameCurba.Visible = true
                    VideoFrameCurba.Parent = ScreenGuiCurba

                    BounceSpeedCurba = Vector2.new(3, 3)

                    ConnectionCurba = RunService.RenderStepped:Connect(function()
                        if ToggleCurbaModernFilm and VideoFrameCurba then
                            local Pos = VideoFrameCurba.Position
                            local AbsPos = Vector2.new(Pos.X.Offset, Pos.Y.Offset)
                            local Size = Vector2.new(VideoFrameCurba.Size.X.Offset, VideoFrameCurba.Size.Y.Offset)
                            local Viewport = workspace.CurrentCamera.ViewportSize

                            AbsPos = AbsPos + BounceSpeedCurba

                            if AbsPos.X <= 0 or AbsPos.X + Size.X >= Viewport.X then
                                BounceSpeedCurba = Vector2.new(-BounceSpeedCurba.X, BounceSpeedCurba.Y)
                            end
                            if AbsPos.Y <= 0 or AbsPos.Y + Size.Y >= Viewport.Y then
                                BounceSpeedCurba = Vector2.new(BounceSpeedCurba.X, -BounceSpeedCurba.Y)
                            end

                            VideoFrameCurba.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y)
                        end
                    end)
                end

                if VideoFrameCurba then
                    VideoFrameCurba.Visible = true
                    VideoFrameCurba:Play()
                end
            else
                if VideoFrameCurba then
                    VideoFrameCurba:Pause()
                    VideoFrameCurba.Visible = false
                end
            end
        end,
    })
end

do
    local ToggleSamanyoluFilm = false
    local ScreenGuiSamanyolu, VideoFrameSamanyolu, BounceSpeedSamanyolu, ConnectionSamanyolu

    Tab4:CreateToggle({
        Name = "Eren Karayilan Samanyolu Kisa Film",
        CurrentValue = false,
        Flag = "ToggleSamanyolu",
        Callback = function(Value)
            ToggleSamanyoluFilm = Value

            if ToggleSamanyoluFilm then
                local function DownloadFile(Path, Link)
                    local Content = game:HttpGet(Link)
                    writefile(Path, Content)
                end

                if not isfile("SamanyoluFilimi.mp4") then
                    DownloadFile("SamanyoluFilimi.mp4", "https://github.com/jzexok/Forsaken/blob/main/Silly/SamanyoluFilimi.mp4?raw=true")
                end

                if not ScreenGuiSamanyolu then
                    ScreenGuiSamanyolu = Instance.new("ScreenGui")
                    ScreenGuiSamanyolu.Name = "VideoGUI2"
                    ScreenGuiSamanyolu.IgnoreGuiInset = true
                    ScreenGuiSamanyolu.ResetOnSpawn = false
                    ScreenGuiSamanyolu.Parent = game:GetService("CoreGui")

                    VideoFrameSamanyolu = Instance.new("VideoFrame")
                    VideoFrameSamanyolu.Name = "SamanyoluVideo"
                    VideoFrameSamanyolu.Size = UDim2.new(0, 300, 0, 200)
                    local ScreenSize = workspace.CurrentCamera.ViewportSize
                    VideoFrameSamanyolu.Position = UDim2.new(0, (ScreenSize.X - 300) / 2, 0, (ScreenSize.Y - 200) / 2)
                    VideoFrameSamanyolu.BackgroundTransparency = 1
                    VideoFrameSamanyolu.Video = getcustomasset("SamanyoluFilimi.mp4")
                    VideoFrameSamanyolu.Looped = true
                    VideoFrameSamanyolu.Volume = 8
                    VideoFrameSamanyolu.Visible = true
                    VideoFrameSamanyolu.Parent = ScreenGuiSamanyolu

                    BounceSpeedSamanyolu = Vector2.new(3, 3)

                    ConnectionSamanyolu = RunService.RenderStepped:Connect(function()
                        if ToggleSamanyoluFilm and VideoFrameSamanyolu then
                            local Pos = VideoFrameSamanyolu.Position
                            local AbsPos = Vector2.new(Pos.X.Offset, Pos.Y.Offset)
                            local Size = Vector2.new(VideoFrameSamanyolu.Size.X.Offset, VideoFrameSamanyolu.Size.Y.Offset)
                            local Viewport = workspace.CurrentCamera.ViewportSize

                            AbsPos = AbsPos + BounceSpeedSamanyolu

                            if AbsPos.X <= 0 or AbsPos.X + Size.X >= Viewport.X then
                                BounceSpeedSamanyolu = Vector2.new(-BounceSpeedSamanyolu.X, BounceSpeedSamanyolu.Y)
                            end
                            if AbsPos.Y <= 0 or AbsPos.Y + Size.Y >= Viewport.Y then
                                BounceSpeedSamanyolu = Vector2.new(BounceSpeedSamanyolu.X, -BounceSpeedSamanyolu.Y)
                            end

                            VideoFrameSamanyolu.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y)
                        end
                    end)
                end

                if VideoFrameSamanyolu then
                    VideoFrameSamanyolu.Visible = true
                    VideoFrameSamanyolu:Play()
                end
            else
                if VideoFrameSamanyolu then
                    VideoFrameSamanyolu:Pause()
                    VideoFrameSamanyolu.Visible = false
                end
            end
        end,
    })
end

Tab4:CreateSection("Game modifying")

local plrsvc = game:GetService("Players")
local wrkspc = game:GetService("Workspace")
local runsrv = game:GetService("RunService")

local locplr = plrsvc.LocalPlayer
local mp3lst = {}

local allfns = listfiles("")
for _, pathnm in ipairs(allfns) do
	if pathnm:lower():match("%.mp3$") then
		table.insert(mp3lst, pathnm:match("[^/\\]+$"))
	end
end

local sndsel = ""

Tab4:CreateDropdown({
	Name = "Custom LMS",
	Options = mp3lst,
	CurrentOption = {},
	MultipleOptions = false,
	Flag = "customlmsdropdown",
	Callback = function(selopt)
		if selopt[1] then
			sndsel = selopt[1]
		end
	end,
})

local toggon = false
local loopcn = nil

Tab4:CreateToggle({
	Name = "Enabled",
	CurrentValue = false,
	Flag = "customlmstoggle",
	Callback = function(valuse)
		toggon = valuse
		if toggon then
			loopcn = runsrv.RenderStepped:Connect(function()
				local themes = wrkspc:FindFirstChild("Themes")
				if themes then
					local lastsnd = themes:FindFirstChild("LastSurvivor")
					if lastsnd and lastsnd:IsA("Sound") and sndsel ~= "" then
						lastsnd.SoundId = getcustomasset(sndsel)
					end
				end
			end)
		else
			if loopcn then
				loopcn:Disconnect()
				loopcn = nil
			end
		end
	end,
})

Tab4:CreateSection("Kinda Blatant i guess.")

Tab4:CreateLabel("You can only dash while using the A or D keybind.", "proportions")

Tab4:CreateKeybind({
   Name = "Dash",
   CurrentKeybind = "V",
   HoldToInteract = false,
   Flag = "DashKeybind",
   Callback = function()
      local plr = game.Players.LocalPlayer
      local uis = game:GetService("UserInputService")
      local tween_service = game:GetService("TweenService")
      local camera = workspace.CurrentCamera

      local move_input = Vector3.zero
      local can_dash = true
      local dash_distance = 8
      local dash_duration = 0.3
      local dash_cooldown = 0

      local function setup_character(chr)
         local humrp = chr:WaitForChild("HumanoidRootPart")

         uis.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.W then move_input = move_input + Vector3.new(0, 0, 1) end
            if input.KeyCode == Enum.KeyCode.S then move_input = move_input + Vector3.new(0, 0, -1) end
            if input.KeyCode == Enum.KeyCode.A then move_input = move_input + Vector3.new(-1, 0, 0) end
            if input.KeyCode == Enum.KeyCode.D then move_input = move_input + Vector3.new(1, 0, 0) end
         end)

         uis.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then move_input = move_input - Vector3.new(0, 0, 1) end
            if input.KeyCode == Enum.KeyCode.S then move_input = move_input - Vector3.new(0, 0, -1) end
            if input.KeyCode == Enum.KeyCode.A then move_input = move_input - Vector3.new(-1, 0, 0) end
            if input.KeyCode == Enum.KeyCode.D then move_input = move_input - Vector3.new(1, 0, 0) end
         end)

         uis.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.V and can_dash then
               if move_input.X == 0 or move_input.Z ~= 0 then return end
               can_dash = false

               local cam_cf = camera.CFrame
               local move_dir = (cam_cf.RightVector * move_input.X).Unit
               local target_pos = humrp.Position + (move_dir * dash_distance)

               local tween = tween_service:Create(humrp, TweenInfo.new(dash_duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                  CFrame = CFrame.new(target_pos)
               })
               tween:Play()

               task.delay(dash_cooldown, function()
                  can_dash = true
               end)
            end
         end)
      end

      local chr = plr.Character or plr.CharacterAdded:Wait()
      setup_character(chr)

      plr.CharacterAdded:Connect(setup_character)
   end,
})

Tab4:CreateKeybind({
	Name = "Fortnite Flip",
	CurrentKeybind = "P",
	HoldToInteract = false,
	Flag = "flip_keybind",
	Callback = function()
		local flip_cooldown = false
		if flip_cooldown then return end
		flip_cooldown = true

		local character = game:GetService("Players").LocalPlayer.Character
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
		if not hrp or not humanoid then
			flip_cooldown = false
			return
		end

		local saved_tracks = {}

		if animator then
			for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
				saved_tracks[#saved_tracks + 1] = { track = track, time = track.TimePosition }
				track:Stop(0)
			end
		end

		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)

		local duration = 0.45
		local steps = 120
		local start_cframe = hrp.CFrame
		local forward_vector = start_cframe.LookVector
		local up_vector = Vector3.new(0, 1, 0)

		task.spawn(function()
			local start_time = tick()
			for i = 1, steps do
				local t = i / steps
				local height = 4 * (t - t ^ 2) * 10
				local next_pos = start_cframe.Position + forward_vector * (35 * t) + up_vector * height
				local rotation = start_cframe.Rotation * CFrame.Angles(-math.rad(i * (360 / steps)), 0, 0)

				hrp.CFrame = CFrame.new(next_pos) * rotation
				local elapsed_time = tick() - start_time
				local expected_time = (duration / steps) * i
				local wait_time = expected_time - elapsed_time
				if wait_time > 0 then
					task.wait(wait_time)
				end
			end

			hrp.CFrame = CFrame.new(start_cframe.Position + forward_vector * 35) * start_cframe.Rotation
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
			humanoid:ChangeState(Enum.HumanoidStateType.Running)

			if animator then
				for _, data in ipairs(saved_tracks) do
					local track = data.track
					track:Play()
					track.TimePosition = data.time
				end
			end

			task.wait(0.25)
			flip_cooldown = false
		end)
	end,
})

Tab4:CreateSection("Other Things")

Tab4:CreateButton({
	Name = "Open Chat",
	Description = "Disables Stun when getting stunned.",
	Callback = function()
		local runservice = game:GetService("RunService")
		local textchatservice = game:GetService("TextChatService")

		runservice.RenderStepped:Connect(function()
			local config = textchatservice:FindFirstChild("ChatWindowConfiguration")
			if config and config:IsA("ChatWindowConfiguration") then
				config.Enabled = true
			end
		end)
	end
})

Tab4:CreateToggle({
   Name = "Disable Privacy",
   CurrentValue = false,
   Flag = "HideStatsToggle",
   Callback = function(Value)
      local local_player = game.Players.LocalPlayer
      local original_values = {}

      local function store_originals()
         original_values = {}
         for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= local_player then
               for _, descendant in ipairs(player:GetDescendants()) do
                  if descendant:IsA("BoolValue") and (
                     descendant.Name == "HideKillerWins" or
                     descendant.Name == "HidePlaytime" or
                     descendant.Name == "HideSurvivorWins") then

                     original_values[descendant] = descendant.Value
                  end
               end
            end
         end
      end

      local running = true

      task.spawn(function()
         while running and Value do
            for _, player in ipairs(game.Players:GetPlayers()) do
               if player ~= local_player then
                  for _, descendant in ipairs(player:GetDescendants()) do
                     if descendant:IsA("BoolValue") and (
                        descendant.Name == "HideKillerWins" or
                        descendant.Name == "HidePlaytime" or
                        descendant.Name == "HideSurvivorWins") then

                        if original_values[descendant] == nil then
                           original_values[descendant] = descendant.Value
                        end

                        descendant.Value = false
                     end
                  end
               end
            end
            task.wait(1)
         end
      end)

      if Value then
         store_originals()
      else
         running = false
         for obj, val in pairs(original_values) do
            if obj and obj.Parent then
               obj.Value = val
            end
         end
      end
   end,
})

Tab4:CreateButton({ 
   Name = "Disable Nametags", 
   Callback = function()
      task.spawn(function()
         while true do
            local nametags = game:GetService("ReplicatedStorage"):FindFirstChild("Systems")
            if nametags then
               nametags = nametags:FindFirstChild("Character")
               if nametags then
                  nametags = nametags:FindFirstChild("Game")
                  if nametags then
                     local target = nametags:FindFirstChild("Nametags")
                     if target then
                        target:Destroy()
                     end
                  end
               end
            end
            task.wait(1)
         end
      end)
   end,
})

local Tab9 = Window:CreateTab("Emotes", "book")

Tab9:CreateSection("Ingame emotes, Including secret and unreleased ones. Other players wont hear the sound.")

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local rs = game:GetService("ReplicatedStorage")

local assets = rs:FindFirstChild("Assets")
local emotesFolder = assets and assets:FindFirstChild("Emotes")
local emotes = {}

local track = nil
local sound = nil

local function stop()
	if track then
		track:Stop()
		track:Destroy()
		track = nil
	end
	if sound then
		sound:Stop()
		sound:Destroy()
		sound = nil
	end
end

if emotesFolder then
	for _, m in pairs(emotesFolder:GetChildren()) do
		if m:IsA("ModuleScript") then
			local ok, data = pcall(require, m)
			if ok and typeof(data) == "table" and typeof(data.AssetID) == "string" then
				emotes[m.Name] = data
			end
		end
	end
end

for name, data in pairs(emotes) do
	Tab9:CreateButton({
		Name = name,
		Callback = function()
			stop()
			char = plr.Character or plr.CharacterAdded:Wait()
			hum = char:WaitForChild("Humanoid")

			local anim = Instance.new("Animation")
			anim.AnimationId = data.AssetID
			track = hum:LoadAnimation(anim)
			track:Play()

			if data.SFX and typeof(data.SFX) == "string" then
				sound = Instance.new("Sound")
				sound.SoundId = data.SFX
				sound.Volume = 1
				sound.Parent = char:FindFirstChild("Head") or char
				sound:Play()
			end
		end,
	})
end

hum:GetPropertyChangedSignal("MoveDirection"):Connect(function()
	if hum.MoveDirection.Magnitude > 0 then
		stop()
	end
end)

local Tab6 = Window:CreateTab("Credits", "book-heart")

Tab6:CreateSection("Who made this dam script?!?!?!?!?!")

Tab6:CreateLabel("The owner of this script is jzexok on discord.", "volume-2")

Tab6:CreateParagraph({Title = "🎉🚚💨", Content = "This script is not paid and has a discord server, to join our discord server you can copy the link with the button below."})

Tab6:CreateDivider()

Tab6:CreateButton({
   Name = "Copy Discord Server Link",
   Callback = function()
   setclipboard("https://discord.gg/7ya5axvynf")
   end,
})
