local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local startPos = CFrame.new(696, 3, 240)
local fileName = "SystemSettings.json"
local HttpService = game:GetService("HttpService")

local function saveConfig(data)
    if writefile then
        writefile(fileName, HttpService:JSONEncode(data))
    end
end

local function loadConfig()
    if isfile and isfile(fileName) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(fileName))
        end)
        if success then return result end
    end
    return {isRunning = false} -- Default if no file found
end

local config = loadConfig()
local isRunning = config.isRunning

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToggleSystemGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 150, 0, 50)
toggleBtn.Position = UDim2.new(0, 50, 1, -100)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Parent = screenGui

local function updateUI()
    if isRunning then
        toggleBtn.Text = "SYSTEM: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        toggleBtn.Text = "SYSTEM: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        if humanoid then
            humanoid:Move(Vector3.new(0, 0, 0), true)
        end
    end
end

updateUI()

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    saveConfig({isRunning = isRunning})
    updateUI()
end)

RunService.RenderStepped:Connect(function()
    if isRunning and humanoid and rootPart then
        humanoid:Move(Vector3.new(0, 0, -1), true)
        local currentPos = rootPart.Position
        if currentPos.X > 708 or currentPos.Z > 290 then
            rootPart.CFrame = startPos
        end
    end
end)

task.spawn(function()
    while true do
        if isRunning then
            local networkPath = game:GetService("ReplicatedStorage")
                :WaitForChild("Shared")
                :WaitForChild("Packages")
                :WaitForChild("Network")
                :FindFirstChild("rev_KickEvent")

            if networkPath then
                networkPath:FireServer(0.9527527689933777)
            end
        end
        task.wait(1.5)
    end
end)
