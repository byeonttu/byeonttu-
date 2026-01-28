-- [[ K-MODERN All-in-One Fix by byeonttu ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true -- Velocity에서 드래그 가능하게 설정
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- 버튼들이 들어갈 공간 (Container)
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -50) -- 상단 여유 공간 제외
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 2, 0) -- 스크롤 가능하게
Container.ScrollBarThickness = 2

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 상태 변수
local States = {ESP = false, Wallbang = false, Aimlock = false, Noclip = false}

-- 버튼 생성기 (디자인 개선)
local function CreateButton(txt, callback)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Text = txt .. " : OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    
    b.MouseButton1Click:Connect(function()
        callback(b)
    end)
end

-- 기능 연결
CreateButton("AIMLOCK", function(b) 
    States.Aimlock = not States.Aimlock 
    b.Text = "AIMLOCK : "..(States.Aimlock and "ON" or "OFF")
    b.BackgroundColor3 = States.Aimlock and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(45, 45, 45)
end)

CreateButton("WALLBANG", function(b) 
    States.Wallbang = not States.Wallbang 
    b.Text = "WALLBANG : "..(States.Wallbang and "ON" or "OFF")
    b.BackgroundColor3 = States.Wallbang and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(45, 45, 45)
end)

CreateButton("NOCLIP", function(b) 
    States.Noclip = not States.Noclip 
    b.Text = "NOCLIP : "..(States.Noclip and "ON" or "OFF")
    b.BackgroundColor3 = States.Noclip and Color3.fromRGB(100, 255, 0) or Color3.fromRGB(45, 45, 45)
end)

-- 타이틀 라벨 (메뉴 이름)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "BYEONTTU HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- 단축키 설정
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
