--[[
                 . .  .     .          .  .             .
          .       .  .  .     ..   .    .      .        .
                   .   .     .             ...  .        
.                  .       .    ..  .    .=*+-.         .
       . .             .               .-*:..+:  .      .
..      .               .+=:..        :*-.. .-+          
.           ..        . :#-..-#=.   .#-      .*.         
  .          .........:-=#=.  ..=*-==.       .*..   .    
        . .:+#%%%%*#%%#%%=..      -+:.       .*.         
         .-%#%*%%#****%%#=:.       ..     .. .*.      .  
        ..=%%*@*******%%##+.           .    .==        . 
       .  -%%%**********+--.   .  ..:*%=-. .:+:  .. . .  
          .=#****#%@%**++**:.    .+#-.#..  .=-. .   .    
      ..   :****#@@@@%*****-.=..-%@%-.--  :*=:..     .   
     .     :*****#%@%******=-:+#@@@#:..=..:::+=          
. .       .:##************=:. ..*@%=..... .:*-..         
           :##**********+=++::..  ..:==-:.=*.      .     
          .=##********##===+*+++:  ...-... :+:..  .    . 
 ..  .    :+##********##===*-....  ...:++===*=.      .   
    .     .-#%#%*****##@=-*= ....:=#%+.                  
        .     :%%%%#%*%%#*..      .:+.                .  
        . .   -@%#%#******+..   .  .-+.                  
    .        :%%#******+-... .  .  ..+=.   .         .   
            :%*%********+...  .    . .%.            .  . 
       .   .*##%*********....        .:+.  .   .         
          .-#*##*********+:..        ..*.    .           
  .    .  .=#*%#********+::...     .  .=:  . .           
    .     .+#*%#*******=.... ..       .--        .  ..   
          .*#*%%********=.. .     . . .-=.    .    .     
   .   .  .+#*#%*******-:..           .-=.         .   . 
       .  .:--+*********+-...   .  .  ... .  .     .     
        .     .........::::..            .  ..           
                        .. .                     ..      
             .            .           .               .  
This file was generated on https://dsc.gg/decompiler | Pulsar v1.4.3
Resolved: 156 identifiers | 67 functions | 0 Strings | Renamed: 58 functions | Connected: 34 callbacks | Dead Code Removed: 2 blocks | Inlined: 0 wrappers | Detected loop: 18 blocks
[Renamer: ON] [Decompiler: ON]
]]

if game.Players.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == true then
    repeat
        task.wait()
    until game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == false
end

AutoUseCrouch = false
ClutchHeart = false
Screech = false

local OriginalNamecall = nil
OriginalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if tostring(self) == "Screech" and method == "FireServer" and Screech == true then
        args[1] = true
        return OriginalNamecall(self, unpack(args))
    end
    
    if tostring(self) == "ClutchHeartbeat" and method == "FireServer" and ClutchHeart == true then
        args[2] = true
        return OriginalNamecall(self, unpack(args))
    end
    
    if self.Name ~= "Crouch" or method ~= "FireServer" or AutoUseCrouch ~= true then
        return OriginalNamecall(self, ...)
    end
    
    args[1] = true
    return OriginalNamecall(self, unpack(args))
end))

workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and descendant.Name == "Screech" then
        descendant:Destroy()
    end
end)

local EntityModules = game:GetService("ReplicatedStorage").ModulesClient.EntityModules
local FloorValue = game.ReplicatedStorage:WaitForChild("GameData"):WaitForChild("Floor")
local IsMines = FloorValue.Value == "Mines"
local IsHotel = FloorValue.Value == "Hotel"
local IsBackdoor = FloorValue.Value == "Backdoor"
local IsGarden = FloorValue.Value == "Garden"

function Distance(position)
    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - position).Magnitude
    end
end

_G.GetOldBright = {
    Brightness = game.Lighting.Brightness,
    ClockTime = game.Lighting.ClockTime,
    FogEnd = game.Lighting.FogEnd,
    GlobalShadows = game.Lighting.GlobalShadows,
    OutdoorAmbient = game.Lighting.OutdoorAmbient
}

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "VexonHub",
    Icon = "door-open",
    IconThemed = true,
    Author = "Doors",
    Folder = "vexonhub",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    ScrollBarEnabled = true
})

Window:EditOpenButton({
    Title = "Open VexonHub",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true
})

Tabs = {
    Tab = Window:Tab({Title = "Main"}),
    Tab1 = Window:Tab({Title = "Misc"}),
    Tab2 = Window:Tab({Title = "Esp"}),
    Info = Window:Tab({Title = "Information"})
}

local MainTab = Tabs.Tab

MainTab:Toggle({
    Title = "Fullbright",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.FullBright = state
        while _G.FullBright do
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 100000
            game.Lighting.GlobalShadows = false
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            task.wait()
        end
        for property, value in pairs(_G.GetOldBright) do
            game.Lighting[property] = value
        end
    end
})

MainTab:Toggle({
    Title = "No Fog",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.Nofog = state
        while _G.Nofog do
            game:GetService("Lighting").FogStart = 100000
            game:GetService("Lighting").FogEnd = 200000
            for _, child in pairs(game:GetService("Lighting"):GetChildren()) do
                if child.ClassName == "Atmosphere" then
                    child.Density = 0
                    child.Haze = 0
                end
            end
            task.wait()
        end
        game:GetService("Lighting").FogStart = 0
        game:GetService("Lighting").FogEnd = 1000
        for _, child in pairs(game:GetService("Lighting"):GetChildren()) do
            if child.ClassName == "Atmosphere" then
                child.Density = 0.3
                child.Haze = 1
            end
        end
    end
})

MainTab:Toggle({
    Title = "Instant Prompt",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.NoCooldownProximity = state
        if _G.NoCooldownProximity ~= true then
            if CooldownProximity then
                CooldownProximity:Disconnect()
                CooldownProximity = nil
            end
        else
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant.ClassName == "ProximityPrompt" then
                    descendant.HoldDuration = 0
                end
            end
            CooldownProximity = workspace.DescendantAdded:Connect(function(descendant)
                if _G.NoCooldownProximity == true and descendant:IsA("ProximityPrompt") then
                    descendant.HoldDuration = 0
                end
            end)
        end
    end
})

MainTab:Section({
    Title = "Misc Main",
    TextXAlignment = "Left",
    TextSize = 17
})

MainTab:Toggle({
    Title = "Anti Screech",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.AntiScreech = state
        Screech = state
    end
})

MainTab:Toggle({
    Title = "Auto Clutch Heart Win",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        ClutchHeart = state
    end
})

MainTab:Toggle({
    Title = "Anti Halt",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.NoHalt = state
        local shadeModule = EntityModules:FindFirstChild("Shade") or EntityModules:FindFirstChild("_Shade")
        if shadeModule then
            shadeModule.Name = _G.NoHalt and "_Shade" or "Shade"
        end
    end
})

