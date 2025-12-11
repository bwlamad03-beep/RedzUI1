-- Loader.lua - واجهة نظام فارم بلوكس فروت
print("🔗 جاري تحميل نظام فارم بلوكس فروت...")

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
    
    -- تحميل نظام الفارم
    print("📦 جاري تحميل نظام الفارم...")
    local Commands = safeLoad("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua")
    if not Commands then error("❌ فشل تحميل نظام الفارم") end
    
    delay(0.5)
    
    -- إضافة أوامر الفارم للواجهة
    print("➕ جاري إضافة أوامر بلوكس فروت...")
    
    -- ==================== قسم التحكم الرئيسي ====================
    Interface.AddOption("🚀 بدء/إيقاف الفارم", "⚔️", Color3.fromRGB(255, 80, 80), function()
        Commands.StartBloxFruitsFarm()
    end)
    
    Interface.AddOption("🔀 تبديل وضع الفارم", "👑", Color3.fromRGB(255, 180, 0), function()
        Commands.ToggleFarmMode()
    end)
    
    Interface.AddOption("📊 حالة النظام", "📈", Color3.fromRGB(100, 200, 255), function()
        Commands.GetFarmingStatus()
    end)
    
    -- ==================== قسم الإعدادات ====================
    Interface.AddOption("🦅 ارتفاع الطيران: 30", "📏", Color3.fromRGB(150, 220, 255), function()
        Commands.SetFlyingHeight(30)
    end)
    
    Interface.AddOption("🦅 ارتفاع الطيران: 50", "⬆️", Color3.fromRGB(120, 200, 255), function()
        Commands.SetFlyingHeight(50)
    end)
    
    Interface.AddOption("🔍 نطاق البحث: 100", "🎯", Color3.fromRGB(200, 150, 255), function()
        Commands.SetSearchRadius(100)
    end)
    
    Interface.AddOption("🔍 نطاق البحث: 200", "🔭", Color3.fromRGB(180, 130, 255), function()
        Commands.SetSearchRadius(200)
    end)
    
    -- ==================== قسم الخدمات ====================
    Interface.AddOption("📍 تلفيل للبداية", "🏠", Color3.fromRGB(100, 255, 150), function()
        Commands.TeleportToSpawn()
    end)
    
    Interface.AddOption("🔄 إعادة التولد", "💀", Color3.fromRGB(255, 100, 100), function()
        local character = game:GetService("Players").LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end)
    
    Interface.AddOption("🧹 تنظيف النظام", "🗑️", Color3.fromRGB(200, 100, 100), function()
        Commands.Cleanup()
    end)
    
    Interface.AddOption("ℹ️ معلومات النظام", "📋", Color3.fromRGB(100, 200, 200), function()
        print("🏝️ نظام فارم بلوكس فروت")
        print("📚 الإصدار: Blox Fruits Farmer 4.0")
        print("👤 المطور: Mr.Qattusa")
        print("✨ المميزات:")
        print("├── فارم تلقائي للـ NPCs")
        print("├── صيد البوسات الأقوياء")
        print("├── طيران متقدم فوق الأهداف")
        print("├── هجوم بالمهارات تلقائي")
        print("└── إعدادات متعددة")
    end)
    
    print("🎉 تم تحميل نظام فارم بلوكس فروت!")
    print("✅ الواجهة: جاهزة")
    print("✅ النظام: جاهز للعمل")
    print("🚀 اضغط على 'بدء/إيقاف الفارم' للبدء")
    print("⚙️ يمكنك تغيير الإعدادات من القائمة")
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Blox Fruits Farmer",
        Text = "جاهز للعمل! ابدأ الفارم الآن",
        Duration = 5,
        Icon = "⚔️"
    })
    
    return {
        Interface = Interface,
        Commands = Commands,
        Version = "Blox Fruits Farmer 4.0"
    }
end)

if not success then
    warn("❌ خطأ في تحميل النظام: " .. tostring(err))
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Blox Fruits Farmer",
        Text = "فشل التحميل: " .. tostring(err),
        Duration = 5,
        Icon = "⚠️"
    })
end
