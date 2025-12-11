-- Commands.lua - نظام التلفيل والفارم الذكي الكامل
local RedzCommands = {}
RedzCommands.Version = "Ultimate System 4.0"
RedzCommands.Author = "Mr.Qattusa"

-- مكتبات النظام
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

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
    RequiredKills = 10
}

RedzCommands.Connections = {}
local LocalPlayer = Players.LocalPlayer

-- دالة تأخير
local function delay(time)
    if task then
        return task.wait(time)
    else
        return wait(time)
    end
end

-- ==================== دوال المساعدة ====================
function RedzCommands.GetCharacter()
    local character = LocalPlayer.Character
    if not character then return nil, nil, nil end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
    return character, humanoid, root
end

function RedzCommands.Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- ==================== نظام كشف المستوى ====================
function RedzCommands.GetPlayerLevel()
    local level = 1
    
    -- البحث في leaderstats
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local levelStat = leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("Lvl")
        if levelStat then
            level = tonumber(levelStat.Value) or 1
        end
    end
    
    -- البحث في Stats
    local character = LocalPlayer.Character
    if character then
        local stats = character:FindFirstChild("Stats")
        if stats then
            local levelValue = stats:FindFirstChild("Level") or stats:FindFirstChild("Lvl")
            if levelValue then
                level = tonumber(levelValue.Value) or level
            end
        end
    end
    
    RedzCommands.Farming.CurrentLevel = level
    return level
end

-- ==================== نظام التلفيل الثابت ====================
function RedzCommands.TeleportToPosition(x, y, z)
    local character, humanoid, root = RedzCommands.GetCharacter()
    if not root then return false end
    
    -- التلفيل مع تأثير
    local originalPos = root.Position
    local targetPos = Vector3.new(x, y, z)
    
    root.CFrame = CFrame.new(targetPos)
    
    -- إضافة BodyPosition للثبات
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Position = targetPos
    bodyPosition.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyPosition.P = 1000
    bodyPosition.Parent = root
    
    -- إشعار
    print("📍 تلفيل إلى: " .. math.floor(x) .. ", " .. math.floor(y) .. ", " .. math.floor(z))
    RedzCommands.Notify("التلفيل", "تم التلفيل بنجاح", 2)
    
    -- تنظيف بعد ثواني
    delay(2)
    if bodyPosition then
        bodyPosition:Destroy()
    end
    
    return true
end

function RedzCommands.TeleportToLocation(locationName)
    local locations = {
        ["بداية"] = {x = -1085, y = 15, z = 1422},
        ["قراصنة"] = {x = -1093, y = 15, z = 3944},
        ["محاربين"] = {x = 1458, y = 15, z = -1780},
        ["بحارة"] = {x = -838, y = 15, z = -2167},
        ["جبل"] = {x = 1122, y = 15, z = 3939},
        ["صحراء"] = {x = 1275, y = 15, z = -2144},
        ["سجن"] = {x = 4864, y = 15, z = 100}
    }
    
    local loc = locations[locationName]
    if loc then
        return RedzCommands.TeleportToPosition(loc.x, loc.y, loc.z)
    end
    
    return false
end

-- ==================== نظام أخذ المهمة ====================
function RedzCommands.TakeQuest()
    local level = RedzCommands.GetPlayerLevel()
    print("📊 مستواك: " .. level)
    
    -- تحديد NPC بناءً على المستوى
    local npcLocation = {x = -1085, y = 15, z = 1422}
    local npcName = "قبول المهام"
    
    if level >= 30 then
        npcLocation = {x = -1093, y = 15, z = 3944}
        npcName = "مهام القراصنة"
    elseif level >= 50 then
        npcLocation = {x = 1458, y = 15, z = -1780}
        npcName = "مهام المحاربين"
    elseif level >= 75 then
        npcLocation = {x = -838, y = 15, z = -2167}
        npcName = "مهام البحارة"
    end
    
    -- التلفيل لـ NPC
    RedzCommands.TeleportToPosition(npcLocation.x, npcLocation.y + 5, npcLocation.z)
    
    -- محاكاة أخذ المهمة
    delay(2)
    RedzCommands.Farming.HasQuest = true
    RedzCommands.Farming.QuestNPC = npcName
    RedzCommands.Farming.KillCount = 0
    RedzCommands.Farming.RequiredKills = 10
    
    print("✅ تم أخذ المهمة من: " .. npcName)
    RedzCommands.Notify("المهمة", "تم أخذ المهمة", 3)
    
    return true
