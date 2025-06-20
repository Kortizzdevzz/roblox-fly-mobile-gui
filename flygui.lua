-- Script Roblox - Painel FLY Minimizável
-- Execute este script em um executor como Synapse X, KRNL, etc.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variáveis do FLY
local flying = false
local flyConnection = nil
local flySpeed = 50

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyPanel"
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Arredondar cantos
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Header (barra superior)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 30)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "FLY PANEL"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = header

-- Botão Minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -30, 0, 2.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = header

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 4)
minimizeBtnCorner.Parent = minimizeBtn

-- Container do conteúdo
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Botão FLY
local flyBtn = Instance.new("TextButton")
flyBtn.Name = "FlyBtn"
flyBtn.Size = UDim2.new(0, 180, 0, 40)
flyBtn.Position = UDim2.new(0.5, -90, 0, 20)
flyBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
flyBtn.BorderSizePixel = 0
flyBtn.Text = "FLY: OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextScaled = true
flyBtn.Font = Enum.Font.Gotham
flyBtn.Parent = contentFrame

local flyBtnCorner = Instance.new("UICorner")
flyBtnCorner.CornerRadius = UDim.new(0, 6)
flyBtnCorner.Parent = flyBtn

-- Label de velocidade
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 70)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidade: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = contentFrame

-- Slider de velocidade
local speedSlider = Instance.new("Frame")
speedSlider.Name = "SpeedSlider"
speedSlider.Size = UDim2.new(0, 180, 0, 10)
speedSlider.Position = UDim2.new(0.5, -90, 0, 95)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedSlider.BorderSizePixel = 0
speedSlider.Parent = contentFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 5)
sliderCorner.Parent = speedSlider

local sliderFill = Instance.new("Frame")
sliderFill.Name = "Fill"
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.Position = UDim2.new(0, 0, 0, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = speedSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 5)
fillCorner.Parent = sliderFill

-- Variáveis de estado
local isMinimized = false
local originalSize = mainFrame.Size

-- Funções do FLY
local function createFlyBodyVelocity(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    return bodyVelocity
end

local function startFlying()
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not humanoid then return end
    
    local bodyVelocity = createFlyBodyVelocity(character)
    if not bodyVelocity then return end
    
    flying = true
    flyBtn.Text = "FLY: ON"
    flyBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying then return end
        
        local camera = workspace.CurrentCamera
        local moveVector = humanoid.MoveDirection
        local lookVector = camera.CFrame.LookVector
        local rightVector = camera.CFrame.RightVector
        
        local velocity = Vector3.new(0, 0, 0)
        
        -- Movimento baseado na câmera (corrigido)
        if moveVector.Magnitude > 0 then
            velocity = velocity + (lookVector * -moveVector.Z + rightVector * moveVector.X) * flySpeed
        end
        
        -- Controles de subir/descer
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, flySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            velocity = velocity + Vector3.new(0, -flySpeed, 0)
        end
        
        bodyVelocity.Velocity = velocity
    end)
end

local function stopFlying()
    flying = false
    flyBtn.Text = "FLY: OFF"
    flyBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end
end

-- Função de minimizar/maximizar
local function toggleMinimize()
    isMinimized = not isMinimized
    
    local targetSize
    local targetPos = mainFrame.Position
    
    if isMinimized then
        targetSize = UDim2.new(0, 250, 0, 30)
        minimizeBtn.Text = "+"
        contentFrame.Visible = false
    else
        targetSize = originalSize
        minimizeBtn.Text = "-"
        contentFrame.Visible = true
    end
    
    local tween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = targetSize}
    )
    
    tween:Play()
end

-- Função do slider de velocidade
local function updateSpeed(input)
    local sliderPos = speedSlider.AbsolutePosition
    local sliderSize = speedSlider.AbsoluteSize
    local mousePos = input.Position.X
    
    local relativePos = math.clamp((mousePos - sliderPos.X) / sliderSize.X, 0, 1)
    flySpeed = math.floor(relativePos * 100 + 10) -- Velocidade de 10 a 110
    
    sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
    speedLabel.Text = "Velocidade: " .. flySpeed
end

-- Eventos
flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end)

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- Slider events
local dragging = false
speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        updateSpeed(input)
    end
end)

speedSlider.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSpeed(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Limpar quando o personagem morre
player.CharacterRemoving:Connect(function()
    stopFlying()
end)

-- Atalho de teclado (F para ativar/desativar FLY)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        if flying then
            stopFlying()
        else
            startFlying()
        end
    end
end)

print("FLY Panel carregado! Use F para ativar/desativar o FLY rapidamente.")
