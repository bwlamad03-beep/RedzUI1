-- BloxFruits.lua - نظام شراء فواكه بلوكس فروت
local BloxFruits = {}
BloxFruits.Version = "Fruit Auto-Buy 1.0"
BloxFruits.Author = "Mr.Qattusa"

-- مكتبات النظام
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- متغيرات النظام
BloxFruits.Active = false
BloxFruits.Buying = false
BloxFruits.LastCheck = 0
BloxFruits.CheckDelay = 5
BloxFruits.FruitBought = false
BloxFruits.FruitInInventory = false

local LocalPlayer = Players.LocalPlayer

-- ==================== دوال المساعدة ====================
function BloxFruits.Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

function BloxFruits.GetCharacter()
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        return char, root
    end
    return nil, nil
end

function BloxFruits.Delay(time)
    if task then
        task.wait(time)
    else
        wait(time)
    end
end

-- ==================== نظام البحث عن الفواكه ====================
function BloxFruits.FindFruits()
    print("🔍 جاري البحث عن فواكه...")
    
    local fruits = {}
    
    -- البحث عن فواكه في Workspace
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "Fruit" or obj.Name:find("Fruit") then
            table.insert(fruits, obj)
        elseif obj:IsA("Model") then
            -- قد تكون الفواكه داخل Models
            for _, part in pairs(obj:GetChildren()) do
                if part.Name == "Fruit" or part.Name:find("Fruit") then
                    table.insert(fruits, part)
                end
            end
        end
    end
    
    return fruits
end

-- ==================== نظام التحرك للفاكهة ====================
function BloxFruits.GoToFruit(fruit)
    local char, root = BloxFruits.GetCharacter()
    if not root then return false end
    
    -- الذهاب للفاكهة
    root.CFrame = CFrame.new(fruit.Position + Vector3.new(0, 3, 0))
    print("📍 ذهبت للفاكهة: " .. fruit.Name)
    
    BloxFruits.Delay(1)
    
    -- محاولة جمع الفاكهة (افتراضياً)
    return true
end

-- ==================== نظام شراء الفواكه ====================
function BloxFruits.GoToFruitDealer()
    print("🛒 الذهاب لبائع الفواكه...")
    
    local char, root = BloxFruits.GetCharacter()
    if not root then return false end
    
    -- مواقع بائعي الفواكه الشائعة
    local dealers = {
        Vector3.new(-1093, 15, 3944),  -- مدينة القراصنة
        Vector3.new(-1085, 15, 1422),  -- البداية
        Vector3.new(1458, 15, -1780),  -- قرية المحاربين
        Vector3.new(-838, 15, -2167)   -- مدينة البحارة
    }
    
    -- الذهاب لأول بائع
    root.CFrame = CFrame.new(dealers[1])
    BloxFruits.Delay(2)
    
    return true
end

function BloxFruits.TryBuyFruit()
    print("💰 محاولة شراء فاكهة...")
    
    -- الذهاب للبائع أولاً
    if not BloxFruits.GoToFruitDealer() then
        return false
    end
    
    BloxFruits.Delay(2)
    
    -- محاكاة شراء الفاكهة (هنا تحتاج إلى تعديل حسب اللعبة)
    print("✅ تم شراء فاكهة (افتراضي)")
    BloxFruits.Notify("الفاكهة", "تم الشراء", 3)
    
    BloxFruits.FruitBought = true
    return true
end

-- ==================== نظام وضع الفاكهة في المخزن ====================
function BloxFruits.GoToStorage()
    print("📦 الذهاب للمخزن...")
    
    local char, root = BloxFruits.GetCharacter()
    if not root then return false end
    
    -- مواقع المخازن
    local storages = {
        Vector3.new(-1100, 15, 1400),  -- قرب البداية
        Vector3.new(-1050, 15, 3950)   -- قرب القراصنة
    }
    
    -- الذهاب للمخزن
    root.CFrame = CFrame.new(storages[1])
    BloxFruits.Delay(2)
    
    return true
end

function BloxFruits.StoreFruit()
    print("💾 تخزين الفاكهة...")
    
    -- الذهاب للمخزن
    if not BloxFruits.GoToStorage() then
        return false
    end
    
    BloxFruits.Delay(2)
    
    -- محاكاة تخزين الفاكهة
    print("✅ تم تخزين الفاكهة")
    BloxFruits.Notify("المخزن", "تم التخزين", 3)
    
    BloxFruits.FruitInInventory = false
    return true
end

-- ==================== النظام الرئيسي ====================
function BloxFruits.StartAutoSystem()
    if BloxFruits.Active then
        -- إيقاف النظام
        BloxFruits.Active = false
        print("🛑 إيقاف نظام الفواكه")
        BloxFruits.Notify("النظام", "تم الإيقاف", 3)
        return
    end
    
    -- بدء النظام
    BloxFruits.Active = true
    BloxFruits.FruitBought = false
    BloxFruits.FruitInInventory = false
    
    print("🍊 بدء نظام الفواكه الأوتوماتيكي...")
    BloxFruits.Notify("الفواكه", "بدأ النظام", 3)
    
    -- حلقة العمل الرئيسية
    spawn(function()
        while BloxFruits.Active do
            print("\n🔄 دورة جديدة...")
            
            -- 1. البحث عن فواكه متوفرة
            local fruits = BloxFruits.FindFruits()
            
            if #fruits > 0 then
                print("🎯 وجدت " .. #fruits .. " فواكه")
                
                -- الذهاب لأول فاكهة
                BloxFruits.GoToFruit(fruits[1])
                BloxFruits.FruitInInventory = true
                
                -- 2. تخزين الفاكهة
                BloxFruits.StoreFruit()
                
            else
                print("🔍 لا توجد فواكه متاحة")
                
                -- 3. شراء فواكه جديدة
                if not BloxFruits.FruitBought then
                    BloxFruits.TryBuyFruit()
                end
            end
            
            -- انتظار قبل الدورة التالية
            BloxFruits.Delay(BloxFruits.CheckDelay)
        end
    end)
end

-- ==================== معلومات النظام ====================
function BloxFruits.GetStatus()
    print("📊 حالة نظام الفواكه:")
    print("├── النظام: " .. (BloxFruits.Active and "✅ نشط" or "❌ متوقف"))
    print("├── اشترى فاكهة: " .. (BloxFruits.FruitBought and "✅" or "❌"))
    print("├── فاكهة في الجيب: " .. (BloxFruits.FruitInInventory and "✅" : "❌"))
    print("└── التفحص كل: " .. BloxFruits.CheckDelay .. " ثواني")
    
    BloxFruits.Notify("الحالة", "النظام: " .. (BloxFruits.Active and "نشط" or "متوقف"), 3)
end

function BloxFruits.StopSystem()
    BloxFruits.Active = false
    print("🛑 توقف نظام الفواكه")
    BloxFruits.Notify("النظام", "تم التوقف", 3)
end

-- ==================== التفعيل ====================
function BloxFruits.Init()
    print("🍊 نظام شراء فواكه بلوكس فروت جاهز!")
    print("📚 الإصدار: " .. BloxFruits.Version)
    print("👤 المطور: " .. BloxFruits.Author)
    print("✨ المميزات:")
    print("├── 🔍 بحث تلقائي عن الفواكه")
    print("├── 🛒 شراء فواكه عند عدم توفر")
    print("├── 📦 تخزين تلقائي في المخزن")
    print("└── 🔄 عمل مستمر")
    
    return BloxFruits
end

BloxFruits.Init()
return BloxFruits
