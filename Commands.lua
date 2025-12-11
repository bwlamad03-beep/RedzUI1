-- Commands.lua - نظام فارم بلوكس فروت الأوتوماتيكي
local RedzCommands = {}
RedzCommands.Version = "Blox Fruits Farmer 4.0"
RedzCommands.Author = "Mr.Qattusa"

-- مكتبات النظام
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- متغيرات نظام الفارم
RedzCommands.Farming = {
    Enabled = false,
    CurrentTarget = nil,
    IsFlying = false,
    FlyingHeight = 30,
    SearchRadius = 150,
    AutoClick = false,
    ClickDelay = 0.5,
    FarmMode = "NPCs" -- NPCs, Bosses, Players
}

RedzCommands.Connections = {}
RedzCommands.BodyVelocity = nil
RedzCommands.BodyGyro = nil

-- دالة تأخير متوافقة
local function delay(time)
    if task then
        return task.wait(time)
    else
        return wait(time)
    end
end

-- ==================== نظام الطيران المتقدم ====================
function RedzCommands.ToggleFlight(enable)
    local character = Players.LocalPlayer.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid then return end
    
    if enable and not RedzCommands.IsFlying then
        -- تفعيل الطيران
        RedzCommands.IsFlying = true
        
        -- BodyVelocity للرفع
        RedzCommands.BodyVelocity = Instance.new("BodyVelocity")
        RedzCommands.BodyVelocity.Name = "FarmFlightVelocity"
        RedzCommands.BodyVelocity.Velocity = Vector3.new(0, 0.5, 0)
        RedzCommands.BodyVelocity.MaxForce = Vector3.new(0, 10000, 0)
        RedzCommands.BodyVelocity.Parent = root
        
        -- BodyGyro للتوازن
        RedzCommands.BodyGyro = Instance.new("BodyGyro")
        RedzCommands.BodyGyro.Name = "FarmFlightGyro"
        RedzCommands.BodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
        RedzCommands.BodyGyro.P = 1000
        RedzCommands.BodyGyro.CFrame = root.CFrame
        RedzCommands.BodyGyro.Parent = root
        
        humanoid.PlatformStand = true
        
        print("🦅 وضع الطيران مفعل للفارم!")
        return true
    elseif not enable and RedzCommands.IsFlying then
        -- إيقاف الطيران
        RedzCommands.IsFlying = false
        
        if RedzCommands.BodyVelocity then
            RedzCommands.BodyVelocity:Destroy()
            RedzCommands.BodyVelocity = nil
        end
        
        if RedzCommands.BodyGyro then
            RedzCommands.BodyGyro:Destroy()
            RedzCommands.BodyGyro = nil
        end
        
        humanoid.PlatformStand = false
        
        print("🛑 وضع الطيران معطل!")
        return true
    end
end

-- ==================== البحث عن NPCs في بلوكس فروت ====================
function RedzCommands.FindBloxFruitsNPC()
    local character = Players.LocalPlayer.Character
    if not character then return nil end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local nearestNPC = nil
    local nearestDistance = RedzCommands.Farming.SearchRadius
    
    -- NPCs المحددة في بلوكس فروت
    local targetNPCs = {
        "Bandit", "Monkey", "Pirate", "Brute", "Snow Bandit",
        "Desert Bandit", "Marine", "Chief Petty Officer", "Shark",
        "Pirate Captain", "Sky Bandit", "Dark Master", "Galley Captain"
    }
    
    for _, npcName in pairs(targetNPCs) do
        local npc = Workspace:FindFirstChild(npcName, true)
        if npc and npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            local npcRoot = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso")
            
            if humanoid and humanoid.Health > 0 and npcRoot then
                local distance = (root.Position - npcRoot.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestNPC = npc
                end
            end
        end
    end
    
    -- بحث عام في Workspace
    if not nearestNPC then
        for _, model in pairs(Workspace:GetChildren()) do
            if model:IsA("Model") then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    -- استبعاد اللاعبين
                    if not Players:GetPlayerFromCharacter(model) then
                        local npcRoot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                        if npcRoot then
                            local distance = (root.Position - npcRoot.Position).Magnitude
                            if distance < nearestDistance then
                                nearestDistance = distance
                                nearestNPC = model
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nearestNPC
end

-- ==================== البحث عن Bosses ====================
function RedzCommands.FindBoss()
    local character = Players.LocalPlayer.Character
    if not character then return nil end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local bosses = {
        "The Gorilla King", "Bobby", "Mob Leader", "Vice Admiral",
        "Warden", "Chief Warden", "Swan", "Saber Expert",
        "Mad Scientist", "Diamond", "Jeremy", "Fajita"
    }
    
    for _, bossName in pairs(bosses) do
        local boss = Workspace:FindFirstChild(bossName, true)
        if boss and boss:IsA("Model") then
            local humanoid = boss:FindFirstChildOfClass("Humanoid")
            local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
            
            if humanoid and humanoid.Health > 0 and bossRoot then
                local distance = (root.Position - bossRoot.Position).Magnitude
                if distance < 500 then -- نطاق أوسع للبوس
                    return boss
                end
            end
        end
    end
    
    return nil
end

-- ==================== نظام الهجوم المتقدم ====================
function RedzCommands.AttackBloxFruitsTarget(target)
    if not target then return false end
    
    local character = Players.LocalPlayer.Character
    if not character then return false end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid then return false end
    
    local targetRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso")
    if not targetRoot then return false end
    
    -- الحفاظ على مسافة آمنة فوق الهدف
    local targetPosition = targetRoot.Position + Vector3.new(0, RedzCommands.Farming.FlyingHeight, 0)
    
    -- التحرك إلى فوق الهدف
    root.CFrame = CFrame.new(targetPosition, targetRoot.Position)
    
    -- محاكاة الضرب (سيتم استبدالها بأدوات اللعبة)
    if RedzCommands.Farming.AutoClick then
        -- إرسال نقرات افتراضية
        mouse1click()
        delay(RedzCommands.Farming.ClickDelay)
    end
    
    -- استخدام المهارات (يمكن إضافتها)
    RedzCommands.UseCombatSkills(target)
    
    -- تحقق إذا مات الهدف
    local targetHumanoid = target:FindFirstChildOfClass("Humanoid")
    if targetHumanoid and targetHumanoid.Health <= 0 then
        print("💀 تم قتل " .. target.Name .. "!")
        delay(1) -- انتظار لحظة قبل الهدف التالي
        return true
    end
    
    return false
end

-- ==================== استخدام مهارات القتال ====================
function RedzCommands.UseCombatSkills(target)
    local character = Players.LocalPlayer.Character
    if not character then return end
    
    -- البحث عن أدوات (تولز) للهجوم
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            -- تفعيل الهجوم من الأدوات
            local remote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
            if remote then
                pcall(function()
                    remote:FireServer("Attack", target)
                end)
            end
        end
    end
    
    -- استخدام مفاتيح المهارات (Z, X, C, V)
    local skillKeys = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}
    for _, key in pairs(skillKeys) do
        pcall(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, nil)
            delay(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, nil)
        end)
        delay(0.2)
    end
