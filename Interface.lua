-- Interface.lua - واجهة بسيطة وشغالة 100%
local RedzUI = {}
RedzUI.Version = "Simple UI 1.0"
RedzUI.Author = "Mr.Qattusa"

-- متغيرات النظام
RedzUI.MainGUI = nil
RedzUI.OptionsFrame = nil

-- ==================== إنشاء واجهة بسيطة ====================
function RedzUI.Create()
    print("🛠️ إنشاء واجهة جديدة...")
    
    -- تنظيف الواجهة القديمة
    if RedzUI.MainGUI then
        RedzUI.MainGUI:Destroy()
    end
    
    -- إنشاء واجهة الشاشة
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedzUISimple"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- زر القط الأساسي
    local CatButton = Instance.new("TextButton")
    CatButton.Name = "CatButton"
    CatButton.Size = UDim2.new(0, 70, 0, 70)
    CatButton.Position = UDim2.new(0, 20, 0.5, -35)
    CatButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CatButton.Text = "🐱"
    CatButton.TextSize = 30
    CatButton.Font = Enum.Font.GothamBold
    CatButton.TextColor3 = Color3.new(1, 1, 1)
    CatButton.Parent = ScreenGui
    
    -- القائمة الرئيسية
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainMenu"
    MainFrame.Size = UDim2.new(0, 300, 0, 350)
    MainFrame.Position = UDim2.new(0, 100, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    -- شريط العنوان
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    TitleBar.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "🐱 Mr.Qattusa Menu"
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- زر الإغلاق
    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "✕"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
    
    -- إطار الخيارات
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Name = "OptionsFrame"
    OptionsFrame.Size = UDim2.new(1, -20, 1, -60)
    OptionsFrame.Position = UDim2.new(0, 10, 0, 50)
    OptionsFrame.BackgroundTransparency = 1
    OptionsFrame.Parent = MainFrame
    
    -- فتح/إغلاق القائمة
    CatButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        print("📱 القائمة: " .. (MainFrame.Visible and "مفتوحة" or "مغلقة"))
    end)
    
    -- حفظ المرجع
    RedzUI.MainGUI = ScreenGui
    RedzUI.OptionsFrame = OptionsFrame
    
    print("✅ الواجهة تم إنشاؤها بنجاح!")
    return ScreenGui, OptionsFrame
end

-- ==================== دالة إضافة خيار ====================
function RedzUI.AddOption(name, icon, color, callback)
    print("➕ إضافة خيار: " .. name)
    
    if not RedzUI.OptionsFrame then
        print("⚠️ لا يوجد إطار خيارات، جاري إنشاء واجهة...")
        RedzUI.Create()
    end
    
    local optionCount = #RedzUI.OptionsFrame:GetChildren()
    local optionHeight = 45
    
    -- إنشاء زر الخيار
    local OptionButton = Instance.new("TextButton")
    OptionButton.Name = "Option_" .. name
    OptionButton.Text = icon .. "  " .. name
    OptionButton.Size = UDim2.new(1, 0, 0, optionHeight)
    OptionButton.Position = UDim2.new(0, 0, 0, optionCount * (optionHeight + 5))
    OptionButton.BackgroundColor3 = color
    OptionButton.BackgroundTransparency = 0.3
    OptionButton.TextColor3 = Color3.new(1, 1, 1)
    OptionButton.Font = Enum.Font.GothamBold
    OptionButton.TextSize = 15
    OptionButton.Parent = RedzUI.OptionsFrame
    
    -- عند النقر
    OptionButton.MouseButton1Click:Connect(function()
        print("🎯 نقر على: " .. name)
        pcall(callback)
        RedzUI.MainGUI:FindFirstChild("MainMenu").Visible = false
    end)
    
    print("✅ تم إضافة: " .. name)
    return OptionButton
end

-- ==================== دالة إظهار القائمة ====================
function RedzUI.ToggleMenu(state)
    if RedzUI.MainGUI then
        local menu = RedzUI.MainGUI:FindFirstChild("MainMenu")
        if menu then
            menu.Visible = state or not menu.Visible
        end
    end
end

-- ==================== التفعيل التلقائي ====================
spawn(function()
    wait(1)
    RedzUI.Create()
    print("🎮 الواجهة جاهزة! اضغط على القط 🐱")
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "RedzUI",
        Text = "جاهز! اضغط على القط",
        Duration = 3
    })
end)

return RedzUI
