-- GUI Roblox: Botão flutuante + menu com FLY e 2 opções extras
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MainFlyMenu"

-- Botão flutuante para abrir/fechar
local openButton = Instance.new("ImageButton")
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.3, 0)
openButton.BackgroundTransparency = 1
openButton.Image = "rbxassetid://6035047409" -- ícone de engrenagem
openButton.Parent = gui

-- Frame do menu principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 180)
mainFrame.Position = UDim2.new(0, 80, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "Painel de Comandos"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- Função para criar botão
local function createButton(name, order)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, 40 + ((order - 1) * 45))
	button.Text = name
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Parent = mainFrame
	return button
end

-- Botões
local flyButton = createButton("FLY", 1)
local opt2 = createButton("Opção 2", 2)
local opt3 = createButton("Opção 3", 3)

-- Controle de FLY
local flying = false
local bodyGyro, bodyVel
local speed = 50

local function toggleFly()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	if flying then
		flying = false
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVel then bodyVel:Destroy() end
	else
		flying = true
		bodyGyro = Instance.new("BodyGyro", hrp)
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.CFrame = hrp.CFrame

		bodyVel = Instance.new("BodyVelocity", hrp)
		bodyVel.Velocity = Vector3.new(0, 0, 0)
		bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		coroutine.wrap(function()
			while flying do
				game:GetService("RunService").RenderStepped:Wait()
				bodyGyro.CFrame = workspace.CurrentCamera.CFrame
				bodyVel.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
			end
		end)()
	end
end

-- Funções dos botões
flyButton.MouseButton1Click:Connect(toggleFly)

-- Abrir/Fechar menu
openButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)
