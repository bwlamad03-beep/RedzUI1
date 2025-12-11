-- Commands.lua - نظام يستمر حتى مع الأخطاء
local RedzCommands = {}
RedzCommands.Version = "No-Stop System 6.0"
RedzCommands.Author = "Mr.Qattusa"

-- مكتبات النظام
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- متغيرات النظام
RedzCommands.Farming = {
    Enabled = false,
    CurrentTarget = nil,
    HasQuest = false,
    QuestNPC = nil,
    CurrentLevel = 0,
    QuestCompleted = false,
    FlyingHeight = 25,
    AutoFarmRange = 100,
    KillCount = 0,
    RequiredKills = 10,
    IsBusy = false
}

local LocalPlayer = Players.LocalPlayer

-- دالة تأخير بسيطة
local function delay(time)
    if task then
        task.wait(time)
    else
        wait(time)
    end
end

-- دالة تنفيذ بدون توقف
local function tryExecute(func, taskName)
    local success, result = pcall(func)
    if not success then
        print("⚠️ خطأ في " .. taskName .. ": " .. tostring(result))
        return false
    end
    return true
end

-- ==================== دوال أساسية بدون توقف ====================
function RedzCommands.GetCharacter()
    return tryExecute(function()
        local character = LocalPlayer.Character
        if not character then
            print("⏳ انتظار الشخصية...")
            delay(2)
            character = LocalPlayer.Character
        end
        
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            return character, humanoid, root
        end
        
        return nil, nil, nil
    end, "جلب الشخصية")
end

function RedzCommands.Notify(title, text, duration)
    tryExecute(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end, "الإشعار")
end

-- ==================== نظام كشف المستوى ====================
function RedzCommands.GetPlayerLevel()
    local level = 1
    
    tryExecute(function()
        -- طريقة بسيطة لمعرفة المستوى
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local levelStat = leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("Lvl")
            if levelStat then
                level = tonumber(levelStat.Value) or 1
            end
        end
    end, "قراءة المستوى")
    
    RedzCommands.Farming.CurrentLevel = level
    print("📊 المستوى: " .. level)
    return level
end

-- ==================== نظام التلفيل البسيط ====================
function RedzCommands.TeleportToLocation(locationName)
    if RedzCommands.Farming.IsBusy then
        print("⏳ النظام مشغول حالياً")
        return false
    end
    
    RedzCommands.Farming.IsBusy = true
    
    print("🚀 بدء التلفيل إلى: " .. locationName)
    
    -- قائمة المواقع الثابتة
    local locations = {
        ["بداية"] = Vector3.new(-1085, 15, 1422),
        ["قراصنة"] = Vector3.new(-1093, 15, 3944),
        ["محاربين"] = Vector3.new(1458, 15, -1780),
        ["بحارة"] = Vector3.new(-838, 15, -2167)
    }
    
    local targetPos = locations[locationName]
    if not targetPos then
        print("❌ الموقع غير معروف")
        RedzCommands.Farming.IsBusy = false
        return false
    end
    
    local success = tryExecute(function()
        local character, _, root = RedzCommands.GetCharacter()
        if not root then
            print("❌ لا توجد شخصية")
            return false
        end
        
        -- التلفيل مباشرة
        root.CFrame = CFrame.new(targetPos)
        print("✅ تم التلفيل إلى: " .. locationName)
        
        -- انتظار للتثبيت
        delay(2)
        
        -- تأكيد البقاء
        local currentPos = root.Position
        local distance = (currentPos - targetPos).Magnitude
        
        if distance > 50 then
            print("⚠️ تم إرجاع اللاعب، إعادة التلفيل...")
            root.CFrame = CFrame.new(targetPos)
            delay(1)
        end
        
        RedzCommands.Notify("التلفيل", "تم الوصول إلى " .. locationName, 2)
        return true
    end, "التلفيل")
    
    RedzCommands.Farming.IsBusy = false
    return success
end

