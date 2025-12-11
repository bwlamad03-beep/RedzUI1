-- Commands.lua - أوامر Redz Style فقط بدون واجهة
-- رابط: loadstring(game:HttpGet("https://raw.githubusercontent.com/اسمك/RedzUI/main/Commands.lua"))()

local RedzCommands = {}
RedzCommands.Version = "Commands 2.0"
RedzCommands.Author = "Mr.Qattusa"

-- مكتبات النظام
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- متغيرات النظام
RedzCommands.Active = {
    Noclip = false,
    Fly = false,
    Speed = false,
    Jump = false,
    ESP = false
}

RedzCommands.Connections = {}

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

-- ==================== أوامر الحركة ====================
function RedzCommands.Speed(value)
    local success, err = pcall(function()
        local _, humanoid, _ = RedzCommands.GetCharacter()
        if not humanoid then return end
        
        if value then
            humanoid.WalkSpeed = tonumber(value) or 100
            RedzCommands.Active.Speed = true
            print("🚀 السرعة: " .. humanoid.WalkSpeed)
        else
            humanoid.WalkSpeed = 16
            RedzCommands.Active.Speed = false
            print("🚶 السرعة: عادية")
        end
    end)
    
    if not success then
        warn("❌ خطأ في السرعة: " .. tostring(err))
    end
end

function RedzCommands.Jump(value)
    local success, err = pcall(function()
        local _, humanoid, _ = RedzCommands.GetCharacter()
        if not humanoid then return end
        
        if value then
            humanoid.JumpPower = tonumber(value) or 100
            RedzCommands.Active.Jump = true
            print("🐰 قفزة: " .. humanoid.JumpPower)
        else
            humanoid.JumpPower = 50
            RedzCommands.Active.Jump = false
            print("🐰 القفزة: عادية")
        end
    end)
    
    if not success then
        warn("❌ خطأ في القفزة: " .. tostring(err))
    end
end

function RedzCommands.Fly()
    local success, err = pcall(function()
        if RedzCommands.Active.Fly then
            -- إيقاف الطيران
            RedzCommands.Active.Fly = false
            
            if RedzCommands.Connections.Fly then
                RedzCommands.Connections.Fly:Disconnect()
                RedzCommands.Connections.Fly = nil
            end
            
            local character, humanoid, root = RedzCommands.GetCharacter()
            if character then
                humanoid.PlatformStand = false
            end
            
            print("🛑 إيقاف الطيران")
            RedzCommands.Notify("Flight", "تم إيقاف الطيران", 2)
        else
            -- تفعيل الطيران
            RedzCommands.Active.Fly = true
            
            local character, humanoid, root = RedzCommands.GetCharacter()
            if not character then return end
            
            humanoid.PlatformStand = true
            
            -- نظام التحكم بالطيران
            RedzCommands.Connections.Fly = RunService.Heartbeat:Connect(function()
                if not RedzCommands.Active.Fly or not character or not root then
                    return
                end
                
                local camera = Workspace.CurrentCamera
                local direction = Vector3.new()
                local speed = 100
                
                -- التحكم بالاتجاهات
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, 1, 0)
                end
                
                -- تطبيق الحركة
                if direction.Magnitude > 0 then
                    root.Velocity = direction.Unit * speed
                else
                    root.Velocity = Vector3.new(0, 0, 0)
                end
            end)
            
            print("🦅 تفعيل الطيران")
            RedzCommands.Notify("Flight", "الطيران مفعل! استخدم WASD + Space/Shift", 3)
        end
    end)
    
    if not success then
        warn("❌ خطأ في الطيران: " .. tostring(err))
    end
end

