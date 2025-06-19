local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyMenu"
gui.ResetOnSpawn = false

-- Botão flutuante
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
toggleButton.Text = "≡"
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 24
toggleButton.Parent = gui

-- Função para arrastar o toggleButton
local dragging = false
local dragInput
local dragStart
local startPos

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
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
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
	if input.UserInputType == Enum.UserInputType.MouseMovement or
	   input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateInput(input)
	end
end)

-- Painel principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 220)
mainFrame.Position = UDim2.new(0, 70, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Visible = false
mainFrame.Parent = gui

-- Criar botão
local function createMenuButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.Text = text
	btn.Parent = mainFrame
	return btn
end

-- Botões
local btnFly = createMenuButton("Ativar FLY", 10)
local btnESP = createMenuButton("Ativar ESP BONE", 60)
local btn3 = createMenuButton("Opção 3", 110)
local btnEject = createMenuButton("Ejetar Script", 160)

-- Alternar visibilidade do menu
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- === FLY ===
local flying = false
local speed = 50
local bv, bg

local function startFly()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	bg = Instance.new("BodyGyro")
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	bv = Instance.new("BodyVelocity")
	bv.velocity = Vector3.new()
	bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Parent = hrp

	flying = true

	while flying do
		game:GetService("RunService").RenderStepped:Wait()
		bg.CFrame = workspace.CurrentCamera.CFrame
		bv.velocity = workspace.CurrentCamera.CFrame.LookVector * speed
	end

	bg:Destroy()
	bv:Destroy()
end

btnFly.MouseButton1Click:Connect(function()
	if flying then
		flying = false
		btnFly.Text = "Ativar FLY"
	else
		btnFly.Text = "Desativar FLY"
		coroutine.wrap(startFly)()
	end
end)

-- === ESP BONE ===
local espBoneEnabled = false
local espLines = {}

local bones = {
	{"Head", "UpperTorso"},
	{"UpperTorso", "LowerTorso"},
	{"UpperTorso", "LeftUpperArm"},
	{"LeftUpperArm", "LeftLowerArm"},
	{"LeftLowerArm", "LeftHand"},
	{"UpperTorso", "RightUpperArm"},
	{"RightUpperArm", "RightLowerArm"},
	{"RightLowerArm", "RightHand"},
	{"LowerTorso", "LeftUpperLeg"},
	{"LeftUpperLeg", "LeftLowerLeg"},
	{"LeftLowerLeg", "LeftFoot"},
	{"LowerTorso", "RightUpperLeg"},
	{"RightUpperLeg", "RightLowerLeg"},
	{"RightLowerLeg", "RightFoot"},
}

local function createBoneESP(plr)
	if plr == player then return end
	if not plr.Character then return end

	espLines[plr] = {}

	for _, bone in pairs(bones) do
		local line = Drawing.new("Line")
		line.Thickness = 2
		line.Color = Color3.new(1, 1, 1)
		line.Visible = false
		table.insert(espLines[plr], {part1 = bone[1], part2 = bone[2], line = line})
	end
end

local function removeBoneESP(plr)
	if espLines[plr] then
		for _, item in pairs(espLines[plr]) do
			item.line:Remove()
		end
		espLines[plr] = nil
	end
end

game:GetService("RunService").RenderStepped:Connect(function()
	if not espBoneEnabled then return end

	for plr, lines in pairs(espLines) do
		if plr.Character then
			for _, boneData in pairs(lines) do
				local part1 = plr.Character:FindFirstChild(boneData.part1)
				local part2 = plr.Character:FindFirstChild(boneData.part2)

				if part1 and part2 then
					local p1, on1 = workspace.CurrentCamera:WorldToViewportPoint(part1.Position)
					local p2, on2 = workspace.CurrentCamera:WorldToViewportPoint(part2.Position)
					if on1 and on2 then
						boneData.line.From = Vector2.new(p1.X, p1.Y)
						boneData.line.To = Vector2.new(p2.X, p2.Y)
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
		if espBoneEnabled then
			createBoneESP(plr)
		end
	end)
end)

btnESP.MouseButton1Click:Connect(function()
	espBoneEnabled = not espBoneEnabled
	btnESP.Text = espBoneEnabled and "Desativar ESP BONE" or "Ativar ESP BONE"

	if espBoneEnabled then
		for _, plr in pairs(game.Players:GetPlayers()) do
			createBoneESP(plr)
		end
	else
		for _, lines in pairs(espLines) do
			for _, item in pairs(lines) do
				item.line:Remove()
			end
		end
		espLines = {}
	end
end)

-- === Ejetar Script ===
btnEject.MouseButton1Click:Connect(function()
	-- Para o fly se estiver ativo
	flying = false
	
	-- Desativa ESP e remove linhas
	espBoneEnabled = false
	for _, lines in pairs(espLines) do
		for _, item in pairs(lines) do
			item.line:Remove()
		end
	end
	espLines = {}
	
	-- Remove GUI
	gui:Destroy()
end)
