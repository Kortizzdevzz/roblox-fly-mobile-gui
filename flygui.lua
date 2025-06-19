-- Fly Script com GUI para Mobile
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Flying = false
local Speed = 50
local BodyGyro, BodyVelocity

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "FlyGUI"

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 120, 0, 50)
FlyButton.Position = UDim2.new(0.05, 0, 0.8, 0)
FlyButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
FlyButton.TextColor3 = Color3.new(1, 1, 1)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextSize = 20
FlyButton.Text = "Ativar Fly"
FlyButton.Parent = ScreenGui

-- Função de Fly
local function Fly()
	local character = Player.Character or Player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.P = 9e4
	BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	BodyGyro.cframe = humanoidRootPart.CFrame
	BodyGyro.Parent = humanoidRootPart

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.velocity = Vector3.new(0, 0, 0)
	BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
	BodyVelocity.Parent = humanoidRootPart

	Flying = true

	while Flying do
		game:GetService("RunService").RenderStepped:Wait()
		BodyGyro.CFrame = workspace.CurrentCamera.CFrame
		BodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * Speed
	end

	BodyGyro:Destroy()
	BodyVelocity:Destroy()
end

-- Botão de Ativar/Desativar Fly
FlyButton.MouseButton1Click:Connect(function()
	if Flying then
		Flying = false
		FlyButton.Text = "Ativar Fly"
	else
		FlyButton.Text = "Desativar Fly"
		coroutine.wrap(Fly)()
	end
end)
