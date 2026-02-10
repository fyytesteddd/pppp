local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/fyywannafly-sudo/FyyCommunity/refs/heads/main/lib.lua"))()
end)

local LocalPlayer = game:GetService("Players").LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "Fyy X Community | FREE",
    Folder = "FyyConfig",
    Size = UDim2.fromOffset(530, 300),
    MinSize = Vector2.new(320, 300),
    MaxSize = Vector2.new(850, 560),
    NewElements = true,
    Transparent = false,
    HideSearchBar = true,
    SideBarWidth = 150,
    Resizable = false,
    HasOutline = true,  
    OpenButton = {
        Title = "Fyy X Abyss IT",
        Icon = "rbxassetid://106899268176689",
        CornerRadius = UDim.new(1,0), 
        StrokeThickness = 2,
        Enabled = false, 
        Draggable = false,
        OnlyMobile = true,
        Color = ColorSequence.new(Color3.fromHex("#00c3ff"), Color3.fromHex("#ffffff"))
    },

        Topbar = {
        Height = 44,
        ButtonsType = "Mac", 
        TitleAlignment = "Right",
        AuthorAlignment = "Right",
    },
})
WindUI:AddTheme({
    Name = "amoled",
    
    Background = Color3.fromHex("#000000"),
    WindowBackground = Color3.fromHex("#000000"),
    DialogBackground = Color3.fromHex("#000000"),
    PopupBackground = Color3.fromHex("#000000"),
    
    BackgroundTransparency = 0,
    WindowBackgroundTransparency = 0,
    DialogBackgroundTransparency = 0,
    PopupBackgroundTransparency = 0,

})
WindUI:SetTheme("amoled")
Window:SetToggleKey(Enum.KeyCode.G)

local ConfigFolder = "FyyCommunityConfig"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local ConfigObjects = {}

local function SaveConfig(name)
    local data = {}
    for key, obj in pairs(ConfigObjects) do
        local val = obj.Value
        if type(val) == "table" and val.Default and val.Min then
            data[key] = val.Default 
        elseif type(val) == "table" and #val > 0 then
            data[key] = val
        else
            data[key] = val
        end
    end
    writefile(ConfigFolder .. "/" .. name .. ".json", game:GetService("HttpService"):JSONEncode(data))
end

local function LoadConfig(name)
    if not isfile(ConfigFolder .. "/" .. name .. ".json") then return end
    local content = readfile(ConfigFolder .. "/" .. name .. ".json")
    local data = game:GetService("HttpService"):JSONDecode(content)
    
    local loadedCount = 0
    local failedCount = 0
    
    for key, val in pairs(data) do
        if ConfigObjects[key] then
            local success = pcall(function()
                local obj = ConfigObjects[key]
                if obj.Select then 
                    obj:Select(val)
                elseif obj.Set then
                    obj:Set(val)
                elseif obj.SetValue then 
                    obj:SetValue(val)
                else 
                    obj.Value = val 
                end
            end)
            if success then
                loadedCount = loadedCount + 1
            else
                failedCount = failedCount + 1
            end
        end
    end
    
    -- Debug notification
    WindUI:Notify({
        Title = "Config Loaded",
        Content = string.format("%d/%d items loaded (%d failed)", loadedCount, loadedCount + failedCount, failedCount),
        Duration = 3
    })
end

local function SetAutoLoad(name)
    writefile(ConfigFolder .. "/autoload.txt", name)
end

local function GetAutoLoad()
    if isfile(ConfigFolder .. "/autoload.txt") then
        return readfile(ConfigFolder .. "/autoload.txt")
    end
    return nil
end

local function LoadAutoConfig()
    local name = GetAutoLoad()
    WindUI:Notify({Title = "Auto-Load Check", Content = name or "No auto-load set", Duration = 2})
    if name and isfile(ConfigFolder .. "/" .. name .. ".json") then
        WindUI:Notify({Title = "Auto-Loading", Content = "Loading: " .. name, Duration = 2})
        LoadConfig(name)
        return name
    else
        if name then
            WindUI:Notify({Title = "Auto-Load Error", Content = "File not found: " .. name, Duration = 3})
        end
    end
    return nil
end

local function DeleteConfig(name)
    if isfile(ConfigFolder .. "/" .. name .. ".json") then
        delfile(ConfigFolder .. "/" .. name .. ".json")
    end
end

local function GetConfigs()
    local files = listfiles(ConfigFolder)
    local names = {}
    for _, file in ipairs(files) do
        table.insert(names, file:match("([^/\\]+)%.json$") or file)
    end
    return names
end

local function AddConfig(key, object)
    ConfigObjects[key] = object
end

WindUI:Notify({
    Title = "FyyLoader",
    Content = "Press G To Open/Close Menu!",
    Duration = 4, 
    Icon = "slack",
})


