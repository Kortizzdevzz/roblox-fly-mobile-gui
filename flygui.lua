local player = game.Players.LocalPlayer
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
local flySpeed = 60
local flyConn
local bodyVel

local function stopFly()
    flying = false
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    flyBtn.Text = "FLY"
end

local function startFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Remove PlatformStand para não travar animações nem pular
    hum.PlatformStand = false

    if not bodyVel then
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVel.Velocity = Vector3.new(0,0,0)
        bodyVel.Parent = hrp
    end

    flyConn = game:GetService("RunService").Heartbeat:Connect(function()
        if not flying then return end
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then stopFly() return end
        local moveDir = hum.MoveDirection
        -- Use a direção do joystick para voar, senão mantém no ar
        if moveDir.Magnitude > 0 then
            bodyVel.Velocity = (Vector3.new(moveDir.X, 0, moveDir.Z).Unit * flySpeed) + Vector3.new(0, flySpeed/2, 0)
        else
            bodyVel.Velocity = Vector3.new(0, flySpeed/2, 0)
        end
    end)
    flyBtn.Text = "UNFLY"
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        flying = true
        startFly()
    end
end)

-- Desativa o fly ao resetar/morrer
player.CharacterAdded:Connect(function(char)
    stopFly()
    char:WaitForChild("Humanoid").Died:Connect(function()
        stopFly()
    end)
end)

if player.Character then
    player.Character:WaitForChild("Humanoid").Died:Connect(function()
        stopFly()
    end)
end
