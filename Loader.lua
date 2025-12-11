-- Loader.lua بديل مباشر
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Interface.lua"))()

if UI and UI.AddOption then
    -- إضافة خيارات مباشرة
    UI.AddOption("🚀 ابدأ", "▶️", Color3.fromRGB(255, 80, 80), function()
        print("بدأ النظام")
    end)
    
    UI.AddOption("📍 تلفيل", "🏠", Color3.fromRGB(100, 200, 100), function()
        local plr = game.Players.LocalPlayer
        if plr.Character then
            plr.Character:MoveTo(Vector3.new(-1085, 15, 1422))
        end
    end)
    
    UI.AddOption("📊 حالة", "📈", Color3.fromRGB(100, 200, 255), function()
        print("الحالة: جيد")
    end)
    
    print("✅ تمت إضافة 3 خيارات")
else
    print("❌ مشكلة في الواجهة")
end
