-- Loader.lua - واجهة النظام الكامل النهائي
print("🔗 جاري تحميل النظام الكامل...")

local function safeLoad(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    
    if not success then
        warn("❌ فشل تحميل: " .. url)
        return nil
    end
    
    return result
end

local function delay(time)
    if task then
        return task.wait(time)
    else
        return wait(time)
    end
end

-- التحميل الرئيسي
local success, err = pcall(function()
    -- تحميل الواجهة
    print("📦 جاري تحميل الواجهة...")
    local Interface = safeLoad("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Interface.lua")
    if not Interface then error("❌ فشل تحميل الواجهة") end
    
    delay(0.5)
    
    -- تحميل النظام
    print("📦 جاري تحميل النظام...")
    local Commands = safeLoad("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua")
    if not Commands then error("❌ فشل تحميل النظام") end
    
    delay(0.5)
    
    -- الحصول على مستوى اللاعب
    local playerLevel = Commands.GetPlayerLevel()
    print("📊 مستوى اللاعب: " .. playerLevel)
    
    -- تحديد الموقع المناسب
    local bestLocation = "بداية"
    if playerLevel >= 30 then bestLocation = "قراصنة"
    elseif playerLevel >= 50 then bestLocation = "محاربين"
    elseif playerLevel >= 75 then bestLocation = "بحارة" end
    
    -- إضافة الأوامر للواجهة
    print("➕ جاري إضافة الأوامر...")
    
    -- ==================== زر النظام المتكامل الرئيسي ====================
    Interface.AddOption("🚀 نظام متكامل كامل", "🤖", Color3.fromRGB(255, 80, 80), function()
        print("🚀 بدء النظام المتكامل...")
        print("📊 مستواك: " .. playerLevel)
        print("📍 الموقع: " .. bestLocation)
        
        -- بدء النظام المتكامل
        Commands.StartFullSystem()
    end)
    
    -- ==================== قسم المواقع ====================
    Interface.AddOption("📍 الذهاب لـ " .. bestLocation, "🎯", Color3.fromRGB(100, 200, 100), function()
        Commands.TeleportToLocation(bestLocation)
        delay(1)
        Commands.TakeQuest()
        delay(1)
        Commands.StartSmartFarm()
    end)
    
    Interface.AddOption("🏝️ الذهاب للبداية", "🚀", Color3.fromRGB(255, 150, 100), function()
        Commands.TeleportToLocation("بداية")
    end)
    
    Interface.AddOption("⚓ الذهاب للقراصنة", "🌊", Color3.fromRGB(100, 150, 255), function()
        Commands.TeleportToLocation("قراصنة")
    end)
    
    Interface.AddOption("⚔️ الذهاب للمحاربين", "🛡️", Color3.fromRGB(200, 100, 200), function()
        Commands.TeleportToLocation("محاربين")
    end)
    
    Interface.AddOption("👮 الذهاب للبحارة", "⚖️", Color3.fromRGB(100, 200, 255), function()
        Commands.TeleportToLocation("بحارة")
    end)
    
    -- ==================== قسم المهام ====================
    Interface.AddOption("📝 أخذ مهمة جديدة", "📜", Color3.fromRGB(100, 200, 255), function()
        Commands.TakeQuest()
    end)
    
    Interface.AddOption("🌾 بدء/إيقاف فارم", "⚔️", Color3.fromRGB(100, 200, 100), function()
        Commands.StartSmartFarm()
    end)
    
    -- ==================== قسم التحكم ====================
    Interface.AddOption("📊 حالة النظام", "📈", Color3.fromRGB(100, 200, 255), function()
        Commands.CheckStatus()
    end)
    
    Interface.AddOption("🔄 إعادة تعيين", "🔄", Color3.fromRGB(200, 200, 100), function()
        Commands.ResetSystem()
    end)
    
    Interface.AddOption("🛑 إيقاف الكل", "⏹️", Color3.fromRGB(200, 100, 100), function()
        Commands.StopAll()
    end)
    
    Interface.AddOption("💀 إعادة التولد", "⚡", Color3.fromRGB(255, 100, 100), function()
        Commands.StopAll()
        delay(0.5)
        local character = game:GetService("Players").LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end)
    
    Interface.AddOption("ℹ️ معلومات النظام", "📋", Color3.fromRGB(100, 200, 200), function()
        print("🎮 النظام الكامل لـ Blox Fruits")
        print("📚 الإصدار: Ultimate System 4.0")
        print("👤 المطور: Mr.Qattusa")
        print("📊 مستواك: " .. playerLevel)
        print("📍 الموصى: " .. bestLocation)
        print("✨ طريقة العمل:")
        print("1. اضغط على '🚀 نظام متكامل كامل'")
        print("2. النظام راح:")
        print("   ├── يتلفيل للموقع المناسب")
        print("   ├── يأخذ مهمة مناسبة")
        print("   ├── يبدأ الفارم تلقائياً")
        print("   └── يتابع حتى إكمال المهمة")
        print("3. يمكنك متابعة التقدم من '📊 حالة النظام'")
    end)
    
    print("🎉 تم تحميل النظام الكامل بنجاح!")
    print("✅ الواجهة: جاهزة")
    print("✅ النظام: جاهز للعمل")
    print("📊 مستوى اللاعب: " .. playerLevel)
    print("📍 الموقع الموصى: " .. bestLocation)
    print("🚀 اضغط على '🚀 نظام متكامل كامل' للبدء التلقائي")
    
    -- إشعار الترحيب
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "النظام الكامل",
        Text = "جاهز! مستواك: " .. playerLevel,
        Duration = 5,
        Icon = "🎮"
    })
    
    -- إشعار التعليمات
    delay(2)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "كيفية الاستخدام",
        Text = "اضغط على 'نظام متكامل كامل' للبدء",
        Duration = 4,
        Icon = "💡"
    })
    
    return {
        Interface = Interface,
        Commands = Commands,
        PlayerLevel = playerLevel,
        BestLocation = bestLocation
    }
end)

if not success then
    warn("❌ خطأ في تحميل النظام: " .. tostring(err))
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "النظام",
        Text = "فشل التحميل: " .. tostring(err),
        Duration = 5,
        Icon = "⚠️"
    })
end
