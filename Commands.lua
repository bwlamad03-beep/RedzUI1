-- Commands.lua - نظام التلفيل لبلوكس فروت
local RedzCommands = {}
RedzCommands.Version = "Teleport System 1.0"
RedzCommands.Author = "Mr.Qattusa"

-- مكتبات النظام
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- دالة تأخير متوافقة
local function delay(time)
    if task then
        return task.wait(time)
    else
        return wait(time)
    end
end

-- ==================== دوال المساعدة ====================
function RedzCommands.GetCharacter()
    local player = Players.LocalPlayer
    local character = player.Character
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

-- ==================== نظام التلفيل الأساسي ====================
function RedzCommands.TeleportToPlayer(playerName)
    local _, _, root = RedzCommands.GetCharacter()
    if not root then
        RedzCommands.Notify("خطأ", "لا توجد شخصية", 2)
        return
    end
    
    -- البحث عن اللاعب
    local targetPlayer = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if string.find(string.lower(player.Name), string.lower(playerName)) then
                targetPlayer = player
                break
            end
        end
    end
    
    if targetPlayer and targetPlayer.Character then
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            root.CFrame = targetRoot.CFrame
            print("✅ تلفيل إلى: " .. targetPlayer.Name)
            RedzCommands.Notify("التلفيل", "ذهبت إلى " .. targetPlayer.Name, 3)
            return true
        end
    end
    
    print("❌ لاعب غير موجود!")
    RedzCommands.Notify("خطأ", "اللاعب غير موجود", 2)
    return false
end

function RedzCommands.TeleportToPosition(x, y, z)
    local _, _, root = RedzCommands.GetCharacter()
    if not root then return end
    
    local posX = tonumber(x) or 0
    local posY = tonumber(y) or 0
    local posZ = tonumber(z) or 0
    
    root.CFrame = CFrame.new(posX, posY, posZ)
    print("📍 تلفيل إلى الموقع: " .. posX .. ", " .. posY .. ", " .. posZ)
    RedzCommands.Notify("التلفيل", "تم التلفيل للموقع", 2)
end

function RedzCommands.CopyPosition()
    local _, _, root = RedzCommands.GetCharacter()
    if not root then return end
    
    local position = tostring(root.Position)
    
    if setclipboard then
        setclipboard(position)
        print("📋 تم نسخ الموقع: " .. position)
        RedzCommands.Notify("نسخ", "تم نسخ الموقع", 2)
    else
        print("📋 الموقع: " .. position)
    end
end

-- ==================== تلفيل للجزر والمناطق ====================
function RedzCommands.TeleportToIsland(islandName)
    local _, _, root = RedzCommands.GetCharacter()
    if not root then return end
    
    local islands = {
        ["بداية"] = {x = -1085, y = 15, z = 1422},
        ["مدينة القراصنة"] = {x = -1093, y = 15, z = 3944},
        ["الجبل"] = {x = 1122, y = 15, z = 3939},
        ["قرية المحاربين"] = {x = 1458, y = 15, z = -1780},
        ["صحراء"] = {x = 1275, y = 15, z = -2144},
        ["مدينة البحارة"] = {x = -838, y = 15, z = -2167},
        ["سجن"] = {x = 4864, y = 15, z = 100},
        ["جزيرة البحر"] = {x = 2091, y = 15, z = 924},
        ["المستعمرة"] = {x = -1224, y = 15, z = -175},
        ["برج الساعة"] = {x = 1304, y = 15, z = 717}
    }
    
    local target = islands[islandName]
    if target then
        root.CFrame = CFrame.new(target.x, target.y, target.z)
        print("🏝️ تلفيل إلى: " .. islandName)
        RedzCommands.Notify("التلفيل", "ذهبت إلى " .. islandName, 3)
        return true
    else
        print("❌ الجزيرة غير معروفة!")
        RedzCommands.Notify("خطأ", "الجزيرة غير موجودة", 2)
        return false
    end
end

