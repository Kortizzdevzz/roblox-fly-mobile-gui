--[[
    Roblox LocalScript: HUB com várias funções, incluindo Fly
    Layout moderno, botão abrir/fechar (mobile e PC), e título do HUB piscando em RGB!
    Créditos "Source By Tentacions" em RGB dentro do painel.
    Coloque este LocalScript em StarterPlayerScripts ou StarterCharacterScripts.
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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

-- Sombra
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(0, 350, 0, 240)
shadow.Position = UDim2.new(0.5, -175, 0.5, -120)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.4
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Visible = false
shadow.Parent = gui
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.ClipsDescendants = false
shadow.Name = "Shadow"
shadow.Rotation = 3
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 24)
shadowCorner.Parent = shadow

-- Fundo do painel principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 330, 0, 220)
mainFrame.Position = UDim2.new(0.5, -165, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(34, 39, 54)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = gui
mainFrame.ZIndex = 1

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(60, 110, 200)
mainStroke.Transparency = 0.25
mainStroke.Parent = mainFrame

-- Título RGB (PISCANDO)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 48)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌐 Meu HUB"
title.Font = Enum.Font.FredokaOne
title.TextSize = 32
title.TextColor3 = Color3.fromRGB(169, 206, 255)
title.ZIndex = 2
title.Parent = mainFrame

-- Efeito RGB piscando no título
spawn(function()
    local t = 0
    while true do
        t = t + 0.05
        local r = math.abs(math.sin(t)) * 255
        local g = math.abs(math.sin(t + 2)) * 255
        local b = math.abs(math.sin(t + 4)) * 255
        title.TextColor3 = Color3.fromRGB(r, g, b)
        wait(0.04)
    end
end)

-- Linha decorativa
local decoLine = Instance.new("Frame")
decoLine.Size = UDim2.new(1, -40, 0, 2)
decoLine.Position = UDim2.new(0, 20, 0, 46)
decoLine.BackgroundColor3 = Color3.fromRGB(60, 110, 200)
decoLine.BorderSizePixel = 0
decoLine.ZIndex = 2
decoLine.Parent = mainFrame

-- Container dos botões
local buttonHolder = Instance.new("Frame")
buttonHolder.Size = UDim2.new(1, -40, 0, 110)
buttonHolder.Position = UDim2.new(0, 20, 0, 60)
buttonHolder.BackgroundTransparency = 1
buttonHolder.ZIndex = 2
buttonHolder.Parent = mainFrame

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Top
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Padding = UDim.new(0, 16)
buttonLayout.Parent = buttonHolder

-- Botão do Fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 130, 0, 44)
flyButton.BackgroundColor3 = Color3.fromRGB(54, 104, 217)
flyButton.Text = "🛩️ Ativar Fly"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.FredokaOne
flyButton.TextSize = 22
flyButton.Parent = buttonHolder
flyButton.AutoButtonColor = true
flyButton.LayoutOrder = 1

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 12)
flyCorner.Parent = flyButton

local flyStroke = Instance.new("UIStroke")
flyStroke.Color = Color3.fromRGB(80, 150, 255)
flyStroke.Thickness = 1.5
flyStroke.Transparency = 0.15
flyStroke.Parent = flyButton

-- Lógica do botão Fly
flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyButton.Text = "🛩️ Ativar Fly"
    else
        startFly()
        flyButton.Text = "🛑 Desativar Fly"
    end
end)

-- Créditos RGB
local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, -24, 0, 28)
creditLabel.Position = UDim2.new(0, 12, 1, -34)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "Source By Tentacions"
creditLabel.Font = Enum.Font.FredokaOne
creditLabel.TextSize = 22
creditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
creditLabel.TextStrokeTransparency = 0.5
creditLabel.ZIndex = 2
creditLabel.Parent = mainFrame

spawn(function()
    local t = 0
    while true do
        t = t + 0.04
        local r = math.abs(math.sin(t)) * 255
        local g = math.abs(math.sin(t + 2)) * 255
        local b = math.abs(math.sin(t + 4)) * 255
        creditLabel.TextColor3 = Color3.fromRGB(r, g, b)
        wait(0.04)
    end
end)

-- Botão para abrir/fechar o HUB (Mobile + PC)
local openCloseButton = Instance.new("ImageButton")
openCloseButton.Size = UDim2.new(0, 56, 0, 56)
openCloseButton.Position = UDim2.new(0, 24, 0.5, -28)
openCloseButton.BackgroundColor3 = Color3.fromRGB(44, 49, 74)
openCloseButton.BackgroundTransparency = 0.1
openCloseButton.Image = "rbxassetid://7733960981" -- Ícone de menu/hambúrguer
openCloseButton.Parent = gui
openCloseButton.ZIndex = 10

local openCloseCorner = Instance.new("UICorner")
openCloseCorner.CornerRadius = UDim.new(1, 0)
openCloseCorner.Parent = openCloseButton

local openCloseStroke = Instance.new("UIStroke")
openCloseStroke.Color = Color3.fromRGB(80, 150, 255)
openCloseStroke.Thickness = 1
openCloseStroke.Transparency = 0.25
openCloseStroke.Parent = openCloseButton

-- Efeito de hover no botão
openCloseButton.MouseEnter:Connect(function()
    openCloseButton.BackgroundColor3 = Color3.fromRGB(80, 110, 170)
end)
openCloseButton.MouseLeave:Connect(function()
    openCloseButton.BackgroundColor3 = Color3.fromRGB(44, 49, 74)
end)

local function abrirHub()
    shadow.Visible = true
    mainFrame.Visible = true
    -- Transição suave
    mainFrame.Position = UDim2.new(0.5, -165, 0.5, -150)
    shadow.Position = UDim2.new(0.5, -175, 0.5, -160)
    TweenService:Create(mainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -165, 0.5, -110)}):Play()
    TweenService:Create(shadow, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -175, 0.5, -120)}):Play()
end

local function fecharHub()
    TweenService:Create(mainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -165, 0.5, -150)}):Play()
    TweenService:Create(shadow, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -175, 0.5, -160)}):Play()
    task.wait(0.18)
    mainFrame.Visible = false
    shadow.Visible = false
end

openCloseButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then
        fecharHub()
    else
        abrirHub()
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.H then
        if mainFrame.Visible then
            fecharHub()
        else
            abrirHub()
        end
    end
end)

-- Dica para o usuário
local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(0, 400, 0, 34)
hint.Position = UDim2.new(0.5, -200, 1, -44)
hint.BackgroundTransparency = 1
hint.Text = "Pressione H (PC) ou use o botão azul (Mobile/PC) para abrir o HUB"
hint.TextColor3 = Color3.fromRGB(180,210,255)
hint.Font = Enum.Font.FredokaOne
hint.TextSize = 20
hint.TextStrokeTransparency = 0.8
hint.Parent = gui
hint.ZIndex = 10

task.delay(6, function()
    if hint and hint.Parent then
        TweenService:Create(hint, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.6)
        hint:Destroy()
    end
end)
