-- Interface.lua - واجهة Redz Style فقط بدون أوامر
local RedzUI = {}
RedzUI.Version = "Interface 3.0"
RedzUI.Author = "Mr.Qattusa"

-- مكتبات النظام
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- متغيرات النظام
RedzUI.MainGUI = nil
RedzUI.OptionsContainer = nil
RedzUI.OptionsList = {}

-- دالة تأخير متوافقة
local function delay(time)
    if task then
        task.wait(time)
    else
        wait(time)
    end
end

-- ==================== إنشاء الواجهة ====================
function RedzUI.Create()
    local success, err = pcall(function()
        print("🎮 جاري إنشاء واجهة Redz Style...")
        
        -- تنظيف الواجهة القديمة
        RedzUI.Destroy()
        
        -- إنشاء واجهة الشاشة
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "RedzUI_Main"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        -- حماية الواجهة
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
        elseif gethui then
            ScreenGui.Parent = gethui()
        else
            ScreenGui.Parent = game:GetService("CoreGui")
        end
        
        -- القط الرئيسي (زر التبديل)
        local MainButton = Instance.new("TextButton")
        MainButton.Name = "RedzUI_Toggle"
        MainButton.Size = UDim2.new(0, 80, 0, 80)
        MainButton.Position = UDim2.new(0, 20, 0.5, -40)
        MainButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        MainButton.BackgroundTransparency = 0.2
        MainButton.Text = "🐱"
        MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        MainButton.Font = Enum.Font.GothamBold
        MainButton.TextSize = 30
        MainButton.ZIndex = 10
        
        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0.3, 0)
        MainCorner.Parent = MainButton
        
        -- تأثير عند التحويم
        MainButton.MouseEnter:Connect(function()
            local tween = TweenService:Create(
                MainButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0.1}
            )
            tween:Play()
        end)
        
        MainButton.MouseLeave:Connect(function()
            local tween = TweenService:Create(
                MainButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0.2}
            )
            tween:Play()
        end)
        
        -- القائمة الرئيسية
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "RedzUI_Menu"
        MainFrame.Size = UDim2.new(0, 350, 0, 400)
        MainFrame.Position = UDim2.new(0, 110, 0.5, -200)
        MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        MainFrame.BackgroundTransparency = 0.1
        MainFrame.Visible = false
        MainFrame.ZIndex = 5
        
        local FrameCorner = Instance.new("UICorner")
        FrameCorner.CornerRadius = UDim.new(0.05, 0)
        FrameCorner.Parent = MainFrame
        
        -- تأثير الظل
        local FrameShadow = Instance.new("ImageLabel")
        FrameShadow.Name = "Shadow"
        FrameShadow.Image = "rbxassetid://5554236805"
        FrameShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        FrameShadow.ImageTransparency = 0.8
        FrameShadow.ScaleType = Enum.ScaleType.Slice
        FrameShadow.SliceCenter = Rect.new(23, 23, 277, 277)
        FrameShadow.Size = UDim2.new(1, 20, 1, 20)
        FrameShadow.Position = UDim2.new(0, -10, 0, -10)
        FrameShadow.BackgroundTransparency = 1
        FrameShadow.ZIndex = 4
        FrameShadow.Parent = MainFrame
        
        -- شريط العنوان
        local TitleBar = Instance.new("Frame")
        TitleBar.Name = "TitleBar"
        TitleBar.Size = UDim2.new(1, 0, 0, 40)
        TitleBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        TitleBar.ZIndex = 6
        
        local TitleCorner = Instance.new("UICorner")
        TitleCorner.CornerRadius = UDim.new(0.05, 0)
        TitleCorner.Parent = TitleBar
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Text = "🐱 Mr.Qattusa Menu"
        TitleLabel.Size = UDim2.new(1, -10, 1, 0)
        TitleLabel.Position = UDim2.new(0, 10, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 18
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 7
        TitleLabel.Parent = TitleBar
        
        TitleBar.Parent = MainFrame
        
        -- زر الإغلاق
        local CloseButton = Instance.new("TextButton")
        CloseButton.Text = "✕"
        CloseButton.Size = UDim2.new(0, 30, 0, 30)
        CloseButton.Position = UDim2.new(1, -35, 0, 5)
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.Font = Enum.Font.GothamBold
        CloseButton.TextSize = 16
        CloseButton.ZIndex = 8
        
        CloseButton.MouseButton1Click:Connect(function()
            RedzUI.ToggleMenu(false)
        end)
        
        CloseButton.Parent = TitleBar
        
        -- منطقة الخيارات
        local OptionsScroller = Instance.new("ScrollingFrame")
        OptionsScroller.Name = "OptionsContainer"
        OptionsScroller.Size = UDim2.new(1, -20, 1, -60)
        OptionsScroller.Position = UDim2.new(0, 10, 0, 50)
        OptionsScroller.BackgroundTransparency = 1
        OptionsScroller.ScrollBarThickness = 3
        OptionsScroller.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 100)
        OptionsScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
        OptionsScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
        OptionsScroller.ZIndex = 6
        OptionsScroller.Parent = MainFrame
        
        -- فتح/إغلاق القائمة
        MainButton.MouseButton1Click:Connect(function()
            RedzUI.ToggleMenu(not MainFrame.Visible)
        end)
        
        -- خاصية السحب والنقل
        local dragging = false
        local dragInput, dragStart, startPos
        
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input == dragInput then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
        
        -- إضافة العناصر
        MainButton.Parent = ScreenGui
        MainFrame.Parent = ScreenGui
        
        -- حفظ المرجع
        RedzUI.MainGUI = ScreenGui
        RedzUI.OptionsContainer = OptionsScroller
        
        -- حركة القط الخلفية
        coroutine.wrap(function()
            while RedzUI.MainGUI and RedzUI.MainGUI.Parent do
                delay(5)
                local randomX = math.random(-20, 20)
                local randomY = math.random(-20, 20)
                
                local tween = TweenService:Create(
                    MainButton,
                    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0, 20 + randomX, 0.5, -40 + randomY)}
                )
                tween:Play()
            end
        end)()
        
        -- مفاتيح الاختصار
        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed then
                if input.KeyCode == Enum.KeyCode.RightControl then
                    RedzUI.ToggleMenu(not MainFrame.Visible)
                end
            end
        end)
        
        print("✅ واجهة Redz Style تم إنشاؤها!")
        return ScreenGui, OptionsScroller
    end)
    
    if not success then
        warn("❌ خطأ في إنشاء الواجهة: " .. tostring(err))
        return nil, nil
    end
