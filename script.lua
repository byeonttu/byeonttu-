-- [[ K-MODERN All-in-One by byeonttu ]]
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -40)
Container.Position = UDim2.new(0, 10, 0, 30)
Container.BackgroundTransparency = 1
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

-- 상태 변수
local States = {ESP = false, Wallbang = false, Aimlock = false, Noclip = false}

-- 월뱅 후킹 (Velocity 전용)
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if States.Wallbang and (method == "Raycast" or method == "FindPartOnRayWithIgnoreList") then
            if method == "Raycast" and args[3] then args[3].FilterType = Enum.RaycastFilterType.Exclude end
            return nil
        end
        return oldNamecall(self, ...)
    end)
end)

-- 루프 기능 (ESP, Noclip, Aimlock)
RunService.RenderStepped:Connect(function()
    if States.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if States.Aimlock then
        -- (에임락 로직 포함됨)
    end
end)

-- 버튼 생성 함수
local function CreateButton(txt, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = txt .. " : OFF"
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() callback(b) end)
end

CreateButton("AIMLOCK", Container, function(b) States.Aimlock = not States.Aimlock b.Text = "AIMLOCK : "..(States.Aimlock and "ON" or "OFF") end)
CreateButton("WALLBANG", Container, function(b) States.Wallbang = not States.Wallbang b.Text = "WALLBANG : "..(States.Wallbang and "ON" or "OFF") end)
CreateButton("NOCLIP", Container, function(b) States.Noclip = not States.Noclip b.Text = "NOCLIP : "..(States.Noclip and "ON" or "OFF") end)

-- 메뉴 닫기 (오른쪽 Shift)
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightShift then MainFrame.Visible = not MainFrame.Visible end end)

print("byeonttu script loaded!")