end

-- ==================== نظام البحث عن الأهداف ====================
function RedzCommands.FindTargetsForLevel()
    local level = RedzCommands.GetPlayerLevel()
    local targets = {}
    
    if level < 20 then
        targets = {"Bandit", "Monkey"}
    elseif level < 40 then
        targets = {"Pirate", "Brute", "Desert Bandit"}
    elseif level < 60 then
        targets = {"Marine", "Chief Petty Officer", "Shark"}
    elseif level < 80 then
        targets = {"Sky Bandit", "Galley Captain", "Dark Master"}
    else
        targets = {"Gorilla King", "Pirate Captain", "Soul Reaper"}
    end
    
    return targets
end

function RedzCommands.FindTarget()
    local character, _, root = RedzCommands.GetCharacter()
    if not root then return nil end
    
    local targets = RedzCommands.FindTargetsForLevel()
    
    -- البحث في Workspace
    for _, targetName in pairs(targets) do
        local target = Workspace:FindFirstChild(targetName, true)
        
        if target and target:IsA("Model") then
            local humanoid = target:FindFirstChildOfClass("Humanoid")
            local targetRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso")
            
            if humanoid and humanoid.Health > 0 and targetRoot then
                local distance = (root.Position - targetRoot.Position).Magnitude
                
                if distance < RedzCommands.Farming.AutoFarmRange then
                    print("🎯 وجدت هدف: " .. targetName)
                    return target
                end
            end
        end
    end
    
    return nil
end

-- ==================== نظام الهجوم ====================
function RedzCommands.AttackTarget(target)
    if not target then return false end
    
    local character, _, root = RedzCommands.GetCharacter()
    if not root then return false end
    
    local targetRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso")
    if not targetRoot then return false end
    
    -- التحرك فوق الهدف
    local attackPos = targetRoot.Position + Vector3.new(0, RedzCommands.Farming.FlyingHeight, 0)
    root.CFrame = CFrame.new(attackPos)
    
    -- محاكاة الهجوم
    delay(0.5)
    
    -- استخدام المهارات
    local skills = {"Z", "X", "C", "V"}
    for _, skill in pairs(skills) do
        pcall(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[skill], false, nil)
            delay(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode[skill], false, nil)
        end)
        delay(0.2)
    end
    
    -- التحقق من موت الهدف
    local targetHumanoid = target:FindFirstChildOfClass("Humanoid")
    if targetHumanoid and targetHumanoid.Health <= 0 then
        RedzCommands.Farming.KillCount = RedzCommands.Farming.KillCount + 1
        print("💀 قتل (" .. RedzCommands.Farming.KillCount .. "/" .. RedzCommands.Farming.RequiredKills .. ")")
        return true
    end
    
    return false
end

-- ==================== نظام الفارم الرئيسي ====================
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
    print("🌾 بدء الفارم الذكي...")
    RedzCommands.Notify("الفارم", "بدأ الفارم", 2)
    
    spawn(function()
        while RedzCommands.Farming.Enabled do
            -- البحث عن هدف
            local target = RedzCommands.FindTarget()
            
            if target then
                -- الهجوم على الهدف
                local killed = RedzCommands.AttackTarget(target)
                
                if killed then
                    -- تحقق إذا اكتملت المهمة
                    if RedzCommands.Farming.HasQuest and 
                       RedzCommands.Farming.KillCount >= RedzCommands.Farming.RequiredKills then
                        print("🎉 اكتملت المهمة!")
                        RedzCommands.Farming.QuestCompleted = true
                        RedzCommands.Notify("المهمة", "اكتملت!", 3)
                        
                        -- أخذ مهمة جديدة
                        delay(2)
                        RedzCommands.TakeQuest()
                    end
                    
                    delay(0.5)
                else
                    delay(0.3)
                end
            else
                -- البحث عن أهداف
                print("🔍 جاري البحث عن أهداف...")
                local character, _, root = RedzCommands.GetCharacter()
                if root then
                    local angle = math.random() * math.pi * 2
                    local radius = 20
                    local newX = root.Position.X + math.cos(angle) * radius
                    local newZ = root.Position.Z + math.sin(angle) * radius
                    root.CFrame = CFrame.new(newX, root.Position.Y, newZ)
                end
                delay(2)
            end
            
            delay(0.2)
        end
    end)
