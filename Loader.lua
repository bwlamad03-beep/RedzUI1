-- Loader.lua - واجهة نظام الفواكه
print("🍊 تحميل نظام فواكه بلوكس فروت...")

-- إنشاء واجهة بسيطة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitSystemUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- زر القط
local CatButton = Instance.new("TextButton")
CatButton.Name = "FruitCat"
CatButton.Size = UDim2.new(0, 70, 0, 70)
CatButton.Position = UDim2.new(0, 20, 0.5, -35)
CatButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
CatButton.Text = "🍊"
CatButton.TextSize = 30
CatButton.Font = Enum.Font.GothamBold
CatButton.TextColor3 = Color3.new(1, 1, 1)
CatButton.Parent = ScreenGui

-- القائمة
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "FruitMenu"
MenuFrame.Size = UDim2.new(0, 250, 0, 150)
MenuFrame.Position = UDim2.new(0, 100, 0.5, -75)
MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MenuFrame.Visible = false
MenuFrame.Parent = ScreenGui

-- عنوان القائمة
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
TitleBar.Parent = MenuFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "🍊 نظام الفواكه"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

-- الزر الرئيسي
local MainButton = Instance.new("TextButton")
MainButton.Text = "🚀 بدء/إيقاف النظام"
MainButton.Size = UDim2.new(0.9, 0, 0, 40)
MainButton.Position = UDim2.new(0.05, 0, 0.3, 0)
MainButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
MainButton.TextColor3 = Color3.new(1, 1, 1)
MainButton.Font = Enum.Font.GothamBold
MainButton.TextSize = 14
MainButton.Parent = MenuFrame

-- زر الحالة
local StatusButton = Instance.new("TextButton")
StatusButton.Text = "📊 حالة النظام"
StatusButton.Size = UDim2.new(0.9, 0, 0, 40)
StatusButton.Position = UDim2.new(0.05, 0, 0.6, 0)
StatusButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
StatusButton.TextColor3 = Color3.new(1, 1, 1)
StatusButton.Font = Enum.Font.GothamBold
StatusButton.TextSize = 14
StatusButton.Parent = MenuFrame

-- فتح/إغلاق القائمة
CatButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
    print("📱 القائمة: " .. (MenuFrame.Visible and "مفتوحة" or "مغلقة"))
end)

-- تحميل النظام
local FruitSystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/BloxFruits.lua"))()

-- عند النقر على الزر الرئيسي
MainButton.MouseButton1Click:Connect(function()
    if FruitSystem then
        FruitSystem.StartAutoSystem()
    else
        print("❌ فشل تحميل نظام الفواكه")
    end
    MenuFrame.Visible = false
end)

-- عند النقر على زر الحالة
StatusButton.MouseButton1Click:Connect(function()
    if FruitSystem then
        FruitSystem.GetStatus()
    end
    MenuFrame.Visible = false
end)

-- إشعار التحميل
print("✅ النظام جاهز!")
print("🎯 اضغط على 🍊 لفتح القائمة")
print("🚀 اختر 'بدء النظام' للبدء")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "نظام الفواكه",
    Text = "جاهز! اضغط على البرتقالة 🍊",
    Duration = 5
})
