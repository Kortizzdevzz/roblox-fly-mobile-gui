local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PainelExecutor"
gui.ResetOnSpawn = false

-- Estilo da Janela
local function createMainFrame()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 350, 0, 300)
	frame.Position = UDim2.new(0.5, -175, 0.5, -150)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Name = "MainFrame"
	frame.BackgroundTransparency = 0.1

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 12)

	local title = Instance.new("TextLabel", frame)
	title.Text = "Executor - Painel"
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true

	local layout = Instance.new("UIListLayout", frame)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	return frame
end

-- Botão genérico
local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.AutoButtonColor = true

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)

	btn.MouseButton1Click:Connect(function()
		print("Executando:", text)
		-- aqui você pode colocar comandos reais
	end)

	return btn
end

-- Botão de abrir/fechar
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Image = "rbxassetid://6031094678" -- ícone de engrenagem
toggleBtn.BackgroundTransparency = 1
toggleBtn.Name = "AbrirFechar"

-- Criar painel
local frame = createMainFrame()
frame.Parent = gui

-- Adicionar botões ao painel
for i = 1, 5 do
	local btn = createButton("Função " .. i)
	btn.Parent = frame
end

-- Animação abrir/fechar
local tweenService = game:GetService("TweenService")
local openTween = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	if frame.Visible then
		tweenService:Create(frame, openTween, {Size = UDim2.new(0, 350, 0, 300)}):Play()
	else
		tweenService:Create(frame, openTween, {Size = UDim2.new(0, 0, 0, 0)}):Play()
		wait(0.3)
		frame.Visible = false
	end
end)
