--[[

       PEA API
Made by PeaPattern#2703

--]]

---- Setup ----

if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end

---- Main Variables ----

local Services = {
    Workspace = game:GetService("Workspace"),
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    HttpService = game:GetService("HttpService"),
    TweenService = game:GetService("TweenService"),
    CoreGui = game:GetService("CoreGui")
}

local Player = Services.Players.LocalPlayer
whiteListed = {Player.UserId}

local split, sub, len, find, lower, format =
string.split, string.sub, string.len, string.find, string.lower, string.format

---- Main Functions ----

local commandTable = {}
function addCommand(names, description, func)
    local Cmd = {
        Names = names,
        Description = description,
        Function = func,
        Data = {}
    }
    commandTable[names[1]] = Cmd
end

function getCmd(cmd)
	return rawget(commandTable, cmd)
end

function removeCommand(cmd)
    local Command = getCmd(cmd)
    if Command then
        table.remove(commandTable, table.find(commandTable, cmd))
    else
        return false
    end
end

function getData(cmd)
    local Command = getCmd(cmd)
    if Command then
        return Command[4]
    else
        return false
    end
end

function addAlias(cmd, alias)
	local Command = getCmd(cmd)
	if Command then
		table.insert(Command.Names, alias)
		return Command
	else
		return false
	end
end

function removeAlias(cmd, alias)
	local Command = getCmd(cmd)
	if Command then
		if table.find(Command.Names, alias) then
			table.insert(Command.Names, table.find(Command.Names, alias))
		end
		return Command
	else
		return false
	end
end

function getPlayer(Str)
    for _,v in pairs(Services.Players:GetPlayers()) do
        if find(v.Name:lower(), lower(Str)) or find(lower(v.DisplayName), lower(Str)) then
            return v
        end
    end
    return false
end

function getCharacter(Plr)
    return (Plr and Plr.Character) or (Player and Player.Character) or false
end

function getHumanoid(Plr)
    return (Plr and Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")) or (Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")) or false
end

local function newTween(object, info, goal)
    info = info or TweenInfo.new(0.5)
    if not object or not goal then
        return
    end
    return Services.TweenService:Create(object,info,goal)
end

local spoofedProperties = {}
function spoofProperty(Instance, Property)
    for _,v in pairs(spoofedProperties) do
        if not table.find(spoofedProperties, {Instance, Property}) then
            local oldValue = Instance[Property]
            local oldIndex = hookmetamethod(game, "__index", function(Self, Key)
                if Self == Instance and Key == Property then
                    return oldValue
                end
                return oldIndex(Self, Key)
            end)
        end
    end
end

---- UI ----

local Notifications = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Description = Instance.new("TextLabel")
local Amount = Instance.new("IntValue")

Notifications.Name = "Notifications"
Notifications.Parent = Services.CoreGui
Notifications.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Background.Name = "Background"
Background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Background.BorderSizePixel = 0
Background.Position = UDim2.new(0.882324219, 0, 0.859480262, 0)
Background.Size = UDim2.new(0.117578126, 0, 0.121174201, 0)
Background.BackgroundTransparency = 1
Background.Parent = nil

Amount.Name = "NC"
Amount.Parent = Background

Title.Name = "Title"
Title.Parent = Background
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Size = UDim2.new(1.00000191, 0, 0.163542494, 0)
Title.Font = Enum.Font.Ubuntu
Title.Text = "Notification"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextSize = 14.000
Title.TextWrapped = true
Title.TextTransparency = 1
Title.BackgroundTransparency = 1
Title.BorderSizePixel = 0

Description.Name = "Description"
Description.Parent = Background
Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description.BackgroundTransparency = 1.000
Description.Position = UDim2.new(0.0249169432, 0, 0.158856243, 0)
Description.Size = UDim2.new(0.947176695, 0, 0.783080339, 0)
Description.Font = Enum.Font.SourceSans
Description.Text = "Example"
Description.TextColor3 = Color3.fromRGB(255, 255, 255)
Description.TextSize = 20.000
Description.TextWrapped = true
Description.TextTransparency = 1
Description.BackgroundTransparency = 1

