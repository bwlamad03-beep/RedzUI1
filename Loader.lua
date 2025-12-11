-- Loader.lua - واجهة مبسطة ومستقرة
print("🔗 جاري تحميل النظام المؤمن...")

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
    
    delay(1)
    
    -- تحميل النظام
    print("📦 جاري تحميل النظام المؤمن...")
    local Commands = safeLoad("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua")
    if not Commands then error("❌ فشل تحميل النظام") end
    
    delay(1)
    
    -- الحصول على مستوى اللاعب
    local playerLevel = Commands.GetPlayerLevel()
    print("📊 مستوى اللاعب: " .. playerLevel)
    
    -- إضافة الأوامر للواجهة
    print("➕ جاري إضافة الأوامر...")
    
    -- زر رئيسي واحد فقط
    Interface.AddOption("🚀 ابدأ النظام التلقائي", "🤖", Color3.fromRGB(255, 80, 80), function()
        print("▶️ بدء النظام التلقائي...")
        Commands.StartFullSystem()
    end)
    
    -- زر التحكم
    Interface.AddOption("⏸️ إيقاف مؤقت", "⏸️", Color3.fromRGB(255, 180, 0), function()
        Commands.StopAll()
    end)
    
    -- زر الحالة
    Interface.AddOption("📊 عرض الحالة", "📈", Color3.fromRGB(100, 200, 255), function()
        Commands.CheckStatus()
    end)
    
    -- زر إعادة التعيين
    Interface.AddOption("🔄 إعادة تعيين", "🔄", Color3.fromRGB(200, 200, 100), function()
        Commands.ResetSystem()
    end)
    
    -- زر المساعدة
    Interface.AddOption("❓ المساعدة", "💡", Color3.fromRGB(100, 200, 200), function()
        print("🎮 النظام المؤمن لـ Blox Fruits")
        print("📚 الإصدار: Stable System 5.0")
        print("👤 المطور: Mr.Qattusa")
        print("📊 مستواك: " .. playerLevel)
        print("✨ كيف يعمل:")
        print("1. اضغط على '🚀 ابدأ النظام التلقائي'")
        print("2. النظام راح يعمل كل شيء تلقائياً")
        print("3. راقب التقدم من '📊 عرض الحالة'")
        print("4. استخدم '⏸️ إيقاف مؤقت' للتوقف")
        print("⚠️ النظام مؤمن ضد التوقف المفاجئ")
    end)
    
    print("✅ تم تحميل النظام بنجاح!")
    print("📊 مستوى اللاعب: " .. playerLevel)
    print("🚀 اضغط على 'ابدأ النظام التلقائي' للبدء")
    
    -- إشعار ترحيبي
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "النظام المؤمن",
        Text = "جاهز! اضغط الزر الرئيسي للبدء",
        Duration = 5,
        Icon = "✅"
    })
    
    return {
        Interface = Interface,
        Commands = Commands,
        PlayerLevel = playerLevel
    }
end)

if not success then
    warn("❌ خطأ في التحميل: " .. tostring(err))
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "خطأ",
        Text = "فشل التحميل: " .. tostring(err),
        Duration = 5,
        Icon = "❌"
    })
end
