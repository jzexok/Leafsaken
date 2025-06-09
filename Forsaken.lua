local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function RemoveEspFromCharacter(Character)
    local Highlight = Character:FindFirstChild("PlayerHighlight")
    if Highlight then
        Highlight:Destroy()
    end
    local Head = Character:FindFirstChild("Head")
    if Head then
        local NameEsp = Head:FindFirstChild("NameEsp")
        if NameEsp then
            NameEsp:Destroy()
        end
    end
end

local function ApplyHighlight(Player)
    if Player == LocalPlayer then return end
    local Character = Player.Character
    if Character and not Character:FindFirstChild("PlayerHighlight") and Character.Parent and Character.Parent.Name ~= "Ragdolls" then
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "PlayerHighlight"
        Highlight.FillTransparency = 0.9
        Highlight.OutlineTransparency = 0.7
        Highlight.OutlineColor = Color3.new(1, 1, 1) -- Beyaz outline
        if Character.Parent.Name == "Survivors" then
            Highlight.FillColor = Color3.fromRGB(0, 255, 0)
        elseif Character.Parent.Name == "Killers" then
            Highlight.FillColor = Color3.fromRGB(255, 0, 0)
        end
        Highlight.Parent = Character
    elseif Character and Character.Parent and Character.Parent.Name == "Ragdolls" then
        RemoveEspFromCharacter(Character)
    end
end

local function ApplyNameEsp(Player)
    if Player == LocalPlayer then return end
    local Character = Player.Character
    if Character and Character:FindFirstChild("Head") and Character.Parent and Character.Parent.Name ~= "Ragdolls" and not Character.Head:FindFirstChild("NameEsp") then
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "NameEsp"
        BillboardGui.Adornee = Character.Head
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(0, 100, 0, 30)
        BillboardGui.StudsOffset = Vector3.new(0, 2, 0)

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = BillboardGui
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = Player.Name
        TextLabel.Font = Enum.Font.Gotham -- Daha temiz font, Montserrat değil
        TextLabel.TextSize = 14
        TextLabel.TextScaled = false
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Beyaz outline
        TextLabel.TextStrokeTransparency = 0
        if Character.Parent.Name == "Survivors" then
            TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif Character.Parent.Name == "Killers" then
            TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        else
            TextLabel.TextColor3 = Color3.new(1, 1, 1)
        end

        BillboardGui.Parent = Character.Head
    elseif Character and Character.Parent and Character.Parent.Name == "Ragdolls" then
        RemoveEspFromCharacter(Character)
    end
end

local function OnCharacterParentChanged(Character)
    Character:GetPropertyChangedSignal("Parent"):Connect(function()
        if Character.Parent and Character.Parent.Name == "Ragdolls" then
            RemoveEspFromCharacter(Character)
        end
    end)
end

local function ApplyEspForAllPlayers()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player.Character then
            ApplyHighlight(Player)
            ApplyNameEsp(Player)
            OnCharacterParentChanged(Player.Character)
        end
        Player.CharacterAdded:Connect(function(Character)
            ApplyHighlight(Player)
            ApplyNameEsp(Player)
            OnCharacterParentChanged(Character)
        end)
    end
end

ApplyEspForAllPlayers()

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        ApplyHighlight(Player)
        ApplyNameEsp(Player)
        OnCharacterParentChanged(Character)
    end)
end)