end

-- ==================== نظام النقر التلقائي ====================
function RedzCommands.ToggleAutoClick()
    RedzCommands.Farming.AutoClick = not RedzCommands.Farming.AutoClick
    
    if RedzCommands.Farming.AutoClick then
        print("🖱️ النقر التلقائي مفعل!")
        
        -- بدء النقر التلقائي
        spawn(function()
            while RedzCommands.Farming.AutoClick do
                pcall(function()
                    mouse1click()
                end)
                delay(RedzCommands.Farming.ClickDelay)
            end
        end)
    else
        print("🛑 النقر التلقائي معطل!")
    end
end

-- ==================== نظام الفارم الرئيسي ====================
function RedzCommands.StartBloxFruitsFarm()
    if RedzCommands.Farming.Enabled then
        -- إيقاف الفارم
        RedzCommands.Farming.Enabled = false
        RedzCommands.ToggleFlight(false)
        RedzCommands.Farming.AutoClick = false
        RedzCommands.Farming.CurrentTarget = nil
        
        print("🛑 إيقاف فارم بلوكس فروت")
        RedzCommands.Notify("الفارم", "تم إيقاف الفارم", 2)
        return
    end
    
    -- بدء الفارم
    RedzCommands.Farming.Enabled = true
    print("🏝️ بدء فارم بلوكس فروت...")
    RedzCommands.Notify("الفارم", "جاري البحث عن أهداف...", 2)
    
    -- تفعيل الطيران
    RedzCommands.ToggleFlight(true)
    
    -- تفعيل النقر التلقائي
    RedzCommands.ToggleAutoClick()
    
    -- حلقة الفارم الرئيسية
    spawn(function()
        while RedzCommands.Farming.Enabled do
            -- البحث عن هدف حسب الوضع
            local target = nil
            
            if RedzCommands.Farming.FarmMode == "Bosses" then
                target = RedzCommands.FindBoss()
                if not target then
                    target = RedzCommands.FindBloxFruitsNPC()
                end
            else
                target = RedzCommands.FindBloxFruitsNPC()
            end
            
            if target then
                print("🎯 عثرت على هدف: " .. target.Name)
                RedzCommands.Farming.CurrentTarget = target
                
                -- الهجوم على الهدف
                local killed = RedzCommands.AttackBloxFruitsTarget(target)
                
                if killed then
                    print("💰 تم الحصول على خبرة!")
                    RedzCommands.Farming.CurrentTarget = nil
                    
                    -- البحث عن هدف جديد بسرعة
                    delay(0.5)
                else
                    -- الاستمرار في الهجوم
                    delay(0.3)
                end
            else
                print("🔍 جاري البحث عن أهداف...")
                
                -- التحرك بشكل عشوائي للبحث
                local character = Players.LocalPlayer.Character
                if character then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local randomX = math.random(-RedzCommands.Farming.SearchRadius/2, RedzCommands.Farming.SearchRadius/2)
                        local randomZ = math.random(-RedzCommands.Farming.SearchRadius/2, RedzCommands.Farming.SearchRadius/2)
                        local newPos = root.Position + Vector3.new(randomX, RedzCommands.Farming.FlyingHeight, randomZ)
                        root.CFrame = CFrame.new(newPos)
                    end
                end
                delay(2)
            end
            
            delay(0.1) -- لمنع التحميل الزائد
        end
        
        -- تنظيف عند التوقف
        RedzCommands.ToggleFlight(false)
        RedzCommands.Farming.AutoClick = false
        RedzCommands.Farming.CurrentTarget = nil
    end)