end

-- ==================== النظام المتكامل ====================
function RedzCommands.StartFullSystem()
    print("🚀 بدء النظام المتكامل...")
    
    -- 1. الحصول على المستوى
    local level = RedzCommands.GetPlayerLevel()
    print("📊 مستوى اللاعب: " .. level)
    
    -- 2. اختيار موقع مناسب
    local locationName = "بداية"
    if level >= 30 then locationName = "قراصنة"
    elseif level >= 50 then locationName = "محاربين"
    elseif level >= 75 then locationName = "بحارة" end
    
    print("📍 الموقع المختار: " .. locationName)
    
    -- 3. التلفيل للموقع
    RedzCommands.Notify("النظام", "جاري التلفيل...", 2)
    RedzCommands.TeleportToLocation(locationName)
    
    -- 4. أخذ المهمة
    delay(3)
    RedzCommands.Notify("النظام", "جاري أخذ المهمة...", 2)
    RedzCommands.TakeQuest()
    
    -- 5. بدء الفارم
    delay(2)
    RedzCommands.Notify("النظام", "بدء الفارم...", 2)
    RedzCommands.StartSmartFarm()
    
    -- 6. إشعار نهائي
    delay(1)
    print("✅ بدأ النظام المتكامل بنجاح!")
    RedzCommands.Notify("النظام", "يعمل تلقائياً الآن!", 4)
    
    return true
end

-- ==================== أوامر التحكم ====================
function RedzCommands.CheckStatus()
    local level = RedzCommands.GetPlayerLevel()
    
    print("📊 حالة النظام:")
    print("├── المستوى: " .. level)
    print("├── الفارم: " .. (RedzCommands.Farming.Enabled and "✅ نشط" or "❌ متوقف"))
    print("├── المهمة: " .. (RedzCommands.Farming.HasQuest and "✅ نشطة" or "❌ لا"))
    print("├── القتلى: " .. RedzCommands.Farming.KillCount .. "/" .. RedzCommands.Farming.RequiredKills)
    print("└── اكتمال: " .. (RedzCommands.Farming.QuestCompleted and "✅" or "❌"))
    
    RedzCommands.Notify("الحالة", "المستوى: " .. level .. " | الفارم: " .. 
        (RedzCommands.Farming.Enabled and "نشط" or "متوقف"), 3)
end

function RedzCommands.StopAll()
    RedzCommands.Farming.Enabled = false
    RedzCommands.Farming.HasQuest = false
    RedzCommands.Farming.QuestCompleted = false
    RedzCommands.Farming.KillCount = 0
    
    print("🛑 توقف جميع الأنظمة")
    RedzCommands.Notify("التوقف", "تم إيقاف كل شيء", 2)
end

function RedzCommands.ResetSystem()
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
        RequiredKills = 10
    }
    
    print("🔄 إعادة تعيين النظام")
    RedzCommands.Notify("النظام", "تم إعادة التعيين", 2)
end

-- ==================== التفعيل ====================
function RedzCommands.Init()
    print("🎮 النظام الكامل جاهز!")
    print("📚 الإصدار: " .. RedzCommands.Version)
    print("👤 المطور: " .. RedzCommands.Author)
    print("✨ المميزات:")
    print("├── 🚀 تلفيل ذكي")
    print("├── 📝 أخذ مهمة تلقائي")
    print("├── ⚔️ فارم أهداف")
    print("├── 🔄 متابعة تلقائية")
    print("└── 🤖 نظام متكامل")
    
    return RedzCommands
end

RedzCommands.Init()
return RedzCommands
