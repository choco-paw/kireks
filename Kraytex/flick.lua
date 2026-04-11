--[[
malsınız aqq 
git kod yazmayı ören buney

--]]


-- [ KRAYTEX FLİCK SCRİPT ] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function GetSafeGuiParent()
    local success, parent = pcall(function() return gethui() end)
    if success and parent then return parent end
    success, parent = pcall(function() return CoreGui end)
    if success and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local SafeParent = GetSafeGuiParent()

for _, v in pairs(SafeParent:GetChildren()) do
    if v.Name == "KraytexLang" or v.Name == "KraytexMain" or v.Name == "KraytexVisuals" or v.Name == "KraytexESP" or v.Name == "KraytexMobile" then v:Destroy() end
end

pcall(function() RunService:UnbindFromRenderStep("KraytexMainLoop") end)
if _G.K_InputBegan then _G.K_InputBegan:Disconnect() end
if _G.K_InputEnded then _G.K_InputEnded:Disconnect() end

_G.KraytexLang = "TR"

local Theme = {
    Black = Color3.fromRGB(20, 20, 22),
    DarkBlack = Color3.fromRGB(14, 14, 16),
    Yellow = Color3.fromRGB(255, 215, 0),
    Text = Color3.fromRGB(240, 240, 240),
    TextMuted = Color3.fromRGB(150, 150, 150)
}

local Settings = {
    MenuKeybind = Enum.KeyCode.RightShift,
    AimKey = Enum.UserInputType.MouseButton2,
    AimbotToggleKey = Enum.KeyCode.T,
    Aimbot = false,
    TeamCheck = true,
    Smoothness = 5,
    ShowFOV = false,
    FOVSize = 100,
    ESPBox = false,
    ESPNames = false,
    ESPDist = false,
    ESPHp = false,
    ESPTracer = false
}

local Aiming = false
local MobileAiming = false
local CurrentTarget = nil

local Translations = {
    TR = {
        LangTitle = "Dil // Language",
        Aimbot = "Aimbot", ESP = "ESP", Binds = "Anahtarlar", About = "Hakkında",
        MenuKey = "Menü Aç/Kapat Tuşu", AimKey = "Aimbot Kilitlenme Tuşu", AimToggleKey = "Aimbot Aç/Kapat Tuşu",
        Dev = "Yapımcı : Shadzy", Desc = "Menü Adı : Kraytex Flick", Discord = "Kraytex Discord",
        AimToggle = "Aimbot Aç Kapat", TeamCheck = "Takım Kontrolü", Smoothness = "Smoothness", ShowFOV = "Fov Göster", FOVSize = "Fov Ayarlama",
        ESPBox = "Hitbox", ESPNames = "Names", ESPDist = "Distance", ESPHp = "Health Bar", ESPTracer = "Tracers"
    },
    EN = {
        LangTitle = "Dil // Language",
        Aimbot = "Aimbot", ESP = "ESP", Binds = "Keybinds", About = "About",
        MenuKey = "Menu Toggle Key", AimKey = "Aimbot Lock Key", AimToggleKey = "Aimbot Toggle Key",
        Dev = "Developer : Shadzy", Desc = "Menu Name : Kraytex Flick", Discord = "Kraytex Discord",
        AimToggle = "Toggle Aimbot", TeamCheck = "Team Check", Smoothness = "Smoothness", ShowFOV = "Show FOV", FOVSize = "FOV Size",
        ESPBox = "Hitbox", ESPNames = "Names", ESPDist = "Distance", ESPHp = "Health Bar", ESPTracer = "Tracers"
    }
}

local VisualsGui = Instance.new("ScreenGui")
VisualsGui.Name = "KraytexVisuals"
VisualsGui.IgnoreGuiInset = true
VisualsGui.Parent = SafeParent
pcall(function() VisualsGui.Interactable = false end)

local FOVFrame = Instance.new("Frame")
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = VisualsGui
local FOVCorner = Instance.new("UICorner") FOVCorner.CornerRadius = UDim.new(1, 0) FOVCorner.Parent = FOVFrame
local FOVStroke = Instance.new("UIStroke") FOVStroke.Color = Theme.Text FOVStroke.Thickness = 1.5 FOVStroke.Parent = FOVFrame