end

-- ==================== وظائف التحكم ====================
function RedzUI.ToggleMenu(state)
    if RedzUI.MainGUI then
        local menu = RedzUI.MainGUI:FindFirstChild("RedzUI_Menu")
        if menu then
            menu.Visible = state
            
            -- تأثير الظهور
            if state then
                menu.Position = UDim2.new(0, 110, 0.5, -200)
                
                local tween = TweenService:Create(
                    menu,
                    TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0, 110, 0.5, -200)}
                )
                tween:Play()
            end
        end
    end
end

function RedzUI.AddOption(name, icon, color, callback)
    local success, err = pcall(function()
        if not RedzUI.OptionsContainer then
            warn("⚠️ لا توجد واجهة نشطة!")
            return nil
        end
        
        local optionID = #RedzUI.OptionsList + 1
        local optionHeight = 50
        
        -- إنشاء زر الخيار
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = "Option_" .. name
        OptionButton.Text = icon .. "  " .. name
        OptionButton.Size = UDim2.new(1, 0, 0, optionHeight)
        OptionButton.Position = UDim2.new(0, 0, 0, (optionID - 1) * (optionHeight + 5))
        OptionButton.BackgroundColor3 = color
        OptionButton.BackgroundTransparency = 0.3
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.Font = Enum.Font.GothamBold
        OptionButton.TextSize = 15
        OptionButton.ZIndex = 7
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0.1, 0)
        OptionCorner.Parent = OptionButton
        
        -- تأثير التحويم
        OptionButton.MouseEnter:Connect(function()
            local tween = TweenService:Create(
                OptionButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0.2}
            )
            tween:Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            local tween = TweenService:Create(
                OptionButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0.3}
            )
            tween:Play()
        end)
        
        -- عند النقر
        OptionButton.MouseButton1Click:Connect(function()
            spawn(function()
                local success, funcErr = pcall(callback)
                if not success then
                    warn("❌ خطأ في تنفيذ الخيار " .. name .. ": " .. tostring(funcErr))
                else
                    -- إغلاق القائمة بعد التنفيذ
                    RedzUI.ToggleMenu(false)
                end
            end)
        end)
        
        -- إضافة للواجهة
        OptionButton.Parent = RedzUI.OptionsContainer
        
        -- حفظ في القائمة
        table.insert(RedzUI.OptionsList, {
            Id = optionID,
            Name = name,
            Button = OptionButton,
            Callback = callback
        })
        
        print("✅ تم إضافة خيار: " .. name)
        return OptionButton
    end)
    
    if not success then
        warn("❌ خطأ في إضافة الخيار " .. name .. ": " .. tostring(err))
    end
end

function RedzUI.ClearOptions()
    if RedzUI.OptionsContainer then
        for _, child in pairs(RedzUI.OptionsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        RedzUI.OptionsList = {}
        print("🧹 تم تنظيف جميع الخيارات")
    end
end

function RedzUI.Destroy()
    if RedzUI.MainGUI then
        RedzUI.MainGUI:Destroy()
        RedzUI.MainGUI = nil
        RedzUI.OptionsContainer = nil
        RedzUI.OptionsList = {}
        print("🗑️ تم تدمير الواجهة")
    end
end

function RedzUI.GetGUI()
    return RedzUI.MainGUI
end

function RedzUI.GetVersion()
    return RedzUI.Version
end

-- ==================== التفعيل التلقائي ====================
spawn(function()
    delay(0.5)
    RedzUI.Create()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Redz UI",
        Text = "الواجهة جاهزة! استخدم RCtrl لفتحها",
        Duration = 3,
        Icon = "🐱"
    })
end)

return RedzUI
