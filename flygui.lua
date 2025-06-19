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

-- Painel principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 180)
mainFrame.Position = UDim2.new(0, 70, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Visible = false
mainFrame.Parent = gui

-- Criar botão no menu
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
local btnESP = createMenuButton("Ativar ESP", 60)
local btn3 = createMenuButton("Opção 3", 110)

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

-- === ESP ===
local espEnabled = false
local espObjects = {}

local function createESP(plr)
	if plr == player then return end
	if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

	local tag = Drawing.new("Text")
	tag.Visible = false
	tag.Center = true
	tag.Outline = true
	tag.Font = 2
	tag.Size = 13
	tag.Color = Color3.new(1, 1, 1)
	tag.Text = plr.Name

	espObjects[plr] = tag
end

local function updateESP()
	for plr, tag in pairs(espObjects) do
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
			if onScreen then
				tag.Position = Vector2.new(pos.X, pos.Y)
				tag.Visible = true
			else
				tag.Visible = false
			end
		else
			tag.Visible = false
		end
	end
end

local function removeESP(plr)
	if espObjects[plr] then
		espObjects[plr]:Remove()
		espObjects[plr] = nil
	end
end

game:GetService("RunService").RenderStepped:Connect(function()
	if espEnabled then
		updateESP()
	end
end)

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		if espEnabled then
			createESP(plr)
		end
	end)
end)

btnESP.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	btnESP.Text = espEnabled and "Desativar ESP" or "Ativar ESP"

	if espEnabled then
		for _, plr in pairs(game.Players:GetPlayers()) do
			createESP(plr)
		end
	else
		for _, v in pairs(espObjects) do
			v:Remove()
		end
		espObjects = {}
	end
end)
