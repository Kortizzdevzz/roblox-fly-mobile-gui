local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI Principal
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "CustomPanelUI"
screenGui.ResetOnSpawn = false

-- Tween Service para animações
local TweenService = game:GetService("TweenService")

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

-- Icone flutuante
local toggleButton = Instance.new("ImageButton", screenGui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
toggleButton.Image = "rbxassetid://6035198845" -- Ícone de engrenagem
toggleButton.BackgroundTransparency = 1
toggleButton.Visible = false

-- Painel
local panel = Instance.new("Frame", screenGui)
panel.Size = UDim2.new(0, 300, 0, 250)
panel.Position = UDim2.new(0.5, -150, 0.5, -125)
panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
panel.BorderSizePixel = 0
panel.Visible = false
panel.ClipsDescendants = true

-- Título
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

-- Botões com ações
local function showNotification(text)
	game.StarterGui:SetCore("SendNotification", {
		Title = "Notificação";
		Text = text;
		Duration = 3;
	})
end

local function changePanelColor()
	panel.BackgroundColor3 = Color3.fromRGB(math.random(30, 100), math.random(30, 100), math.random(30, 100))
end

local function toggleButtonVisibility()
	toggleButton.Visible = not toggleButton.Visible
end

local function quitGame()
	if game:GetService("RunService"):IsStudio() then
		game:Shutdown()
	else
		showNotification("Não é possível sair fora do Studio.")
	end
end

local actions = {
	function() showNotification("Você clicou no botão 1!") end,
	changePanelColor,
	toggleButtonVisibility,
	quitGame
}

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

	button.MouseButton1Click:Connect(actions[i])
end

-- Função animada de abrir/fechar o painel
local open = false
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local function animatePanel(visible)
	if visible then
		panel.Visible = true
		panel.Size = UDim2.new(0, 0, 0, 0)
		panel.Position = UDim2.new(0.5, 0, 0.5, 0)
		local sizeTween = TweenService:Create(panel, tweenInfo, { Size = UDim2.new(0, 300, 0, 250), Position = UDim2.new(0.5, -150, 0.5, -125) })
		sizeTween:Play()
	else
		local sizeTween = TweenService:Create(panel, tweenInfo, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) })
		sizeTween:Play()
		sizeTween.Completed:Wait()
		panel.Visible = false
	end
end

toggleButton.MouseButton1Click:Connect(function()
	open = not open
	animatePanel(open)
end)

-- Carregamento animado
task.spawn(function()
	for i = 1, 100 do
		loadingText.Text = "Carregando" .. string.rep(".", i % 4)
		task.wait(0.05)
	end
	loadingFrame:Destroy()
	toggleButton.Visible = true
end)
