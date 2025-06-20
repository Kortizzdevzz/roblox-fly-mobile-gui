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

	local dragBar = Instance.new("TextButton", frame)
	dragBar.Size = UDim2.new(1, 0, 0, 40)
	dragBar.Position = UDim2.new(0, 0, 0, 0)
	dragBar.BackgroundTransparency = 1
	dragBar.Text = ""

	local layout = Instance.new("UIListLayout", frame)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Drag da janela
	local dragging, dragInput, dragStart, startPos
	dragBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	dragBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

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

	return btn
end

-- Botão de abrir/fechar
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Image = "rbxassetid://6031094678"
toggleBtn.BackgroundTransparency = 1
toggleBtn.Name = "AbrirFechar"

-- Drag do botão
local dragging, dragInput, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = toggleBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
toggleBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Criar painel
local frame = createMainFrame()
frame.Parent = gui

-- Função 1: FLY
local flying = false
local flyVelocity
local btn1 = createButton("Função 1 - FLY")
btn1.MouseButton1Click:Connect(function()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	flying = not flying
	if flying then
		local hrp = char:WaitForChild("HumanoidRootPart")
		flyVelocity = Instance.new("BodyVelocity")
		flyVelocity.Velocity = Vector3.new(0, 0, 0)
		flyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
		flyVelocity.Name = "FlyForce"
		flyVelocity.Parent = hrp

		local UIS = game:GetService("UserInputService")
		local moveVector = Vector3.zero

		local function updateMovement()
			if not flying or not flyVelocity then return end
			local cam = workspace.CurrentCamera
			local dir = cam.CFrame:vectorToWorldSpace(moveVector)
			flyVelocity.Velocity = dir * 60
		end

		UIS.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Q then
				flying = false
				if flyVelocity then flyVelocity:Destroy() end
			end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.W then moveVector = Vector3.new(0, 0, -1) end
				if input.KeyCode == Enum.KeyCode.S then moveVector = Vector3.new(0, 0, 1) end
				if input.KeyCode == Enum.KeyCode.A then moveVector = Vector3.new(-1, 0, 0) end
				if input.KeyCode == Enum.KeyCode.D then moveVector = Vector3.new(1, 0, 0) end
				if input.KeyCode == Enum.KeyCode.Space then moveVector = Vector3.new(0, 1, 0) end
			end
		end)
		UIS.InputEnded:Connect(function(input)
			moveVector = Vector3.zero
		end)

		coroutine.wrap(function()
			while flying and flyVelocity and flyVelocity.Parent do
				updateMovement()
				task.wait()
			end
		end)()
	else
		if flyVelocity then flyVelocity:Destroy() end
	end
end)
btn1.Parent = frame

-- Funções 2 a 5 (em branco)
for i = 2, 5 do
	local btn = createButton("Função " .. i)
	btn.MouseButton1Click:Connect(function()
		print("Função " .. i .. " clicada.")
	end)
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
