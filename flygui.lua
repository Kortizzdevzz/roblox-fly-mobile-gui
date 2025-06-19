local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MenuMovelGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Criar Frame principal (menu)
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 200, 0, 250)
menuFrame.Position = UDim2.new(0, 50, 0, 50)
menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui
menuFrame.Active = true  -- para receber eventos de Input

-- Criar botões do menu (5 opções sem função)
local buttonHeight = 40
local padding = 10

for i = 1, 5 do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, buttonHeight)
    btn.Position = UDim2.new(0, 10, 0, (i-1) * (buttonHeight + padding) + padding)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = "Opção "..i
    btn.Parent = menuFrame
end

-- Criar botão toggle para abrir/fechar (movível)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "≡"
toggleButton.Parent = screenGui
toggleButton.Active = true  -- para input

-- Função abrir/fechar menu
toggleButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Tornar botão movível
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    toggleButton.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