local Commands = Instance.new("ScreenGui")
local Background2 = Instance.new("Frame")
local Search = Instance.new("TextBox")
local List = Instance.new("ScrollingFrame")
local EXAMPLE = Instance.new("TextLabel")
local UIGridLayout = Instance.new("UIGridLayout")
local Close = Instance.new("TextButton")

Commands.Name = "Commands"
Commands.Parent = Services.CoreGui
Commands.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Background2.Name = "Background"
Background2.Parent = nil
Background2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Background2.BackgroundTransparency = 0.200
Background2.BorderSizePixel = 0
Background2.Position = UDim2.new(0.446289062, 0, 0.373436004, 0)
Background2.Size = UDim2.new(0.106835939, 0, 0.25303176, 0)
Background2.Active = true
Background2.Draggable = true

Search.Name = "Search"
Search.Parent = Background2
Search.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Search.BackgroundTransparency = 1.000
Search.Size = UDim2.new(1, 0, 0.100000001, 0)
Search.Font = Enum.Font.SourceSans
Search.PlaceholderText = "Search"
Search.Text = ""
Search.TextColor3 = Color3.fromRGB(255, 255, 255)
Search.TextScaled = true
Search.TextSize = 14.000
Search.TextWrapped = true

List.Name = "List"
List.Parent = Background2
List.Active = true
List.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
List.BackgroundTransparency = 0.700
List.BorderSizePixel = 0
List.Position = UDim2.new(0.0274223033, 0, 0.106504492, 0)
List.Size = UDim2.new(0.945155799, 0, 0.87067312, 0)

EXAMPLE.Name = "EXAMPLE"
EXAMPLE.Parent = List
EXAMPLE.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
EXAMPLE.BackgroundTransparency = 1.000
EXAMPLE.Size = UDim2.new(1, 0, 0.0500000007, 0)
EXAMPLE.Font = Enum.Font.SourceSansBold
EXAMPLE.Text = "EXAMPLE"
EXAMPLE.TextColor3 = Color3.fromRGB(255, 255, 255)
EXAMPLE.TextScaled = true
EXAMPLE.TextSize = 14.000
EXAMPLE.TextWrapped = true

UIGridLayout.Parent = List
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellSize = UDim2.new(1, 0, 0.0500000007, 0)

Close.Name = "Close"
Close.Parent = Background2
Close.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Close.BackgroundTransparency = 1.000
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0.857893586, 0, 0, 0)
Close.Size = UDim2.new(0.13834174, 0, 0.106504448, 0)
Close.Font = Enum.Font.SourceSansBold
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 20.000
Close.TextWrapped = true

local function openCmds()
    Background2.Parent = Commands
end

Close.MouseButton1Down:Connect(function()
    Background2.Parent = nil
end)

local notifCount = 0
function Notify(Text)
    spawn(function()
        local newBack = Background:Clone()
        local newTitle = newBack.Title
        local newDesc = newBack.Description
        local NC = newBack.NC
        newBack.Parent = Notifications
        newDesc.Text = Text
        
        NC.Value = notifCount
        newBack.Position = UDim2.new(0.882324219, 0, 0.859480262-(0.14*notifCount), 0)
        notifCount = notifCount + 1
        
        local Tween1 = newTween(newBack, nil, {BackgroundTransparency = 0})
        local Tween2 = newTween(newTitle, nil, {TextTransparency = 0})
        local Tween3 = newTween(newDesc, nil, {TextTransparency = 0})
        Tween1:Play()
        Tween2:Play()
        Tween3:Play()
        wait((Text:len()/10)+4)
        local Tween4 = newTween(newBack, nil, {BackgroundTransparency = 1})
        local Tween5 = newTween(newTitle, nil, {TextTransparency = 1})
        local Tween6 = newTween(newDesc, nil, {TextTransparency = 1})
        Tween4:Play()
        Tween5:Play()
        Tween6:Play()
        Tween6.Completed:Connect(function()
            notifCount = notifCount - 1
            newBack:Destroy()
            if #Notifications:GetChildren() >= 1 then
                for _,v in pairs(Notifications:GetChildren()) do
                    local moveTween = newTween(v, nil, {Position = UDim2.new(0.882324219, 0, 0.859480262-(0.14*(v.NC.Value-1)), 0)})
                    moveTween:Play()
                end
            end
        end)
    end)