MainTab:Toggle({
    Title = "Anti Eyes / Lookman",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.NoEyes = state
        while _G.NoEyes do
            if (workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("BackdoorLookman")) and game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") then
                game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("MotorReplication"):FireServer(-649)
            end
            task.wait()
        end
    end
})

if IsMines then
    MainTab:Toggle({
        Title = "Anti Egg Gloom",
        Type = "Toggle",
        Default = false,
        Callback = function(state)
            _G.AntiEggGloom = state
            while _G.AntiEggGloom do
                for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                    if room:IsA("Model") then
                        for _, child in pairs(room:GetChildren()) do
                            if child.Name:find("GloomPile") and child:FindFirstChild("GloomEgg") and child.GloomEgg:FindFirstChild("Egg") then
                                child.GloomEgg.Egg.CanTouch = false
                            end
                        end
                    end
                end
                task.wait()
            end
        end
    })
end

MainTab:Toggle({
    Title = "Auto Use Crouch",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        AutoUseCrouch = state
    end
})

MainTab:Toggle({
    Title = "Get Jump Button",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.JumpButton = state
        while _G.JumpButton do
            if game.Players.LocalPlayer.Character:GetAttribute("CanJump") then
                game.Players.LocalPlayer.Character:SetAttribute("CanJump", true)
            end
            task.wait()
        end
        if game.Players.LocalPlayer.Character:GetAttribute("CanJump") then
            game.Players.LocalPlayer.Character:SetAttribute("CanJump", false)
        end
    end
})

MainTab:Toggle({
    Title = "Inf Oxygen",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.ActiveInfOxygen = state
        while _G.ActiveInfOxygen do
            if game.Players.LocalPlayer.Character:GetAttribute("Oxygen") then
                game.Players.LocalPlayer.Character:SetAttribute("Oxygen", 99999)
            end
            task.wait()
        end
        if game.Players.LocalPlayer.Character:GetAttribute("Oxygen") then
            game.Players.LocalPlayer.Character:SetAttribute("Oxygen", 100)
        end
    end
})

local MiscTab = Tabs.Tab1

MiscTab:Dropdown({
    Title = "Choose Entity",
    Values = {"Rush", "Seek", "Eyes", "Window", "LookMan", "Gloombat", "Ambush", "A-60", "A-120"},
    Value = {"Rush"},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        _G.EntityChoose = selected
    end
})

MiscTab:Toggle({
    Title = "Notification Entity",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.NotifyEntity = state
        if _G.NotifyEntity then
            EntityChild = workspace.ChildAdded:Connect(function(child)
                for _, entityName in ipairs(_G.EntityChoose) do
                    if child:IsA("Model") and child.Name:find(entityName) then
                        repeat
                            task.wait()
                        until not child:IsDescendantOf(workspace) or game.Players.LocalPlayer:DistanceFromCharacter(child:GetPivot().Position) < 1000
                        
                        if child:IsDescendantOf(workspace) then
                            WindUI:Notify({
                                Title = entityName .. " Spawn!!",
                                Duration = 5
                            })
                            if _G.NotifyEntityChat then
                                local chatPrefix = _G.ChatNotify or ""
                                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(chatPrefix .. entityName .. " Spawn!!")
                            end
                        end
                    end
                end
            end)
        elseif EntityChild then
            EntityChild:Disconnect()
            EntityChild = nil
        end
    end
})

if IsHotel then
    MiscTab:Toggle({
        Title = "Auto Get Code Library",
        Type = "Toggle",
        Default = false,
        Callback = function(state)
            _G.NotifyEntity = state
            if _G.NotifyEntity then
                local function GetCodeFromPaper(paper)
                    local hintsUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("PermUI"):WaitForChild("Hints")
                    local codeDigits = {"_", "_", "_", "_", "_"}
                    
                    for _, imageLabel in pairs(paper:WaitForChild("UI"):GetChildren()) do
                        if imageLabel:IsA("ImageLabel") and imageLabel.Name ~= "Image" then
                            for _, hintLabel in pairs(hintsUI:GetChildren()) do
                                if hintLabel:IsA("ImageLabel") and hintLabel.Visible and imageLabel.ImageRectOffset == hintLabel.ImageRectOffset then
                                    codeDigits[tonumber(imageLabel.Name)] = hintLabel:FindFirstChild("TextLabel").Text
                                end
                            end
                        end
                    end
                    
                    return codeDigits
                end
                
                local function ProcessPaper(tool)
                    local code = tool:IsA("Tool") and tool.Name == "LibraryHintPaper" and table.concat(GetCodeFromPaper(tool))
                    if code then
                        WindUI:Notify({
                            Title = "Code: " .. code,
                            Duration = 15
                        })
                        if _G.NotifyEntityChat then
                            local TextChat
                            if _G.ChatNotify then
                                TextChat = _G.ChatNotify
                            else
                                TextChat = ""
                            end
                            if TextChat then
                                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(TextChat .. code)
                            end
                        end
                    end
                end
                
                Getpaper = game.Players.LocalPlayer.Character.ChildAdded:Connect(function(child)
                    ProcessPaper(child)
                end)
            elseif Getpaper then
                Getpaper:Disconnect()
                Getpaper = nil
            end
        end
    })
end

MiscTab:Input({
    Title = "Input Chat",
    Value = "",
    InputIcon = "speaker",
    Type = "Input",
    Placeholder = "Your Chat...",
    Callback = function(text)
        _G.ChatNotify = text
    end
})

MiscTab:Toggle({
    Title = "Notification Chat",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.NotifyEntityChat = state
    end
})

MiscTab:Slider({
    Title = "Hiding Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        _G.TransparencyHide = value
    end
})

