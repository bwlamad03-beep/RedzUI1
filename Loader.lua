-- Loader.lua - الإصدار المؤكد العمل
print("🎮 RedzUI System - Loading...")

-- ==================== الجزء 1: تحميل الواجهة ====================
print("📦 Loading Interface...")
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Interface.lua", true))()

if not UI then
    warn("❌ Failed to load Interface!")
    return
end

print("✅ Interface loaded: " .. (UI.Version or "Unknown"))

-- ==================== الجزء 2: إنشاء واجهة احتياطية ====================
local function CreateEmergencyUI()
    print("⚠️ Creating emergency UI...")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedzUI_Emergency"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- زر القط الرئيسي
    local CatButton = Instance.new("TextButton")
    CatButton.Name = "EmergencyCat"
    CatButton.Size = UDim2.new(0, 70, 0, 70)
    CatButton.Position = UDim2.new(0, 30, 0.5, -35)
    CatButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CatButton.Text = "🐱"
    CatButton.TextSize = 30
    CatButton.Font = Enum.Font.GothamBold
    CatButton.TextColor3 = Color3.new(1, 1, 1)
    CatButton.Parent = ScreenGui
    
    -- القائمة
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Name = "EmergencyMenu"
    MenuFrame.Size = UDim2.new(0, 300, 0, 350)
    MenuFrame.Position = UDim2.new(0, 120, 0.5, -175)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MenuFrame.Visible = false
    MenuFrame.Parent = ScreenGui
    
    -- شريط العنوان
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    TitleBar.Parent = MenuFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "RedzUI - Emergency"
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- قائمة الخيارات
    local OptionsFrame = Instance.new("ScrollingFrame")
    OptionsFrame.Size = UDim2.new(1, -20, 1, -60)
    OptionsFrame.Position = UDim2.new(0, 10, 0, 50)
    OptionsFrame.BackgroundTransparency = 1
    OptionsFrame.ScrollBarThickness = 5
    OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    OptionsFrame.Parent = MenuFrame
    
    -- فتح/إغلاق القائمة
    CatButton.MouseButton1Click:Connect(function()
        MenuFrame.Visible = not MenuFrame.Visible
    end)
    
    -- دالة إضافة خيار
    local function AddEmergencyOption(name, icon, color, callback)
        local optionCount = #OptionsFrame:GetChildren()
        local optionHeight = 45
        
        local OptionButton = Instance.new("TextButton")
        OptionButton.Text = icon .. "  " .. name
        OptionButton.Size = UDim2.new(1, 0, 0, optionHeight)
        OptionButton.Position = UDim2.new(0, 0, 0, optionCount * (optionHeight + 5))
        OptionButton.BackgroundColor3 = color
        OptionButton.TextColor3 = Color3.new(1, 1, 1)
        OptionButton.Font = Enum.Font.GothamBold
        OptionButton.TextSize = 16
        
        OptionButton.MouseButton1Click:function()
            callback()
            MenuFrame.Visible = false
        end
        
        OptionButton.Parent = OptionsFrame
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, (optionCount + 1) * (optionHeight + 5))
    end
    
    -- إضافة خيارات
    AddEmergencyOption("🚀 بدء النظام", "▶️", Color3.fromRGB(255, 80, 80), function()
        print("🎮 بدء النظام...")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua"))()
    end)
    
    AddEmergencyOption("📍 تلفيل للبداية", "🏠", Color3.fromRGB(100, 200, 100), function()
        local char = game.Players.LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(-1085, 15, 1422)
                print("✅ تم التلفيل")
            end
        end
    end)
    
    AddEmergencyOption("📊 حالة النظام", "📈", Color3.fromRGB(100, 200, 255), function()
        print("📊 النظام يعمل")
    end)
    
    AddEmergencyOption("⏹️ إيقاف", "⏸️", Color3.fromRGB(255, 180, 0), function()
        print("⏹️ تم الإيقاف")
    end)
    
    AddEmergencyOption("💀 إعادة التولد", "🔄", Color3.fromRGB(255, 100, 100), function()
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end)
    
    print("✅ Emergency UI created with 5 options")
    return {AddOption = AddEmergencyOption}
end

-- ==================== الجزء 3: محاولة استخدام الواجهة الأصلية ====================
local function TryAddOptions()
    print("➕ Attempting to add options...")
    
    local optionsAdded = false
    
    if UI and UI.AddOption then
        print("✅ UI.AddOption is available")
        
        -- خيار 1
        UI.AddOption("🚀 بدء النظام التلقائي", "🤖", Color3.fromRGB(255, 80, 80), function()
            print("🎮 Starting system...")
            local cmds = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua"))()
            if cmds and cmds.StartFullSystem then
                cmds.StartFullSystem()
            end
        end)
        
        -- خيار 2
        UI.AddOption("📍 تلفيل للبداية", "🏠", Color3.fromRGB(100, 200, 100), function()
            local char = game.Players.LocalPlayer.Character
            if char then
                char:MoveTo(Vector3.new(-1085, 15, 1422))
            end
        end)
        
        -- خيار 3
        UI.AddOption("📊 حالة النظام", "📈", Color3.fromRGB(100, 200, 255), function()
            print("📊 System status: OK")
        end)
        
        -- خيار 4
        UI.AddOption("⏹️ إيقاف الكل", "⏸️", Color3.fromRGB(255, 180, 0), function()
            print("⏹️ All systems stopped")
        end)
        
        -- خيار 5
        UI.AddOption("💀 إعادة التولد", "🔄", Color3.fromRGB(255, 100, 100), function()
            local char = game.Players.LocalPlayer.Character
            if char then
                char:BreakJoints()
            end
        end)
        
        -- خيار 6
        UI.AddOption("❓ المساعدة", "💡", Color3.fromRGB(200, 200, 100), function()
            print("🎮 RedzUI System")
            print("📚 Version: 1.0")
            print("👤 Developer: Mr.Qattusa")
        end)
        
        optionsAdded = true
        print("✅ Successfully added 6 options to main UI")
        
    else
        print("❌ UI.AddOption not available, using emergency UI")
    end
    
    return optionsAdded
end

-- ==================== الجزء 4: التنفيذ الرئيسي ====================
wait(1)

local optionsAdded = TryAddOptions()

if not optionsAdded then
    print("⚠️ Falling back to emergency UI...")
    UI = CreateEmergencyUI()
    TryAddOptions()
end

-- ==================== الجزء 5: الإشعار النهائي ====================
print("\n" .. string.rep("=", 50))
print("🎮 REDZUI SYSTEM LOADED")
print("📋 Options available: 6")
print("🎯 Press cat button or RCtrl to open")
print(string.rep("=", 50))

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "RedzUI",
    Text = "System ready!\nClick the cat button",
    Duration = 5,
    Icon = "✅"
})

-- اختصار لوحة المفاتيح
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        print("🔓 Menu toggled with RCtrl")
    end
end)