-- ==================== تلفيل للبوسات ====================
function RedzCommands.TeleportToBoss(bossName)
    local _, _, root = RedzCommands.GetCharacter()
    if not root then return end
    
    local bosses = {
        ["الملك غوريلا"] = {x = -1224, y = 15, z = -175},
        ["بوبي"] = {x = -1093, y = 15, z = 3944},
        ["قائد القراصنة"] = {x = 1122, y = 15, z = 3939},
        ["القرش"] = {x = 1458, y = 15, z = -1780},
        ["الضابط البحري"] = {x = 1275, y = 15, z = -2144}
    }
    
    local target = bosses[bossName]
    if target then
        root.CFrame = CFrame.new(target.x + 10, target.y + 5, target.z + 10)
        print("👑 تلفيل إلى بوس: " .. bossName)
        RedzCommands.Notify("البوس", "ذهبت إلى " .. bossName, 3)
        return true
    else
        print("❌ البوس غير معروف!")
        RedzCommands.Notify("خطأ", "البوس غير موجود", 2)
        return false
    end
end

-- ==================== تلفيل للـ NPCs المهمة ====================
function RedzCommands.TeleportToQuestNPC()
    local _, _, root = RedzCommands.GetCharacter()
    if not root then return end
    
    local npcs = {
        {name = "قبول المهام", x = -1085, y = 15, z = 1422},
        {name = "بائع الفواكه", x = -1093, y = 15, z = 3944},
        {name = "تدريب المهارات", x = 1122, y = 15, z = 3939},
        {name = "تحديث الهوكي", x = 1458, y = 15, z = -1780}
    }
    
    -- اختر أقرب NPC (هنا نختار أول واحد)
    local target = npcs[1]
    root.CFrame = CFrame.new(target.x, target.y + 5, target.z)
    print("🎯 تلفيل إلى: " .. target.name)
    RedzCommands.Notify("المهمة", "ذهبت إلى " .. target.name, 3)
end

-- ==================== أوامر مفيدة ====================
function RedzCommands.GoToSafeZone()
    local _, _, root = RedzCommands.GetCharacter()
    if not root then return end
    
    root.CFrame = CFrame.new(-1085, 15, 1422)
    print("🛡️ ذهبت إلى المنطقة الآمنة")
    RedzCommands.Notify("المنطقة الآمنة", "أنت الآن في مكان آمن", 3)
end

function RedzCommands.GoToSea()
    local _, _, root = RedzCommands.GetCharacter()
    if not root then return end
    
    root.CFrame = CFrame.new(-2000, 15, 2000)
    print("🌊 ذهبت إلى البحر")
    RedzCommands.Notify("البحر", "أنت الآن في البحر", 3)
end

function RedzCommands.ListLocations()
    print("📍 قائمة المواقع المتاحة:")
    print("├── 🏝️  الجزر:")
    print("│   ├── بداية")
    print("│   ├── مدينة القراصنة")
    print("│   ├── الجبل")
    print("│   ├── قرية المحاربين")
    print("│   ├── صحراء")
    print("│   ├── مدينة البحارة")
    print("│   ├── سجن")
    print("│   ├── جزيرة البحر")
    print("│   ├── المستعمرة")
    print("│   └── برج الساعة")
    print("├── 👑  البوسات:")
    print("│   ├── الملك غوريلا")
    print("│   ├── بوبي")
    print("│   ├── قائد القراصنة")
    print("│   ├── القرش")
    print("│   └── الضابط البحري")
    print("└── 🎯  خدمات:")
    print("    ├── قبول المهام")
    print("    ├── بائع الفواكه")
    print("    ├── تدريب المهارات")
    print("    └── تحديث الهوكي")
end

function RedzCommands.ShowCurrentPosition()
    local _, _, root = RedzCommands.GetCharacter()
    if not root then return end
    
    local pos = root.Position
    print("📍 موقعك الحالي:")
    print("├── X: " .. math.floor(pos.X))
    print("├── Y: " .. math.floor(pos.Y))
    print("└── Z: " .. math.floor(pos.Z))
    
    RedzCommands.Notify("الموقع", "X: " .. math.floor(pos.X) .. " Y: " .. math.floor(pos.Y) .. " Z: " .. math.floor(pos.Z), 4)
end

-- ==================== التفعيل ====================
function RedzCommands.Init()
    print("🎮 نظام التلفيل لبلوكس فروت جاهز!")
    print("📚 الإصدار: " .. RedzCommands.Version)
    print("👤 المطور: " .. RedzCommands.Author)
    
    return RedzCommands
end

RedzCommands.Init()
return RedzCommands