end

-- ==================== أوامر إضافية ====================
function RedzCommands.ToggleFarmMode()
    if RedzCommands.Farming.FarmMode == "NPCs" then
        RedzCommands.Farming.FarmMode = "Bosses"
        print("👑 وضع فارم البوسات مفعل!")
        RedzCommands.Notify("الوضع", "وضع البوسات", 2)
    else
        RedzCommands.Farming.FarmMode = "NPCs"
        print("👤 وضع فارم NPCs مفعل!")
        RedzCommands.Notify("الوضع", "وضع NPCs", 2)
    end
end

function RedzCommands.SetFlyingHeight(value)
    local height = tonumber(value)
    if height and height > 0 then
        RedzCommands.Farming.FlyingHeight = height
        print("📏 ارتفاع الطيران: " .. height)
        RedzCommands.Notify("الارتفاع", "ضبط على: " .. height, 2)
    end
end

function RedzCommands.SetSearchRadius(value)
    local radius = tonumber(value)
    if radius and radius > 0 then
        RedzCommands.Farming.SearchRadius = radius
        print("🔍 نطاق البحث: " .. radius)
        RedzCommands.Notify("النطاق", "ضبط على: " .. radius, 2)
    end
end

function RedzCommands.TeleportToSpawn()
    local spawns = Workspace:FindFirstChild("SpawnLocation") 
                 or Workspace:FindFirstChild("Spawn")
                 or Workspace:FindFirstChild("Start")
    
    local character = Players.LocalPlayer.Character
    if character and spawns then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = spawns.CFrame + Vector3.new(0, 10, 0)
            print("📍 تلفيل إلى نقطة البداية")
            RedzCommands.Notify("التلفيل", "ذهبت إلى البداية", 2)
        end
    end
end

function RedzCommands.GetFarmingStatus()
    print("📊 حالة نظام فارم بلوكس فروت:")
    print("├── الفارم: " .. (RedzCommands.Farming.Enabled and "✅ نشط" or "❌ متوقف"))
    print("├── الوضع: " .. RedzCommands.Farming.FarmMode)
    print("├── الطيران: " .. (RedzCommands.IsFlying and "✅" or "❌"))
    print("├── النقر التلقائي: " .. (RedzCommands.Farming.AutoClick and "✅" or "❌"))
    print("├── الارتفاع: " .. RedzCommands.Farming.FlyingHeight)
    print("├── نطاق البحث: " .. RedzCommands.Farming.SearchRadius)
    print("├── الهدف الحالي: " .. (RedzCommands.Farming.CurrentTarget and RedzCommands.Farming.CurrentTarget.Name or "لا يوجد"))
    print("└── تأخير النقر: " .. RedzCommands.Farming.ClickDelay .. " ثانية")
end

-- ==================== دوال المساعدة ====================
function RedzCommands.GetCharacter()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character then
        warn("⚠️ لا توجد شخصية!")
        return nil, nil, nil
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not root then
        warn("⚠️ الشخصية غير مكتملة!")
        return nil, nil, nil
    end
    
    return character, humanoid, root
end

function RedzCommands.Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

function RedzCommands.Cleanup()
    print("🧹 تنظيف نظام بلوكس فروت...")
    
    RedzCommands.Farming.Enabled = false
    RedzCommands.ToggleFlight(false)
    RedzCommands.Farming.AutoClick = false
    
    for name, connection in pairs(RedzCommands.Connections) do
        if connection then
            connection:Disconnect()
            RedzCommands.Connections[name] = nil
        end
    end
    
    print("✅ تم تنظيف النظام")
    RedzCommands.Notify("التنظيف", "تم تنظيف النظام", 2)
end

-- ==================== التفعيل ====================
function RedzCommands.Init()
    print("🏝️ نظام فارم بلوكس فروت جاهز!")
    print("📚 الإصدار: " .. RedzCommands.Version)
    print("👤 المطور: " .. RedzCommands.Author)
    print("✨ المميزات:")
    print("├── 🎯 بحث ذكي عن NPCs")
    print("├── 👑 وضع صيد البوسات")
    print("├── 🦅 طيران متقدم للفارم")
    print("├── ⚔️ هجوم تلقائي بالمهارات")
    print("├── 🖱️ نقر تلقائي مستمر")
    print("└── 🔧 إعدادات قابلة للتخصيص")
    
    Players.LocalPlayer.CharacterAdded:Connect(function()
        RedzCommands.Cleanup()
    end)
    
    return RedzCommands
end

RedzCommands.Init()
return RedzCommands
