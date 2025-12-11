-- Loader.lua - واجهة نظام التلفيل البسيط
print("🔗 جاري تحميل نظام التلفيل...")

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
    
    -- تحميل نظام التلفيل
    print("📦 جاري تحميل نظام التلفيل...")
    local Commands = safeLoad("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua")
    if not Commands then error("❌ فشل تحميل نظام التلفيل") end
    
    delay(0.5)
    
    -- إضافة أوامر التلفيل للواجهة
    print("➕ جاري إضافة أوامر التلفيل...")
    
    -- ==================== قسم الجزر الرئيسية ====================
    Interface.AddOption("🏝️ جزيرة البداية", "📍", Color3.fromRGB(100, 200, 100), function()
        Commands.TeleportToIsland("بداية")
    end)
    
    Interface.AddOption("🏝️ مدينة القراصنة", "⚓", Color3.fromRGB(200, 100, 100), function()
        Commands.TeleportToIsland("مدينة القراصنة")
    end)
    
    Interface.AddOption("🏝️ قرية المحاربين", "⚔️", Color3.fromRGB(100, 150, 255), function()
        Commands.TeleportToIsland("قرية المحاربين")
    end)
    
    Interface.AddOption("🏝️ مدينة البحارة", "👮", Color3.fromRGB(100, 200, 255), function()
        Commands.TeleportToIsland("مدينة البحارة")
    end)
    
    Interface.AddOption("🏝️ السجن", "🔒", Color3.fromRGB(150, 150, 150), function()
        Commands.TeleportToIsland("سجن")
    end)
    
    -- ==================== قسم البوسات ====================
    Interface.AddOption("👑 الملك غوريلا", "🦍", Color3.fromRGB(150, 100, 50), function()
        Commands.TeleportToBoss("الملك غوريلا")
    end)
    
    Interface.AddOption("👑 بوبي", "🤡", Color3.fromRGB(255, 100, 100), function()
        Commands.TeleportToBoss("بوبي")
    end)
    
    Interface.AddOption("👑 قائد القراصنة", "☠️", Color3.fromRGB(200, 150, 50), function()
        Commands.TeleportToBoss("قائد القراصنة")
    end)
    
    Interface.AddOption("👑 القرش", "🦈", Color3.fromRGB(100, 150, 200), function()
        Commands.TeleportToBoss("القرش")
    end)
    
    -- ==================== قسم الخدمات ====================
    Interface.AddOption("🎯 قبول المهام", "📜", Color3.fromRGB(255, 200, 100), function()
        Commands.TeleportToQuestNPC()
    end)
    
    Interface.AddOption("📍 موقعي الحالي", "📊", Color3.fromRGB(100, 200, 200), function()
        Commands.ShowCurrentPosition()
    end)
    
    Interface.AddOption("📋 نسخ الموقع", "📝", Color3.fromRGB(200, 200, 100), function()
        Commands.CopyPosition()
    end)
    
    Interface.AddOption("📍 قائمة المواقع", "📋", Color3.fromRGB(150, 150, 255), function()
        Commands.ListLocations()
    end)
    
    Interface.AddOption("🛡️ منطقة آمنة", "🏠", Color3.fromRGB(100, 255, 100), function()
        Commands.GoToSafeZone()
    end)
    
    Interface.AddOption("🌊 البحر", "💧", Color3.fromRGB(100, 150, 255), function()
        Commands.GoToSea()
    end)
    
    print("🎉 تم تحميل نظام التلفيل بنجاح!")
    print("✅ الواجهة: جاهزة")
    print("✅ التلفيل: 15 موقع متاح")
    print("🚀 اضغط على أي موقع للانتقال إليه فوراً")
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "نظام التلفيل",
        Text = "جاهز! اختر موقعاً من القائمة",
        Duration = 5,
        Icon = "📍"
    })
    
    return {
        Interface = Interface,
        Commands = Commands,
        Version = "Teleport System 1.0"
    }
end)

if not success then
    warn("❌ خطأ في تحميل النظام: " .. tostring(err))
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "نظام التلفيل",
        Text = "فشل التحميل: " .. tostring(err),
        Duration = 5,
        Icon = "⚠️"
    })
end
