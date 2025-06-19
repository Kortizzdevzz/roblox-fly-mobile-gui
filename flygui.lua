local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyMenu"
gui.ResetOnSpawn = false

-- Botão flutuante (círculo azul com ícone ≡)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 15, 0.5, -30)
toggleButton.Text = "≡"
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 28
toggleButton.AutoButtonColor = true
toggleButton.Parent = gui
toggleButton.ClipsDescendants = true

local toggleCorner = Instance.new("UICorner", toggleButton)
toggleCorner.CornerRadius = UDim.new(1, 0)

-- Arrastar botão
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

local function updateInput(input)
	local delta = input.Position - dragStart
	toggleButton.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = toggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

toggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then updateInput(input) end
end)

-- Painel principal com scroll
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0, 90, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 14)

local shadow = Instance.new("Frame", mainFrame)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.65
shadow.ZIndex = 0

local shadowCorner = Instance.new("UICorner", shadow)
shadowCorner.CornerRadius = UDim.new(0, 14)

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 136, 220)
title.Text = "⚙️ Feito por Tentacions"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 12)

-- ScrollFrame
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Position = UDim2.new(0, 0, 0, 50)
scrollFrame.Size = UDim2.new(1, 0, 1, -50)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ClipsDescendants = true

-- Função de botão
local function createMenuButton(text, order)
	local btn = Instance.new("TextButton", scrollFrame)
	btn.Size = UDim2.new(0.9, 0, 0, 60)
	btn.Position = UDim2.new(0.05, 0, 0, (order - 1) * 80)
	btn.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 20
	btn.Text = text
	btn.AutoButtonColor = true

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)

	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(25, 118, 210) end)
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(30, 136, 229) end)

	return btn
end

-- Botões
local btnFly = createMenuButton("✈️ Ativar FLY", 1)
local btnESP = createMenuButton("🦴 Ativar ESP BONE", 2)
local btn3 = createMenuButton("🧪 Opção 3", 3)
local btnEject = createMenuButton("🗑️ Ejetar Script", 4)

-- Mostrar/esconder menu
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- FLY
local flying, speed, bv, bg = false, 50, nil, nil

local function startFly()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	bg = Instance.new("BodyGyro", hrp)
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = hrp.CFrame

	bv = Instance.new("BodyVelocity", hrp)
	bv.velocity = Vector3.new()
	bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

	flying = true
	while flying do
		game:GetService("RunService").RenderStepped:Wait()
		bg.CFrame = workspace.CurrentCamera.CFrame
		bv.velocity = workspace.CurrentCamera.CFrame.LookVector * speed
	end

	if bg then bg:Destroy() end
	if bv then bv:Destroy() end
end

btnFly.MouseButton1Click:Connect(function()
	if flying then
		flying = false
		btnFly.Text = "✈️ Ativar FLY"
	else
		btnFly.Text = "🛑 Desativar FLY"
		coroutine.wrap(startFly)()
	end
end)

-- ESP BONE
local espBoneEnabled = false
local espLines = {}
local bones = {
	{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
	{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
	{"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"},
	{"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
	{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
	{"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"},
	{"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}

local function createBoneESP(plr)
	if plr == player or not plr.Character then return end
	espLines[plr] = {}
	for _, bone in pairs(bones) do
		local line = Drawing.new("Line")
		line.Thickness = 2
		line.Color = Color3.new(1, 1, 1)
		line.Visible = false
		table.insert(espLines[plr], {part1 = bone[1], part2 = bone[2], line = line})
	end
end

btnESP.MouseButton1Click:Connect(function()
	espBoneEnabled = not espBoneEnabled
	btnESP.Text = espBoneEnabled and "🦴 Desativar ESP BONE" or "🦴 Ativar ESP BONE"

	if espBoneEnabled then
		for _, plr in pairs(game.Players:GetPlayers()) do createBoneESP(plr) end
	else
		for _, lines in pairs(espLines) do
			for _, item in pairs(lines) do item.line:Remove() end
		end
		espLines = {}
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if not espBoneEnabled then return end
	for plr, lines in pairs(espLines) do
		if plr.Character then
			for _, boneData in pairs(lines) do
				local p1 = plr.Character:FindFirstChild(boneData.part1)
				local p2 = plr.Character:FindFirstChild(boneData.part2)
				if p1 and p2 then
					local s1, on1 = workspace.CurrentCamera:WorldToViewportPoint(p1.Position)
					local s2, on2 = workspace.CurrentCamera:WorldToViewportPoint(p2.Position)
					if on1 and on2 then
						boneData.line.From = Vector2.new(s1.X, s1.Y)
						boneData.line.To = Vector2.new(s2.X, s2.Y)
						boneData.line.Visible = true
					else
						boneData.line.Visible = false
					end
				else
					boneData.line.Visible = false
				end
			end
		end
	end
end)

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		if espBoneEnabled then createBoneESP(plr) end
	end)
end)

-- Ejetar
btnEject.MouseButton1Click:Connect(function()
	flying = false
	espBoneEnabled = false
	for _, lines in pairs(espLines) do
		for _, item in pairs(lines) do item.line:Remove() end
	end
	espLines = {}
	gui:Destroy()
end)