local function UpdateFOV()
    FOVFrame.Size = UDim2.new(0, Settings.FOVSize * 2, 0, Settings.FOVSize * 2)
    FOVFrame.Visible = Settings.ShowFOV
    if isMobile then
        FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    else
        local mousePos = UserInputService:GetMouseLocation()
        FOVFrame.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
    end
end

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "KraytexESP"
ESPGui.IgnoreGuiInset = true
ESPGui.Parent = SafeParent
pcall(function() ESPGui.Interactable = false end)

local ESPCache = {}

local function CreateESPElements()
    local elements = {}
    
    elements.Box = Instance.new("Frame")
    elements.Box.BackgroundTransparency = 1
    elements.Box.Visible = false
    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Theme.Yellow
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = elements.Box
    
    elements.HealthBg = Instance.new("Frame")
    elements.HealthBg.BackgroundColor3 = Theme.DarkBlack
    elements.HealthBg.BorderSizePixel = 0
    elements.HealthBg.Visible = false
    elements.HealthBg.Parent = ESPGui
    
    elements.HealthFill = Instance.new("Frame")
    elements.HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    elements.HealthFill.BorderSizePixel = 0
    elements.HealthFill.Parent = elements.HealthBg
    
    elements.NameText = Instance.new("TextLabel")
    elements.NameText.BackgroundTransparency = 1
    elements.NameText.TextColor3 = Theme.Text
    elements.NameText.TextStrokeTransparency = 0
    elements.NameText.Font = Enum.Font.GothamBold
    elements.NameText.TextSize = 13
    elements.NameText.Visible = false
    elements.NameText.Parent = ESPGui
    
    elements.DistText = Instance.new("TextLabel")
    elements.DistText.BackgroundTransparency = 1
    elements.DistText.TextColor3 = Theme.Yellow
    elements.DistText.TextStrokeTransparency = 0
    elements.DistText.Font = Enum.Font.GothamMedium
    elements.DistText.TextSize = 11
    elements.DistText.Visible = false
    elements.DistText.Parent = ESPGui

    elements.Tracer = Instance.new("Frame")
    elements.Tracer.BackgroundColor3 = Theme.Yellow
    elements.Tracer.BorderSizePixel = 0
    elements.Tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    elements.Tracer.Visible = false
    elements.Tracer.Parent = ESPGui
    
    elements.Box.Parent = ESPGui
    return elements
end

local function GetClosestPlayer()
    local closestDist = Settings.FOVSize
    local closestPlayer = nil
    local center = isMobile and Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) or UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if Settings.TeamCheck and player.Team == LocalPlayer.Team then continue end
            if player.Team and player.Team.Name:lower():find("spec") then continue end

            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local head = player.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen and pos.Z > 0 then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist <= closestDist then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

_G.K_InputBegan = UserInputService.InputBegan:Connect(function(input, gp)
    if input.UserInputType == Settings.AimKey then Aiming = true end
end)

_G.K_InputEnded = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Settings.AimKey then Aiming = false end
end)

