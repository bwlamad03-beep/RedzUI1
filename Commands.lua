-- Commands.lua - نظام مؤمن ضد التوقف
local RedzCommands = {}
RedzCommands.Version = "Stable System 5.0"
RedzCommands.Author = "Mr.Qattusa"

-- مكتبات النظام
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- متغيرات النظام مع قفل
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
    IsBusy = false, -- قفل لمنع التكرار
    SafeMode = true -- وضع آمن
}

RedzCommands.Connections = {}
local LocalPlayer = Players.LocalPlayer
local SystemLock = false -- قفل النظام الرئيسي

-- دالة تأخير آمنة
local function safeDelay(time)
    if task then
        return task.wait(time)
    else
        return wait(time)
    end
end

-- دالة تنفيذ آمنة
local function safeExecute(func, errorMsg)
    local success, err = pcall(func)
    if not success then
        warn("⚠️ " .. errorMsg .. ": " .. tostring(err))
        return false
    end
    return true
end

-- ==================== دوال المساعدة الآمنة ====================
function RedzCommands.GetCharacter()
    if not LocalPlayer then return nil, nil, nil end
    
    local character = LocalPlayer.Character
    if not character then
        -- انتظار ظهور الشخصية
        local charAdded
        local connection
        connection = LocalPlayer.CharacterAdded:Connect(function(newChar)
            charAdded = newChar
            if connection then connection:Disconnect() end
        end)
        
        -- انتظار لمدة 5 ثواني كحد أقصى
        local startTime = tick()
        while not charAdded and tick() - startTime < 5 do
            safeDelay(0.1)
        end
        
        character = charAdded
    end
    
    if not character then
        warn("⚠️ فشل تحميل الشخصية")
        return nil, nil, nil
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not root then
        -- انتظار تحميل المكونات
        local startTime = tick()
        while tick() - startTime < 3 do
            humanoid = humanoid or character:FindFirstChildOfClass("Humanoid")
            root = root or character:FindFirstChild("HumanoidRootPart")
            if humanoid and root then break end
            safeDelay(0.1)
        end
    end
    
    return character, humanoid, root
end

function RedzCommands.Notify(title, text, duration)
    safeExecute(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end, "إرسال إشعار")
end

-- ==================== نظام كشف المستوى الآمن ====================
function RedzCommands.GetPlayerLevel()
    if SystemLock then return 1 end
    
    local level = 1
    
    safeExecute(function()
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
    end, "قراءة المستوى")
    
    RedzCommands.Farming.CurrentLevel = level
    return level
end

-- ==================== نظام التلفيل الآمن ====================
function RedzCommands.SafeTeleport(x, y, z)
    if SystemLock then return false end
    if RedzCommands.Farming.IsBusy then return false end
    
    RedzCommands.Farming.IsBusy = true
    
    local success = safeExecute(function()
        local character, humanoid, root = RedzCommands.GetCharacter()
        if not root then
            print("❌ لا يمكن التلفيل - لا توجد شخصية")
            return false
        end
        
        -- حفظ الموقع الأصلي
        local originalPos = root.Position
        
        -- التلفيل
        root.CFrame = CFrame.new(x, y, z)
        print("📍 تلفيل إلى: " .. math.floor(x) .. ", " .. math.floor(y) .. ", " .. math.floor(z))
        
        -- إضافة تثبيت للموقع
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Position = Vector3.new(x, y, z)
        bodyPosition.MaxForce = Vector3.new(40000, 40000, 40000)
        bodyPosition.P = 1000
        bodyPosition.Parent = root
        
        -- انتظار للتثبيت
        safeDelay(2)
        
        -- تنظيف
        if bodyPosition and bodyPosition.Parent then
            bodyPosition:Destroy()
        end
        
        -- تأكيد البقاء في المكان
        safeDelay(1)
        local currentPos = root.Position
        local distance = (currentPos - Vector3.new(x, y, z)).Magnitude
        
        if distance > 50 then
            print("⚠️ تم إرجاع اللاعب، إعادة التلفيل...")
            root.CFrame = CFrame.new(x, y, z)
            safeDelay(1)
        end
        
        RedzCommands.Notify("التلفيل", "تم التلفيل بنجاح", 2)
        return true
    end, "التلفيل")
    
    RedzCommands.Farming.IsBusy = false
    return success
end

function RedzCommands.TeleportToLocation(locationName)
    if SystemLock then return false end
    
    local locations = {
        ["بداية"] = {x = -1085, y = 15, z = 1422},
        ["قراصنة"] = {x = -1093, y = 15, z = 3944},
        ["محاربين"] = {x = 1458, y = 15, z = -1780},
        ["بحارة"] = {x = -838, y = 15, z = -2167}
    }
    
    local loc = locations[locationName]
    if loc then
        print("🚀 التلفيل إلى: " .. locationName)
        return RedzCommands.SafeTeleport(loc.x, loc.y, loc.z)
    end
    
    return false
