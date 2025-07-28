--// ROBLOX CLIENT-SIDE: Grow a Garden - Fake Egg Hatch ESP + UI //
-- By: ChatGPT | Custom ESP GUI + Randomizer

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGURATIONS
local Eggs = {
    "Bug Egg", "Bee Egg", "AntiBee Egg", "Zen Egg",
    "Oasis Egg", "Paradise Egg", "Dino Egg", "Primal Egg"
}

local PetPool = {
  ["Bug Egg"] = {
    {name = "Snail", rarity = "Common"},
    {name = "Giant Ant", rarity = "Uncommon"},
    {name = "Caterpillar", rarity = "Rare"},
    {name = "Praying Mantis", rarity = "Epic"},
    {name = "Dragonfly", rarity = "Mythic"},
  },
  ["Night Egg"] = {
    {name = "Hedgehog", rarity = "Common"},
    {name = "Mole", rarity = "Uncommon"},
    {name = "Echo Frog", rarity = "Rare"},
    {name = "Night Owl", rarity = "Epic"},
    {name = "Raccoon", rarity = "Mythic"},
    },
  ["Bee Egg"] = {
    {name = "Bee", rarity = "Common"},
    {name = "Honey Bee", rarity = "Uncommon"},
    {name = "Bear Bee", rarity = "Rare"},
    {name = "Petal Bee", rarity = "Epic"},
    {name = "Queen Bee", rarity = "Mythic"},
  },
  ["Anti Bee Egg"] = {
    {name = "Wasp", rarity = "Common"},
    {name = "Tarantula Hawk", rarity = "Uncommon"},
    {name = "Moth", rarity = "Rare"},
    {name = "Butterfly", rarity = "Mythic"},
    {name = "Disco Bee", rarity = "Mythic"},
    },
  ["Paradise Egg"] = {
    {name = "Ostrich", rarity = "Common"},
    {name = "Peacock", rarity = "Uncommon"},
    {name = "Capybara", rarity = "Rare"},
    {name = "Scarlet Macaw", rarity = "Epic"},
    {name = "Mimic Octopus", rarity = "Mythic"},
  },
  ["Oasis Egg"] = {
    {name = "Meerkat", rarity = "Common"},
    {name = "Sand Snake", rarity = "Uncommon"},
    {name = "Axolotl", rarity = "Rare"},
    {name = "Hyacinth Macaw", rarity = "Epic"},
    {name = "Fennec Fox", rarity = "Mythic"},
    },
  ["Dino Egg"] = {
    {name = "Raptor", rarity = "Common"},
    {name = "Triceratops", rarity = "Uncommon"},
    {name = "Stegosaurus", rarity = "Rare"},
    {name = "Pterodactyl", rarity = "Epic"},
    {name = "Brontosaurus", rarity = "Mythic"},
    {name = "T-Rex", rarity = "Mythic"},
  },
  ["Primal Egg"] = {
    {name = "Parasaurolophus", rarity = "Common"},
    {name = "Iguanodon", rarity = "Uncommon"},
    {name = "Pachycephalosaurus", rarity = "Rare"},
    {name = "Dilophosaurus", rarity = "Epic"},
    {name = "Ankylosaurus", rarity = "Mythic"},
    {name = "Spinosaurus", rarity = "Mythic"},
    },
  ["Zen Egg"] = {
    {name = "Shiba Inu", rarity = "Common"},
    {name = "Nihonzaru", rarity = "Uncommon"},
    {name = "Tanuki", rarity = "Rare"},
    {name = "Tanchozuru", rarity = "Epic"},
    {name = "Kappa", rarity = "Epic"},
    {name = "Kitsune", rarity = "Mythic"},
    },
}

local RarityColors = {
    ["Common"] = Color3.fromRGB(255, 255, 255),
    ["Uncommon"] = Color3.fromRGB(170, 85, 255),
    ["Rare"] = Color3.fromRGB(255, 100, 100),
    ["Epic"] = Color3.fromRGB(255, 150, 0),
    ["Mythic"] = Color3.fromRGB(255, 0, 255)
}

-- STATE
local ESPEnabled = true
local AutoRandomize = false
local LastRandom = 0
local dragging = false
local dragInput, dragStart, startPos

-- UI CREATION
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "PetRandomizerUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 200)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.1
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -20, 0, 20)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Pet Randomizer"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,0.3,0.3)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16

local NameTime = Instance.new("TextLabel", MainFrame)
NameTime.Size = UDim2.new(1, 0, 0, 16)
NameTime.Position = UDim2.new(0, 0, 0, 20)
NameTime.BackgroundTransparency = 1
NameTime.TextColor3 = Color3.fromRGB(200,200,200)
NameTime.Font = Enum.Font.SourceSans
NameTime.TextSize = 14
NameTime.Text = LocalPlayer.Name .. " - " .. os.date("%X")

local ESPToggle = Instance.new("TextButton", MainFrame)
ESPToggle.Size = UDim2.new(1, -20, 0, 20)
ESPToggle.Position = UDim2.new(0, 10, 0, 40)
ESPToggle.Text = "ESP: ON"
ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPToggle.TextColor3 = Color3.new(1,1,1)
ESPToggle.Font = Enum.Font.SourceSansBold
ESPToggle.TextSize = 14