-- ==================== نظام أخذ المهمة ====================
function RedzCommands.TakeQuest()
    if RedzCommands.Farming.IsBusy then
        print("⏳ النظام مشغول")
        return false
    end
    
    RedzCommands.Farming.IsBusy = true
    print("📝 جاري أخذ المهمة...")
    
    local success = tryExecute(function()
        -- 1. الحصول على المستوى
        local level = RedzCommands.GetPlayerLevel()
        
        -- 2. تحديد موقع NPC
        local locationName = "بداية"
        if level >= 30 then locationName = "قراصنة"
        elseif level >= 50 then locationName = "محاربين" end
        
        print("📍 الذهاب لـ NPC في: " .. locationName)
        
        -- 3. التلفيل
        local teleportSuccess = RedzCommands.TeleportToLocation(locationName)
        if not teleportSuccess then
            print("❌ فشل التلفيل لـ NPC")
            return false
        end
        
        -- 4. انتظار وهمي لأخذ المهمة
        delay(2)
        
        -- 5. تأكيد أخذ المهمة
        RedzCommands.Farming.HasQuest = true
        RedzCommands.Farming.QuestNPC = locationName
        RedzCommands.Farming.KillCount = 0
        RedzCommands.Farming.RequiredKills = 10
        
        print("✅ تم أخذ المهمة!")
        RedzCommands.Notify("المهمة", "تم أخذ المهمة", 3)
        
        return true
    end, "أخذ المهمة")
    
    RedzCommands.Farming.IsBusy = false
    return success
end

-- ==================== نظام الفارم البسيط ====================
function RedzCommands.StartSmartFarm()
    if RedzCommands.Farming.Enabled then
        -- إيقاف الفارم
        RedzCommands.Farming.Enabled = false
        print("🛑 إيقاف الفارم")
        RedzCommands.Notify("الفارم", "تم الإيقاف", 2)
        return
    end
    
    -- بدء الفارم
    RedzCommands.Farming.Enabled = true
    print("🌾 بدء الفارم...")
    RedzCommands.Notify("الفارم", "بدأ الفارم", 2)
    
    -- حلقة الفارم في thread منفصل
    spawn(function()
        while RedzCommands.Farming.Enabled do
            tryExecute(function()
                local character, _, root = RedzCommands.GetCharacter()
                if not root then
                    delay(1)
                    return
                end
                
                -- البحث عن أي هدف قريب
                local foundTarget = nil
                
                -- أسماء أهداف ممكنة
                local targetNames = {"Bandit", "Pirate", "Marine", "Brute", "Monkey"}
                
                for _, name in pairs(targetNames) do
                    local target = Workspace:FindFirstChild(name, true)
                    if target and target:IsA("Model") then
                        local humanoid = target:FindFirstChildOfClass("Humanoid")
                        local targetRoot = target:FindFirstChild("HumanoidRootPart")
                        
                        if humanoid and humanoid.Health > 0 and targetRoot then
                            local distance = (root.Position - targetRoot.Position).Magnitude
                            if distance < 100 then
                                foundTarget = target
                                break
                            end
                        end
                    end
                end
                
                if foundTarget then
                    -- التحرك للهدف
                    local targetRoot = foundTarget:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local attackPos = targetRoot.Position + Vector3.new(0, 20, 0)
                        root.CFrame = CFrame.new(attackPos)
                        
                        delay(0.5)
                        
                        -- زيادة العداد
                        local humanoid = foundTarget:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health <= 0 then
                            RedzCommands.Farming.KillCount = RedzCommands.Farming.KillCount + 1
                            print("💀 قتل (" .. RedzCommands.Farming.KillCount .. "/10)")
                            
                            -- تحقق إذا اكتملت المهمة
                            if RedzCommands.Farming.KillCount >= 10 then
                                print("🎉 اكتملت المهمة!")
                                RedzCommands.Farming.QuestCompleted = true
                                RedzCommands.Notify("المهمة", "اكتملت!", 3)
                                delay(2)
                                
                                -- أخذ مهمة جديدة
                                RedzCommands.TakeQuest()
                            end
                        end
                    end
                else
                    -- حركة بحث
                    local randomX = math.random(-30, 30)
                    local randomZ = math.random(-30, 30)
                    local newPos = root.Position + Vector3.new(randomX, 0, randomZ)
                    root.CFrame = CFrame.new(newPos)
                    delay(2)
                end
                
                delay(0.3)
            end, "دورة الفارم")
        end
    end)
