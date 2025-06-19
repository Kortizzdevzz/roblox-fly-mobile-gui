-- ESP Variables
local espEnabled = false
local espObjects = {}

local function createESP(player)
	if player == game.Players.LocalPlayer then return end
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

	local box = Drawing.new("Text")
	box.Visible = false
	box.Center = true
	box.Outline = true
	box.Font = 2
	box.Size = 13
	box.Color = Color3.new(1, 1, 1)
	box.Text = player.Name

	espObjects[player] = box
end

local function updateESP()
	for player, box in pairs(espObjects) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
			if onScreen then
				box.Position = Vector2.new(pos.X, pos.Y)
				box.Visible = true
			else
				box.Visible = false
			end
		else
			box.Visible = false
		end
	end
end

local function removeESP(player)
	if espObjects[player] then
		espObjects[player]:Remove()
		espObjects[player] = nil
	end
end

-- Atualizar ESP a cada frame
game:GetService("RunService").RenderStepped:Connect(function()
	if espEnabled then
		updateESP()
	end
end)

-- Monitorar novos players
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		if espEnabled then
			createESP(plr)
		end
	end)
end)

-- Botão ESP (Opção 2)
btn2.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	btn2.Text = espEnabled and "Desativar ESP" or "Ativar ESP"

	if espEnabled then
		for _, plr in pairs(game.Players:GetPlayers()) do
			createESP(plr)
		end
	else
		for _, box in pairs(espObjects) do
			box:Remove()
		end
		espObjects = {}
	end
end)