function RedzCommands.Noclip()
    local success, err = pcall(function()
        if RedzCommands.Active.Noclip then
            -- إيقاف النوكلب
            RedzCommands.Active.Noclip = false
            
            if RedzCommands.Connections.Noclip then
                RedzCommands.Connections.Noclip:Disconnect()
                RedzCommands.Connections.Noclip = nil
            end
            
            print("🛑 إيقاف النوكلب")
            RedzCommands.Notify("Noclip", "تم إيقاف النوكلب", 2)
        else
            -- تفعيل النوكلب
            RedzCommands.Active.Noclip = true
            
            RedzCommands.Connections.Noclip = RunService.Stepped:Connect(function()
                if not RedzCommands.Active.Noclip then return end
                
                local character, humanoid, root = RedzCommands.GetCharacter()
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            
            print("👻 تفعيل النوكلب")
            RedzCommands.Notify("Noclip", "النوكلب مفعل", 2)
        end
    end)
    
    if not success then
        warn("❌ خطأ في النوكلب: " .. tostring(err))
    end
end

-- ==================== أوامر اللعبة ====================
function RedzCommands.TeleportTo(playerName)
    local success, err = pcall(function()
        local _, _, root = RedzCommands.GetCharacter()
        if not root then return end
        
        local targetPlayer = nil
        
        -- البحث عن اللاعب
        for _, player in pairs(Players:GetPlayers()) do
            if string.find(string.lower(player.Name), string.lower(playerName)) then
                targetPlayer = player
                break
            end
        end
        
        if targetPlayer and targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                root.CFrame = targetRoot.CFrame
                print("🎯 تلفيل إلى: " .. targetPlayer.Name)
                RedzCommands.Notify("Teleport", "تم التلفيل إلى " .. targetPlayer.Name, 3)
            end
        else
            print("❌ لاعب غير موجود!")
            RedzCommands.Notify("Teleport", "اللاعب غير موجود", 2)
        end
    end)
    
    if not success then
        warn("❌ خطأ في التلفيل: " .. tostring(err))
    end
end

function RedzCommands.TeleportToPosition(x, y, z)
    local success, err = pcall(function()
        local _, _, root = RedzCommands.GetCharacter()
        if not root then return end
        
        local position = Vector3.new(
            tonumber(x) or 0,
            tonumber(y) or 0,
            tonumber(z) or 0
        )
        
        root.CFrame = CFrame.new(position)
        print("📍 تلفيل إلى: " .. tostring(position))
        RedzCommands.Notify("Teleport", "تم التلفيل إلى الموقع", 2)
    end)
    
    if not success then
        warn("❌ خطأ في التلفيل: " .. tostring(err))
    end
end

function RedzCommands.CopyPosition()
    local success, err = pcall(function()
        local _, _, root = RedzCommands.GetCharacter()
        if not root then return end
        
        local position = tostring(root.Position)
        
        if setclipboard then
            setclipboard(position)
            print("📋 نسخ الموقع: " .. position)
            RedzCommands.Notify("Copy", "تم نسخ الموقع: " .. position, 3)
        else
            print("📋 الموقع: " .. position)
        end
    end)
    
    if not success then
        warn("❌ خطأ في نسخ الموقع: " .. tostring(err))
    end
end

-- ==================== أوامر المراقبة ====================
function RedzCommands.ESP()
    local success, err = pcall(function()
        if RedzCommands.Active.ESP then
            -- إيقاف ESP
            RedzCommands.Active.ESP = false
            
            if RedzCommands.Connections.ESP then
                RedzCommands.Connections.ESP:Disconnect()
                RedzCommands.Connections.ESP = nil
            end
            
            -- تنظيف
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part:FindFirstChild("ESP_Highlight") then
                            part.ESP_Highlight:Destroy()
                        end
                    end
                end
            end
            
            print("🛑 إيقاف ESP")
            RedzCommands.Notify("ESP", "تم إيقاف ESP", 2)
        else
            -- تفعيل ESP
            RedzCommands.Active.ESP = true
            
            -- دالة إنشاء ESP
            local function createESP(character)
                if not character then return end
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and not part:FindFirstChild("ESP_Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESP_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Adornee = part
                        highlight.Parent = part
                    end
                end
            end
            
            -- تطبيق على جميع اللاعبين
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    if player.Character then
                        createESP(player.Character)
                    end
                    
                    player.CharacterAdded:Connect(function(character)
                        if RedzCommands.Active.ESP then
                            delay(1)
                            createESP(character)
                        end
                    end)
                end
            end
            
            -- مراقبة اللاعبين الجدد
            RedzCommands.Connections.ESP = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    if RedzCommands.Active.ESP then
                        delay(1)
                        createESP(character)
                    end
                end)
            end)
            
            print("👁️ تفعيل ESP")
            RedzCommands.Notify("ESP", "ESP مفعل", 2)
        end
    end)
    
    if not success then
        warn("❌ خطأ في ESP: " .. tostring(err))
    end
end

-- ==================== أوامر النظام ====================
function RedzCommands.Refresh()
    local success, err = pcall(function()
        local player = Players.LocalPlayer
        local character = player.Character
        
        if character then
            character:BreakJoints()
            print("🔄 إعادة التولد")
            RedzCommands.Notify("Refresh", "جاري إعادة التولد...", 2)
        end
    end)
    
    if not success then
        warn("❌ خطأ في إعادة التولد: " .. tostring(err))
    end
end

function RedzCommands.Cleanup()
    print("🧹 تنظيف جميع الأنظمة...")
    
    -- إيقاف جميع الأنظمة
    for feature, active in pairs(RedzCommands.Active) do
        RedzCommands.Active[feature] = false
    end
    
    -- قطع جميع الاتصالات
    for name, connection in pairs(RedzCommands.Connections) do
        if connection then
            connection:Disconnect()
            RedzCommands.Connections[name] = nil
        end
    end
    
    -- إعادة تعيين الحركة
    local _, humanoid, _ = RedzCommands.GetCharacter()
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        humanoid.PlatformStand = false
    end
    
    print("✅ تم تنظيف جميع الأنظمة")
    RedzCommands.Notify("Cleanup", "تم تنظيف جميع الأنظمة", 2)
end

function RedzCommands.ListCommands()
    print("📋 قائمة الأوامر المتاحة:")
    print("├── 🚀 Speed [قيمة] - تغيير السرعة")
    print("├── 🐰 Jump [قيمة] - تغيير قوة القفزة")
    print("├── 🦅 Fly - تفعيل/إيقاف الطيران")
    print("├── 👻 Noclip - تفعيل/إيقاف النوكلب")
    print("├── 🎯 TeleportTo [اسم] - تلفيل إلى لاعب")
    print("├── 📍 TeleportToPosition [x y z] - تلفيل إلى إحداثيات")
    print("├── 📋 CopyPosition - نسخ الموقع الحالي")
    print("├── 👁️ ESP - رؤية اللاعبين عبر الجدران")
    print("├── 🔄 Refresh - إعادة التولد")
    print("└── 🧹 Cleanup - تنظيف جميع الأنظمة")
end

function RedzCommands.GetStatus()
    print("📊 حالة النظام:")
    for feature, active in pairs(RedzCommands.Active) do
        print("├── " .. feature .. ": " .. (active and "✅" or "❌"))
    end
end

-- ==================== التفعيل ====================
function RedzCommands.Init()
    print("🎮 أوامر Redz Style جاهزة!")
    print("📚 الإصدار: " .. RedzCommands.Version)
    print("👤 المطور: " .. RedzCommands.Author)
    
    -- تنظيف عند إعادة التولد
    Players.LocalPlayer.CharacterAdded:Connect(function()
        RedzCommands.Cleanup()
    end)
    
    return RedzCommands
end

-- التفعيل التلقائي
RedzCommands.Init()

return RedzCommands