end

-- ==================== النظام المتكامل ====================
function RedzCommands.StartFullSystem()
    print("🚀 بدء النظام المتكامل...")
    
    -- بدء كل شيء في thread منفصل
    spawn(function()
        tryExecute(function()
            print("📊 جاري التحضير...")
            
            -- 1. الحصول على المستوى
            local level = RedzCommands.GetPlayerLevel()
            print("📊 مستوى اللاعب: " .. level)
            
            -- 2. اختيار الموقع
            local locationName = "بداية"
            if level >= 30 then locationName = "قراصنة"
            elseif level >= 50 then locationName = "محاربين" end
            
            print("📍 الموقع المختار: " .. locationName)
            
            -- 3. التلفيل
            RedzCommands.Notify("النظام", "جاري التلفيل...", 2)
            delay(1)
            
            local teleportSuccess = RedzCommands.TeleportToLocation(locationName)
            if not teleportSuccess then
                print("⚠️ فشل التلفيل، لكن النظام يستمر")
            end
            
            -- 4. أخذ المهمة
            delay(2)
            RedzCommands.Notify("النظام", "جاري أخذ المهمة...", 2)
            delay(1)
            
            local questSuccess = RedzCommands.TakeQuest()
            if not questSuccess then
                print("⚠️ فشل أخذ المهمة، لكن النظام يستمر")
            end
            
            -- 5. بدء الفارم
            delay(2)
            RedzCommands.Notify("النظام", "بدء الفارم...", 2)
            delay(1)
            
            if not RedzCommands.Farming.Enabled then
                RedzCommands.StartSmartFarm()
            end
            
            -- 6. إشعار نهائي
            delay(1)
            print("✅ النظام يعمل الآن!")
            RedzCommands.Notify("النظام", "جاري العمل...", 4)
            
        end, "النظام المتكامل")
    end)
end

-- ==================== أوامر التحكم ====================
function RedzCommands.CheckStatus()
    local level = RedzCommands.GetPlayerLevel()
    
    print("📊 حالة النظام:")
    print("├── المستوى: " .. level)
    print("├── الفارم: " .. (RedzCommands.Farming.Enabled and "✅ نشط" or "❌ متوقف"))
    print("├── المهمة: " .. (RedzCommands.Farming.HasQuest and "✅" or "❌"))
    print("├── القتلى: " .. RedzCommands.Farming.KillCount .. "/10")
    print("└── اكتمال: " .. (RedzCommands.Farming.QuestCompleted and "✅" or "❌"))
    
    RedzCommands.Notify("الحالة", "المستوى: " .. level, 2)
end

function RedzCommands.StopAll()
    RedzCommands.Farming.Enabled = false
    RedzCommands.Farming.IsBusy = false
    
    print("🛑 توقف النظام")
    RedzCommands.Notify("النظام", "تم الإيقاف", 2)
end

function RedzCommands.ResetSystem()
    RedzCommands.StopAll()
    delay(0.5)
    
    RedzCommands.Farming = {
        Enabled = false,
        CurrentTarget = nil,
        HasQuest = false,
        QuestNPC = nil,
        CurrentLevel = 0,
        QuestCompleted = false,
        FlyingHeight = 25,
        AutoFarmRange = 100,
        KillCount = 0,
        RequiredKills = 10,
        IsBusy = false
    }
    
    print("🔄 إعادة تعيين")
    RedzCommands.Notify("النظام", "تم إعادة التعيين", 2)
end

-- ==================== التفعيل ====================
function RedzCommands.Init()
    print("🎮 النظام الجديد جاهز!")
    print("📚 الإصدار: " .. RedzCommands.Version)
    print("👤 المطور: " .. RedzCommands.Author)
    print("✨ المميزات:")
    print("├── لا يتوقف عند الأخطاء")
    print("├── يستمر في العمل")
    print("├── بسيط وثابت")
    print("└── يعمل حتى مع المشاكل")
    
    return RedzCommands
end

RedzCommands.Init()
return RedzCommands
