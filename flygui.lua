local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "FlyPanel"
gui.Parent = player.PlayerGui

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 120, 0, 40)
flyBtn.Position = UDim2.new(0, 20, 0, 130)
flyBtn.Text = "FLY"
flyBtn.BackgroundColor3 = Color3.fromRGB(70, 180, 255)
flyBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextScaled = true
flyBtn.Parent = gui

local flying = false
local flySpeed = 50
local flyConnection = nil
local bodyVel = nil

local function stopFly()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
    end
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end
    flyBtn.Text = "FLY"
end

local function startFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    hum.PlatformStand = true

    if not bodyVel then
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.Parent = hrp
    end

    flyBtn.Text = "UNFLY"

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then stopFly() return end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            bodyVel.Velocity = Vector3.new(moveDir.X, 0, moveDir.Z).Unit * flySpeed + Vector3.new(0, 2, 0)
        else
            bodyVel.Velocity = Vector3.new(0, 2, 0)
        end
    end)
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        flying = true
        startFly()
    end
end)

player.CharacterAdded:Connect(function()
    stopFly()
end)

-- Garante que o fly para se o personagem morrer
if player.Character then
    player.Character:WaitForChild("Humanoid").Died:Connect(function()
        stopFly()
    end)
end
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        stopFly()
    end)
end)