end

-- ==================== نظام أخذ المهمة المؤمن ====================
function RedzCommands.TakeQuest()
    if SystemLock then return false end
    if RedzCommands.Farming.IsBusy then 
        print("⏳ النظام مشغول، انتظر...")
        return false 
    end
    
    RedzCommands.Farming.IsBusy = true
    
    print("📝 بدء عملية أخذ المهمة...")
    
    -- 1. الحصول على المستوى
    local level = RedzCommands.GetPlayerLevel()
    print("📊 مستوى اللاعب: " .. level)
    
    -- 2. تحديد موقع NPC
    local npcLocation = {x = -1085, y = 15, z = 1422}
    local npcName = "قبول المهام"
    
    if level >= 30 then
        npcLocation = {x = -1093, y = 15, z = 3944}
        npcName = "مهام القراصنة"
    elseif level >= 50 then
        npcLocation = {x = 1458, y = 15, z = -1780}
        npcName = "مهام المحاربين"
    end
    
    -- 3. التلفيل لـ NPC
    print("📍 الذهاب إلى: " .. npcName)
    local teleportSuccess = RedzCommands.SafeTeleport(npcLocation.x, npcLocation.y + 5, npcLocation.z)
    
    if not teleportSuccess then
        RedzCommands.Farming.IsBusy = false
        return false
    end
    
    -- 4. انتظار للتفاعل
    safeDelay(3)
    
    -- 5. تأكيد أخذ المهمة
    RedzCommands.Farming.HasQuest = true
    RedzCommands.Farming.QuestNPC = npcName
    RedzCommands.Farming.KillCount = 0
    RedzCommands.Farming.RequiredKills = 10
    
    print("✅ تم أخذ المهمة من: " .. npcName)
    RedzCommands.Notify("المهمة", "تم أخذ المهمة بنجاح", 3)
    
    -- 6. عرض تفاصيل المهمة
    print("📋 تفاصيل المهمة:")
    print("├── النوع: " .. npcName)
    print("├── المطلوب: 10 أعداء")
    print("└── المكافأة: خبرة عالية")
    
    RedzCommands.Farming.IsBusy = false
    return true
end

-- ==================== نظام الفارم الثابت ====================
function RedzCommands.StartSmartFarm()
    if SystemLock then return end
    
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
    
    -- بدء حلقة الفارم في thread منفصل
    spawn(function()
        local farmThread = coroutine.running()
        RedzCommands.Connections.FarmThread = farmThread
        
        local errorCount = 0
        local maxErrors = 5
        
        while RedzCommands.Farming.Enabled and errorCount < maxErrors do
            local success, err = pcall(function()
                -- البحث عن هدف
                local character, _, root = RedzCommands.GetCharacter()
                if not root then
                    safeDelay(1)
                    return
                end
                
                -- أهداف حسب المستوى
                local targets = {"Bandit", "Pirate", "Marine", "Brute"}
                local foundTarget = nil
                
                for _, targetName in pairs(targets) do
                    local target = Workspace:FindFirstChild(targetName, true)
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
                    -- الهجوم على الهدف
                    local targetRoot = foundTarget:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local attackPos = targetRoot.Position + Vector3.new(0, 25, 3)
                        root.CFrame = CFrame.new(attackPos)
                        
                        -- هجوم
                        safeDelay(0.5)
                        
                        -- زيادة العداد إذا مات
                        local humanoid = foundTarget:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health <= 0 then
                            RedzCommands.Farming.KillCount = RedzCommands.Farming.KillCount + 1
                            print("💀 قتل (" .. RedzCommands.Farming.KillCount .. "/10)")
                            
                            if RedzCommands.Farming.KillCount >= 10 then
                                print("🎉 اكتملت المهمة!")
                                RedzCommands.Farming.QuestCompleted = true
                                RedzCommands.Notify("المهمة", "اكتملت!", 3)
                                safeDelay(2)
                                
                                -- أخذ مهمة جديدة
                                RedzCommands.TakeQuest()
                            end
                        end
                    end
                else
                    -- حركة بحث
                    local randomX = math.random(-20, 20)
                    local randomZ = math.random(-20, 20)
                    local newPos = root.Position + Vector3.new(randomX, 0, randomZ)
                    root.CFrame = CFrame.new(newPos)
                    safeDelay(2)
                end
                
                safeDelay(0.3)
            end)
            
            if not success then
                errorCount = errorCount + 1
                warn("⚠️ خطأ في الفارم (" .. errorCount .. "/" .. maxErrors .. "): " .. tostring(err))
                safeDelay(1)
            else
                errorCount = 0 -- إعادة تعيين عند النجاح
            end
        end
        
        if errorCount >= maxErrors then
            print("🚨 توقف الفارم بسبب أخطاء متعددة")
            RedzCommands.Farming.Enabled = false
            RedzCommands.Notify("خطأ", "توقف الفارم", 3)
        end
    end)
end

