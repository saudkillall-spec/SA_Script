--!strict
local Players            = game:GetService("Players")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local RunService         = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Camera      = workspace.CurrentCamera

local Theme = {
    Background     = Color3.fromRGB(16, 16, 20),
    Surface        = Color3.fromRGB(24, 24, 30),
    SurfaceLight   = Color3.fromRGB(32, 32, 40),
    Stroke         = Color3.fromRGB(45, 45, 55),
    Text           = Color3.fromRGB(240, 240, 245),
    SubText        = Color3.fromRGB(150, 150, 165),
    Accent         = Color3.fromRGB(120, 90, 255),
    AccentGlow     = Color3.fromRGB(120, 90, 255),
    Success        = Color3.fromRGB(80, 220, 140),
    Danger         = Color3.fromRGB(255, 90, 100),
}

local TweenInfo_Main  = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TweenInfo_Fast  = TweenInfo.new(0.18, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TweenInfo_Snap  = TweenInfo.new(0.10, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)

local Connections = {}
local Instances   = {}

local function addConn(conn)
    table.insert(Connections, conn)
    return conn
end
local function addInst(inst)
    table.insert(Instances, inst)
    return inst
end
local function cleanupAll()
    for _, c in ipairs(Connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(Connections)
    for _, i in ipairs(Instances) do
        pcall(function() i:Destroy() end)
    end
    table.clear(Instances)
end

local function make(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    addInst(inst)
    return inst
end

local function tween(inst, props, ti)
    local t = TweenService:Create(inst, ti or TweenInfo_Fast, props)
    t:Play()
    return t
end

local function corner(parent, radius)
    return make("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, parent)
end

local function stroke(parent, color, thickness, transparency)
    return make("UIStroke", {
        Color       = color or Theme.Stroke,
        Thickness   = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function padding(parent, all)
    return make("UIPadding", {
        PaddingTop    = UDim.new(0, all),
        PaddingBottom = UDim.new(0, all),
        PaddingLeft   = UDim.new(0, all),
        PaddingRight  = UDim.new(0, all),
    }, parent)
end

local function getGuiParent()
    local ok, sg = pcall(function() return game:GetService("CoreGui") end)
    if ok and sg then
        local test = Instance.new("Folder")
        local success = pcall(function() test.Parent = sg end)
        test:Destroy()
        if success then return sg end
    end
    return PlayerGui
end

local ScreenGui = make("ScreenGui", {
    Name             = "SAScriptHub",
    ResetOnSpawn     = false,
    IgnoreGuiInset   = true,
    ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
    DisplayOrder     = 999,
}, getGuiParent())

local Window = make("Frame", {
    Name             = "Window",
    Size             = UDim2.fromOffset(640, 420),
    Position         = UDim2.new(0.5, -320, 0.5, -210),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 1,
    BorderSizePixel  = 0,
    ClipsDescendants = true,
}, ScreenGui)
corner(Window, 14)
stroke(Window, Theme.Stroke, 1, 0.3)

local Shadow = make("Frame", {
    Name             = "Shadow",
    Size             = UDim2.new(1, 40, 1, 40),
    Position         = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint      = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Accent,
    BackgroundTransparency = 0.85,
    BorderSizePixel  = 0,
    ZIndex           = 0,
}, Window)
corner(Shadow, 20)

local Header = make("Frame", {
    Name             = "Header",
    Size             = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = Theme.Surface,
    BackgroundTransparency = 1,
    BorderSizePixel  = 0,
    ZIndex           = 5,
}, Window)
corner(Header, 14)

local HeaderAccent = make("Frame", {
    Size             = UDim2.new(0, 4, 0, 22),
    Position         = UDim2.new(0, 20, 0.5, -11),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, Header)
corner(HeaderAccent, 2)

make("TextLabel", {
    Size             = UDim2.new(0, 200, 0, 22),
    Position         = UDim2.new(0, 36, 0, 15),
    BackgroundTransparency = 1,
    Font             = Enum.Font.GothamBold,
    Text             = "SA SCRIPT",
    TextColor3       = Theme.Text,
    TextSize         = 15,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 6,
}, Header)

make("TextLabel", {
    Size             = UDim2.new(0, 200, 0, 14),
    Position         = UDim2.new(0, 36, 0, 32),
    BackgroundTransparency = 1,
    Font             = Enum.Font.Gotham,
    Text             = "v2.0 Universal",
    TextColor3       = Theme.SubText,
    TextSize         = 11,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 6,
}, Header)

local StatusDot = make("Frame", {
    Size             = UDim2.new(0, 8, 0, 8),
    Position         = UDim2.new(0, 220, 0, 22),
    BackgroundColor3 = Theme.Success,
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, Header)
corner(StatusDot, 4)

local StatsLabel = make("TextLabel", {
    Size             = UDim2.new(0, 120, 0, 20),
    Position         = UDim2.new(1, -280, 0, 16),
    BackgroundTransparency = 1,
    Font             = Enum.Font.Gotham,
    Text             = "FPS 60 | Ping 0",
    TextColor3       = Theme.SubText,
    TextSize         = 11,
    TextXAlignment   = Enum.TextXAlignment.Right,
    ZIndex           = 6,
}, Header)

local function makeCtrlButton(name, glyph, color, xOffset)
    local btn = make("TextButton", {
        Name             = name,
        Size             = UDim2.new(0, 28, 0, 28),
        Position         = UDim2.new(1, xOffset, 0.5, -14),
        BackgroundColor3 = Theme.SurfaceLight,
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        Text             = glyph,
        Font             = Enum.Font.GothamBold,
        TextColor3       = color,
        TextSize         = 14,
        AutoButtonColor  = false,
        ZIndex           = 7,
    }, Header)
    corner(btn, 6)
    return btn
end

local MinimizeBtn = makeCtrlButton("Minimize", "—", Theme.SubText, -76)
local CloseBtn    = makeCtrlButton("Close",    "X", Theme.Danger, -44)

local function bindCtrlHover(btn, hoverColor, normalColor)
    addConn(btn.MouseEnter:Connect(function()
        tween(btn, { BackgroundTransparency = 0.4, TextColor3 = hoverColor }, TweenInfo_Snap)
        tween(btn, { Size = UDim2.new(0, 30, 0, 30) }, TweenInfo_Snap)
    end))
    addConn(btn.MouseLeave:Connect(function()
        tween(btn, { BackgroundTransparency = 1, TextColor3 = normalColor }, TweenInfo_Snap)
        tween(btn, { Size = UDim2.new(0, 28, 0, 28) }, TweenInfo_Snap)
    end))
end
bindCtrlHover(MinimizeBtn, Theme.Text, Theme.SubText)
bindCtrlHover(CloseBtn, Color3.fromRGB(255, 140, 150), Theme.Danger)

local Sidebar = make("Frame", {
    Name             = "Sidebar",
    Size             = UDim2.new(0, 150, 1, -52),
    Position         = UDim2.new(0, 0, 0, 52),
    BackgroundColor3 = Theme.Surface,
    BackgroundTransparency = 1,
    BorderSizePixel  = 0,
    ZIndex           = 4,
}, Window)
make("UIListLayout", {
    Padding  = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, Sidebar)
make("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, Sidebar)

local Indicator = make("Frame", {
    Name             = "Indicator",
    Size             = UDim2.new(0, 3, 0, 30),
    Position         = UDim2.new(0, 4, 0, 0),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel  = 0,
    ZIndex           = 8,
}, Sidebar)
corner(Indicator, 2)

local ContentHost = make("Frame", {
    Name             = "ContentHost",
    Size             = UDim2.new(1, -150, 1, -52),
    Position         = UDim2.new(0, 150, 0, 52),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 1,
    BorderSizePixel  = 0,
    ClipsDescendants = true,
    ZIndex           = 3,
}, Window)
padding(ContentHost, 8)

local function makeContentPage(name)
    local page = make("ScrollingFrame", {
        Name             = name,
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize       = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible          = false,
        ZIndex           = 3,
    }, ContentHost)
    make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, page)
    make("UIPadding", { PaddingRight = UDim.new(0, 6) }, page)
    return page
end

local function sectionLabel(parent, text)
    return make("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Font             = Enum.Font.GothamBold,
        Text             = string.upper(text),
        TextColor3       = Theme.Accent,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, parent)
end

local function makeSlider(parent, name, default, min, max, callback)
    local holder = make("Frame", {
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel  = 0,
    }, parent)
    corner(holder, 8)
    stroke(holder, Theme.Stroke, 1, 0.4)

    make("TextLabel", {
        Size             = UDim2.new(0, 200, 0, 18),
        Position         = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1,
        Font             = Enum.Font.Gotham,
        Text             = name,
        TextColor3       = Theme.Text,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, holder)

    local valueLbl = make("TextLabel", {
        Size             = UDim2.new(0, 80, 0, 18),
        Position         = UDim2.new(1, -92, 0, 6),
        BackgroundTransparency = 1,
        Font             = Enum.Font.GothamBold,
        Text             = tostring(default),
        TextColor3       = Theme.Accent,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Right,
    }, holder)

    local track = make("Frame", {
        Size             = UDim2.new(1, -24, 0, 4),
        Position         = UDim2.new(0, 12, 0, 32),
        BackgroundColor3 = Theme.SurfaceLight,
        BorderSizePixel  = 0,
    }, holder)
    corner(track, 2)

    local fill = make("Frame", {
        Size             = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel  = 0,
    }, track)
    corner(fill, 2)

    local knob = make("Frame", {
        Size             = UDim2.new(0, 12, 0, 12),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
        BackgroundColor3 = Theme.Text,
        BorderSizePixel  = 0,
        ZIndex           = 2,
    }, track)
    corner(knob, 6)
    stroke(knob, Theme.Accent, 1.5, 0)

    local dragging = false
    local function setValue(v)
        v = math.clamp(v, min, max)
        local alpha = (v - min) / (max - min)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        valueLbl.Text = string.format("%.1f", v)
        if callback then callback(v) end
    end
    setValue(default)

    local function updateFromInput(input)
        local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        setValue(min + rel * (max - min))
    end

    addConn(track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end))
    addConn(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end))
    addConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    return { Set = setValue }
end

local function makeToggle(parent, name, default, callback)
    local holder = make("Frame", {
        Size             = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel  = 0,
    }, parent)
    corner(holder, 8)
    stroke(holder, Theme.Stroke, 1, 0.4)

    make("TextLabel", {
        Size             = UDim2.new(1, -70, 1, 0),
        Position         = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Font             = Enum.Font.Gotham,
        Text             = name,
        TextColor3       = Theme.Text,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, holder)

    local trackBg = make("Frame", {
        Size             = UDim2.new(0, 36, 0, 20),
        Position         = UDim2.new(1, -48, 0.5, -10),
        BackgroundColor3 = Theme.SurfaceLight,
        BorderSizePixel  = 0,
    }, holder)
    corner(trackBg, 10)

    local knob = make("Frame", {
        Size             = UDim2.new(0, 16, 0, 16),
        Position         = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = Theme.Text,
        BorderSizePixel  = 0,
    }, trackBg)
    corner(knob, 8)

    local state = default
    local function setState(v)
        state = v
        if v then
            tween(trackBg, { BackgroundColor3 = Theme.Accent }, TweenInfo_Fast)
            tween(knob, { Position = UDim2.new(1, -18, 0, 2) }, TweenInfo_Fast)
        else
            tween(trackBg, { BackgroundColor3 = Theme.SurfaceLight }, TweenInfo_Fast)
            tween(knob, { Position = UDim2.new(0, 2, 0, 2) }, TweenInfo_Fast)
        end
        if callback then callback(v) end
    end
    if default then setState(true) end

    addConn(holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            setState(not state)
        end
    end))

    return { Set = setState, Get = function() return state end }
end

local function makeButton(parent, name, callback)
    local btn = make("TextButton", {
        Size             = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel  = 0,
        Font             = Enum.Font.GothamBold,
        Text             = name,
        TextColor3       = Theme.Text,
        TextSize         = 12,
        AutoButtonColor  = false,
    }, parent)
    corner(btn, 8)
    stroke(btn, Theme.Stroke, 1, 0.4)
    addConn(btn.MouseEnter:Connect(function()
        tween(btn, { BackgroundColor3 = Theme.SurfaceLight }, TweenInfo_Snap)
    end))
    addConn(btn.MouseLeave:Connect(function()
        tween(btn, { BackgroundColor3 = Theme.Surface }, TweenInfo_Snap)
    end))
    addConn(btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end))
    return btn
end

local PlayerPage = makeContentPage("PlayerPage")
sectionLabel(PlayerPage, "Character")

makeSlider(PlayerPage, "WalkSpeed", 16, 1, 500, function(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end)

makeSlider(PlayerPage, "JumpPower", 50, 1, 500, function(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.UseJumpPower = true; hum.JumpPower = v end
end)

local noclipConn
makeToggle(PlayerPage, "Noclip", false, function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end
        end)
        addConn(noclipConn)
    else
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = nil
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end)

local infJumpConn
makeToggle(PlayerPage, "Infinite Jump", false, function(state)
    if state then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
        addConn(infJumpConn)
    else
        if infJumpConn then infJumpConn:Disconnect() end
        infJumpConn = nil
    end
end)
local ESPPage = makeContentPage("ESPPage")
sectionLabel(ESPPage, "Visuals")

local ESP = { Enabled = false, ShowBox = true, ShowName = true, ShowDistance = true, ShowHealth = true, Objects = {} }
local Draw = Drawing.new

local function createESP(player)
    if player == LocalPlayer or ESP.Objects[player] then return end
    ESP.Objects[player] = { Box = Draw("Square"), Name = Draw("Text"), Distance = Draw("Text"), HealthBg = Draw("Square"), HealthFg = Draw("Square") }
    local t = ESP.Objects[player]
    t.Box.Thickness = 1; t.Box.Filled = false; t.Box.Color = Theme.Accent
    t.Name.Center = true; t.Name.Outline = true; t.Name.Font = 2; t.Name.Size = 14; t.Name.Color = Color3.new(1,1,1)
    t.Distance.Center = true; t.Distance.Outline = true; t.Distance.Font = 2; t.Distance.Size = 12; t.Distance.Color = Color3.fromRGB(200,200,200)
    t.HealthBg.Filled = true; t.HealthBg.Color = Color3.fromRGB(20,20,20)
    t.HealthFg.Filled = true; t.HealthFg.Color = Theme.Success
end

local function removeESP(player)
    local t = ESP.Objects[player]
    if not t then return end
    for _, d in pairs(t) do pcall(function() d:Remove() end) end
    ESP.Objects[player] = nil
end

local function removeAllESP() for p in pairs(ESP.Objects) do removeESP(p) end end

local function updateESP()
    if not ESP.Enabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            if ESP.Objects[player] then removeESP(player) end
            continue
        end
        if not ESP.Objects[player] then createESP(player) end
        local t = ESP.Objects[player]
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")
        if not (hrp and hum and head) or hum.Health <= 0 then
            for _, d in pairs(t) do pcall(function() d.Visible = false end) end
            continue
        end
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
        if not onScreen or not headOnScreen then
            for _, d in pairs(t) do pcall(function() d.Visible = false end) end
            continue
        end
        local height = math.abs(headPos.Y - pos.Y) * 2 + 10
        local width = height * 0.55
        local topX, topY = pos.X - width/2, pos.Y - height/2
        t.Box.Visible = ESP.ShowBox
        t.Box.Size = Vector2.new(width, height)
        t.Box.Position = Vector2.new(topX, topY)
        t.Name.Visible = ESP.ShowName
        t.Name.Text = player.Name
        t.Name.Position = Vector2.new(pos.X, topY - 18)
        local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
        t.Distance.Visible = ESP.ShowDistance
        t.Distance.Text = tostring(dist) .. " studs"
        t.Distance.Position = Vector2.new(pos.X, topY + height + 4)
        t.HealthBg.Visible = ESP.ShowHealth
        t.HealthBg.Size = Vector2.new(3, height)
        t.HealthBg.Position = Vector2.new(topX - 6, topY)
        t.HealthFg.Visible = ESP.ShowHealth
        local hp = math.clamp(hum.Health/hum.MaxHealth, 0, 1)
        t.HealthFg.Size = Vector2.new(3, height*hp)
        t.HealthFg.Position = Vector2.new(topX - 6, topY + (height*(1-hp)))
        t.HealthFg.Color = Color3.fromRGB(255*(1-hp), 255*hp, 80)
    end
end

addConn(RunService.RenderStepped:Connect(function() if ESP.Enabled then pcall(updateESP) end end))

makeToggle(ESPPage, "Enable ESP", false, function(state)
    ESP.Enabled = state
    if not state then removeAllESP() end
end)
makeToggle(ESPPage, "Show Boxes", true, function(v) ESP.ShowBox = v end)
makeToggle(ESPPage, "Show Names", true, function(v) ESP.ShowName = v end)
makeToggle(ESPPage, "Show Distance", true, function(v) ESP.ShowDistance = v end)
makeToggle(ESPPage, "Show Health", true, function(v) ESP.ShowHealth = v end)

local TPPage = makeContentPage("TPPage")
sectionLabel(TPPage, "Waypoints")

local savedWaypoints = {}
local function refreshWaypointList()
    for _, ch in ipairs(TPPage:GetChildren()) do
        if ch:IsA("TextButton") and ch.Name:sub(1,9) == "Waypoint_" then ch:Destroy() end
    end
    for name, pos in pairs(savedWaypoints) do
        local btn = makeButton(TPPage, "TP -> " .. name, function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0)) end
        end)
        btn.Name = "Waypoint_" .. name
    end
end

makeButton(TPPage, "+ Save Current Position", function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local name = "WP_" .. (#savedWaypoints + 1) .. "_" .. math.random(100,999)
    savedWaypoints[name] = hrp.Position
    refreshWaypointList()
end)

makeButton(TPPage, "Clear Waypoints", function()
    table.clear(savedWaypoints)
    refreshWaypointList()
end)

makeButton(TPPage, "Teleport -> Spawn", function()
    local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = spawn.CFrame + Vector3.new(0,3,0) end
    end
end)

local SettingsPage = makeContentPage("SettingsPage")
sectionLabel(SettingsPage, "Appearance")

local ACCENT_PRESETS = {
    {Color = Color3.fromRGB(120,90,255)},
    {Color = Color3.fromRGB(80,200,255)},
    {Color = Color3.fromRGB(255,100,180)},
    {Color = Color3.fromRGB(80,220,140)},
    {Color = Color3.fromRGB(255,180,80)},
    {Color = Color3.fromRGB(255,90,100)}
}

local accentRow = make("Frame", {
    Size             = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel  = 0,
}, SettingsPage)
corner(accentRow, 8)
stroke(accentRow, Theme.Stroke, 1, 0.4)

make("TextLabel", {
    Size             = UDim2.new(0, 120, 1, 0),
    Position         = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1,
    Font             = Enum.Font.Gotham,
    Text             = "Accent Color",
    TextColor3       = Theme.Text,
    TextSize         = 12,
    TextXAlignment   = Enum.TextXAlignment.Left,
}, accentRow)

local function applyAccent(color)
    Theme.Accent = color
    Theme.AccentGlow = color
    tween(HeaderAccent, { BackgroundColor3 = color }, TweenInfo_Fast)
    tween(Indicator, { BackgroundColor3 = color }, TweenInfo_Fast)
    tween(Shadow, { BackgroundColor3 = color }, TweenInfo_Fast)
    for _, d in pairs(ESP.Objects) do
        if d.Box then d.Box.Color = color end
    end
end

for i, preset in ipairs(ACCENT_PRESETS) do
    local swatch = make("TextButton", {
        Size             = UDim2.new(0, 22, 0, 22),
        Position         = UDim2.new(0, 140 + (i - 1) * 30, 0.5, -11),
        BackgroundColor3 = preset.Color,
        BorderSizePixel  = 0,
        Text             = "",
        AutoButtonColor  = false,
    }, accentRow)
    corner(swatch, 11)
    addConn(swatch.MouseButton1Click:Connect(function() applyAccent(preset.Color) end))
end

sectionLabel(SettingsPage, "Controls")
local KeybindLabel = make("TextButton", {
    Size             = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel  = 0,
    Font             = Enum.Font.Gotham,
    Text             = "UI Toggle Keybind:  [ RightShift ]   (click to change)",
    TextColor3       = Theme.Text,
    TextSize         = 12,
    AutoButtonColor  = false,
}, SettingsPage)
corner(KeybindLabel, 8)
stroke(KeybindLabel, Theme.Stroke, 1, 0.4)

local CurrentToggleKey = Enum.KeyCode.RightShift
local awaitingKeybind = false
addConn(KeybindLabel.MouseButton1Click:Connect(function()
    awaitingKeybind = true
    KeybindLabel.Text = "Press any key..."
end))

addConn(UserInputService.InputBegan:Connect(function(input)
    if awaitingKeybind then
        awaitingKeybind = false
        CurrentToggleKey = input.KeyCode
        KeybindLabel.Text = "UI Toggle Keybind:  [ " .. input.KeyCode.Name .. " ]   (click to change)"
    end
end))

local frames, fpsAccum = 0, 0
local lastStatUpdate = tick()
addConn(RunService.RenderStepped:Connect(function(dt)
    frames += 1
    fpsAccum += dt
    if tick() - lastStatUpdate >= 0.5 then
        local fps = math.floor(frames / fpsAccum)
        local stats = game:GetService("Stats")
        local ok, pingVal = pcall(function() return stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        local ping = ok and math.floor(pingVal) or 0
        StatsLabel.Text = "FPS " .. fps .. "  |  Ping " .. ping
        frames = 0; fpsAccum = 0; lastStatUpdate = tick()
    end
end))

local Tabs, TabButtons = {}, {}
local CurrentTab = nil

local function registerTab(name, icon, page)
    local btn = make("TextButton", {
        Name             = "Tab_" .. name,
        Size             = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.SurfaceLight,
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        Text             = "",
        AutoButtonColor  = false,
        LayoutOrder      = #TabButtons + 1,
        ZIndex           = 5,
    }, Sidebar)
    corner(btn, 8)

    local iconLbl = make("TextLabel", {
        Size             = UDim2.new(0, 24, 1, 0),
        Position         = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Font             = Enum.Font.GothamBold,
        Text             = icon,
        TextColor3       = Theme.SubText,
        TextSize         = 14,
        ZIndex           = 6,
    }, btn)

    local txt = make("TextLabel", {
        Size             = UDim2.new(1, -36, 1, 0),
        Position         = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Font             = Enum.Font.Gotham,
        Text             = name,
        TextColor3       = Theme.SubText,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 6,
    }, btn)

    Tabs[name] = { Button = btn, Page = page, Label = txt, Icon = iconLbl }
    table.insert(TabButtons, btn)

    addConn(btn.MouseEnter:Connect(function()
        if CurrentTab ~= name then
            tween(btn, { BackgroundTransparency = 0.5 }, TweenInfo_Snap)
            tween(txt, { TextColor3 = Theme.Text }, TweenInfo_Snap)
        end
    end))

    addConn(btn.MouseLeave:Connect(function()
        if CurrentTab ~= name then
            tween(btn, { BackgroundTransparency = 1 }, TweenInfo_Snap)
            tween(txt, { TextColor3 = Theme.SubText }, TweenInfo_Snap)
        end
    end))

    addConn(btn.MouseButton1Click:Connect(function()
        if CurrentTab and Tabs[CurrentTab] then
            local cp = Tabs[CurrentTab]
            cp.Page.Visible = false
            tween(cp.Button, { BackgroundTransparency = 1 }, TweenInfo_Fast)
            tween(cp.Label, { TextColor3 = Theme.SubText }, TweenInfo_Fast)
            tween(cp.Icon, { TextColor3 = Theme.SubText }, TweenInfo_Fast)
        end
        CurrentTab = name
        local tab = Tabs[name]
        tab.Page.Visible = true
        tab.Page.CanvasPosition = Vector2.new(0, 0)
        tween(tab.Button, { BackgroundTransparency = 0.85 }, TweenInfo_Fast)
        tween(tab.Label, { TextColor3 = Theme.Text }, TweenInfo_Fast)
        tween(tab.Icon, { TextColor3 = Theme.Accent }, TweenInfo_Fast)
        tween(Indicator, { Position = UDim2.new(0, 4, 0, tab.Button.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y) }, TweenInfo_Main)
    end))
    return btn
end

registerTab("Player", "O", PlayerPage)
registerTab("ESP", "D", ESPPage)
registerTab("Teleport", ">", TPPage)
registerTab("Settings", "*", SettingsPage)

local dragging, dragStart, startPos = false, nil, nil
addConn(Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
    end
end))

addConn(UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end))

addConn(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end))

local isMinimized = false
addConn(MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.fromOffset(640, 52) or UDim2.fromOffset(640, 420)
    tween(Window, { Size = targetSize }, TweenInfo_Main)
    if isMinimized then
        task.delay(0.35, function()
            Sidebar.Visible = false
            ContentHost.Visible = false
        end)
    else
        Sidebar.Visible = true
        ContentHost.Visible = true
    end
end))

addConn(CloseBtn.MouseButton1Click:Connect(function()
    tween(Window, { Size = UDim2.fromOffset(0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }, TweenInfo_Main)
    task.delay(0.36, function()
        cleanupAll()
        ScreenGui:Destroy()
    end)
end))

local hidden = false
addConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CurrentToggleKey then
        hidden = not hidden
        if hidden then
            tween(Window, { Size = UDim2.fromOffset(0, 0) }, TweenInfo_Main)
            task.delay(0.36, function() Window.Visible = false end)
        else
            Window.Visible = true
            tween(Window, { Size = UDim2.fromOffset(640, 420) }, TweenInfo_Main)
        end
    end
end))

Window.Size = UDim2.fromOffset(0, 0)
Window.Position = UDim2.new(0.5, 0, 0.5, 0)
task.spawn(function()
    task.wait(0.05)
    tween(Window, { Size = UDim2.fromOffset(640, 420), Position = UDim2.new(0.5, -320, 0.5, -210) }, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
end)

task.spawn(function()
    task.wait(0.1)
    local tab = Tabs["Player"]
    if tab then
        CurrentTab = "Player"
        tab.Page.Visible = true
        tab.Button.BackgroundTransparency = 0.85
        tab.Label.TextColor3 = Theme.Text
        tab.Icon.TextColor3 = Theme.Accent
        tween(Indicator, { Position = UDim2.new(0, 4, 0, tab.Button.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y) }, TweenInfo_Main)
    end
end)

addConn(Players.PlayerRemoving:Connect(function(p)
    if ESP.Objects[p] then removeESP(p) end
end))

addConn(game:BindToClose(function() cleanupAll() end))
