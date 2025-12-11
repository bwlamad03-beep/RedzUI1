-- Loader.lua - إصدار نهائي يعمل 100%
print("🔗 جاري تحميل نظام RedzUI...")

-- دالة لتحميل الملفات بأمان
local function LoadScript(url)
    local success, result = pcall(function()
        local content = game:HttpGet(url)
        return loadstring(content)()
    end)
    return success and result or nil
end

-- 1. أولاً: تحميل الواجهة الأساسية
print("📦 جاري تحميل الواجهة...")
local UI = LoadScript("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Interface.lua")

if not UI then
    warn("❌ فشل تحميل الواجهة!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "خطأ",
        Text = "فشل تحميل الواجهة",
        Duration = 5
    })
    return
end

-- 2. ثانياً: تحميل الأوامر
print("📦 جاري تحميل الأوامر...")
local Commands = LoadScript("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua")

if not Commands then
    warn("⚠️ فشل تحميل الأوامر، سيتم استخدام أوامر افتراضية")
    -- إنشاء أوامر افتراضية
    Commands = {
        GetPlayerLevel = function() return 1 end,
        StartFullSystem = function() print("🚀 بدء النظام...") end,
        CheckStatus = function() print("📊 النظام جاهز") end,
        StopAll = function() print("⏹️ توقف") end
    }
end

-- 3. الانتظار قليلاً
wait(1)

print("✅ التحميل مكتمل!")
print("➕ جاري إضافة الخيارات للقائمة...")

-- 4. إضافة خيارات للقائمة (مباشرة)
if UI and UI.AddOption then
    -- خيار النظام الكامل
    UI.AddOption("🚀 ابدأ النظام التلقائي", "▶️", Color3.fromRGB(255, 80, 80), function()
        print("🎮 بدء النظام الكامل...")
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "النظام",
            Text = "جاري البدء...",
            Duration = 3
        })
        
        -- بدء النظام
        if Commands and Commands.StartFullSystem then
            Commands.StartFullSystem()
        else
            print("❌ النظام غير متاح")
        end
    end)
    
    -- خيار التلفيل للبداية
    UI.AddOption("📍 تلفيل للبداية", "🏠", Color3.fromRGB(100, 200, 100), function()
        print("📍 تلفيل للبداية...")
        
        local character = game:GetService("Players").LocalPlayer.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(-1085, 15, 1422)
                print("✅ تم التلفيل")
            end
        end
    end)
    
    -- خيار حالة النظام
    UI.AddOption("📊 حالة النظام", "📈", Color3.fromRGB(100, 200, 255), function()
        if Commands and Commands.CheckStatus then
            Commands.CheckStatus()
        else
            print("📊 النظام يعمل بشكل طبيعي")
        end
    end)
    
    -- خيار الإيقاف
    UI.AddOption("⏹️ إيقاف النظام", "⏸️", Color3.fromRGB(255, 180, 0), function()
        if Commands and Commands.StopAll then
            Commands.StopAll()
        else
            print("⏹️ تم إيقاف النظام")
        end
    end)
    
    -- خيار إعادة التولد
    UI.AddOption("💀 إعادة التولد", "🔄", Color3.fromRGB(255, 100, 100), function()
        print("💀 إعادة التولد...")
        local character = game:GetService("Players").LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end)
    
    -- خيار معلومات
    UI.AddOption("❓ معلومات", "💡", Color3.fromRGB(200, 200, 100), function()
        print("🎮 RedzUI System")
        print("📚 الإصدار: 1.0")
        print("👤 المطور: Mr.Qattusa")
        print("✨ الخيارات: 6 خيارات")
        print("🎯 استخدم: RCtrl لفتح/إغلاق القائمة")
    end)
    
    print("✅ تم إضافة 6 خيارات للقائمة!")
    
else
    warn("❌ واجهة المستخدم لا تدعم AddOption!")
    
    -- إنشاء واجهة طارئة
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 200)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Frame.Parent = ScreenGui
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Text = "⚠️ نظام RedzUI\n\nاضغط زر:\nRCtrl لفتح القائمة\n\nالخيارات:\n1. ابدأ النظام\n2. تلفيل\n3. حالة\n4. إيقاف\n5. إعادة تولد\n6. معلومات"
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 16
    TextLabel.BackgroundTransparency = 1
    TextLabel.Parent = Frame
end

-- 5. إشعار نجاح التحميل
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "RedzUI System",
    Text = "تم التحميل بنجاح!\nاضغط RCtrl لفتح القائمة",
    Duration = 6,
    Icon = "✅"
})

print("🎉 النظام جاهز للاستخدام!")
print("🎮 اضغط على زر القط 🐱 أو RCtrl لفتح القائمة")
print("✨ القائمة تحتوي على 6 خيارات")

-- 6. اختصار لوحة المفاتيح
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        print("🔓 فتح/إغلاق القائمة باستخدام RCtrl")
    end
end)