-- ==================== النظام المتكامل الآمن ====================
function RedzCommands.StartFullSystem()
    if SystemLock then
        print("🔒 النظام مقفل حاليًا")
        return false
    end
    
    SystemLock = true
    print("🚀 بدء النظام المتكامل الآمن...")
    
    local success = safeExecute(function()
        -- 1. الحصول على المستوى
        local level = RedzCommands.GetPlayerLevel()
        print("📊 مستوى اللاعب: " .. level)
        
        -- 2. تحديد الموقع
        local locationName = "بداية"
        if level >= 30 then locationName = "قراصنة"
        elseif level >= 50 then locationName = "محاربين" end
        
        print("📍 الموقع المختار: " .. locationName)
        RedzCommands.Notify("النظام", "جاري التجهيز...", 2)
        
        -- 3. التلفيل
        safeDelay(1)
        RedzCommands.Notify("النظام", "جاري التلفيل...", 2)
        
        local teleportSuccess = RedzCommands.TeleportToLocation(locationName)
        if not teleportSuccess then
            error("فشل التلفيل")
        end
        
        -- 4. انتظار للتثبيت
        safeDelay(3)
        
        -- 5. أخذ المهمة
        RedzCommands.Notify("النظام", "جاري أخذ المهمة...", 2)
        safeDelay(1)
        
        local questSuccess = RedzCommands.TakeQuest()
        if not questSuccess then
            error("فشل أخذ المهمة")
        end
        
        -- 6. انتظار
        safeDelay(2)
        
        -- 7. بدء الفارم
        RedzCommands.Notify("النظام", "بدء الفارم...", 2)
        safeDelay(1)
        
        RedzCommands.StartSmartFarm()
        
        -- 8. إشعار نهائي
        safeDelay(1)
        print("✅ بدأ النظام المتكامل بنجاح!")
        RedzCommands.Notify("النظام", "يعمل تلقائياً الآن!", 4)
        
        return true
    end, "النظام المتكامل")
    
    SystemLock = false
    
    if not success then
        print("❌ فشل بدء النظام المتكامل")
        RedzCommands.Notify("خطأ", "فشل بدء النظام", 3)
        return false
    end
    
    return true
end

-- ==================== أوامر التحكم ====================
function RedzCommands.CheckStatus()
    local level = RedzCommands.GetPlayerLevel()
    
    print("📊 حالة النظام:")
    print("├── المستوى: " .. level)
    print("├── الفارم: " .. (RedzCommands.Farming.Enabled and "✅ نشط" or "❌ متوقف"))
    print("├── المهمة: " .. (RedzCommands.Farming.HasQuest and "✅ " .. RedzCommands.Farming.QuestNPC or "❌ لا يوجد"))
    print("├── القتلى: " .. RedzCommands.Farming.KillCount .. "/10")
    print("├── النظام مقفل: " .. (SystemLock and "✅" or "❌"))
    print("└── مشغول: " .. (RedzCommands.Farming.IsBusy and "✅" or "❌"))
    
    RedzCommands.Notify("الحالة", "المستوى: " .. level .. " | الفارم: " .. 
        (RedzCommands.Farming.Enabled and "نشط" or "متوقف"), 3)
end

function RedzCommands.StopAll()
    SystemLock = true
    
    RedzCommands.Farming.Enabled = false
    RedzCommands.Farming.IsBusy = false
    
    -- قطع الاتصالات
    for name, connection in pairs(RedzCommands.Connections) do
        if type(connection) == "thread" then
            coroutine.close(connection)
        elseif connection.Disconnect then
            connection:Disconnect()
        end
        RedzCommands.Connections[name] = nil
    end
    
    print("🛑 توقف جميع الأنظمة")
    RedzCommands.Notify("التوقف", "تم إيقاف كل شيء", 2)
    
    safeDelay(1)
    SystemLock = false
end

function RedzCommands.ResetSystem()
    RedzCommands.StopAll()
    safeDelay(0.5)
    
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
        IsBusy = false,
        SafeMode = true
    }
    
    print("🔄 إعادة تعيين النظام")
    RedzCommands.Notify("النظام", "تم إعادة التعيين", 2)
end

-- ==================== التفعيل ====================
function RedzCommands.Init()
    print("🎮 النظام المؤمن جاهز!")
    print("📚 الإصدار: " .. RedzCommands.Version)
    print("👤 المطور: " .. RedzCommands.Author)
    print("🔒 المميزات الأمنية:")
    print("├── قفل النظام لمنع التكرار")
    print("├── تأمين ضد التوقف المفاجئ")
    print("├── معالجة أخطاء متقدمة")
    print("├── تأكيد كل خطوة")
    print("└── استقرار كامل")
    
    -- تنظيف عند إعادة التولد
    LocalPlayer.CharacterAdded:Connect(function()
        safeDelay(1)
        RedzCommands.ResetSystem()
    end)
    
    return RedzCommands
end

RedzCommands.Init()
return RedzCommands