RunService:BindToRenderStep("KraytexMainLoop", Enum.RenderPriority.Camera.Value + 2, function()
    UpdateFOV()
    
    if Settings.Aimbot then
        CurrentTarget = GetClosestPlayer()
    else
        CurrentTarget = nil
    end

    if Settings.Aimbot and (Aiming or MobileAiming) and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("Head") then
        local head = CurrentTarget.Character.Head
        local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
        if onScreen and pos.Z > 0 then
            if Settings.Smoothness == 0 then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
            else
                local smoothFactor = 1 / (Settings.Smoothness * 4)
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), smoothFactor)
            end
        end
    end

    local bottomCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        if not ESPCache[player] then ESPCache[player] = CreateESPElements() end
        local esp = ESPCache[player]
        local char = player.Character
        local isValid = char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0
        
        local isEnemy = true
        if Settings.TeamCheck and player.Team == LocalPlayer.Team then isEnemy = false end
        if player.Team and player.Team.Name:lower():find("spec") then isEnemy = false end

        if isValid and isEnemy then
            local hrp = char.HumanoidRootPart
            local head = char.Head
            local hum = char.Humanoid
            local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen and hrpPos.Z > 0 then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                
                if Settings.ESPBox then
                    esp.Box.Visible = true
                    esp.Box.Size = UDim2.new(0, width, 0, height)
                    esp.Box.Position = UDim2.new(0, hrpPos.X - width/2, 0, headPos.Y)
                else
                    esp.Box.Visible = false
                end
                
                if Settings.ESPHp then
                    esp.HealthBg.Visible = true
                    esp.HealthBg.Size = UDim2.new(0, width, 0, 4)
                    esp.HealthBg.Position = UDim2.new(0, hrpPos.X - width/2, 0, headPos.Y - 8)
                    local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    esp.HealthFill.Size = UDim2.new(hpPercent, 0, 1, 0)
                    esp.HealthFill.BackgroundColor3 = Color3.fromRGB(255 - (hpPercent * 255), hpPercent * 255, 0)
                else
                    esp.HealthBg.Visible = false
                end
                
                if Settings.ESPNames then
                    esp.NameText.Visible = true
                    esp.NameText.Text = player.Name
                    esp.NameText.Position = UDim2.new(0, hrpPos.X, 0, headPos.Y + height + 5)
                else
                    esp.NameText.Visible = false
                end
                
                if Settings.ESPDist then
                    esp.DistText.Visible = true
                    esp.DistText.Text = math.floor(dist) .. "m"
                    local distOffset = Settings.ESPNames and 20 or 5
                    esp.DistText.Position = UDim2.new(0, hrpPos.X, 0, headPos.Y + height + distOffset)
                else
                    esp.DistText.Visible = false
                end
                
                if Settings.ESPTracer then
                    esp.Tracer.Visible = true
                    local dx = hrpPos.X - bottomCenter.X
                    local dy = (headPos.Y + height) - bottomCenter.Y
                    local tracerDist = math.sqrt(dx*dx + dy*dy)
                    esp.Tracer.Size = UDim2.new(0, 1.5, 0, tracerDist)
                    esp.Tracer.Position = UDim2.new(0, (hrpPos.X + bottomCenter.X)/2, 0, ((headPos.Y + height) + bottomCenter.Y)/2)
                    esp.Tracer.Rotation = math.deg(math.atan2(dy, dx)) - 90
                else
                    esp.Tracer.Visible = false
                end
            else
                esp.Box.Visible = false; esp.HealthBg.Visible = false; esp.NameText.Visible = false; esp.DistText.Visible = false; esp.Tracer.Visible = false;
            end
        else
            if esp then esp.Box.Visible = false; esp.HealthBg.Visible = false; esp.NameText.Visible = false; esp.DistText.Visible = false; esp.Tracer.Visible = false; end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPCache[player] then
        for _, v in pairs(ESPCache[player]) do v:Destroy() end
        ESPCache[player] = nil
    end
end)