local UIS=game:GetService("UserInputService")
local CAS=game:GetService("ContextActionService")
local PG=game.Players.LocalPlayer:WaitForChild("PlayerGui")
local uisConn=nil 
local dragging=false 
local dragInput,dragStart,startPos

local function C()
    local o=PG:FindFirstChild("CustomFloatingIcon_FyyHub")
    if o then o:Destroy()end 
    local g=Instance.new("ScreenGui")
    g.Name="CustomFloatingIcon_FyyHub"
    g.DisplayOrder=999 
    g.ResetOnSpawn=false 
    local f=Instance.new("Frame")
    f.Size=UDim2.fromOffset(45,45)
    f.Position=UDim2.new(0,50,0.4,0)
    f.AnchorPoint=Vector2.new(.5,.5)
    f.BackgroundColor3=Color3.fromRGB(20,20,20)
    f.BorderSizePixel=0 
    f.Parent=g 
    local s=Instance.new("UIStroke")
    s.Color=Color3.fromRGB(138,43,226)
    s.Thickness=2 
    s.Parent=f 
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
    local i=Instance.new("ImageLabel")
    i.Image="rbxassetid://106899268176689"
    i.BackgroundTransparency=1 
    i.Size=UDim2.new(1,-4,1,-4)
    i.Position=UDim2.fromScale(.5,.5)
    i.AnchorPoint=Vector2.new(.5,.5)
    i.Parent=f 
    Instance.new("UICorner",i).CornerRadius=UDim.new(0,10)
    g.Parent=PG 
    return g,f 
end

local function S(g,f)
    if uisConn then 
        uisConn:Disconnect()
        uisConn=nil 
    end 
    local function u(i)
        local d=i.Position-dragStart 
        f.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
    
    f.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then 
            dragging=true 
            dragStart=i.Position 
            startPos=f.Position 
            
            -- Block camera movement on mobile
            CAS:BindActionAtPriority("BlockCameraDrag", function()
                return Enum.ContextActionResult.Sink
            end, false, Enum.ContextActionPriority.High.Value + 100, 
                Enum.UserInputType.Touch, 
                Enum.UserInputType.MouseButton1, 
                Enum.UserInputType.MouseMovement)
            
            local m=false 
            local c1,c2 
            c1=i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then 
                    dragging=false 
                    c1:Disconnect()
                    -- Unblock camera movement
                    CAS:UnbindAction("BlockCameraDrag")
                    if not m and Window and Window.Toggle then 
                        Window:Toggle()
                    end 
                end 
            end)
            c2=i.Changed:Connect(function()
                if dragging and(i.Position-dragStart).Magnitude>5 then 
                    m=true 
                    c2:Disconnect()
                end 
            end)
        end 
    end)
    
    f.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then 
            dragInput=i 
        end 
    end)
    
    uisConn=UIS.InputChanged:Connect(function(i)
        if i==dragInput and dragging then 
            u(i)
        end 
    end)
    
    if Window then 
        Window:OnOpen(function()
            g.Enabled=false 
        end)
        Window:OnClose(function()
            g.Enabled=true 
        end)
    end 
end

local function I()
    if not game.Players.LocalPlayer.Character then 
        game.Players.LocalPlayer.CharacterAdded:Wait()
    end 
    local g,f=C()
    if g and f then 
        S(g,f)
    end 
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    I()
end)
I()

-- Function to get fish names from ReplicatedStorage
local function GetFishNames()
    local fishFolder = game:GetService("ReplicatedStorage"):FindFirstChild("common")
    if not fishFolder then return {} end
    
    local assetsFolder = fishFolder:FindFirstChild("assets")
    if not assetsFolder then return {} end
    
    local fishFolder2 = assetsFolder:FindFirstChild("fish")
    if not fishFolder2 then return {} end
    
    local fishNames = {}
    for _, fish in pairs(fishFolder2:GetChildren()) do
        table.insert(fishNames, fish.Name)
    end
    table.sort(fishNames)
    return fishNames
end

local Main = Window:Tab({Title = "Main", Icon = "play"})

local fishNames = GetFishNames()
if #fishNames == 0 then
    table.insert(fishNames, "No fish found")
end

local selectedFishList = {fishNames[1] or "No fish found"}
local mappedFishUUIDs = {}
local autoFishEnabled = false
local tweenSpeed = 1
local catchCount = 3

local autoOxygenEnabled = false
local savedOxygenPosition = nil

-- Oxygen settings
local minOxygenLevel = 10
local safeZonePosition = Vector3.new(1, 4883, 73)

local fishDropdown = Main:Dropdown({
    Title = "Select Fish",
    Description = "Choose fish to auto fish",
    Options = fishNames,
    CurrentOption = selectedFishList,
    Multi = true,
    Callback = function(options)
        selectedFishList = options
        WindUI:Notify({
            Title = "Fish Selected",
            Content = "Selected: " .. #options .. " fish",
            Duration = 2
        })
    end
})

