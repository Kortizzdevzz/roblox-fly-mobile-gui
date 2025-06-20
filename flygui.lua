local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PainelUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tela de carregamento
local loadingFrame = Instance.new("Frame", screenGui)
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(0.4, 0, 0.1, 0)
loadingText.Position = UDim2.new(0.3, 0, 0.45, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Carregando..."
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.SourceSansBold

-- Botão de abrir painel
local toggleButton = Instance.new("ImageButton", screenGui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
toggleButton.Image = "rbxassetid://6035198845" -- Ícone engrenagem
toggleButton.BackgroundTransparency = 1
toggleButton.Visible = false

-- Painel
local panel = Instance.new("Frame", screenGui)
panel.Size = UDim2.new(0, 300, 0, 250)
panel.Position = UDim2.new(0.5, -150, 1.5, 0) -- Começa fora da tela
panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
panel.Visible = false
panel.BorderSizePixel = 0
panel.ClipsDescendants = true

-- Barra de título
local titleBar = Instance.new("Frame", panel)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Text = "Painel de Funções"
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold

-- Texto de feedback
local feedbackText = Instance.new("TextLabel", screenGui)
feedbackText.Size = UDim2.new(0.5, 0, 0.07, 0)
feedbackText.Position = UDim2.new(0.25, 0, 0.9, 0)
feedbackText.BackgroundTransparency = 0.3
feedbackText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
feedbackText.TextColor3 = Color3.new(1, 1, 1)
feedbackText.TextScaled = true
feedbackText.Visible = false
feedbackText.Font = Enum.Font.Gotham

local function showMessage(text)
	feedbackText.Text = text
	feedbackText.Visible = true
	task.delay(2, function()
		feedbackText.Visible = false
	end)
end

-- Botões com ações
for i = 1, 4 do
	local button = Instance.new("TextButton", panel)
	button.Size = UDim2.new(0.8, 0, 0, 40)
	button.Position = UDim2.new(0.1, 0, 0, 40 + (i - 1) * 50)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.Text = "Função " .. i
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextScaled = true
	button.AutoButtonColor = true

	button.MouseButton1Click:Connect(function()
		showMessage("Executou função " .. i)
	end)
end

-- Animações de abrir/fechar
local open = false
local openTween = TweenService:Create(panel, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0.5, -125)})
local closeTween = TweenService:Create(panel, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 1.5, 0)})

toggleButton.MouseButton1Click:Connect(function()
	if open then
		closeTween:Play()
		open = false
	else
		panel.Visible = true
		openTween:Play()
		open = true
	end
end)

-- Simula o carregamento
task.spawn(function()
	for i = 1, 60 do
		loadingText.Text = "Carregando" .. string.rep(".", i % 4)
		task.wait(0.05)
	end
	loadingFrame:Destroy()
	toggleButton.Visible = true
end)
