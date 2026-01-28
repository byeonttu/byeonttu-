local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ UI 구성 ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "ByeonttuHub_Ultra_v4"
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.8, 0)
Container.ScrollBarThickness = 0
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

-- [[ 상태 및 변수 ]]
local States = {
    ESP = false, SilentAim = false, Aimlock = false, 
    Wallbang = false, Noclip = false, Fly = false
}
local flySpeed = 50

-- [[ 핵심 로직: Fly ]]
local function HandleFly()
    local bg = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
    local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

    spawn(function()
        while States.Fly do
            RunService.RenderStepped:Wait()
            LocalPlayer.Character.Humanoid.PlatformStand = true
            local moveDir = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            bv.velocity = moveDir * flySpeed
            bg.cframe = Camera.CFrame
        end
        bg:Destroy()
        bv:Destroy()
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end)
end

-- [[ 후킹 (Silent Aim & Wallbang) ]]
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if States.Wallbang and (method == "Raycast" or method == "FindPartOnRayWithIgnoreList") then return nil end
    if States.SilentAim and self == Mouse and (method == "Hit" or method == "Target") then
        local target = nil
        local dist = 500
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if vis and mag < dist then target = p.Character.Head dist = mag end
            end
        end
        if target then return (method == "Hit" and target.CFrame or target) end
    end
    return oldNamecall(self, ...)
end)

-- [[ 루프 (Noclip, ESP, Aimlock) ]]
RunService.RenderStepped:Connect(function()
    if States.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if States.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("ByeonttuESP") then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "ByeonttuESP"
                h.FillColor = Color3.fromRGB(255, 50, 50)
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ByeonttuESP") then p.Character.ByeonttuESP:Destroy() end
        end
    end
end)

-- [[ 버튼 생성 ]]
local function AddButton(txt, var)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.Text = txt .. " : OFF"
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        States[var] = not States[var]
        b.Text = txt .. " : " .. (States[var] and "ON" or "OFF")
        b.BackgroundColor3 = States[var] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(35, 35, 35)
        if var == "Fly" and States.Fly then HandleFly() end
    end)
end

AddButton("FLY (V-Flight)", "Fly")
AddButton("ESP (WALLHACK)", "ESP")
AddButton("SILENT AIM", "SilentAim")
AddButton("AIMLOCK", "Aimlock")
AddButton("WALLBANG", "Wallbang")
AddButton("NOCLIP", "Noclip")

UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then MainFrame.Visible = not MainFrame.Visible end
end)
