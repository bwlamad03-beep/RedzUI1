-- Loader.lua - محمل بسيط وشغال
print("🚀 تحميل RedzUI البسيط...")

-- تحميل الواجهة
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Interface.lua"))()

if UI then
    print("✅ الواجهة محملة")
    
    -- إضافة خيارات مباشرة
    UI.AddOption("🚀 بدء النظام", "▶️", Color3.fromRGB(255, 80, 80), function()
        print("🎮 بدء النظام...")
        -- تحميل الأوامر وتشغيلها
        local cmds = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua"))()
        if cmds and cmds.StartFullSystem then
            cmds.StartFullSystem()
        end
    end)
    
    UI.AddOption("📍 تلفيل للبداية", "🏠", Color3.fromRGB(100, 200, 100), function()
        print("📍 تلفيل للبداية...")
        local char = game.Players.LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(-1085, 15, 1422)
            end
        end
    end)
    
    UI.AddOption("⚔️ فارم سريع", "⚔️", Color3.fromRGB(255, 180, 0), function()
        print("⚔️ بدء الفارم...")
        local cmds = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua"))()
        if cmds and cmds.StartSmartFarm then
            cmds.StartSmartFarm()
        end
    end)
    
    UI.AddOption("📊 حالة النظام", "📈", Color3.fromRGB(100, 200, 255), function()
        print("📊 جاري فحص الحالة...")
        local cmds = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua"))()
        if cmds and cmds.CheckStatus then
            cmds.CheckStatus()
        end
    end)
    
    UI.AddOption("⏹️ إيقاف الكل", "⏸️", Color3.fromRGB(255, 100, 100), function()
        print("⏹️ إيقاف جميع الأنظمة...")
        local cmds = loadstring(game:HttpGet("https://raw.githubusercontent.com/bwlamad03-beep/RedzUI1/main/Commands.lua"))()
        if cmds and cmds.StopAll then
            cmds.StopAll()
        end
    end)
    
    UI.AddOption("❓ مساعدة", "💡", Color3.fromRGB(200, 200, 100), function()
        print("🎮 RedzUI System")
        print("📚 Version: Simple 1.0")
        print("👤 By: Mr.Qattusa")
        print("✨ 6 خيارات متاحة")
    end)
    
    print("✅ تمت إضافة 6 خيارات!")
    print("🎯 اضغط على القط 🐱 لرؤية القائمة")
    
else
    print("❌ فشل تحميل الواجهة!")
end
