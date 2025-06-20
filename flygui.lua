local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- Cria o painel de ativação do fly
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FlyPanel"

local flyBtn = Instance.new("TextButton", gui)
flyBtn.Size = UDim2.new(0, 120, 0, 40)
flyBtn.Position = UDim2.new(0, 20, 0, 130)
flyBtn.Text = "FLY"
flyBtn.BackgroundColor3 = Color3.fromRGB(70, 180, 255)
flyBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextScaled = true
flyBtn.Active = true

local flying = false
local flySpeed = 60

local bodyVel = nil
local connection = nil

local function startFly()
    if not bodyVel then
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
        bodyVel.Velocity = Vector3.new(0,0,0)
        bodyVel.Parent = hrp
    end
    humanoid.PlatformStand = true

    connection = game:GetService("RunService").RenderStepped:Connect(function()
        -- Usa o MoveDirection do Humanoid, que é preenchido pelo joystick no mobile
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            bodyVel.Velocity = Vector3.new(moveDir.X, 0, moveDir.Z).Unit * flySpeed + Vector3.new(0, 2, 0)
        else
            bodyVel.Velocity = Vector3.new(0, 2, 0) -- Mantém o player no ar
        end
    end)
end

local function stopFly()
    humanoid.PlatformStand = false
    if bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
    end
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.Text = "UNFLY"
        startFly()
    else
        flyBtn.Text = "FLY"
        stopFly()
    end
end)

-- Garante que o fly para se o personagem morrer ou for resetado
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
    stopFly()
    flying = false
    flyBtn.Text = "FLY"
end)
