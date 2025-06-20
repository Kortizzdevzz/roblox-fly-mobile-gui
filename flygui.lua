--[[
    Roblox Fly Script (LocalScript)
    Características:
    - Ao ativar, o personagem voa para frente continuamente.
    - O movimento é controlado apenas ao virar a câmera (direção do olhar).
    - Um botão (GUI) ativa/desativa o fly.
    - Para LocalScript, coloque em StarterPlayerScripts ou StarterCharacterScripts.
--]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- UI Button Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 120, 0, 40)
flyButton.Position = UDim2.new(0, 20, 0, 90)
flyButton.Text = "Ativar Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 20
flyButton.Parent = screenGui

-- Fly Variables
local flying = false
local flySpeed = 60 -- Ajuste a velocidade aqui

local bodyVelocity = nil

-- Função para iniciar o Fly
local function startFly()
    if not flying then
        flying = true
        flyButton.Text = "Desativar Fly"
        -- Cria BodyVelocity
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        bodyVelocity.P = 5000
        bodyVelocity.Parent = humanoidRootPart
        
        -- Loop de voo
        RunService:BindToRenderStep("FlyForward", Enum.RenderPriority.Input.Value, function()
            if flying and character and humanoidRootPart then
                -- Move sempre na direção da câmera
                local camera = workspace.CurrentCamera
                local forward = camera.CFrame.LookVector
                bodyVelocity.Velocity = forward * flySpeed
                -- Mantém o personagem um pouco acima do solo
                humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end

-- Função para parar o Fly
local function stopFly()
    if flying then
        flying = false
        flyButton.Text = "Ativar Fly"
        RunService:UnbindFromRenderStep("FlyForward")
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
end

-- Botão de ativar/desativar
flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

-- (Opcional) Atalho no teclado: tecla F
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        if flying then
            stopFly()
        else
            startFly()
        end
    end
end)

-- Limpa o Fly se morrer
player.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    stopFly()
end)
