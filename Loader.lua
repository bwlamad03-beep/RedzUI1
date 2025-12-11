-- Loader.lua بسيط ومباشر
print("🔗 تحميل RedzUI...")

-- 1. تحميل الواجهة
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Interface.lua"))()

if UI then
    print("✅ الواجهة محملة")
    
    -- 2. إضافة خيارات مباشرة
    UI.AddOption("🚀 بدء النظام", "▶️", Color3.fromRGB(255, 80, 80), function()
        print("🎮 بدء النظام...")
    end)
    
    UI.AddOption("📍 تلفيل", "🏠", Color3.fromRGB(100, 200, 100), function()
        local plr = game.Players.LocalPlayer
        if plr.Character then
            plr.Character:MoveTo(Vector3.new(-1085, 15, 1422))
        end
    end)
    
    UI.AddOption("📊 حالة", "📈", Color3.fromRGB(100, 200, 255), function()
        print("📊 النظام شغال")
    end)
    
    UI.AddOption("⏹️ إيقاف", "⏸️", Color3.fromRGB(255, 180, 0), function()
        print("⏹️ تم الإيقاف")
    end)
    
    UI.AddOption("💀 إعادة تولد", "🔄", Color3.fromRGB(255, 100, 100), function()
        local char = game.Players.LocalPlayer.Character
        if char then
            char:BreakJoints()
        end
    end)
    
    print("✅ تمت إضافة 5 خيارات")
else
    print("❌ فشل تحميل الواجهة")
end