local function GetOxygenLevel()
    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return 100 end
    
    local mainGui = playerGui:FindFirstChild("Main")
    if not mainGui then return 100 end
    
    local oxygenGui = mainGui:FindFirstChild("Oxygen")
    if not oxygenGui then return 100 end
    
    local canvasGroup = oxygenGui:FindFirstChild("CanvasGroup")
    if not canvasGroup then return 100 end
    
    local oxygenText = canvasGroup:FindFirstChild("Oxygen")
    if not oxygenText then return 100 end
    
    if oxygenText:IsA("TextLabel") or oxygenText:IsA("TextBox") then
        local text = oxygenText.Text
        -- Extract number from text (e.g., "Oxygen: 50%" -> 50)
        local number = string.match(text, "(%d+)")
        if number then
            return tonumber(number) or 100
        end
    end
    
    return 100
end

local function GoToSafeZone()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(2) -- 2 detik ke safe zone
    
    local tween = TweenService:Create(
        humanoidRootPart, 
        tweenInfo, 
        {CFrame = CFrame.new(safeZonePosition)}
    )
    tween:Play()
    tween.Completed:Wait()
    
    WindUI:Notify({
        Title = "Oxygen Low",
        Content = "Going to safe zone to refill oxygen",
        Duration = 2
    })
    
    -- Tunggu sampai oxygen penuh
    while autoFishEnabled do
        local oxygenLevel = GetOxygenLevel()
        if oxygenLevel >= 95 then
            WindUI:Notify({
                Title = "Oxygen Refilled",
                Content = "Oxygen is now full, returning to fishing",
                Duration = 2
            })
            return true
        end
        task.wait(0.5)
    end
    return false
end

