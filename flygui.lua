--[[
    Roblox Local Script: Fly (Mobile/PC sem botões virtuais de direção)
    - Ative/desative com um botão (mobile)
    - Ao ativar, o personagem voa para frente continuamente (direção da câmera)
    - Movimente para os lados apenas girando a tela/câmera
    - Sem botões virtuais de direção

    Coloque este script em StarterPlayerScripts.
--]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local flying = false
local flySpeed = 40

-- Botão Fly para mobile
local function createFlyButton()
    -- Só exibe no mobile
    if not UIS.TouchEnabled then return nil end

    local button = Instance.new("TextButton")
    button.Name = "FlyToggleButton"
    button.Text = "FLY"
    button.Size = UDim2.new(0, 100, 0, 50)
    button.Position = UDim2.new(1, -110, 1, -60)
    button.AnchorPoint = Vector2.new(0, 0)
    button.BackgroundTransparency = 0.3
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.ZIndex = 10
    button.Parent = StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false) and player.PlayerGui or player.PlayerGui

    return button
end

-- Fly loop
local flyConn
local function startFlying()
    if flyConn then flyConn:Disconnect() end
    flying = true

    flyConn = RunService.RenderStepped:Connect(function(dt)
        if not flying then return end
        if not character or not character.Parent then return end
        if not humanoidRoot or not humanoidRoot.Parent then return end

        -- Direção da câmera
        local camCF = camera.CFrame
        local moveDir = camCF.LookVector

        -- Move suavemente para frente
        humanoidRoot.Velocity = moveDir * flySpeed
        -- Mantém sempre no ar
        humanoidRoot.AssemblyLinearVelocity = moveDir * flySpeed
    end)
end

local function stopFlying()
    flying = false
    if flyConn then flyConn:Disconnect() end
    -- Para o movimento ao desligar
    if humanoidRoot then
        humanoidRoot.Velocity = Vector3.new(0, 0, 0)
        humanoidRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end

-- PC: Use "F" para ativar/desativar o fly
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if UIS.TouchEnabled then return end -- só PC
    if input.KeyCode == Enum.KeyCode.F then
        if not flying then
            startFlying()
        else
            stopFlying()
        end
    end
end)

-- Mobile: Botão
local button = createFlyButton()
if button then
    button.MouseButton1Click:Connect(function()
        if not flying then
            button.Text = "UNFLY"
            startFlying()
        else
            button.Text = "FLY"
            stopFlying()
        end
    end)
end

-- Garante que ao respawn funcione
player.CharacterAdded:Connect(function(char)
    character = char
    humanoidRoot = character:WaitForChild("HumanoidRootPart")
    stopFlying()
    if button then button.Text = "FLY" end
end)

-- Dica para PC
if not UIS.TouchEnabled then
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Fly] Pressione 'F' para ativar/desativar o Fly!";
        Color = Color3.new(0, 1, 1);
        Font = Enum.Font.SourceSansBold;
        FontSize = Enum.FontSize.Size24;
    })
end

-- Observação: Não há botões virtuais de direção, só o botão de ativar/desativar fly no mobile.
