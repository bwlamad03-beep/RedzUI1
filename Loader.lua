-- Loader.lua - محمل لتجميع الواجهة والأوامر
-- رابط: loadstring(game:HttpGet("https://raw.githubusercontent.com/اسمك/RedzUI/main/Loader.lua"))()

print("🔗 جاري تحميل Mr.Qattusa System...")

local function safeLoad(url)
    local success, result = pcall(function()
        local content = game:HttpGet(url, true)
        return loadstring(content)()
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
    local Interface = safeLoad("https://raw.githubusercontent.com/اسمك/RedzUI/main/Interface.lua")
    if not Interface then error("❌ فشل تحميل الواجهة") end
    
    delay(0.5)
    
    -- تحميل الأوامر
    print("📦 جاري تحميل الأوامر...")
    local Commands = safeLoad("https://raw.githubusercontent.com/اسمك/RedzUI/main/Commands.lua")
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
    Interface.AddOption("تلفيل للاعب", "🎯", Color3.fromRGB(100, 255, 150), function()
        local playerName = "اسم اللاعب هنا"
        Commands.TeleportTo(playerName)
    end)
    
    Interface.AddOption("نسخ الموقع", "📋", Color3.fromRGB(255, 200, 100), function()
        Commands.CopyPosition()
    end)
    
    Interface.AddOption("ESP", "👁️", Color3.fromRGB(150, 200, 255), function()
        Commands.ESP()
    end)
    
    -- مجموعة أوامر النظام
    Interface.AddOption("إعادة التولد", "🔄", Color3.fromRGB(255, 150, 100), function()
        Commands.Refresh()
    end)
    
    Interface.AddOption("قائمة الأوامر", "📋", Color3.fromRGB(200, 200, 100), function()
        Commands.ListCommands()
    end)
    
    Interface.AddOption("حالة النظام", "📊", Color3.fromRGB(100, 200, 200), function()
        Commands.GetStatus()
    end)
    
    Interface.AddOption("تنظيف النظام", "🧹", Color3.fromRGB(200, 100, 100), function()
        Commands.Cleanup()
    end)
    
    print("🎉