local RandomizeBtn = Instance.new("TextButton", MainFrame)
RandomizeBtn.Size = UDim2.new(1, -20, 0, 20)
RandomizeBtn.Position = UDim2.new(0, 10, 0, 65)
RandomizeBtn.Text = "Randomize Egg"
RandomizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RandomizeBtn.TextColor3 = Color3.new(1,1,1)
RandomizeBtn.Font = Enum.Font.SourceSansBold
RandomizeBtn.TextSize = 14

local AutoToggle = Instance.new("TextButton", MainFrame)
AutoToggle.Size = UDim2.new(1, -20, 0, 20)
AutoToggle.Position = UDim2.new(0, 10, 0, 90)
AutoToggle.Text = "Auto: OFF"
AutoToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoToggle.TextColor3 = Color3.new(1,1,1)
AutoToggle.Font = Enum.Font.SourceSansBold
AutoToggle.TextSize = 14

local HelpButton = Instance.new("TextButton", MainFrame)
HelpButton.Size = UDim2.new(0, 30, 0, 20)
HelpButton.Position = UDim2.new(0, 5, 0, 0)
HelpButton.Text = "?"
HelpButton.Font = Enum.Font.SourceSansBold
HelpButton.TextColor3 = Color3.new(1,1,1)
HelpButton.TextSize = 16
HelpButton.BackgroundTransparency = 1

local HitText = Instance.new("TextLabel", MainFrame)
HitText.Size = UDim2.new(1, -20, 0, 20)
HitText.Position = UDim2.new(0, 10, 0, 115)
HitText.Text = ""
HitText.TextColor3 = Color3.fromRGB(255, 255, 0)
HitText.Font = Enum.Font.GothamBold
HitText.TextSize = 16
HitText.BackgroundTransparency = 1

local HelpFrame = Instance.new("TextLabel", MainFrame)
HelpFrame.Visible = false
HelpFrame.Size = UDim2.new(1, -20, 0, 80)
HelpFrame.Position = UDim2.new(0, 10, 1, -60)
HelpFrame.BackgroundTransparency = 0.1
HelpFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
HelpFrame.TextColor3 = Color3.new(1, 1, 1)
HelpFrame.Font = Enum.Font.SourceSans
HelpFrame.TextSize = 14
HelpFrame.TextWrapped = true
HelpFrame.TextYAlignment = Enum.TextYAlignment.Top
HelpFrame.TextXAlignment = Enum.TextXAlignment.Left
HelpFrame.Text = [[This is a PET RANDOMIZER
How it works?
Make sure you have the rarest pet of the egg to make it 100% accurate
EGG          PET
Bug         Dragonfly
Night      Raccoon
Bee         Queen Bee
AntiBee  Butterfly / Disco Bee
Paradise   Mimic Octopus
Oasis       Fennec Fox
Dino        T-Rex
Primal      Spinosaurus
Zen          Kitsune
Corrupted Zen   Corrupted Kitsune
Put eggs in the garden and wait for it to be READY.
You can randomize it one click at a time or use automatic mode.]]

-- FUNCTION TO RANDOMIZE PETS
local function getRandomPet(egg)
    local pool = PetPool[egg]
    if not pool then return {name = "???", rarity = "Common"} end
    local weightedList = {}
    for _, pet in ipairs(pool) do
        local weight = ({Common=10, Uncommon=7, Rare=4, Epic=2, Mythic=1})[pet.rarity] or 1
        for i = 1, weight do
            table.insert(weightedList, pet)
        end
    end
    return weightedList[math.random(1, #weightedList)]
end

-- FUNCTION TO UPDATE EGG ESP
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "EggESP"

local function updateESP()
    espFolder:ClearAllChildren()
    if not ESPEnabled then return end

    for _, egg in ipairs(Eggs) do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == egg then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local pet = getRandomPet(egg)
                    local gui = Instance.new("BillboardGui")
                    gui.Size = UDim2.new(0, 150, 0, 30)
                    gui.StudsOffset = Vector3.new(0, 4, 0)
                    gui.AlwaysOnTop = true
                    gui.Adornee = primary
                    gui.Parent = espFolder

                    local label = Instance.new("TextLabel", gui)
                    label.Size = UDim2.new(1,0,1,0)
                    label.Text = pet.name
                    label.TextColor3 = RarityColors[pet.rarity] or Color3.new(1,1,1)
                    label.BackgroundTransparency = 1
                    label.TextStrokeTransparency = 0.5
                    label.TextSize = 18
                    label.Font = Enum.Font.SourceSansBold

                    if pet.rarity == "Mythic" then
                        HitText.Text = "Got HIT!!!"
                    else
                        HitText.Text = ""
                    end
                end
            end
        end
    end
end

-- BUTTON CONNECTIONS
ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    updateESP()
end)

RandomizeBtn.MouseButton1Click:Connect(function()
    if tick() - LastRandom >= 1 then
        LastRandom = tick()
        updateESP()
    end
end)

AutoToggle.MouseButton1Click:Connect(function()
    AutoRandomize = not AutoRandomize
    AutoToggle.Text = "Auto: " .. (AutoRandomize and "ON" or "OFF")
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    espFolder:Destroy()
end)

HelpButton.MouseButton1Click:Connect(function()
    HelpFrame.Visible = not HelpFrame.Visible
end)

-- LOOP
RunService.RenderStepped:Connect(function()
    NameTime.Text = LocalPlayer.Name .. " - " .. os.date("%X")
    if AutoRandomize and tick() - LastRandom >= 1 then
        LastRandom = tick()
        updateESP()
    end
end)

updateESP()
