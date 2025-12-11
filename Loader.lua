-- Loader.lua - محمل نظام RedzUI الكامل
print("🔗 جاري تحميل Mr.Qattusa System...")

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
    
    -- تحميل الأوامر
    print("📦 جاري تحميل الأوامر...")
    local Commands = safeLoad("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua")
    if not Commands then error("❌ فشل تحميل الأوامر") end
    
    delay(0.5)
    
    -- إضافة الأوامر للواجهة
    print("➕ جاري إضافة الأوامر للواجهة...")
    
    -- مجموعة أوامر الحركة
    Interface.AddOption("السرعة ×2", "🚀", Color3.fromRGB(200, 100, 255), function()
        Commands.Speed(100)
    end)
    
    Interface.AddOption("القفزة ×2", "🐰", Color3.fromRGB(255, 150, 100), function()
        Commands.Jump(100)
    end)
    
    Interface.AddOption("الطيران", "🦅", Color3.fromRGB(100, 200, 255), function()
        Commands.Fly()
    end)
    
    Interface.AddOption("النوكلب", "👻", Color3.fromRGB(150, 150, 255), function()
        Commands.Noclip()
    end)
    
    -- مجموعة أوامر اللعبة
    Interface.AddOption("تلفيل للاعب قريب", "🎯", Color3.fromRGB(100, 255, 150), function()
        Commands.TeleportTo("") -- هيشتغل مع الواجهة المعدلة
    end)
    
    Interface.AddOption("نسخ الموقع", "📋", Color3.fromRGB(255, 200, 100), function()
        Commands.CopyPosition()
    end)
    
    Interface.AddOption("ESP (رؤية)", "👁️", Color3.fromRGB(150, 200, 255), function()
        Commands.ESP()
    end)
    
    -- مجموعة أوامر النظام
    Interface.AddOption("إعادة التولد", "🔄", Color3.fromRGB(255, 150, 100), function()
        Commands.Refresh()
    end)
    
    Interface.AddOption("حالة النظام", "📊", Color3.fromRGB(100, 200, 200), function()
        Commands.GetStatus()
    end)
    
    Interface.AddOption("تنظيف النظام", "🧹", Color3.fromRGB(200, 100, 100), function()
        Commands.Cleanup()
    end)
    
    print("🎉 تم تحميل النظام بالكامل!")
    print("✅ الواجهة: جاهزة")
    print("✅ الأوامر: 10 أوامر")
    print("🚀 النظام جاهز للاستخدام!")
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Mr.Qattusa System",
        Text = "تم التحميل بنجاح! اضغط RCtrl لفتح القائمة",
        Duration = 5,
        Icon = "🐱"
    })
    
    return {
        Interface = Interface,
        Commands = Commands,
        Version = "2.0"
    }
end)

if not success then
    warn("❌ خطأ في تحميل النظام: " .. tostring(err))
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Mr.Qattusa System",
        Text = "فشل التحميل: " .. tostring(err),
        Duration = 5,
        Icon = "⚠️"
    })
end