MiscTab:Toggle({
    Title = "Transparency Hiding",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.HidingTransparency = state
        while true do
            if not _G.HidingTransparency then
                return
            end
            if game.Players.LocalPlayer.Character:GetAttribute("Hiding") then
                for _, descendant in pairs(workspace.CurrentRooms:GetDescendants()) do
                    if descendant:IsA("ObjectValue") and descendant.Name == "HiddenPlayer" and descendant.Value == game.Players.LocalPlayer.Character then
                        local hidingParts = {}
                        for _, part in pairs(descendant.Parent:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Transparency = _G.TransparencyHide or 0.5
                                table.insert(hidingParts, part)
                            end
                        end
                        
                        while true do
                            task.wait()
                            for _, part in pairs(hidingParts) do
                                part.Transparency = _G.TransparencyHide or 0.5
                                task.wait()
                            end
                            if not (game.Players.LocalPlayer.Character:GetAttribute("Hiding") and _G.HidingTransparency) then
                                for _, part in pairs(hidingParts) do
                                    part.Transparency = 0
                                    task.wait()
                                end
                                break
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end
})

_G.Aura = {
    "ActivateEventPrompt",
    "AwesomePrompt",
    "FusesPrompt",
    "HerbPrompt",
    "LeverPrompt",
    "LootPrompt",
    "ModulePrompt",
    "SkullPrompt",
    "UnlockPrompt",
    "ValvePrompt"
}

MiscTab:Toggle({
    Title = "Auto Loot",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.AutoLoot = state
        if _G.AutoLoot then
            lootables = {}
            
            local function AddLootable(descendant)
                if descendant:IsA("ProximityPrompt") and table.find(_G.Aura, descendant.Name) then
                    table.insert(lootables, descendant)
                end
            end
            
            for _, descendant in ipairs(workspace:GetDescendants()) do
                AddLootable(descendant)
            end
            
            ChildAllNext = workspace.DescendantAdded:Connect(function(descendant)
                AddLootable(descendant)
            end)
            
            RemoveChild = workspace.DescendantRemoving:Connect(function(descendant)
                for i = #lootables, 1, -1 do
                    if lootables[i] == descendant then
                        table.remove(lootables, i)
                        break
                    end
                end
            end)
        else
            if ChildAllNext then
                ChildAllNext:Disconnect()
                ChildAllNext = nil
            end
            if RemoveChild then
                RemoveChild:Disconnect()
                RemoveChild = nil
            end
        end
        
        while _G.AutoLoot do
            for _, prompt in pairs(lootables) do
                if prompt:IsA("ProximityPrompt") and table.find(_G.Aura, prompt.Name) and prompt:GetAttribute("Interactions" .. game.Players.LocalPlayer.Name) == nil then
                    if prompt.Parent.Name:find("Mandrake") then
                        return
                    end
                    if Distance(prompt.Parent:GetPivot().Position) <= 12 then
                        fireproximityprompt(prompt)
                    end
                end
            end
            task.wait(0.1)
        end
    end
})

MiscTab:Slider({
    Title = "Walkspeed",
    Step = 1,
    Value = {Min = 16, Max = 21, Default = 16},
    Callback = function(value)
        _G.WalkSpeedTp = value
    end
})

MiscTab:Toggle({
    Title = "WalkSpeed",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.SpeedWalk = state
        while _G.SpeedWalk do
            if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeedTp
            end
            task.wait()
        end
    end
})

local EspTab = Tabs.Tab2

if not IsGarden then
    EspTab:Toggle({
        Title = (IsHotel or IsBackdoor) and "Esp Key / Lever" or (IsMines and "Esp Fuse" or IsMines),
        Type = "Toggle",
        Default = false,
        Callback = function(state)
            _G.EspKey = state
            if _G.EspKey ~= false then
                function Keys(model)
                    if (model.Name:find("Key") or model.Name:find("FuseObtain")) and model:FindFirstChild("Hitbox") or model.Name == "LeverForGate" and model.PrimaryPart then
                        if model:FindFirstChild("Esp_Highlight") then
                            model:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                            model:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        end
                        
                        if _G.EspHighlight ~= true or model:FindFirstChild("Esp_Highlight") ~= nil then
                            if _G.EspHighlight == false and model:FindFirstChild("Esp_Highlight") then
                                model:FindFirstChild("Esp_Highlight"):Destroy()
                            end
                        else
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "Esp_Highlight"
                            highlight.FillColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Adornee = model
                            highlight.Parent = model
                        end
                        
                        if model:FindFirstChild("Esp_Gui") and model.Esp_Gui:FindFirstChild("TextLabel") then
                            local textLabel = model.Esp_Gui:FindFirstChild("TextLabel")
                            local nameText = _G.EspName ~= true or model.Name == "LeverForGate" and "Lever" or (model.Name:find("Key") and "Key" or (model.Name:find("FuseObtain") and ("Fuse" or "") or ""))
                            local distanceText
                            
                            if _G.EspDistance ~= true then
                                distanceText = ""
                            else
                                local prefix = "\nDistance ("
                                local formatStr = "%.0f"
                                local pos = ((model.Name ~= "LeverForGate" or not model.PrimaryPart.Position) and true or false) and (model.Name:find("Key") or model.Name:find("FuseObtain"))
                                if pos then
                                    pos = model.Hitbox.Position
                                end
                                distanceText = prefix .. string.format(formatStr, Distance(pos)) .. "m)" or ""
                            end
                            
                            textLabel.Text = nameText .. distanceText
                            model.Esp_Gui:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                            model.Esp_Gui:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                        end
                        
                        if _G.EspGui ~= true or model:FindFirstChild("Esp_Gui") ~= nil then
                            if _G.EspGui == false and model:FindFirstChild("Esp_Gui") then
                                model:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        else
                            GuiEsp = Instance.new("BillboardGui", model)
                            GuiEsp.Adornee = model
                            GuiEsp.Name = "Esp_Gui"
                            GuiEsp.Size = UDim2.new(0, 100, 0, 150)
                            GuiEsp.AlwaysOnTop = true
                            
                            GuiEspText = Instance.new("TextLabel", GuiEsp)
                            GuiEspText.BackgroundTransparency = 1
                            GuiEspText.Font = Enum.Font.Code
                            GuiEspText.Size = UDim2.new(0, 100, 0, 100)
                            GuiEspText.TextSize = 15
                            GuiEspText.TextColor3 = Color3.new(0, 0, 0)
                            GuiEspText.TextStrokeTransparency = 0.5
                            GuiEspText.Text = ""
                            
                            local stroke = Instance.new("UIStroke")
                            stroke.Color = Color3.new(0, 0, 0)
                            stroke.Thickness = 1.5
                            stroke.Parent = GuiEspText
                        end
                    end
                end
                
                local function AddKey(descendant)
                    if not table.find(_G.KeyAdd, descendant) and (descendant.Name:find("Key") or descendant.Name:find("FuseObtain")) and descendant:FindFirstChild("Hitbox") or descendant.Name == "LeverForGate" and descendant.PrimaryPart then
                        table.insert(_G.KeyAdd, descendant)
                    end
                end
                
                for _, descendant in ipairs(workspace:GetDescendants()) do
                    AddKey(descendant)
                end
                
                KeySpawn = workspace.DescendantAdded:Connect(function(descendant)
                    AddKey(descendant)
                end)
                
                KeyRemove = workspace.DescendantRemoving:Connect(function(descendant)
                    for i = #_G.KeyAdd, 1, -1 do
                        if _G.KeyAdd[i] == descendant then
                            table.remove(_G.KeyAdd, i)
                            break
                        end
                    end
                end)
            else
                _G.KeyAdd = {}
                if KeySpawn then
                    KeySpawn:Disconnect()
                    KeySpawn = nil
                end
                if KeyRemove then
                    KeyRemove:Disconnect()
                    KeyRemove = nil
                end
                
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant.Name:find("Key") or descendant.Name == "LeverForGate" or descendant.Name:find("FuseObtain") then
                        for _, child in pairs(descendant:GetChildren()) do
                            if child.Name:find("Esp_") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end
            
            while _G.EspKey do
                for _, model in pairs(_G.KeyAdd) do
                    if model:IsA("Model") then
                        Keys(model)
                    end
                end
                task.wait()
            end
        end
    })
end

EspTab:Toggle({
    Title = "Esp Door",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspDoor = state
        if _G.EspDoor == false then
            for _, room in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
                if room:isA("Model") then
                    for _, child in pairs(room:GetChildren()) do
                        if child.Name:find("Esp_") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
        
        while _G.EspDoor do
            for _, room in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
                if room:IsA("Model") and room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
                    if room:FindFirstChild("Esp_Highlight") then
                        room:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        room:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                    end
                    
                    if _G.EspHighlight ~= true or room:FindFirstChild("Esp_Highlight") ~= nil then
                        if _G.EspHighlight == false and room:FindFirstChild("Esp_Highlight") then
                            room:FindFirstChild("Esp_Highlight"):Destroy()
                        end
                    else
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "Esp_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 255, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Adornee = room.Door
                        highlight.Parent = room
                    end
                    
                    if room:FindFirstChild("Esp_Gui") and room.Esp_Gui:FindFirstChild("TextLabel") then
                        local textLabel = room.Esp_Gui:FindFirstChild("TextLabel")
                        local nameText
                        
                        if _G.EspName ~= true then
                            nameText = ""
                        else
                            local doorPrefix = "Door "
                            local signText = not (room.Door:FindFirstChild("Sign") and room.Door.Sign:FindFirstChild("Stinker") and room.Door.Sign.Stinker.Text) and room.Door.Sign:FindFirstChild("SignText")
                            if signText then
                                signText = room.Door.Sign.SignText.Text
                            end
                            nameText = doorPrefix .. signText:gsub("^0+", "") .. (room.Door:FindFirstChild("Lock") and " (lock)" or "") or ""
                        end
                        
                        textLabel.Text = nameText .. (_G.EspDistance ~= true and "" or ("\nDistance (" .. string.format("%.0f", Distance(room.Door.Door.Position)) .. "m)" or ""))
                        room.Esp_Gui:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                        room.Esp_Gui:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                    end
                    
                    if _G.EspGui ~= true or room:FindFirstChild("Esp_Gui") ~= nil then
                        if _G.EspGui == false and room:FindFirstChild("Esp_Gui") then
                            room:FindFirstChild("Esp_Gui"):Destroy()
                        end
                    else
                        GuiEsp = Instance.new("BillboardGui", room)
                        GuiEsp.Adornee = room.Door
                        GuiEsp.Name = "Esp_Gui"
                        GuiEsp.Size = UDim2.new(0, 100, 0, 150)
                        GuiEsp.AlwaysOnTop = true
                        
                        GuiEspText = Instance.new("TextLabel", GuiEsp)
                        GuiEspText.BackgroundTransparency = 1
                        GuiEspText.Font = Enum.Font.Code
                        GuiEspText.Size = UDim2.new(0, 100, 0, 100)
                        GuiEspText.TextSize = 15
                        GuiEspText.TextColor3 = Color3.new(0, 0, 0)
                        GuiEspText.TextStrokeTransparency = 0.5
                        GuiEspText.Text = ""
                        
                        local stroke = Instance.new("UIStroke")
                        stroke.Color = Color3.new(0, 0, 0)
                        stroke.Thickness = 1.5
                        stroke.Parent = GuiEspText
                    end
                end
            end
            task.wait()
        end
    end
})

if IsBackdoor then
    EspTab:Toggle({
        Title = "Esp Time Lever",
        Type = "Toggle",
        Default = false,
        Callback = function(state)
            _G.EspLeverTime = state
            if _G.EspLeverTime ~= false then
                function LeverTimes(model)
                    if model.Name:find("TimerLever") and model.PrimaryPart then
                        if model:FindFirstChild("Esp_Highlight") then
                            model:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                            model:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        end
                        
                        if _G.EspHighlight ~= true or model:FindFirstChild("Esp_Highlight") ~= nil then
                            if _G.EspHighlight == false and model:FindFirstChild("Esp_Highlight") then
                                model:FindFirstChild("Esp_Highlight"):Destroy()
                            end
                        else
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "Esp_Highlight"
                            highlight.FillColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Adornee = model
                            highlight.Parent = model
                        end
                        
                        if model:FindFirstChild("Esp_Gui") and model.Esp_Gui:FindFirstChild("TextLabel") then
                            model.Esp_Gui:FindFirstChild("TextLabel").Text = (_G.EspName == true and "Lever Time" or "") .. (_G.EspDistance ~= true and "" or ("\nDistance (" .. string.format("%.0f", Distance(model.PrimaryPart.Position)) .. "m)" or ""))
                            model.Esp_Gui:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                            model.Esp_Gui:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                        end
                        
                        if _G.EspGui ~= true or model:FindFirstChild("Esp_Gui") ~= nil then
                            if _G.EspGui == false and model:FindFirstChild("Esp_Gui") then
                                model:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        else
                            GuiEsp = Instance.new("BillboardGui", model)
                            GuiEsp.Adornee = model
                            GuiEsp.Name = "Esp_Gui"
                            GuiEsp.Size = UDim2.new(0, 100, 0, 150)
                            GuiEsp.AlwaysOnTop = true
                            
                            GuiEspText = Instance.new("TextLabel", GuiEsp)
                            GuiEspText.BackgroundTransparency = 1
                            GuiEspText.Font = Enum.Font.Code
                            GuiEspText.Size = UDim2.new(0, 100, 0, 100)
                            GuiEspText.TextSize = 15
                            GuiEspText.TextColor3 = Color3.new(0, 0, 0)
                            GuiEspText.TextStrokeTransparency = 0.5
                            GuiEspText.Text = ""
                            
                            local stroke = Instance.new("UIStroke")
                            stroke.Color = Color3.new(0, 0, 0)
                            stroke.Thickness = 1.5
                            stroke.Parent = GuiEspText
                        end
                    end
                end
                
                local function AddTimeLever(descendant)
                    if not table.find(_G.TimeLeverAdd, descendant) and descendant.Name == "TimerLever" then
                        table.insert(_G.TimeLeverAdd, descendant)
                    end
                end
                
                for _, descendant in ipairs(workspace:GetDescendants()) do
                    AddTimeLever(descendant)
                end
                
                TimeLeverSpawn = workspace.DescendantAdded:Connect(function(descendant)
                    AddTimeLever(descendant)
                end)
                
                TimeLeverRemove = workspace.DescendantRemoving:Connect(function(descendant)
                    for i = #_G.TimeLeverAdd, 1, -1 do
                        if _G.TimeLeverAdd[i] == descendant then
                            table.remove(_G.TimeLeverAdd, i)
                            break
                        end
                    end
                end)
            else
                _G.TimeLeverAdd = {}
                if TimeLeverSpawn then
                    TimeLeverSpawn:Disconnect()
                    TimeLeverSpawn = nil
                end
                if TimeLeverRemove then
                    TimeLeverRemove:Disconnect()
                    TimeLeverRemove = nil
                end
                
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant.Name:find("TimerLever") then
                        for _, child in pairs(descendant:GetChildren()) do
                            if child.Name:find("Esp_") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end
            
            while _G.EspLeverTime do
                for _, model in pairs(_G.TimeLeverAdd) do
                    if model:IsA("Model") then
                        LeverTimes(model)
                    end
                end
                task.wait()
            end
        end
    })
end

if IsHotel then
    EspTab:Toggle({
        Title = "Esp Book",
        Type = "Toggle",
        Default = false,
        Callback = function(state)
            _G.EspBook = state
            if _G.EspBook ~= false then
                function Books(model)
                    if model.Name:find("LiveHintBook") and model.PrimaryPart then
                        if model:FindFirstChild("Esp_Highlight") then
                            model:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                            model:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        end
                        
                        if _G.EspHighlight ~= true or model:FindFirstChild("Esp_Highlight") ~= nil then
                            if _G.EspHighlight == false and model:FindFirstChild("Esp_Highlight") then
                                model:FindFirstChild("Esp_Highlight"):Destroy()
                            end
                        else
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "Esp_Highlight"
                            highlight.FillColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Adornee = model
                            highlight.Parent = model
                        end
                        
                        if model:FindFirstChild("Esp_Gui") and model.Esp_Gui:FindFirstChild("TextLabel") then
                            model.Esp_Gui:FindFirstChild("TextLabel").Text = (_G.EspName == true and "Book" or "") .. (_G.EspDistance ~= true and "" or ("\nDistance (" .. string.format("%.0f", Distance(model.PrimaryPart.Position)) .. "m)" or ""))
                            model.Esp_Gui:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                            model.Esp_Gui:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                        end
                        
                        if _G.EspGui ~= true or model:FindFirstChild("Esp_Gui") ~= nil then
                            if _G.EspGui == false and model:FindFirstChild("Esp_Gui") then
                                model:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        else
                            GuiEsp = Instance.new("BillboardGui", model)
                            GuiEsp.Adornee = model
                            GuiEsp.Name = "Esp_Gui"
                            GuiEsp.Size = UDim2.new(0, 100, 0, 150)
                            GuiEsp.AlwaysOnTop = true
                            
                            GuiEspText = Instance.new("TextLabel", GuiEsp)
                            GuiEspText.BackgroundTransparency = 1
                            GuiEspText.Font = Enum.Font.Code
                            GuiEspText.Size = UDim2.new(0, 100, 0, 100)
                            GuiEspText.TextSize = 15
                            GuiEspText.TextColor3 = Color3.new(0, 0, 0)
                            GuiEspText.TextStrokeTransparency = 0.5
                            GuiEspText.Text = ""
                            
                            local stroke = Instance.new("UIStroke")
                            stroke.Color = Color3.new(0, 0, 0)
                            stroke.Thickness = 1.5
                            stroke.Parent = GuiEspText
                        end
                    end
                end
                
                local function AddBook(descendant)
                    if not table.find(_G.BookAdd, descendant) and descendant.Name == "LiveHintBook" then
                        table.insert(_G.BookAdd, descendant)
                    end
                end
                
                for _, descendant in ipairs(workspace:GetDescendants()) do
                    AddBook(descendant)
                end
                
                BookSpawn = workspace.DescendantAdded:Connect(function(descendant)
                    AddBook(descendant)
                end)
                
                BookRemove = workspace.DescendantRemoving:Connect(function(descendant)
                    for i = #_G.BookAdd, 1, -1 do
                        if _G.BookAdd[i] == descendant then
                            table.remove(_G.BookAdd, i)
                            break
                        end
                    end
                end)
            else
                _G.BookAdd = {}
                if BookSpawn then
                    BookSpawn:Disconnect()
                    BookSpawn = nil
                end
                if BookRemove then
                    BookRemove:Disconnect()
                    BookRemove = nil
                end
                
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant.Name:find("LiveHintBook") then
                        for _, child in pairs(descendant:GetChildren()) do
                            if child.Name:find("Esp_") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end
            
            while _G.EspBook do
                for _, model in pairs(_G.BookAdd) do
                    if model:IsA("Model") then
                        Books(model)
                    end
                end
                task.wait()
            end
        end
    })
    
    EspTab:Toggle({
        Title = "Esp Breaker",
        Type = "Toggle",
        Default = false,
        Callback = function(state)
            _G.EspBreaker = state
            if _G.EspBreaker ~= false then
                function Breakers(model)
                    if model.Name == "LiveBreakerPolePickup" and model:FindFirstChildOfClass("ProximityPrompt") then
                        if model:FindFirstChild("Esp_Highlight") then
                            model:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                            model:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        end
                        
                        if _G.EspHighlight ~= true or model:FindFirstChild("Esp_Highlight") ~= nil then
                            if _G.EspHighlight == false and model:FindFirstChild("Esp_Highlight") then
                                model:FindFirstChild("Esp_Highlight"):Destroy()
                            end
                        else
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "Esp_Highlight"
                            highlight.FillColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Adornee = model
                            highlight.Parent = model
                        end
                        
                        if model:FindFirstChild("Esp_Gui") and model.Esp_Gui:FindFirstChild("TextLabel") then
                            model.Esp_Gui:FindFirstChild("TextLabel").Text = (_G.EspName == true and "Breaker" or "") .. (_G.EspDistance ~= true and "" or ("\nDistance (" .. string.format("%.0f", Distance(model.PrimaryPart.Position)) .. "m)" or ""))
                            model.Esp_Gui:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                            model.Esp_Gui:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                        end
                        
                        if _G.EspGui ~= true or model:FindFirstChild("Esp_Gui") ~= nil then
                            if _G.EspGui == false and model:FindFirstChild("Esp_Gui") then
                                model:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        else
                            GuiEsp = Instance.new("BillboardGui", model)
                            GuiEsp.Adornee = model
                            GuiEsp.Name = "Esp_Gui"
                            GuiEsp.Size = UDim2.new(0, 100, 0, 150)
                            GuiEsp.AlwaysOnTop = true
                            
                            GuiEspText = Instance.new("TextLabel", GuiEsp)
                            GuiEspText.BackgroundTransparency = 1
                            GuiEspText.Font = Enum.Font.Code
                            GuiEspText.Size = UDim2.new(0, 100, 0, 100)
                            GuiEspText.TextSize = 15
                            GuiEspText.TextColor3 = Color3.new(0, 0, 0)
                            GuiEspText.TextStrokeTransparency = 0.5
                            GuiEspText.Text = ""
                            
                            local stroke = Instance.new("UIStroke")
                            stroke.Color = Color3.new(0, 0, 0)
                            stroke.Thickness = 1.5
                            stroke.Parent = GuiEspText
                        end
                    end
                end
                
                local function AddBreaker(descendant)
                    if not table.find(_G.BreakerAdd, descendant) and descendant.Name == "LiveBreakerPolePickup" then
                        table.insert(_G.BreakerAdd, descendant)
                    end
                end
                
                for _, descendant in ipairs(workspace:GetDescendants()) do
                    AddBreaker(descendant)
                end
                
                BreakerSpawn = workspace.DescendantAdded:Connect(function(descendant)
                    AddBreaker(descendant)
                end)
                
                BreakerRemove = workspace.DescendantRemoving:Connect(function(descendant)
                    for i = #_G.BreakerAdd, 1, -1 do
                        if _G.BreakerAdd[i] == descendant then
                            table.remove(_G.BreakerAdd, i)
                            break
                        end
                    end
                end)
            else
                _G.BreakerAdd = {}
                if BreakerSpawn then
                    BreakerSpawn:Disconnect()
                    BreakerSpawn = nil
                end
                if BreakerRemove then
                    BreakerRemove:Disconnect()
                    BreakerRemove = nil
                end
                
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant.Name:find("LiveBreakerPolePickup") then
                        for _, child in pairs(descendant:GetChildren()) do
                            if child.Name:find("Esp_") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end
            
            while _G.EspBreaker do
                for _, model in pairs(_G.BreakerAdd) do
                    if model.Name == "LiveBreakerPolePickup" then
                        Breakers(model)
                    end
                end
                task.wait()
            end
        end
    })
end

EspTab:Toggle({
    Title = "Esp Item",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspItem = state
        if _G.EspItem ~= false then
            function Items(handle)
                if handle.Name == "Handle" and handle.Parent:FindFirstChildOfClass("ProximityPrompt") then
                    if handle:FindFirstChild("Esp_Highlight") then
                        handle:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        handle:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                    end
                    
                    if _G.EspHighlight ~= true or handle:FindFirstChild("Esp_Highlight") ~= nil then
                        if _G.EspHighlight == false and handle:FindFirstChild("Esp_Highlight") then
                            handle:FindFirstChild("Esp_Highlight"):Destroy()
                        end
                    else
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "Esp_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 255, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Adornee = handle.Parent
                        highlight.Parent = handle
                    end
                    
                    if handle:FindFirstChild("Esp_Gui") and handle.Esp_Gui:FindFirstChild("TextLabel") then
                        handle.Esp_Gui:FindFirstChild("TextLabel").Text = (_G.EspName ~= true and "" or (handle.Parent.Name or "")) .. (_G.EspDistance ~= true and "" or ("\nDistance (" .. string.format("%.0f", Distance(handle.Position)) .. "m)" or ""))
                        handle.Esp_Gui:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                        handle.Esp_Gui:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                    end
                    
                    if _G.EspGui ~= true or handle:FindFirstChild("Esp_Gui") ~= nil then
                        if _G.EspGui == false and handle:FindFirstChild("Esp_Gui") then
                            handle:FindFirstChild("Esp_Gui"):Destroy()
                        end
                    else
                        GuiEsp = Instance.new("BillboardGui", handle)
                        GuiEsp.Adornee = handle.Parent
                        GuiEsp.Name = "Esp_Gui"
                        GuiEsp.Size = UDim2.new(0, 100, 0, 150)
                        GuiEsp.AlwaysOnTop = true
                        
                        GuiEspText = Instance.new("TextLabel", GuiEsp)
                        GuiEspText.BackgroundTransparency = 1
                        GuiEspText.Font = Enum.Font.Code
                        GuiEspText.Size = UDim2.new(0, 100, 0, 100)
                        GuiEspText.TextSize = 15
                        GuiEspText.TextColor3 = Color3.new(0, 0, 0)
                        GuiEspText.TextStrokeTransparency = 0.5
                        GuiEspText.Text = ""
                        
                        local stroke = Instance.new("UIStroke")
                        stroke.Color = Color3.new(0, 0, 0)
                        stroke.Thickness = 1.5
                        stroke.Parent = GuiEspText
                    end
                end
            end
            
            local function AddItem(descendant)
                if not table.find(_G.ItemAdd, descendant) and descendant.Name == "Handle" then
                    table.insert(_G.ItemAdd, descendant)
                end
            end
            
            for _, descendant in ipairs(workspace:GetDescendants()) do
                AddItem(descendant)
            end
            
            ItemSpawn = workspace.DescendantAdded:Connect(function(descendant)
                AddItem(descendant)
            end)
            
            ItemRemove = workspace.DescendantRemoving:Connect(function(descendant)
                for i = #_G.ItemAdd, 1, -1 do
                    if _G.ItemAdd[i] == descendant then
                        table.remove(_G.ItemAdd, i)
                        break
                    end
                end
            end)
        else
            _G.ItemAdd = {}
            if ItemSpawn then
                ItemSpawn:Disconnect()
                ItemSpawn = nil
            end
            if ItemRemove then
                ItemRemove:Disconnect()
                ItemRemove = nil
            end
            
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant.Name:find("Handle") then
                    for _, child in pairs(descendant:GetChildren()) do
                        if child.Name:find("Esp_") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
        
        while _G.EspItem do
            for _, child in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if child:IsA("Tool") then
                    for _, toolChild in pairs(child:GetChildren()) do
                        if toolChild.Name:find("Esp_") then
                            toolChild:Destroy()
                        end
                    end
                end
            end
            
            for _, handle in pairs(_G.ItemAdd) do
                if handle.Name == "Handle" then
                    Items(handle)
                end
            end
            task.wait()
        end
    end
})

_G.EspEntityNameDis = {
    FigureRig = "Figure",
    SallyMoving = "Window",
    RushMoving = "Rush",
    Eyes = "Eyes",
    Groundskeeper = "Skeeper",
    BackdoorLookman = "Lookman",
    BackdoorRush = "Blitz",
    MandrakeLive = "Mandrake",
    GloomPile = "Egg",
    Snare = "Snare",
    GrumbleRig = "Grumble",
    GiggleCeiling = "Giggle",
    AmbushMoving = "Ambush"
}

EspTab:Toggle({
    Title = "Esp Entity",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspEntity = state
        if _G.EspEntity ~= false then
            local function AddEntity(descendant)
                for entityName, displayName in pairs(_G.EspEntityNameDis) do
                    if descendant:IsA("Model") and descendant.Name == entityName then
                        if descendant.Name == "Snare" and descendant.Parent and descendant.Parent:IsA("Model") and descendant.Parent.Name == "Snare" then
                            return
                        end
                        if not table.find(_G.EntityAdd, descendant) then
                            table.insert(_G.EntityAdd, descendant)
                        end
                    end
                end
            end
            
            for _, descendant in ipairs(workspace:GetDescendants()) do
                AddEntity(descendant)
            end
            
            EntitySpawn = workspace.DescendantAdded:Connect(function(descendant)
                AddEntity(descendant)
            end)
            
            EntityRemove = workspace.DescendantRemoving:Connect(function(descendant)
                for i = #_G.EntityAdd, 1, -1 do
                    if _G.EntityAdd[i] == descendant then
                        table.remove(_G.EntityAdd, i)
                        break
                    end
                end
            end)
        else
            _G.EntityAdd = {}
            if EntitySpawn then
                EntitySpawn:Disconnect()
                EntitySpawn = nil
            end
            if EntityRemove then
                EntityRemove:Disconnect()
                EntityRemove = nil
            end
            
            for _, descendant in pairs(workspace:GetDescendants()) do
                for entityName, displayName in pairs(_G.EspEntityNameDis) do
                    if descendant:IsA("Model") and descendant.Name == entityName then
                        if descendant.PrimaryPart then
                            descendant.PrimaryPart.Transparency = 1
                        end
                        for _, child in pairs(descendant:GetChildren()) do
                            if child.Name:find("Esp_") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end
        end
        
        while _G.EspEntity do
            for _, entity in pairs(_G.EntityAdd) do
                for entityName, displayName in pairs(_G.EspEntityNameDis) do
                    if entity:IsA("Model") and entity.Name == entityName then
                        local allTransparent = true
                        for _, child in ipairs(entity:GetChildren()) do
                            if child:IsA("BasePart") and child.Transparency < 1 then
                                allTransparent = false
                                break
                            end
                        end
                        
                        if allTransparent and entity.PrimaryPart then
                            entity.PrimaryPart.Transparency = 1
                        end
                        
                        if entity:FindFirstChild("Esp_Highlight") then
                            entity:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                            entity:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        end
                        
                        if _G.EspHighlight ~= true or entity:FindFirstChild("Esp_Highlight") ~= nil then
                            if _G.EspHighlight == false and entity:FindFirstChild("Esp_Highlight") then
                                entity:FindFirstChild("Esp_Highlight"):Destroy()
                            end
                        else
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "Esp_Highlight"
                            highlight.FillColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Adornee = entity
                            highlight.Parent = entity
                        end
                        
                        if entity:FindFirstChild("Esp_Gui") and entity.Esp_Gui:FindFirstChild("TextLabel") then
                            entity.Esp_Gui:FindFirstChild("TextLabel").Text = (_G.EspName ~= true and "" or (_G.EspEntityNameDis[entity.Name] or "")) .. (_G.EspDistance ~= true and "" or ("\nDistance (" .. string.format("%.0f", Distance(entity.PrimaryPart.Position)) .. "m)" or ""))
                            entity.Esp_Gui:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                            entity.Esp_Gui:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                        end
                        
                        if _G.EspGui ~= true or entity:FindFirstChild("Esp_Gui") ~= nil then
                            if _G.EspGui == false and entity:FindFirstChild("Esp_Gui") then
                                entity:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        else
                            GuiEsp = Instance.new("BillboardGui", entity)
                            GuiEsp.Adornee = entity
                            GuiEsp.Name = "Esp_Gui"
                            GuiEsp.Size = UDim2.new(0, 100, 0, 150)
                            GuiEsp.AlwaysOnTop = true
                            
                            GuiEspText = Instance.new("TextLabel", GuiEsp)
                            GuiEspText.BackgroundTransparency = 1
                            GuiEspText.Font = Enum.Font.Code
                            GuiEspText.Size = UDim2.new(0, 100, 0, 100)
                            GuiEspText.TextSize = 15
                            GuiEspText.TextColor3 = Color3.new(0, 0, 0)
                            GuiEspText.TextStrokeTransparency = 0.5
                            GuiEspText.Text = ""
                            
                            local stroke = Instance.new("UIStroke")
                            stroke.Color = Color3.new(0, 0, 0)
                            stroke.Thickness = 1.5
                            stroke.Parent = GuiEspText
                        end
                    end
                end
            end
            task.wait()
        end
    end
})

EspTab:Toggle({
    Title = "Esp Hiding Spots",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspHiding = state
        if _G.EspHiding ~= false then
            function Hidings(model)
                if (model.Name == "Bed" or model.Name == "Wardrobe" or model.Name == "Backdoor_Wardrobe" or model.Name == "Locker_Large" or model.Name == "Rooms_Locker") and model.PrimaryPart then
                    if model:FindFirstChild("Esp_Highlight") then
                        model:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        model:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                    end
                    
                    if _G.EspHighlight ~= true or model:FindFirstChild("Esp_Highlight") ~= nil then
                        if _G.EspHighlight == false and model:FindFirstChild("Esp_Highlight") then
                            model:FindFirstChild("Esp_Highlight"):Destroy()
                        end
                    else
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "Esp_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 255, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Adornee = model
                        highlight.Parent = model
                    end
                    
                    if model:FindFirstChild("Esp_Gui") and model.Esp_Gui:FindFirstChild("TextLabel") then
                        model.Esp_Gui:FindFirstChild("TextLabel").Text = (_G.EspName ~= true and "" or (model.Name or "")) .. (_G.EspDistance ~= true and "" or ("\nDistance (" .. string.format("%.0f", Distance(model.PrimaryPart.Position)) .. "m)" or ""))
                        model.Esp_Gui:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                        model.Esp_Gui:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                    end
                    
                    if _G.EspGui ~= true or model:FindFirstChild("Esp_Gui") ~= nil then
                        if _G.EspGui == false and model:FindFirstChild("Esp_Gui") then
                            model:FindFirstChild("Esp_Gui"):Destroy()
                        end
                    else
                        GuiEsp = Instance.new("BillboardGui", model)
                        GuiEsp.Adornee = model
                        GuiEsp.Name = "Esp_Gui"
                        GuiEsp.Size = UDim2.new(0, 100, 0, 150)
                        GuiEsp.AlwaysOnTop = true
                        
                        GuiEspText = Instance.new("TextLabel", GuiEsp)
                        GuiEspText.BackgroundTransparency = 1
                        GuiEspText.Font = Enum.Font.Code
                        GuiEspText.Size = UDim2.new(0, 100, 0, 100)
                        GuiEspText.TextSize = 15
                        GuiEspText.TextColor3 = Color3.new(0, 0, 0)
                        GuiEspText.TextStrokeTransparency = 0.5
                        GuiEspText.Text = ""
                        
                        local stroke = Instance.new("UIStroke")
                        stroke.Color = Color3.new(0, 0, 0)
                        stroke.Thickness = 1.5
                        stroke.Parent = GuiEspText
                    end
                end
            end
            
            local function AddHiding(descendant)
                if not table.find(_G.HidingAdd, descendant) and (descendant.Name == "Bed" or descendant.Name == "Wardrobe" or descendant.Name == "Backdoor_Wardrobe" or descendant.Name == "Locker_Large" or descendant.Name == "Rooms_Locker") then
                    table.insert(_G.HidingAdd, descendant)
                end
            end
            
            for _, descendant in ipairs(workspace:GetDescendants()) do
                AddHiding(descendant)
            end
            
            BookSpawn = workspace.DescendantAdded:Connect(function(descendant)
                AddHiding(descendant)
            end)
            
            BookRemove = workspace.DescendantRemoving:Connect(function(descendant)
                for i = #_G.HidingAdd, 1, -1 do
                    if _G.HidingAdd[i] == descendant then
                        table.remove(_G.HidingAdd, i)
                        break
                    end
                end
            end)
        else
            _G.HidingAdd = {}
            if HidingSpawn then
                HidingSpawn:Disconnect()
                HidingSpawn = nil
            end
            if HidingRemove then
                HidingRemove:Disconnect()
                HidingRemove = nil
            end
            
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant.Name == "Bed" or descendant.Name == "Wardrobe" or descendant.Name == "Backdoor_Wardrobe" or descendant.Name == "Locker_Large" or descendant.Name == "Rooms_Locker" then
                    for _, child in pairs(descendant:GetChildren()) do
                        if child.Name:find("Esp_") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
        
        while _G.EspHiding do
            for _, model in pairs(_G.HidingAdd) do
                if model:IsA("Model") then
                    Hidings(model)
                end
            end
            task.wait()
        end
    end
})

EspTab:Toggle({
    Title = "Esp Player",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspPlayer = state
        if _G.EspPlayer == false then
            for _, player in pairs(game.Players:GetChildren()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    for _, child in pairs(player.Character:GetChildren()) do
                        if child.Name:find("Esp_") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
        
        while _G.EspPlayer do
            for _, player in pairs(game.Players:GetChildren()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    if player.Character:FindFirstChild("Esp_Highlight") then
                        player.Character:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.new(255, 255, 255)
                        player.Character:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.new(255, 255, 255)
                    end
                    
                    if _G.EspHighlight ~= true or player.Character:FindFirstChild("Esp_Highlight") ~= nil then
                        if _G.EspHighlight == false and player.Character:FindFirstChild("Esp_Highlight") then
                            player.Character:FindFirstChild("Esp_Highlight"):Destroy()
                        end
                    else
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "Esp_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 255, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Adornee = player.Character
                        highlight.Parent = player.Character
                    end
                    
                    if player.Character:FindFirstChild("Esp_Gui") and player.Character.Esp_Gui:FindFirstChild("TextLabel") then
                        player.Character.Esp_Gui:FindFirstChild("TextLabel").Text = (_G.EspName ~= true and "" or (player.Name or "")) .. (_G.EspDistance ~= true and "" or ("\nDistance (" .. string.format("%.0f", Distance(player.Character.HumanoidRootPart.Position)) .. "m)" or "")) .. (_G.EspHealth ~= true and "" or ("\nHealth [ " .. (player.Character.Humanoid.Health <= 0 and "Dead" or string.format("%.0f", player.Character.Humanoid.Health)) .. " ]" or ""))
                        player.Character.Esp_Gui:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                        player.Character.Esp_Gui:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                    end
                    
                    if _G.EspGui ~= true or player.Character:FindFirstChild("Esp_Gui") ~= nil then
                        if _G.EspGui == false and player.Character:FindFirstChild("Esp_Gui") then
                            player.Character:FindFirstChild("Esp_Gui"):Destroy()
                        end
                    else
                        GuiPlayerEsp = Instance.new("BillboardGui", player.Character)
                        GuiPlayerEsp.Adornee = player.Character.Head
                        GuiPlayerEsp.Name = "Esp_Gui"
                        GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
                        GuiPlayerEsp.AlwaysOnTop = true
                        GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
                        
                        GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
                        GuiPlayerEspText.BackgroundTransparency = 1
                        GuiPlayerEspText.Font = Enum.Font.Code
                        GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
                        GuiPlayerEspText.TextSize = 15
                        GuiPlayerEspText.TextColor3 = Color3.new(0, 0, 0)
                        GuiPlayerEspText.TextStrokeTransparency = 0.5
                        GuiPlayerEspText.Text = ""
                        
                        local stroke = Instance.new("UIStroke")
                        stroke.Color = Color3.new(0, 0, 0)
                        stroke.Thickness = 1.5
                        stroke.Parent = GuiPlayerEspText
                    end
                end
            end
            task.wait()
        end
    end
})

EspTab:Section({
    Title = "Settings Esp",
    TextXAlignment = "Left",
    TextSize = 17
})

EspTab:Toggle({
    Title = "Esp Gui",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspGui = state
    end
})

EspTab:Toggle({
    Title = "Esp HightLight",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspHighlight = state
    end
})

EspTab:Section({
    Title = "Settings Color",
    TextXAlignment = "Left",
    TextSize = 17
})

EspTab:Colorpicker({
    Title = "Color Gui",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        _G.EspGuiTextColor = color
    end
})

EspTab:Colorpicker({
    Title = "Color HightLight",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        _G.ColorLight = color
    end
})

EspTab:Slider({
    Title = "Text Size [ Gui ]",
    Step = 1,
    Value = {Min = 5, Max = 50, Default = 10},
    Callback = function(value)
        _G.EspGuiTextSize = value
    end
})

EspTab:Section({
    Title = "Settings Text",
    TextXAlignment = "Left",
    TextSize = 17
})

EspTab:Toggle({
    Title = "Esp Name",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspName = state
    end
})

EspTab:Toggle({
    Title = "Esp Distance",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspDistance = state
    end
})

EspTab:Toggle({
    Title = "Esp Health",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        _G.EspHealth = state
    end
})

Info = Tabs.Info

local DiscordInviteCode = "Xm5sThnfsP"
local DiscordApiUrl = "https://discord.com/api/v10/invites/" .. DiscordInviteCode .. "?with_counts=true&with_expiration=true"

local function SetupDiscordInfo()
    local success, data = pcall(function()
        local requestData = {
            Url = DiscordApiUrl,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "RobloxBot/1.0",
                ["Accept"] = "application/json"
            }
        }
        return game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request(requestData).Body)
    end)
    
    if success and data and data.guild then
        local DiscordParagraph = Info:Paragraph({
            Title = data.guild.name,
            Desc = " <font color=\"#52525b\">●</font> Member Count : " .. tostring(data.approximate_member_count) .. "\n <font color=\"#16a34a\">●</font> Online Count : " .. tostring(data.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. data.guild.id .. "/" .. data.guild.icon .. ".png?size=1024",
            ImageSize = 42
        })
        
        Info:Button({
            Title = "Update Info",
            Callback = function()
                local refreshSuccess, refreshData = pcall(function()
                    local refreshRequest = {Url = DiscordApiUrl, Method = "GET"}
                    return game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request(refreshRequest).Body)
                end)
                
                if refreshSuccess and refreshData and refreshData.guild then
                    DiscordParagraph:SetDesc(" <font color=\"#52525b\">●</font> Member Count : " .. tostring(refreshData.approximate_member_count) .. "\n <font color=\"#16a34a\">●</font> Online Count : " .. tostring(refreshData.approximate_presence_count))
                end
            end
        })
        
        Info:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/" .. DiscordInviteCode)
            end
        })
    else
        Info:Paragraph({
            Title = "Error fetching Discord Info",
            Desc = game:GetService("HttpService"):JSONEncode(data),
            Image = "triangle-alert",
            ImageSize = 26,
            Color = "Red"
        })
    end
end

SetupDiscordInfo()

Info:Divider()

Info:Section({
    Title = "VexonHub",
    TextXAlignment = "Center",
    TextSize = 17
})

Info:Divider()

Info:Paragraph({
    Title = "TheVex0n/Vexon",
    Desc = "Owner Of VexonHub",
    Image = "rbxassetid://84519376661277",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false
})