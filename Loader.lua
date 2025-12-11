-- Loader.lua - واجهة بسيطة جداً
print("🔗 جاري تحميل النظام...")

local success, Interface = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Interface.lua"))()
end)

local success2, Commands = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua"))()
end)

if not Interface or not Commands then
    print("❌ فشل تحميل بعض الملفات")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "تحميل",
        Text = "تم التحميل جزئياً",
        Duration = 3
    })
end

if Interface and Commands then
    -- زر رئيسي واحد فقط
    Interface.AddOption("🚀 ابدأ النظام", "▶️", Color3.fromRGB(255, 80, 80), function()
        print("▶️ بدء النظام...")
        Commands.StartFullSystem()
    end)
    
    -- زر الإيقاف
    Interface.AddOption("⏹️ إيقاف", "⏹️", Color3.fromRGB(255, 180, 0), function()
        Commands.StopAll()
    end)
    
    -- زر الحالة
    Interface.AddOption("📊 الحالة", "📈", Color3.fromRGB(100, 200, 255), function()
        Commands.CheckStatus()
    end)
    
    print("✅ النظام جاهز!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "جاهز",
        Text = "اضغط 'ابدأ النظام'",
        Duration = 3
    })
end