end

---- Files/Plugins ----

if not isfolder("PeaAPI") then
    makefolder("PeaAPI")
end
if not isfolder("PeaAPI/plugins") then
    makefolder("PeaAPI/plugins")
end
if not isfile("PeaAPI/config.json") then
    writefile("PeaAPI/config.json", '{\n    "Prefix": ">"\n}')
end
Data = Services.HttpService:JSONDecode(readfile("PeaAPI/config.json"))
Prefix = Data.Prefix

for _,v in next, listfiles('PeaAPI/plugins') do
    loadfile(v)()
end

---- Core ----

Notify(string.format("Welcome to PeaAPI, the Prefix is '%s'!", Prefix))

addCommand({"info", "help"}, "Gives helps on a command.", function(Message, Args)
    if #Args >= 1 then
        local Command = getCmd(Args[1])
        if Command then
            return Command.Description
        else
            return "Invalid argument. (" .. Args[1] .. ")"
        end
    else
        return "Missing arguments."
    end
end)

addCommand({"notify"}, "Notifies with text argument.", function(Message, Args)
    if #Args >= 1 then
        local Text = sub(Message, len(Prefix) + 8)
        return Text
    else
        return "Missing arguments."
    end
end)

addCommand({"whitelist"}, "Allows a user to use PeaAPI.", function(Message, Args)
    if #Args >= 1 then
        local Target = getPlayer(Args[1])
        if Target then
            table.insert(whiteListed, Target.UserId)
            return format("Successfully whitelisted %s!", Target.Name)
        else
            return "Invalid argument."
        end
    else
        return "Missing arguments."
    end
end)

addCommand({"blacklist"}, "Disallows a user to use PeaAPI.", function(Message, Args)
    if #Args >= 1 then
        local Target = getPlayer(Args[1])
        if Target then
            if table.find(whiteListed, Target.UserId) then
                table.remove(whiteListed, table.find(whiteListed, Target.UserId))
                return string.format("Successfully blacklisted %s!", Target.Name)
            else
                return "Target is not whitelisted."
            end
        else
            return "Invalid argument."
        end
    else
        return "Missing arguments."
    end
end)

addCommand({"whitelisted"}, "Lists out the whitelisted users.", function(Message, Args)
    local List = ""
    for _,v in pairs(whiteListed) do
        local Target = Services.Players:GetPlayerByUserId(v)
        if Target then
            if _ ~= #whiteListed then
                List = List .. Target.Name .. ", "
            else
                List = List .. Target.Name
            end
        end
    end
    return List
end)

addCommand({"commands", "cmds"}, "Command meant for testing.", function(Message, Args)
    openCmds()
    return "Successfully opened commands ui."
end)

for _,v in pairs(commandTable) do
    local Name = v.Names[1]
    local commandLabel = EXAMPLE:Clone()
    commandLabel.Text = Name
    commandLabel.Parent = List
    
    local UARC = Instance.new("UIAspectRatioConstraint")
    UARC.Parent = commandLabel
    UARC.AspectRatio = 7
end

EXAMPLE:Destroy()
List.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 1)
List.CanvasPosition = Vector2.new(0, UIGridLayout.AbsoluteContentSize.Y)

---- Post-Core ----

for _,v in pairs(game:GetService("Players"):GetPlayers()) do
    v.Chatted:Connect(function(Message)
        local Passed = false
        for i,x in pairs(whiteListed) do
            if v.UserId == x then
                Passed = true
            end
        end
        if Passed then
            local Split = split(Message, " ")
            local Found = false
            for _,v in pairs(commandTable) do
                local Aliases = v.Names
                local Function = v.Function
                
                for i,x in pairs(Aliases) do
                    local Args = split(Message:sub(x:len()+Prefix:len()+2), " ")
                    if Prefix:lower() .. x:lower() == Split[1]:lower() then
                        local dataReturned = Function(Message, Args)
                        if dataReturned then
                            Notify(dataReturned)
                            Found = true
                        else
                            Notify("No data found!")
                            Found = true
                        end
                    end
                end
            end
            if not Found and sub(Split[1], 1,1) == Prefix then
                Notify("Command not found!")
            end
        end
    end)
end
