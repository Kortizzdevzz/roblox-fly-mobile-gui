-- Cria o ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyPanel"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Cria o Frame do painel
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Cria botão de minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.Parent = frame

-- Cria botão FLY
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 120, 0, 40)
flyBtn.Position = UDim2.new(0.5, -60, 0.5, -20)
flyBtn.Text = "FLY"
flyBtn.BackgroundColor3 = Color3.fromRGB(70, 180, 255)
flyBtn.Parent = frame

-- Variáveis de estado
local flying = false
local minimized = false

-- Função de voo
function fly()
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    local bodyGyro = Instance.new("BodyGyro", hrp)
    local bodyVelocity = Instance.new("BodyVelocity", hrp)

    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
    bodyGyro.CFrame = hrp.CFrame
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)

    local UIS = game:GetService("UserInputService")
    local speed = 50

    local flyingConnection
    flyingConnection = game:GetService("RunService").RenderStepped:Connect(function()
        local camCF = workspace.CurrentCamera.CFrame
        local moveVec = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + camCF.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec = moveVec - camCF.UpVector end
        bodyVelocity.Velocity = moveVec.Unit * speed
        bodyGyro.CFrame = camCF
        if not flying then
            flyingConnection:Disconnect()
            bodyGyro:Destroy()
            bodyVelocity:Destroy()
        end
    end)
end

-- Botão FLY
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.Text = "UNFLY"
        fly()
    else
        flyBtn.Text = "FLY"
    end
end)

-- Botão de minimizar
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        flyBtn.Visible = false
        frame.Size = UDim2.new(0, 200, 0, 40)
        minimizeBtn.Text = "+"
    else
        flyBtn.Visible = true
        frame.Size = UDim2.new(0, 200, 0, 100)
        minimizeBtn.Text = "-"
    end
end)