local function LoadMainMenu()
    local T = Translations[_G.KraytexLang]
    
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "KraytexMain"
    MainGui.IgnoreGuiInset = true
    MainGui.Parent = SafeParent
    MainGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.Black
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainGui
    local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke") MainStroke.Color = Theme.Yellow MainStroke.Thickness = 2 MainStroke.Parent = MainFrame

    local function MakeDraggable(dragPart, movePart)
        movePart = movePart or dragPart
        local dragging = false
        local dragInput, dragStart, startPos

        dragPart.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = movePart.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        dragPart.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                movePart.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    local function OpenMenuAnim()
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        local t1 = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 350)})
        t1:Play()
        t1.Completed:Wait()
        local t2 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 350)})
        t2:Play()
    end
    task.spawn(OpenMenuAnim)

    local menuVisible = true
    local function ToggleMenu()
        menuVisible = not menuVisible
        MainFrame.ClipsDescendants = true
        if menuVisible then
            MainGui.Enabled = true
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 350)}):Play()
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            t:Play()
            t.Completed:Wait()
            if not menuVisible then
                MainGui.Enabled = false
            end
        end
    end

    local AimBtn
    local AimStroke
    if isMobile then
        local MobileGui = Instance.new("ScreenGui")
        MobileGui.Name = "KraytexMobile"
        MobileGui.IgnoreGuiInset = true
        MobileGui.Parent = SafeParent
        MobileGui.ResetOnSpawn = false

        local KBtn = Instance.new("TextButton")
        KBtn.Size = UDim2.new(0, 50, 0, 50)
        KBtn.Position = UDim2.new(0.5, -25, 0, 20)
        KBtn.BackgroundColor3 = Theme.Yellow
        KBtn.Text = "K"
        KBtn.TextColor3 = Theme.Black
        KBtn.Font = Enum.Font.GothamBlack
        KBtn.TextSize = 24
        KBtn.Parent = MobileGui
        local KCorner = Instance.new("UICorner")
        KCorner.CornerRadius = UDim.new(1, 0)
        KCorner.Parent = KBtn
        MakeDraggable(KBtn)

        KBtn.MouseButton1Click:Connect(ToggleMenu)

        AimBtn = Instance.new("TextButton")
        AimBtn.Size = UDim2.new(0, 60, 0, 60)
        AimBtn.Position = UDim2.new(1, -80, 0.5, -30)
        AimBtn.BackgroundColor3 = Theme.DarkBlack
        AimBtn.Text = "AIM"
        AimBtn.TextColor3 = Theme.TextMuted
        AimBtn.Font = Enum.Font.GothamBlack
        AimBtn.TextSize = 16
        AimBtn.Visible = false
        AimBtn.Parent = MobileGui
        local AimCorner = Instance.new("UICorner")
        AimCorner.CornerRadius = UDim.new(1, 0)
        AimCorner.Parent = AimBtn
        AimStroke = Instance.new("UIStroke")
        AimStroke.Color = Theme.Yellow
        AimStroke.Thickness = 2
        AimStroke.Parent = AimBtn
        MakeDraggable(AimBtn)

        AimBtn.MouseButton1Click:Connect(function()
            MobileAiming = not MobileAiming
            if MobileAiming then
                AimBtn.BackgroundColor3 = Theme.Yellow
                AimBtn.TextColor3 = Theme.Black
                AimStroke.Color = Theme.Black
            else
                AimBtn.BackgroundColor3 = Theme.DarkBlack
                AimBtn.TextColor3 = Theme.TextMuted
                AimStroke.Color = Theme.Yellow
            end
        end)
    end

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Theme.DarkBlack
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local LogoArea = Instance.new("Frame")
    LogoArea.Size = UDim2.new(1, 0, 0, 50)
    LogoArea.BackgroundTransparency = 1
    LogoArea.Parent = Sidebar
    MakeDraggable(LogoArea, MainFrame)

    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(1, 0, 1, 0)
    Logo.BackgroundTransparency = 1
    Logo.Text = "KRAYTEX"
    Logo.TextColor3 = Theme.Yellow
    Logo.Font = Enum.Font.GothamBlack
    Logo.TextSize = 20
    Logo.Parent = LogoArea

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Sidebar
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -140, 1, 0)
    ContentArea.Position = UDim2.new(0, 140, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local Pages = {}
    local TabButtons = {}

    local function CreateTab(name, title)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -20, 0, 35)
        TabBtn.BackgroundColor3 = Theme.Black
        TabBtn.Text = title
        TabBtn.TextColor3 = Theme.TextMuted
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 13
        TabBtn.Parent = TabContainer
        local TabCorner = Instance.new("UICorner") TabCorner.CornerRadius = UDim.new(0, 6) TabCorner.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0, 10, 0, 10)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.Parent = ContentArea
        local PageLayout = Instance.new("UIListLayout") PageLayout.Padding = UDim.new(0, 10) PageLayout.Parent = Page

        Pages[name] = Page
        TabButtons[name] = TabBtn

        TabBtn.MouseButton1Click:Connect(function()
            for k, p in pairs(Pages) do p.Visible = (k == name) end
            for k, b in pairs(TabButtons) do 
                if k == name then
                    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Yellow, TextColor3 = Theme.Black}):Play()
                else
                    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Black, TextColor3 = Theme.TextMuted}):Play()
                end
            end
        end)
        return Page
    end

    local AimbotPage = CreateTab("Aimbot", T.Aimbot)
    local ESPPage = CreateTab("ESP", T.ESP)
    local BindsPage
    if not isMobile then
        BindsPage = CreateTab("Binds", T.Binds)
    end
    local AboutPage = CreateTab("About", T.About)

    Pages["Aimbot"].Visible = true
    TabButtons["Aimbot"].BackgroundColor3 = Theme.Yellow
    TabButtons["Aimbot"].TextColor3 = Theme.Black

    local function CreateToggle(page, text, stateKey, callback)
        local Frame = Instance.new("Frame") Frame.Size = UDim2.new(1, 0, 0, 40) Frame.BackgroundColor3 = Theme.DarkBlack Frame.Parent = page
        local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = Frame
        local Label = Instance.new("TextLabel") Label.Size = UDim2.new(1, -70, 1, 0) Label.Position = UDim2.new(0, 15, 0, 0) Label.BackgroundTransparency = 1 Label.Text = text Label.TextColor3 = Theme.Text Label.Font = Enum.Font.GothamSemibold Label.TextSize = 13 Label.TextXAlignment = Enum.TextXAlignment.Left Label.Parent = Frame
        
        local Btn = Instance.new("TextButton") Btn.Size = UDim2.new(0, 40, 0, 20) Btn.Position = UDim2.new(1, -55, 0.5, -10) Btn.BackgroundColor3 = Settings[stateKey] and Theme.Yellow or Theme.Black Btn.Text = "" Btn.Parent = Frame
        local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(1, 0) BtnCorner.Parent = Btn
        local Circle = Instance.new("Frame") Circle.Size = UDim2.new(0, 16, 0, 16) Circle.Position = UDim2.new(Settings[stateKey] and 1 or 0, Settings[stateKey] and -18 or 2, 0.5, -8) Circle.BackgroundColor3 = Theme.Text Circle.Parent = Btn
        local CircleCorner = Instance.new("UICorner") CircleCorner.CornerRadius = UDim.new(1, 0) CircleCorner.Parent = Circle

        local function UpdateVisuals(state)
            Settings[stateKey] = state
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Yellow or Theme.Black}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(state and 1 or 0, state and -18 or 2, 0.5, -8)}):Play()
            if callback then callback(state) end
        end

        Btn.MouseButton1Click:Connect(function()
            UpdateVisuals(not Settings[stateKey])
        end)

        return UpdateVisuals
    end

    local function CreateSlider(page, text, min, max, stateKey, isFloat, callback)
        local Frame = Instance.new("Frame") Frame.Size = UDim2.new(1, 0, 0, 55) Frame.BackgroundColor3 = Theme.DarkBlack Frame.Parent = page
        local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = Frame
        local Label = Instance.new("TextLabel") Label.Size = UDim2.new(1, -30, 0, 25) Label.Position = UDim2.new(0, 15, 0, 5) Label.BackgroundTransparency = 1 Label.Text = text .. ": " .. Settings[stateKey] Label.TextColor3 = Theme.Text Label.Font = Enum.Font.GothamSemibold Label.TextSize = 13 Label.TextXAlignment = Enum.TextXAlignment.Left Label.Parent = Frame
        local SliderBg = Instance.new("Frame") SliderBg.Size = UDim2.new(1, -30, 0, 6) SliderBg.Position = UDim2.new(0, 15, 0, 35) SliderBg.BackgroundColor3 = Theme.Black SliderBg.Parent = Frame
        local BgCorner = Instance.new("UICorner") BgCorner.CornerRadius = UDim.new(1, 0) BgCorner.Parent = SliderBg
        local Fill = Instance.new("Frame") Fill.Size = UDim2.new((Settings[stateKey] - min) / (max - min), 0, 1, 0) Fill.BackgroundColor3 = Theme.Yellow Fill.Parent = SliderBg
        local FillCorner = Instance.new("UICorner") FillCorner.CornerRadius = UDim.new(1, 0) FillCorner.Parent = Fill
        
        local Btn = Instance.new("TextButton") Btn.Size = UDim2.new(1, 0, 1, 20) Btn.Position = UDim2.new(0, 0, 0.5, -10) Btn.BackgroundTransparency = 1 Btn.Text = "" Btn.Parent = SliderBg

        local dragging = false
        local function Update(inputX)
            local relX = math.clamp(inputX - SliderBg.AbsolutePosition.X, 0, SliderBg.AbsoluteSize.X)
            local percent = relX / SliderBg.AbsoluteSize.X
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = min + percent * (max - min)
            val = isFloat and (math.floor(val * 10) / 10) or math.floor(val)
            Settings[stateKey] = val
            Label.Text = text .. ": " .. val
            if callback then callback(val) end
        end

        Btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; Update(input.Position.X) end end)
        UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input.Position.X) end end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    end

    local function CreateKeybind(page, text, defaultKey, callback)
        local Frame = Instance.new("Frame") Frame.Size = UDim2.new(1, 0, 0, 40) Frame.BackgroundColor3 = Theme.DarkBlack Frame.Parent = page
        local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = Frame
        local Label = Instance.new("TextLabel") Label.Size = UDim2.new(1, -100, 1, 0) Label.Position = UDim2.new(0, 15, 0, 0) Label.BackgroundTransparency = 1 Label.Text = text Label.TextColor3 = Theme.Text Label.Font = Enum.Font.GothamSemibold Label.TextSize = 13 Label.TextXAlignment = Enum.TextXAlignment.Left Label.Parent = Frame
        
        local Btn = Instance.new("TextButton") Btn.Size = UDim2.new(0, 80, 0, 26) Btn.Position = UDim2.new(1, -90, 0.5, -13) Btn.BackgroundColor3 = Theme.Black Btn.Text = defaultKey.Name Btn.TextColor3 = Theme.Yellow Btn.Font = Enum.Font.GothamBold Btn.TextSize = 12 Btn.Parent = Frame
        local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(0, 4) BtnCorner.Parent = Btn
        
        Btn.MouseButton1Click:Connect(function()
            Btn.Text = "..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                    local key = input.KeyCode == Enum.KeyCode.Unknown and input.UserInputType or input.KeyCode
                    callback(key)
                    Btn.Text = key.Name:gsub("MouseButton", "MB")
                    conn:Disconnect()
                end
            end)
        end)
    end

    local AimToggleFunc = CreateToggle(AimbotPage, T.AimToggle, "Aimbot", function(state)
        if isMobile and AimBtn then
            AimBtn.Visible = state
            if not state then
                MobileAiming = false
                AimBtn.BackgroundColor3 = Theme.DarkBlack
                AimBtn.TextColor3 = Theme.TextMuted
                AimStroke.Color = Theme.Yellow
            end
        end
    end)
    CreateToggle(AimbotPage, T.TeamCheck, "TeamCheck")
    CreateSlider(AimbotPage, T.Smoothness, 0, 20, "Smoothness", false)
    CreateToggle(AimbotPage, T.ShowFOV, "ShowFOV")
    CreateSlider(AimbotPage, T.FOVSize, 10, 500, "FOVSize", false)

    CreateToggle(ESPPage, T.ESPBox, "ESPBox")
    CreateToggle(ESPPage, T.ESPNames, "ESPNames")
    CreateToggle(ESPPage, T.ESPDist, "ESPDist")
    CreateToggle(ESPPage, T.ESPHp, "ESPHp")
    CreateToggle(ESPPage, T.ESPTracer, "ESPTracer")

    if not isMobile then
        CreateKeybind(BindsPage, T.MenuKey, Settings.MenuKeybind, function(key) Settings.MenuKeybind = key end)
        CreateKeybind(BindsPage, T.AimKey, Settings.AimKey, function(key) Settings.AimKey = key end)
        CreateKeybind(BindsPage, T.AimToggleKey, Settings.AimbotToggleKey, function(key) Settings.AimbotToggleKey = key end)
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp then
            if input.KeyCode == Settings.MenuKeybind then
                ToggleMenu()
            elseif input.KeyCode == Settings.AimbotToggleKey then
                if AimToggleFunc then AimToggleFunc(not Settings.Aimbot) end
            end
        end
    end)

    local Info1 = Instance.new("TextLabel") Info1.Size = UDim2.new(1, 0, 0, 30) Info1.BackgroundTransparency = 1 Info1.Text = T.Dev Info1.TextColor3 = Theme.Yellow Info1.Font = Enum.Font.GothamBlack Info1.TextSize = 16 Info1.TextXAlignment = Enum.TextXAlignment.Left Info1.Parent = AboutPage
    local Info2 = Instance.new("TextLabel") Info2.Size = UDim2.new(1, 0, 0, 30) Info2.BackgroundTransparency = 1 Info2.Text = T.Desc Info2.TextColor3 = Theme.TextMuted Info2.Font = Enum.Font.GothamMedium Info2.TextSize = 13 Info2.TextXAlignment = Enum.TextXAlignment.Left Info2.Parent = AboutPage

    local dcBtn = Instance.new("TextButton")
    dcBtn.Size = UDim2.new(0, 200, 0, 35)
    dcBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    dcBtn.Text = T.Discord
    dcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dcBtn.Font = Enum.Font.GothamBold
    dcBtn.TextSize = 13
    dcBtn.BorderSizePixel = 0
    dcBtn.Parent = AboutPage
    Instance.new("UICorner", dcBtn).CornerRadius = UDim.new(0, 6)

    dcBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/Web3BU7K7m")
            dcBtn.Text = "Kopyalandı! / Copied!"
            task.wait(2)
            dcBtn.Text = T.Discord
        else
            dcBtn.Text = "Desteklenmiyor / Not Supported"
            task.wait(2)
            dcBtn.Text = T.Discord
        end
    end)
