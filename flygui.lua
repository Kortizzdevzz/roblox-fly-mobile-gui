--[[
    Roblox LocalScript: HUB com várias funções, incluindo Fly
    Agora com botão para abrir/fechar o HUB em dispositivos mobile!
    Coloque este LocalScript em StarterPlayerScripts ou StarterCharacterScripts
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variáveis do Fly
local flying = false
local flySpeed = 50
local bodyVelocity = nil

-- Função de Fly
local function startFly()
    if flying then return end
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bodyVelocity.P = 15000
    bodyVelocity.Parent = humanoidRootPart

    RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Input.Value, function()
        if flying then
            local camera = workspace.CurrentCamera
            bodyVelocity.Velocity = camera.CFrame.LookVector * flySpeed
        end
    end)
end

local function stopFly()
    if not flying then return end
    flying = false
    RunService:UnbindFromRenderStep("FlyControl")
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

-- Função para garantir que para o fly ao morrer/reaparecer
player.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    stopFly()
end)

-- GUI do HUB
local gui = Instance.new("ScreenGui")
gui.Name = "MeuHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Fundo do painel
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 200)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Meu HUB"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = mainFrame

-- Botão do Fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 120, 0, 40)
flyButton.Position = UDim2.new(0, 20, 0, 60)
flyButton.Text = "Ativar Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 20
flyButton.Parent = mainFrame

-- Exemplo: botão extra para expandir o HUB
local infoButton = Instance.new("TextButton")
infoButton.Size = UDim2.new(0, 120, 0, 40)
infoButton.Position = UDim2.new(0, 20, 0, 110)
infoButton.Text = "Info"
infoButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
infoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infoButton.Font = Enum.Font.SourceSansBold
infoButton.TextSize = 20
infoButton.Parent = mainFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, 140, 0, 40)
infoLabel.Position = UDim2.new(0, 160, 0, 110)
infoLabel.BackgroundTransparency = 0.5
infoLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
infoLabel.Text = ""
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 18
infoLabel.Visible = false
infoLabel.Parent = mainFrame

-- Lógica do botão Fly
flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyButton.Text = "Ativar Fly"
    else
        startFly()
        flyButton.Text = "Desativar Fly"
    end
end)

-- Lógica do botão Info
infoButton.MouseButton1Click:Connect(function()
    infoLabel.Visible = not infoLabel.Visible
    if infoLabel.Visible then
        infoLabel.Text = "Exemplo de HUB\nScript by Kortizzdevzz"
    else
        infoLabel.Text = ""
    end
end)

-- Botão para abrir/fechar o HUB (Mobile Friendly)
local openCloseButton = Instance.new("ImageButton")
openCloseButton.Size = UDim2.new(0, 60, 0, 60)
openCloseButton.Position = UDim2.new(0, 20, 0.5, -30)
openCloseButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
openCloseButton.BackgroundTransparency = 0.2
openCloseButton.Image = "rbxassetid://7733960981" -- Ícone de menu/hambúrguer, pode trocar por outro
openCloseButton.Parent = gui

-- Efeito visual no botão
openCloseButton.MouseEnter:Connect(function()
    openCloseButton.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
end)
openCloseButton.MouseLeave:Connect(function()
    openCloseButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
end)

openCloseButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Tecla para abrir/fechar HUB: tecla H (PC)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.H then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Dica para o usuário
local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(0, 350, 0, 30)
hint.Position = UDim2.new(0.5, -175, 1, -40)
hint.BackgroundTransparency = 1
hint.Text = "Pressione H (PC) ou use o botão azul (Mobile) para abrir o HUB"
hint.TextColor3 = Color3.fromRGB(255,255,255)
hint.Font = Enum.Font.SourceSansItalic
hint.TextSize = 20
hint.Parent = gui

task.delay(7, function()
    hint:Destroy()
end)