local function FindFishUUID(fishName)
    if not fishName or fishName == "" then
        return nil
    end
    
    local fishClient = workspace:FindFirstChild("Game")
    if not fishClient then return nil end
    
    fishClient = fishClient:FindFirstChild("Fish")
    if not fishClient then return nil end
    
    fishClient = fishClient:FindFirstChild("client")
    if not fishClient then return nil end
    
    local debugLog = "Searching for: '" .. fishName .. "'\n"
    local foundMatches = {}
    
    for _, uuidFolder in pairs(fishClient:GetChildren()) do
        local head = uuidFolder:FindFirstChild("Head")
        if head then
            local stats = head:FindFirstChild("stats")
            if stats then
                local fish = stats:FindFirstChild("Fish")
                if fish then
                    local fishValue = ""
                    
                    if fish:IsA("TextLabel") then
                        fishValue = fish.Text
                    elseif fish:IsA("StringValue") then
                        fishValue = fish.Value
                    elseif fish:IsA("ObjectValue") then
                        local obj = fish.Value
                        if obj then
                            fishValue = obj.Name
                        end
                    end
                    
                    debugLog = debugLog .. "  UUID: " .. uuidFolder.Name .. " = '" .. fishValue .. "' (Type: " .. fish.ClassName .. ")\n"
                    
                    if fishValue == fishName then
                        table.insert(foundMatches, uuidFolder.Name)
                    end
                end
            end
        end
    end
    
    writefile(ConfigFolder .. "/find_uuid_debug.txt", debugLog .. "\nMatches found: " .. #foundMatches)
    
    if #foundMatches > 0 then
        return foundMatches[1]
    end
    return nil
end

local function GetClosestFishPosition(selectedFishArray)
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return nil end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local playerPosition = humanoidRootPart.Position
    local closestFish = nil
    local closestDistance = math.huge
    
    if type(selectedFishArray) == "string" then
        selectedFishArray = {selectedFishArray}
    end
    
    for _, fishName in ipairs(selectedFishArray) do
        local uuid = FindFishUUID(fishName)
        if uuid then
            local fishFolder = workspace:FindFirstChild("Game")
            if fishFolder then
                fishFolder = fishFolder:FindFirstChild("Fish")
                if fishFolder then
                    fishFolder = fishFolder:FindFirstChild("client")
                    if fishFolder then
                        local fishUUIDFolder = fishFolder:FindFirstChild(uuid)
                        if fishUUIDFolder then
                            local fishPosition
                            local head = fishUUIDFolder:FindFirstChild("Head")
                            if head then
                                fishPosition = head.Position
                            else
                                fishPosition = fishUUIDFolder.Position
                            end
                            
                            local distance = (playerPosition - fishPosition).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestFish = {
                                    uuid = uuid,
                                    position = fishPosition
                                }
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestFish
end

local function CatchFish(uuid)
    -- Speed Hack: Find fish instance and set Speed attribute
    local fishFolder = workspace:FindFirstChild("Game"):FindFirstChild("Fish"):FindFirstChild("client")
    if fishFolder then
        local fishInstance = fishFolder:FindFirstChild(uuid)
        if fishInstance then
            fishInstance:SetAttribute("Speed", 99999)
        end
    end

    local HarpoonService = game:GetService("ReplicatedStorage").common.packages.Knit.Services.HarpoonService
    if HarpoonService then
        local RF = HarpoonService:FindFirstChild("RF")
        if RF then
            local StartCatching = RF:FindFirstChild("StartCatching")
            if StartCatching then
                for i = 1, catchCount do
                    pcall(function()
                        StartCatching:InvokeServer(uuid)
                    end)
                    task.wait(0.01)
                end
            end
        end
    end
end

local function CompleteProgress()
    local MinigameService = game:GetService("ReplicatedStorage").common.packages.Knit.Services.MinigameService
    if MinigameService then
        local RF = MinigameService:FindFirstChild("RF")
        if RF then
            local Update = RF:FindFirstChild("Update")
            if Update then
                pcall(function()
                    Update:InvokeServer(
                        "ProgressUpdate",
                        {
                            progress = 1,
                            rewards = {}
                        }
                    )
                )
            end
        end
    end
end

local function AutoFishingLoop()
    while autoFishEnabled do
        -- Check oxygen level before fishing
        local oxygenLevel = GetOxygenLevel()
        if oxygenLevel <= minOxygenLevel then
            WindUI:Notify({
                Title = "Low Oxygen Alert",
                Content = "Oxygen level: " .. oxygenLevel .. "% - Going to safe zone",
                Duration = 2
            })
            
            local success = GoToSafeZone()
            if not success then
                break -- Jika auto fishing dimatikan saat di safe zone
            end
        end
        
        if not fishDropdown or not fishDropdown.Value then
            task.wait(0.1)
        else
            local selectedFishArray = fishDropdown.Value
            
            if type(selectedFishArray) == "string" then
                selectedFishArray = {selectedFishArray}
            end
            
            if selectedFishArray and #selectedFishArray > 0 then
                local closestFish = GetClosestFishPosition(selectedFishArray)
                
                if closestFish then
                    local player = game.Players.LocalPlayer
                    if player and player.Character then
                        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local TweenService = game:GetService("TweenService")
                            local tweenInfo = TweenInfo.new(tweenSpeed)
                            
                            local offsetPosition = closestFish.position + Vector3.new(0, 2, 0)
                            local tween = TweenService:Create(
                                humanoidRootPart, 
                                tweenInfo, 
                                {CFrame = CFrame.new(offsetPosition)}
                            )
                            tween:Play()
                            tween.Completed:Wait()
                            
                            CatchFish(closestFish.uuid)
                            task.wait(0.01)
                            CompleteProgress()
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end
end

Main:Button({
    Title = "Refresh Fish List",
    Description = "Refresh the fish dropdown",
    Callback = function()
        local updatedFishNames = GetFishNames()
        fishDropdown:Refresh(updatedFishNames)
        WindUI:Notify({
            Title = "Fish List Refreshed",
            Content = "Found " .. #updatedFishNames .. " fish",
            Duration = 2
        })
    end
})

Main:Slider({
    Title = "Tween Speed",
    Desc = "Set tween speed in seconds",
    Step = 0.5,
    Value = {
        Min = 0.5,
        Max = 10,
        Default = 2,
    },
    Callback = function(value)
        tweenSpeed = value
        WindUI:Notify({
            Title = "Tween Speed Updated",
            Content = "New speed: " .. value .. "s",
            Duration = 1
        })
    end
})

-- Add input for oxygen threshold
Main:Slider({
    Title = "Min Oxygen Level",
    Desc = "Go to safe zone when oxygen reaches this level (%)",
    Step = 5,
    Value = {
        Min = 5,
        Max = 50,
        Default = 10,
    },
    Callback = function(value)
        minOxygenLevel = value
        WindUI:Notify({
            Title = "Oxygen Threshold Updated",
            Content = "Will go to safe zone at " .. value .. "% oxygen",
            Duration = 2
        })
    end
})

Main:Toggle({
    Title = "Auto Fish",
    Desc = "Enable auto fishing loop",
    Value = false,
    Callback = function(state)
        autoFishEnabled = state
        if state then
            WindUI:Notify({
                Title = "Auto Fish Started",
                Content = "Farming started!",
                Duration = 2
            })
            task.spawn(AutoFishingLoop)
        else
            WindUI:Notify({
                Title = "Auto Fish Stopped",
                Content = "Farming stopped!",
                Duration = 2
            })
        end
    end
})

-- Button to manually go to safe zone
Main:Button({
    Title = "Go to Safe Zone",
    Description = "Manually go to safe zone position",
    Callback = function()
        GoToSafeZone()
    end
})