end

local LangGui = Instance.new("ScreenGui")
LangGui.Name = "KraytexLang"
LangGui.IgnoreGuiInset = true
LangGui.Parent = SafeParent
LangGui.ResetOnSpawn = false

local LangFrame = Instance.new("Frame")
LangFrame.Size = UDim2.new(0, 0, 0, 0)
LangFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LangFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LangFrame.BackgroundColor3 = Theme.Black
LangFrame.ClipsDescendants = true
LangFrame.Parent = LangGui

local LangCorner = Instance.new("UICorner") LangCorner.CornerRadius = UDim.new(0, 10) LangCorner.Parent = LangFrame
local LangStroke = Instance.new("UIStroke") LangStroke.Color = Theme.Yellow LangStroke.Thickness = 2 LangStroke.Parent = LangFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "Dil // Language"
Title.TextColor3 = Theme.Yellow
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = LangFrame

local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(1, -40, 0, 40)
BtnContainer.Position = UDim2.new(0, 20, 1, -60)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = LangFrame

local function CreateLangBtn(text, xPos, langCode)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.45, 0, 1, 0)
    Btn.Position = UDim2.new(xPos, 0, 0, 0)
    Btn.BackgroundColor3 = Theme.DarkBlack
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.Parent = BtnContainer
    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = Btn
    local Stroke = Instance.new("UIStroke") Stroke.Color = Theme.Yellow Stroke.Thickness = 1 Stroke.Transparency = 0.5 Stroke.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        _G.KraytexLang = langCode
        local t1 = TweenService:Create(LangFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 150)})
        t1:Play()
        t1.Completed:Wait()
        local t2 = TweenService:Create(LangFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        t2:Play()
        t2.Completed:Wait()
        LangGui:Destroy()
        LoadMainMenu()
    end)
end

CreateLangBtn("Türkçe", 0, "TR")
CreateLangBtn("English", 0.55, "EN")

local function OpenLangAnim()
    local t1 = TweenService:Create(LangFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 150)})
    t1:Play()
    t1.Completed:Wait()
    local t2 = TweenService:Create(LangFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 150)})
    t2:Play()
end
OpenLangAnim()

