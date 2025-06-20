-- Script Roblox: FLY para Mobile/PC SEM BOTÕES VIRTUAIS
-- Execute este script em um executor. Aperte 'F' para ativar/desativar o fly no PC.
-- No mobile, use o joystick para mover e toque no canto superior direito para alternar o fly.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local flying = false
local flySpeed = 60
local flyConn

-- Função para criar BodyVelocity
local function createBV(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = hrp
    return bv
end

-- Função de ativar o fly
local function startFly()
    if flying then return end
    flying = true
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not humanoid then return end

    local bv = createBV(char)
    humanoid.PlatformStand = true

    flyConn = RunService.Heartbeat:Connect(function()
        if not flying or not bv or not bv.Parent then return end
        local moveDir = humanoid.MoveDirection
        local cam = workspace.CurrentCamera
        local vel = Vector3.new(0,0,0)

        if moveDir.Magnitude > 0 then
            vel = ((cam.CFrame.LookVector * -moveDir.Z) + (cam.CFrame.RightVector * moveDir.X)) * flySpeed
        end

        -- PC: Espaço = subir, Shift = descer
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vel = vel + Vector3.new(0, flySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            vel = vel + Vector3.new(0, -flySpeed, 0)
        end

        bv.Velocity = vel
    end)
end

-- Função de desativar o fly
local function stopFly()
    flying = false
    if flyConn then flyConn:Disconnect() flyConn = nil end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local bv = char.HumanoidRootPart:FindFirstChild("BodyVelocity")
        if bv then bv:Destroy() end
    end
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.PlatformStand = false end
end

-- Atalho PC: Tecla F alterna fly
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then stopFly() else startFly() end
    end
end)

-- Atalho Mobile: Tocar no canto superior direito alterna fly
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    local touched = false
    UserInputService.TouchStarted:Connect(function(touch, gp)
        if touched then return end
        if touch.Position.X > (workspace.CurrentCamera.ViewportSize.X - 80) and touch.Position.Y < 80 then
            touched = true
            if flying then stopFly() else startFly() end
            wait(0.5)
            touched = false
        end
    end)
end

-- Parar o fly se morrer
player.CharacterRemoving:Connect(function()
    stopFly()
end)

print("FLY carregado! Tecla F (PC) ou toque no canto direito (mobile) para ativar/desativar.")
