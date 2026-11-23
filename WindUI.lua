-- WindUI · Roblox Lua Interface Library
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local WindUI = {}
WindUI.__index = WindUI
WindUI.Version = "1.1.0"
WindUI.Animations = true
WindUI.Accent = Color3.fromRGB(139, 92, 246)
WindUI.DefaultAccent = Color3.fromRGB(139, 92, 246)
WindUI.FontFamily = "Gotham"
WindUI.DefaultFont = "Gotham"
WindUI.KeybindCapturing = false
WindUI._windows = {}
WindUI._toasts = {}
WindUI._texts = setmetatable({}, { __mode = "k" })
WindUI._accentBindings = setmetatable({}, { __mode = "k" })
WindUI._globalConnections = {}

WindUI.Theme = {
    Background = Color3.fromRGB(10, 12, 18),
    Surface = Color3.fromRGB(17, 20, 29),
    SurfaceAlt = Color3.fromRGB(24, 28, 40),
    Elevated = Color3.fromRGB(31, 36, 51),
    Text = Color3.fromRGB(245, 247, 252),
    SubText = Color3.fromRGB(147, 155, 178),
    Muted = Color3.fromRGB(94, 103, 126),
    Stroke = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(52, 211, 153),
    Warning = Color3.fromRGB(251, 191, 36),
    Danger = Color3.fromRGB(248, 113, 113),
    Info = Color3.fromRGB(96, 165, 250),
}

local ThemePresets = {
    ["深空黑"] = {
        Accent = Color3.fromRGB(139, 92, 246),
        Background = Color3.fromRGB(10, 12, 18),
        GradientTop = Color3.fromRGB(14, 17, 26),
        GradientBottom = Color3.fromRGB(7, 9, 14),
        Surface = Color3.fromRGB(17, 20, 29),
        SurfaceAlt = Color3.fromRGB(24, 28, 40),
        Elevated = Color3.fromRGB(31, 36, 51),
        Text = Color3.fromRGB(245, 247, 252),
        SubText = Color3.fromRGB(147, 155, 178),
        Muted = Color3.fromRGB(94, 103, 126),
        Stroke = Color3.fromRGB(255, 255, 255),
    },
    ["芙宁娜"] = {
        Accent = Color3.fromRGB(77, 184, 240),
        Background = Color3.fromRGB(9, 18, 28),
        GradientTop = Color3.fromRGB(13, 27, 40),
        GradientBottom = Color3.fromRGB(6, 12, 20),
        Surface = Color3.fromRGB(15, 28, 41),
        SurfaceAlt = Color3.fromRGB(21, 37, 53),
        Elevated = Color3.fromRGB(28, 48, 67),
        Text = Color3.fromRGB(240, 248, 255),
        SubText = Color3.fromRGB(150, 177, 201),
        Muted = Color3.fromRGB(96, 122, 148),
        Stroke = Color3.fromRGB(255, 255, 255),
    },
    ["樱花粉"] = {
        Accent = Color3.fromRGB(244, 114, 182),
        Background = Color3.fromRGB(20, 12, 18),
        GradientTop = Color3.fromRGB(30, 16, 25),
        GradientBottom = Color3.fromRGB(15, 9, 14),
        Surface = Color3.fromRGB(31, 18, 27),
        SurfaceAlt = Color3.fromRGB(42, 25, 36),
        Elevated = Color3.fromRGB(54, 32, 46),
        Text = Color3.fromRGB(255, 244, 250),
        SubText = Color3.fromRGB(196, 156, 178),
        Muted = Color3.fromRGB(136, 104, 122),
        Stroke = Color3.fromRGB(255, 255, 255),
    },
    ["暮光紫"] = {
        Accent = Color3.fromRGB(167, 139, 250),
        Background = Color3.fromRGB(14, 11, 24),
        GradientTop = Color3.fromRGB(22, 17, 37),
        GradientBottom = Color3.fromRGB(9, 7, 16),
        Surface = Color3.fromRGB(24, 19, 39),
        SurfaceAlt = Color3.fromRGB(33, 26, 52),
        Elevated = Color3.fromRGB(44, 34, 68),
        Text = Color3.fromRGB(246, 243, 255),
        SubText = Color3.fromRGB(166, 156, 200),
        Muted = Color3.fromRGB(112, 104, 143),
        Stroke = Color3.fromRGB(255, 255, 255),
    },
    ["翡翠绿"] = {
        Accent = Color3.fromRGB(45, 212, 168),
        Background = Color3.fromRGB(8, 18, 17),
        GradientTop = Color3.fromRGB(12, 28, 26),
        GradientBottom = Color3.fromRGB(5, 13, 12),
        Surface = Color3.fromRGB(14, 31, 29),
        SurfaceAlt = Color3.fromRGB(20, 42, 39),
        Elevated = Color3.fromRGB(27, 55, 51),
        Text = Color3.fromRGB(238, 252, 248),
        SubText = Color3.fromRGB(146, 184, 175),
        Muted = Color3.fromRGB(94, 128, 121),
        Stroke = Color3.fromRGB(255, 255, 255),
    },
    ["日落橙"] = {
        Accent = Color3.fromRGB(251, 146, 60),
        Background = Color3.fromRGB(20, 14, 10),
        GradientTop = Color3.fromRGB(31, 21, 14),
        GradientBottom = Color3.fromRGB(14, 10, 7),
        Surface = Color3.fromRGB(33, 23, 16),
        SurfaceAlt = Color3.fromRGB(45, 32, 22),
        Elevated = Color3.fromRGB(60, 42, 29),
        Text = Color3.fromRGB(255, 247, 240),
        SubText = Color3.fromRGB(198, 168, 143),
        Muted = Color3.fromRGB(136, 113, 94),
        Stroke = Color3.fromRGB(255, 255, 255),
    },
    ["冰川蓝"] = {
        Accent = Color3.fromRGB(56, 189, 248),
        Background = Color3.fromRGB(9, 15, 22),
        GradientTop = Color3.fromRGB(13, 23, 33),
        GradientBottom = Color3.fromRGB(6, 10, 15),
        Surface = Color3.fromRGB(15, 25, 36),
        SurfaceAlt = Color3.fromRGB(21, 34, 48),
        Elevated = Color3.fromRGB(29, 45, 62),
        Text = Color3.fromRGB(240, 249, 255),
        SubText = Color3.fromRGB(148, 174, 196),
        Muted = Color3.fromRGB(95, 119, 140),
        Stroke = Color3.fromRGB(255, 255, 255),
    },
    ["烈焰红"] = {
        Accent = Color3.fromRGB(239, 68, 68),
        Background = Color3.fromRGB(19, 11, 12),
        GradientTop = Color3.fromRGB(30, 16, 18),
        GradientBottom = Color3.fromRGB(13, 8, 9),
        Surface = Color3.fromRGB(32, 17, 19),
        SurfaceAlt = Color3.fromRGB(44, 24, 27),
        Elevated = Color3.fromRGB(58, 31, 35),
        Text = Color3.fromRGB(255, 243, 244),
        SubText = Color3.fromRGB(200, 158, 161),
        Muted = Color3.fromRGB(138, 108, 111),
        Stroke = Color3.fromRGB(255, 255, 255),
    },
}

WindUI.Themes = ThemePresets
WindUI.ThemeOrder = { "深空黑", "芙宁娜", "樱花粉", "暮光紫", "翡翠绿", "日落橙", "冰川蓝", "烈焰红" }
WindUI.Theme.Name = "深空黑"
WindUI.Theme.GradientTop = Color3.fromRGB(14, 17, 26)
WindUI.Theme.GradientBottom = Color3.fromRGB(7, 9, 14)
WindUI.Theme.Accent = Color3.fromRGB(139, 92, 246)
WindUI.Creator = { Theme = WindUI.Theme }
WindUI.CurrentTheme = "深空黑"

local FontFamilies = {
    Gotham = {
        Regular = Enum.Font.Gotham,
        Medium = Enum.Font.GothamMedium,
        Bold = Enum.Font.GothamBold,
        Black = Enum.Font.GothamBlack,
    },
    ["Source Sans"] = {
        Regular = Enum.Font.SourceSans,
        Medium = Enum.Font.SourceSansSemibold,
        Bold = Enum.Font.SourceSansBold,
        Black = Enum.Font.SourceSansBold,
    },
    Roboto = {
        Regular = Enum.Font.Roboto,
        Medium = Enum.Font.Roboto,
        Bold = Enum.Font.Roboto,
        Black = Enum.Font.Roboto,
    },
    Arial = {
        Regular = Enum.Font.Arial,
        Medium = Enum.Font.ArialBold,
        Bold = Enum.Font.ArialBold,
        Black = Enum.Font.ArialBold,
    },
    Code = {
        Regular = Enum.Font.Code,
        Medium = Enum.Font.Code,
        Bold = Enum.Font.Code,
        Black = Enum.Font.Code,
    },
    Fantasy = {
        Regular = Enum.Font.Fantasy,
        Medium = Enum.Font.Fantasy,
        Bold = Enum.Font.Fantasy,
        Black = Enum.Font.Fantasy,
    },
    SciFi = {
        Regular = Enum.Font.SciFi,
        Medium = Enum.Font.SciFi,
        Bold = Enum.Font.SciFi,
        Black = Enum.Font.SciFi,
    },
    Cartoon = {
        Regular = Enum.Font.Cartoon,
        Medium = Enum.Font.Cartoon,
        Bold = Enum.Font.Cartoon,
        Black = Enum.Font.Cartoon,
    },
}

local FontNames = { "Gotham", "Source Sans", "Roboto", "Arial", "Code", "Fantasy", "SciFi", "Cartoon" }

local NotificationTypes = {
    info = { Color = Color3.fromRGB(96, 165, 250), Icon = "i", Title = "提示" },
    success = { Color = Color3.fromRGB(52, 211, 153), Icon = "✓", Title = "完成" },
    warning = { Color = Color3.fromRGB(251, 191, 36), Icon = "!", Title = "注意" },
    error = { Color = Color3.fromRGB(248, 113, 113), Icon = "✕", Title = "错误" },
}

local KeyNames = {
    [Enum.KeyCode.RightShift] = "RShift",
    [Enum.KeyCode.LeftShift] = "LShift",
    [Enum.KeyCode.RightControl] = "RCtrl",
    [Enum.KeyCode.LeftControl] = "LCtrl",
    [Enum.KeyCode.RightAlt] = "RAlt",
    [Enum.KeyCode.LeftAlt] = "LAlt",
    [Enum.KeyCode.Space] = "Space",
    [Enum.KeyCode.Return] = "Enter",
    [Enum.KeyCode.Backspace] = "Backspace",
    [Enum.KeyCode.Escape] = "Esc",
    [Enum.KeyCode.Tab] = "Tab",
    [Enum.KeyCode.CapsLock] = "Caps",
    [Enum.KeyCode.Delete] = "Delete",
    [Enum.KeyCode.Insert] = "Insert",
    [Enum.KeyCode.Home] = "Home",
    [Enum.KeyCode.End] = "End",
    [Enum.KeyCode.PageUp] = "PageUp",
    [Enum.KeyCode.PageDown] = "PageDown",
    [Enum.KeyCode.Up] = "Up",
    [Enum.KeyCode.Down] = "Down",
    [Enum.KeyCode.Left] = "Left",
    [Enum.KeyCode.Right] = "Right",
}

local Window, Tab, Section

local function new(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        object[key] = value
    end
    if parent then
        object.Parent = parent
    end
    return object
end

local function addCorner(object, radius)
    return new("UICorner", { CornerRadius = UDim.new(0, radius) }, object)
end

local function addStroke(object, color, transparency, thickness)
    return new("UIStroke", {
        Color = color or Color3.new(1, 1, 1),
        Transparency = transparency or 0.9,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, object)
end

local function addPadding(object, top, right, bottom, left)
    return new("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
    }, object)
end

local function accentSequence(color)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, color:Lerp(Color3.new(1, 1, 1), 0.28)),
        ColorSequenceKeypoint.new(1, color),
    })
end

local function keyName(key)
    if not key then
        return "未绑定"
    end
    if typeof(key) == "EnumItem" then
        return KeyNames[key] or key.Name
    end
    return tostring(key)
end

local function resolveKey(value)
    if value == nil then
        return nil
    end
    if typeof(value) == "EnumItem" then
        return value
    end
    if type(value) == "string" then
        local ok, key = pcall(function()
            return Enum.KeyCode[value]
        end)
        if ok then
            return key
        end
    end
    return nil
end

local IconAliases = {
    settings = "⚙",
    ["sliders-horizontal"] = "⚏",
    star = "★",
    zap = "⚡",
    send = "➤",
    copy = "⧉",
    trash = "✕",
    ["trash-2"] = "✕",
    eye = "◉",
    ["eye-off"] = "◌",
    refresh = "↻",
    ["refresh-cw"] = "↻",
    ["rotate-cw"] = "↻",
    eraser = "⌫",
    ["scroll-text"] = "▤",
    ["layers-3"] = "▤",
    plus = "＋",
    check = "✓",
    braces = "⌘",
    user = "●",
    home = "⌂",
    shield = "◈",
    info = "i",
    search = "⌕",
    palette = "◑",
    keyboard = "⌨",
    gamepad = "✦",
    ["gamepad-2"] = "✦",
    lock = "▣",
    unlock = "▢",
    bell = "◆",
    sparkles = "✦",
}

local function glyph(icon, fallback)
    if type(icon) ~= "string" or icon == "" then
        return fallback or "✦"
    end
    if IconAliases[icon] then
        return IconAliases[icon]
    end
    if icon:sub(1, 11) == "rbxassetid:" or icon:sub(1, 4) == "http" then
        return fallback or "✦"
    end
    if utf8.len(icon) and utf8.len(icon) <= 3 then
        return icon
    end
    return fallback or "✦"
end

local function compat(options)
    options = options or {}
    if options.Name == nil and options.Title ~= nil then
        options.Name = options.Title
    end
    if options.Description == nil and options.Desc ~= nil then
        options.Description = options.Desc
    end
    if options.Text == nil and options.Title ~= nil then
        options.Text = options.Title
    end
    if options.Options == nil and options.Values ~= nil then
        options.Options = options.Values
    end
    if options.Default == nil and options.Value ~= nil then
        options.Default = options.Value
    end
    return options
end

local function withValue(object, getter, setter)
    return setmetatable(object, {
        __index = function(_, key)
            if key == "Value" then
                return getter()
            end
            return nil
        end,
        __newindex = function(self, key, value)
            if key == "Value" then
                setter(value)
                return
            end
            rawset(self, key, value)
        end,
    })
end

local function addTooltip(library, object, text)
    if type(text) ~= "string" or text == "" then
        return
    end
    object.MouseEnter:Connect(function()
        library:_showTooltip(text)
    end)
    object.MouseLeave:Connect(function()
        library:_hideTooltip()
    end)
end

function WindUI:_tween(object, duration, properties, style, direction)
    if not object then
        return nil
    end
    if not self.Animations or duration <= 0 then
        for key, value in pairs(properties) do
            object[key] = value
        end
        return nil
    end
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

function WindUI:_fontFor(weight)
    local family = FontFamilies[self.FontFamily] or FontFamilies.Gotham
    return family[weight] or family.Regular
end

function WindUI:_registerText(object, weight)
    self._texts[object] = weight or "Regular"
    object.Font = self:_fontFor(weight or "Regular")
    return object
end

function WindUI:_text(parent, properties, weight)
    local class = properties.ClassName or "TextLabel"
    local label = Instance.new(class)
    local defaults = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }
    for key, value in pairs(defaults) do
        label[key] = value
    end
    for key, value in pairs(properties) do
        if key ~= "ClassName" then
            label[key] = value
        end
    end
    label.Font = self:_fontFor(weight or "Regular")
    self._texts[label] = weight or "Regular"
    label.Parent = parent
    return label
end

function WindUI:_bindAccent(object, callback)
    self._accentBindings[object] = callback
    local ok = pcall(callback, self.Accent)
    if not ok then
        self._accentBindings[object] = nil
    end
end

function WindUI:SetAccent(color)
    self.Accent = color
    self.Theme.Accent = color
    for object, callback in pairs(self._accentBindings) do
        if object and object.Parent then
            pcall(callback, color)
        end
    end
end

function WindUI:SetFont(name)
    if FontFamilies[name] then
        self.FontFamily = name
    end
    for object in pairs(self._texts) do
        if object and object.Parent then
            pcall(function()
                object.Font = self:_fontFor(self._texts[object])
            end)
        end
    end
end

function WindUI:SetAnimations(enabled)
    self.Animations = enabled and true or false
end

function WindUI:GetFonts()
    return FontNames
end

function WindUI:GetThemes()
    local names = {}
    for _, name in ipairs(self.ThemeOrder) do
        names[#names + 1] = name
    end
    return names
end

function WindUI:GetCurrentTheme()
    return self.Theme.Name or "深空黑"
end

function WindUI:IsTheme(name)
    return type(name) == "string" and self.Themes[name] ~= nil
end

function WindUI:SetTheme(name)
    if not self:IsTheme(name) then
        return false
    end
    local previous = {}
    for key, value in pairs(self.Theme) do
        previous[key] = value
    end
    local preset = self.Themes[name]
    for key, value in pairs(preset) do
        self.Theme[key] = value
    end
    self.Theme.Name = name
    self.CurrentTheme = name
    self.Creator.Theme = self.Theme
    self:SetAccent(preset.Accent or self.DefaultAccent)
    for _, window in ipairs(self._windows) do
        if not window.Destroyed then
            pcall(function()
                window:_repaint(previous, self.Theme)
            end)
        end
    end
    return true
end

function WindUI:_ensureGui()
    if self._gui and self._gui.Parent then
        return self._gui
    end
    local player = Players.LocalPlayer
    if not player then
        return nil
    end
    local playerGui = player:WaitForChild("PlayerGui")
    local gui = new("ScreenGui", {
        Name = "WindUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })
    gui.Parent = playerGui
    self._gui = gui

    self._notifyLayer = new("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 500,
        Active = false,
    }, gui)
    self._notifyHolder = new("Frame", {
        Name = "Stack",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -18, 0, 18),
        Size = UDim2.fromOffset(304, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
    }, self._notifyLayer)
    new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    }, self._notifyHolder)

    self._overlay = new("Frame", {
        Name = "Overlay",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 600,
    }, gui)

    self._tooltipLayer = new("Frame", {
        Name = "Tooltips",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 700,
        Active = false,
    }, gui)
    self._tooltip = new("Frame", {
        Name = "Tooltip",
        BackgroundColor3 = self.Theme.Elevated,
        BackgroundTransparency = 0.02,
        Size = UDim2.fromOffset(210, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = 1,
    }, self._tooltipLayer)
    addCorner(self._tooltip, 8)
    addStroke(self._tooltip, self.Theme.Stroke, 0.86, 1)
    addPadding(self._tooltip, 8, 10, 8, 10)
    self._tooltipText = self:_text(self._tooltip, {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        TextWrapped = true,
        TextSize = 11,
        TextColor3 = self.Theme.Text,
        LineHeight = 1.2,
    }, "Regular")

    table.insert(self._globalConnections, UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape and self._currentMenu then
            self:_closeMenu()
        end
    end))
    table.insert(self._globalConnections, UserInputService.InputChanged:Connect(function(input)
        if self._tooltip.Visible and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            self:_updateTooltip(input.Position)
        end
    end))
    return gui
end

function WindUI:_updateTooltip(position)
    if not self._tooltip or not self._tooltip.Visible then
        return
    end
    local mouse = position or UserInputService:GetMouseLocation()
    local viewport = self._gui.AbsoluteSize
    if viewport.X <= 0 or viewport.Y <= 0 then
        viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
    end
    local size = self._tooltip.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then
        size = Vector2.new(210, 36)
    end
    local x = mouse.X + 16
    local y = mouse.Y + 18
    if x + size.X > viewport.X - 8 then
        x = mouse.X - size.X - 12
    end
    if y + size.Y > viewport.Y - 8 then
        y = mouse.Y - size.Y - 12
    end
    self._tooltip.Position = UDim2.fromOffset(math.max(8, x), math.max(8, y))
end

function WindUI:_showTooltip(text)
    if not self._tooltip then
        return
    end
    self._tooltipText.Text = text
    self._tooltip.Visible = true
    self:_updateTooltip()
    task.defer(function()
        self:_updateTooltip()
    end)
end

function WindUI:_hideTooltip()
    if self._tooltip then
        self._tooltip.Visible = false
    end
end

function WindUI:_showMenu(menu, backdrop, onClose)
    self:_closeMenu()
    self:_hideTooltip()
    self._overlay.Visible = true
    backdrop.Parent = self._overlay
    menu.Parent = self._overlay
    self._currentMenu = {
        Menu = menu,
        Backdrop = backdrop,
        OnClose = onClose,
    }
end

function WindUI:_closeMenu()
    local current = self._currentMenu
    if not current then
        return
    end
    self._currentMenu = nil
    if current.Backdrop then
        current.Backdrop:Destroy()
    end
    if current.Menu then
        current.Menu:Destroy()
    end
    if self._overlay then
        self._overlay.Visible = false
    end
    if current.OnClose then
        pcall(current.OnClose)
    end
end

function WindUI:Notify(data)
    if type(data) ~= "table" then
        data = { Content = tostring(data or "") }
    end
    if not self:_ensureGui() then
        return nil
    end
    local kind = data.Type or "info"
    local style = NotificationTypes[kind] or NotificationTypes.info
    local duration = data.Duration
    if duration == nil then
        duration = 4
    end
    local title = data.Title or style.Title
    local content = data.Content or ""
    local icon = glyph(data.Icon, style.Icon)

    if #self._toasts >= 4 then
        local oldest = self._toasts[1]
        if oldest then
            oldest.Dismiss()
        end
    end

    local canvas = new("CanvasGroup", {
        Name = "Notification",
        BackgroundColor3 = self.Theme.Surface,
        BackgroundTransparency = 0.02,
        Size = UDim2.fromOffset(304, 78),
        ClipsDescendants = true,
        GroupTransparency = 1,
    }, self._notifyHolder)
    addCorner(canvas, 12)
    addStroke(canvas, style.Color, 0.78, 1)
    local scale = new("UIScale", { Scale = 0.94 }, canvas)

    local iconBox = new("Frame", {
        BackgroundColor3 = style.Color,
        BackgroundTransparency = 0.1,
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.fromOffset(12, 14),
    }, canvas)
    addCorner(iconBox, 9)
    self:_text(iconBox, {
        Size = UDim2.fromScale(1, 1),
        Text = icon,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, "Bold")

    self:_text(canvas, {
        Position = UDim2.fromOffset(52, 11),
        Size = UDim2.new(1, -96, 0, 16),
        Text = tostring(title),
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, "Medium")
    self:_text(canvas, {
        Position = UDim2.fromOffset(52, 31),
        Size = UDim2.new(1, -68, 0, 32),
        Text = tostring(content),
        TextColor3 = self.Theme.SubText,
        TextSize = 11,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextYAlignment = Enum.TextYAlignment.Top,
        LineHeight = 1.15,
    }, "Regular")

    local close = self:_text(canvas, {
        ClassName = "TextButton",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -9, 0, 9),
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "✕",
        TextColor3 = self.Theme.Muted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 3,
    }, "Regular")
    addCorner(close, 6)
    close.MouseEnter:Connect(function()
        close.TextColor3 = self.Theme.Text
        close.BackgroundTransparency = 0.88
    end)
    close.MouseLeave:Connect(function()
        close.TextColor3 = self.Theme.Muted
        close.BackgroundTransparency = 1
    end)

    local track = new("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = style.Color,
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
    }, canvas)
    local fill = new("Frame", {
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = style.Color,
        BorderSizePixel = 0,
    }, track)

    local toast = {}
    local closed = false
    local progressTween

    toast.Dismiss = function()
        if closed then
            return
        end
        closed = true
        if progressTween then
            progressTween:Cancel()
        end
        for index = #self._toasts, 1, -1 do
            if self._toasts[index] == toast then
                table.remove(self._toasts, index)
            end
        end
        if not canvas or not canvas.Parent then
            return
        end
        self:_tween(canvas, 0.18, { GroupTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        self:_tween(scale, 0.18, { Scale = 0.96 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.2, function()
            if canvas and canvas.Parent then
                canvas:Destroy()
            end
        end)
    end

    close.MouseButton1Click:Connect(toast.Dismiss)
    table.insert(self._toasts, toast)
    self:_tween(canvas, 0.22, { GroupTransparency = 0 })
    self:_tween(scale, 0.24, { Scale = 1 }, Enum.EasingStyle.Back)

    if duration > 0 then
        if self.Animations then
            progressTween = TweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Size = UDim2.new(0, 0, 0, 3),
            })
            progressTween:Play()
        else
            fill.Size = UDim2.new(0, 0, 0, 3)
        end
        task.delay(duration, toast.Dismiss)
    else
        fill.Size = UDim2.new(0, 0, 0, 3)
    end
    return toast
end

function WindUI:Destroy()
    self:_closeMenu()
    local windows = {}
    for _, window in ipairs(self._windows) do
        windows[#windows + 1] = window
    end
    for _, window in ipairs(windows) do
        pcall(function()
            window:Destroy()
        end)
    end
    self._windows = {}
    if self._gui then
        self._gui:Destroy()
    end
    for _, connection in ipairs(self._globalConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    self._globalConnections = {}
    self._gui = nil
    self._notifyLayer = nil
    self._notifyHolder = nil
    self._overlay = nil
    self._tooltipLayer = nil
    self._tooltip = nil
    self._tooltipText = nil
    self._toasts = {}
end

Window = {}
Window.__index = Window

function Window:_track(connection)
    table.insert(self._connections, connection)
    return connection
end

function Window:_text(parent, properties, weight)
    return self.Library:_text(parent, properties, weight)
end

function Window:_viewport()
    local size = self.Library._gui and self.Library._gui.AbsoluteSize or Vector2.new(0, 0)
    if size.X <= 0 or size.Y <= 0 then
        local camera = workspace.CurrentCamera
        size = camera and camera.ViewportSize or Vector2.new(1280, 720)
    end
    return size
end

function Window:_clampToViewport()
    if self.Destroyed or not self.Gui then
        return
    end
    local viewport = self:_viewport()
    local size = self.Gui.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then
        return
    end
    local position = self.Gui.AbsolutePosition
    local maxX = math.max(0, viewport.X - size.X)
    local maxY = math.max(0, viewport.Y - size.Y)
    local x = math.clamp(position.X, 0, maxX)
    local y = math.clamp(position.Y, 0, maxY)
    if math.abs(x - position.X) > 0.5 or math.abs(y - position.Y) > 0.5 then
        self.Gui.Position = UDim2.fromOffset(x + size.X * 0.5, y + size.Y * 0.5)
    end
end

function Window:_selectTab(tab)
    if not tab or self.Destroyed then
        return
    end
    self:_cancelKeybind()
    self.ActiveTab = tab
    for _, item in ipairs(self.Tabs) do
        item.Page.Visible = item == tab
        if item.Nav then
            item.Nav:SetActive(item == tab)
        end
    end
    if self.SettingsTab then
        self.SettingsTab.Page.Visible = self.SettingsTab == tab
        if self.SettingsNav then
            self.SettingsNav:SetActive(self.SettingsTab == tab)
        end
    end
    local showTitle = tab.ShowTabTitle ~= false
    self.PageTitle.Visible = showTitle
    self.PageTitle.Text = tab.Name
    self.PageDescription.Text = tab.Description or ""
    self.PageDescription.Visible = showTitle and (tab.Description or "") ~= ""
    self.Scroll.CanvasPosition = Vector2.new(0, 0)
    self.Library:_closeMenu()
    self.Library:_hideTooltip()
    if tab.OnSelect then
        task.spawn(tab.OnSelect)
    end
end

function Window:_createPage()
    local page = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = false,
    }, self.Scroll)
    new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    return page
end

function Window:_createNav(parent, name, icon, callback)
    icon = glyph(icon, "•")
    local library = self.Library
    local theme = library.Theme
    local button = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = theme.SurfaceAlt,
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, parent)
    addCorner(button, 9)
    local indicator = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(2, 16),
        BackgroundColor3 = library.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, button)
    addCorner(indicator, 1)
    library:_bindAccent(indicator, function(color)
        indicator.BackgroundColor3 = color
    end)
    local iconLabel = library:_text(button, {
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.fromOffset(18, 36),
        Text = icon or "•",
        TextSize = 15,
        TextColor3 = theme.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, "Medium")
    local textLabel = library:_text(button, {
        Position = UDim2.fromOffset(34, 0),
        Size = UDim2.new(1, -42, 0, 36),
        Text = name,
        TextSize = 12,
        TextColor3 = theme.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, "Medium")
    local entry = {
        Button = button,
        Active = false,
    }
    function entry:SetActive(active)
        self.Active = active
        if active then
            button.BackgroundColor3 = library.Accent
            library:_tween(button, 0.16, { BackgroundTransparency = 0.88 })
            iconLabel.TextColor3 = library.Accent
            textLabel.TextColor3 = theme.Text
            indicator.BackgroundTransparency = 0
        else
            library:_tween(button, 0.14, { BackgroundTransparency = 1 })
            iconLabel.TextColor3 = theme.SubText
            textLabel.TextColor3 = theme.SubText
            indicator.BackgroundTransparency = 1
        end
    end
    library:_bindAccent(button, function(color)
        if entry.Active then
            button.BackgroundColor3 = color
        end
    end)
    library:_bindAccent(iconLabel, function(color)
        if entry.Active then
            iconLabel.TextColor3 = color
        end
    end)
    button.MouseEnter:Connect(function()
        if not entry.Active then
            button.BackgroundColor3 = theme.SurfaceAlt
            library:_tween(button, 0.14, { BackgroundTransparency = 0.45 })
        end
    end)
    button.MouseLeave:Connect(function()
        if not entry.Active then
            library:_tween(button, 0.14, { BackgroundTransparency = 1 })
        end
    end)
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    return entry
end

function Window:Tab(options)
    options = compat(options)
    local tab = setmetatable({
        Name = options.Name or "页面",
        Icon = glyph(options.Icon, "✦"),
        Description = options.Description or "",
        ShowTabTitle = options.ShowTabTitle ~= false,
        Window = self,
        Page = self:_createPage(),
    }, Tab)
    tab.Nav = self:_createNav(self.NavList, tab.Name, tab.Icon, function()
        self:_selectTab(tab)
    end)
    tab.Nav.Button.LayoutOrder = #self.Tabs + 1
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        self:_selectTab(tab)
    end
    return tab
end

function Window:_initInteraction()
    self:_track(UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if self.Library.KeybindCapturing then
            return
        end
        if UserInputService:GetFocusedTextBox() then
            return
        end
        if self.ToggleKey and input.KeyCode == self.ToggleKey then
            self:Toggle()
        end
    end))

    local dragging = false
    local dragStart
    local startPosition
    local startSize
    local resizing = false
    local resizeStart
    local resizeOrigin
    if self.ResizeGrip then
        self.ResizeGrip.InputBegan:Connect(function(input)
            if self.Minimized then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                resizeStart = input.Position
                resizeOrigin = Vector2.new(self.Gui.AbsoluteSize.X, self.Gui.AbsoluteSize.Y)
                self.Library:_closeMenu()
            end
        end)
    end
    self.DragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = self.Gui.AbsolutePosition
            startSize = self.Gui.AbsoluteSize
            self.Library:_closeMenu()
        end
    end)
    self:_track(UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if resizing then
            local delta = input.Position - resizeStart
            local viewport = self:_viewport()
            local limitX = math.min(self.MaxSize.X, math.max(self.MinSize.X, viewport.X - 24))
            local limitY = math.min(self.MaxSize.Y, math.max(self.MinSize.Y, viewport.Y - 24))
            local width = math.clamp(resizeOrigin.X + delta.X, self.MinSize.X, limitX)
            local height = math.clamp(resizeOrigin.Y + delta.Y, self.MinSize.Y, limitY)
            self.ExpandedSize = UDim2.fromOffset(width, height)
            self.BaseSize = Vector2.new(width, height)
            self.Gui.Size = self.ExpandedSize
            self:_clampToViewport()
            return
        end
        if not dragging then
            return
        end
        local delta = input.Position - dragStart
        local viewport = self:_viewport()
        local maxX = math.max(0, viewport.X - startSize.X)
        local maxY = math.max(0, viewport.Y - startSize.Y)
        local x = math.clamp(startPosition.X + delta.X, 0, maxX)
        local y = math.clamp(startPosition.Y + delta.Y, 0, maxY)
        self.Gui.Position = UDim2.fromOffset(x + startSize.X * 0.5, y + startSize.Y * 0.5)
    end))
    self:_track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            resizing = false
        end
    end))
    local camera = workspace.CurrentCamera
    if camera then
        self:_track(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            task.defer(function()
                self:_clampToViewport()
            end)
        end))
    end
end

function Window:_repaint(previous, current)
    local entries = {}
    for key, value in pairs(previous) do
        local target = current[key]
        if key ~= "Accent" and typeof(value) == "Color3" and typeof(target) == "Color3" and value ~= target then
            entries[#entries + 1] = { Old = value, New = target }
        end
    end
    if #entries == 0 then
        return
    end
    local oldAccent = previous.Accent
    local function convert(color)
        if typeof(color) ~= "Color3" then
            return color
        end
        if oldAccent and color == oldAccent then
            return color
        end
        for _, entry in ipairs(entries) do
            if entry.Old == color then
                return entry.New
            end
        end
        return color
    end
    local function walk(object)
        for _, child in ipairs(object:GetChildren()) do
            local class = child.ClassName
            if class == "UIStroke" then
                pcall(function()
                    child.Color = convert(child.Color)
                end)
            elseif class == "UIGradient" then
                pcall(function()
                    local sequence = child.Color
                    local keypoints = {}
                    local changed = false
                    for _, point in ipairs(sequence.Keypoints) do
                        local mapped = convert(point.Value)
                        if mapped ~= point.Value then
                            changed = true
                        end
                        keypoints[#keypoints + 1] = ColorSequenceKeypoint.new(point.Time, mapped)
                    end
                    if changed and #keypoints >= 2 then
                        child.Color = ColorSequence.new(keypoints)
                    end
                end)
            else
                pcall(function()
                    child.BackgroundColor3 = convert(child.BackgroundColor3)
                end)
                pcall(function()
                    child.TextColor3 = convert(child.TextColor3)
                end)
                walk(child)
            end
        end
    end
    if self.Gui then
        pcall(function()
            self.Gui.BackgroundColor3 = current.Background
        end)
        walk(self.Gui)
    end
end

function Window:_build()
    local library = self.Library
    local theme = library.Theme
    local config = self.Config
    self.CornerRadius = config.CornerRadius or 14
    self.ImageTransparency = config.ImageTransparency or 0.78
    self.BackgroundDim = config.BackgroundDim or 45
    self.MinimizedSize = UDim2.fromOffset(324, 64)
    self.HasUserCard = type(config.User) == "table" and config.User.Enabled == true
    self.BottomHeight = self.HasUserCard and 164 or 94

    self.Shadow = new("Frame", {
        Name = "WindUIShadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 12),
        Size = self.ExpandedSize + UDim2.fromOffset(44, 44),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 8,
    }, self.Library._gui)
    addCorner(self.Shadow, self.CornerRadius + 22)
    self.ShadowInner = new("Frame", {
        Name = "WindUIShadowInner",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 6),
        Size = self.ExpandedSize + UDim2.fromOffset(18, 18),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 9,
    }, self.Library._gui)
    addCorner(self.ShadowInner, self.CornerRadius + 9)

    self.Gui = new("CanvasGroup", {
        Name = "WindUI",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = self.ExpandedSize,
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = config.Transparent and 0.35 or 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        GroupTransparency = 1,
        ZIndex = 10,
    }, self.Library._gui)
    addCorner(self.Gui, self.CornerRadius)
    addStroke(self.Gui, theme.Stroke, 0.9, 1)
    self.WindowGradient = new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.GradientTop or Color3.fromRGB(14, 17, 26)),
            ColorSequenceKeypoint.new(1, theme.GradientBottom or Color3.fromRGB(7, 9, 14)),
        }),
        Rotation = 90,
    }, self.Gui)
    self.Scale = new("UIScale", { Scale = 0.97 }, self.Gui)

    local function syncShadow()
        local position = self.Gui.Position
        local size = self.Gui.Size
        self.Shadow.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + 12)
        self.Shadow.Size = UDim2.new(size.X.Scale, size.X.Offset + 44, size.Y.Scale, size.Y.Offset + 44)
        self.ShadowInner.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + 6)
        self.ShadowInner.Size = UDim2.new(size.X.Scale, size.X.Offset + 18, size.Y.Scale, size.Y.Offset + 18)
    end
    self:_track(self.Gui:GetPropertyChangedSignal("Position"):Connect(syncShadow))
    self:_track(self.Gui:GetPropertyChangedSignal("Size"):Connect(syncShadow))

    self.BackgroundImage = new("ImageLabel", {
        Name = "Background",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ImageTransparency = self.ImageTransparency,
        ScaleType = Enum.ScaleType.Crop,
        Visible = false,
        ZIndex = 1,
    }, self.Gui)

    self.Tint = new("Frame", {
        Name = "Tint",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1 - self.BackgroundDim / 100,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, self.Gui)

    local glow = new("Frame", {
        Name = "Glow",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 70, 0, -130),
        Size = UDim2.fromOffset(290, 290),
        BackgroundColor3 = library.Accent,
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        Rotation = 28,
        ZIndex = 3,
    }, self.Gui)
    addCorner(glow, 145)
    new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.45),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Rotation = 90,
    }, glow)
    library:_bindAccent(glow, function(color)
        glow.BackgroundColor3 = color
    end)

    local topLine = new("Frame", {
        Name = "TopLine",
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = library.Accent,
        BorderSizePixel = 0,
        ZIndex = 25,
    }, self.Gui)
    local topGradient = new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.65, 0.55),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Rotation = 0,
    }, topLine)
    library:_bindAccent(topLine, function(color)
        topLine.BackgroundColor3 = color
        topGradient.Color = accentSequence(color)
    end)

    self.Header = new("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 62),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.22,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, self.Gui)
    local logoBox = 46
    local logoSize = math.clamp(tonumber(config.IconSize) or 32, 16, 42)
    local logoGlow = new("Frame", {
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromOffset(9, 8),
        Size = UDim2.fromOffset(logoBox, logoBox),
        BackgroundColor3 = library.Accent,
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, self.Header)
    addCorner(logoGlow, math.floor(logoBox / 2))
    library:_bindAccent(logoGlow, function(color)
        logoGlow.BackgroundColor3 = color
    end)
    local logo = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(9 + math.floor(logoBox / 2), 8 + math.floor(logoBox / 2)),
        Size = UDim2.fromOffset(logoSize, logoSize),
        BackgroundColor3 = library.Accent,
        BorderSizePixel = 0,
        ZIndex = 12,
    }, self.Header)
    addCorner(logo, math.max(6, math.floor(logoSize * 0.3)))
    addStroke(logo, Color3.new(1, 1, 1), 0.78, 1)
    local logoGradient = new("UIGradient", { Rotation = 45 }, logo)
    library:_bindAccent(logo, function(color)
        logo.BackgroundColor3 = color
        logoGradient.Color = accentSequence(color)
    end)
    if type(config.Icon) == "string" and config.Icon ~= "" then
        new("ImageLabel", {
            Name = "Icon",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = config.Icon,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 13,
        }, logo)
    else
        library:_text(logo, {
            Size = UDim2.fromScale(1, 1),
            Text = "W",
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = math.clamp(math.floor(logoSize * 0.48), 9, 18),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 2,
        }, "Black")
    end

    self:_text(self.Header, {
        Position = UDim2.fromOffset(58, 11),
        Size = UDim2.new(1, -156, 0, 18),
        Text = config.Title or "WindUI",
        TextSize = 15,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 3,
    }, "Bold")
    self:_text(self.Header, {
        Position = UDim2.fromOffset(58, 31),
        Size = UDim2.new(1, -156, 0, 14),
        Text = config.Subtitle or config.Author or "轻量 · 现代 · 流畅",
        TextSize = 10,
        TextColor3 = theme.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 3,
    }, "Regular")

    local function control(icon, x, tooltip, danger)
        local button = library:_text(self.Header, {
            ClassName = "TextButton",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, x, 0.5, 0),
            Size = UDim2.fromOffset(28, 28),
            BackgroundColor3 = danger and theme.Danger or Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = icon,
            TextColor3 = theme.SubText,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 30,
        }, "Medium")
        addCorner(button, 8)
        addTooltip(library, button, tooltip)
        button.MouseEnter:Connect(function()
            library:_tween(button, 0.12, { BackgroundTransparency = 0.86 })
            if danger then
                button.TextColor3 = Color3.new(1, 1, 1)
            else
                button.TextColor3 = theme.Text
            end
        end)
        button.MouseLeave:Connect(function()
            library:_tween(button, 0.12, { BackgroundTransparency = 1 })
            button.TextColor3 = theme.SubText
        end)
        return button
    end
    self.CloseButton = control("✕", -14, "关闭", true)
    self.MinimizeButton = control("—", -48, "最小化 / 还原", false)
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)

    self.DragArea = new("Frame", {
        Name = "DragArea",
        Size = UDim2.new(1, -92, 0, 62),
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = 20,
    }, self.Header)
    new("Frame", {
        Name = "HeaderLine",
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = theme.Stroke,
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, self.Header)

    self.Sidebar = new("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(0, 62),
        Size = UDim2.new(0, self.SideBarWidth, 1, -62),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, self.Gui)
    new("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BackgroundColor3 = theme.Stroke,
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, self.Sidebar)
    self:_text(self.Sidebar, {
        Position = UDim2.fromOffset(16, 12),
        Size = UDim2.new(1, -32, 0, 12),
        Text = "功能导航",
        TextSize = 10,
        TextColor3 = theme.Muted,
    }, "Medium")

    self.NavList = new("ScrollingFrame", {
        Name = "Navigation",
        Position = UDim2.fromOffset(8, 32),
        Size = UDim2.new(1, -16, 1, -(34 + self.BottomHeight)),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 11,
    }, self.Sidebar)
    new("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, self.NavList)

    local userConfig = config.User
    local hasUser = self.HasUserCard
    local bottomHeight = self.BottomHeight
    local sidebarBottom = new("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, bottomHeight),
        BackgroundTransparency = 1,
        ZIndex = 11,
    }, self.Sidebar)
    new("Frame", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = theme.Stroke,
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        ZIndex = 12,
    }, sidebarBottom)

    if hasUser then
        local card = new("TextButton", {
            Name = "UserCard",
            Position = UDim2.fromOffset(8, 7),
            Size = UDim2.new(1, -16, 0, 56),
            BackgroundColor3 = theme.SurfaceAlt,
            BackgroundTransparency = 0.4,
            AutoButtonColor = false,
            Text = "",
            BorderSizePixel = 0,
            ZIndex = 12,
        }, sidebarBottom)
        addCorner(card, 10)
        local avatarFrame = new("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 8, 0.5, 0),
            Size = UDim2.fromOffset(36, 36),
            BackgroundColor3 = library.Accent,
            BackgroundTransparency = 0.78,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 13,
        }, card)
        addCorner(avatarFrame, 11)
        library:_bindAccent(avatarFrame, function(color)
            avatarFrame.BackgroundColor3 = color
        end)
        local avatar = new("ImageLabel", {
            Name = "Avatar",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = "",
            ZIndex = 14,
        }, avatarFrame)
        local initials = library:_text(avatarFrame, {
            Size = UDim2.fromScale(1, 1),
            Text = "?",
            TextSize = 13,
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 15,
        }, "Bold")
        local nameLabel = library:_text(card, {
            Position = UDim2.fromOffset(52, 10),
            Size = UDim2.new(1, -60, 0, 15),
            Text = "玩家",
            TextSize = 11,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 13,
        }, "Medium")
        local stateLabel = library:_text(card, {
            Position = UDim2.fromOffset(52, 27),
            Size = UDim2.new(1, -60, 0, 13),
            Text = "点击切换匿名",
            TextSize = 9,
            TextColor3 = theme.Muted,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 13,
        }, "Regular")

        local user = { Anonymous = userConfig.Anonymous == true, Card = card }
        self.User = user

        local function renderUser()
            local player = Players.LocalPlayer
            local display = user.Name
            if user.Anonymous then
                display = "匿名用户"
                avatar.Image = ""
                initials.Visible = true
                initials.Text = "?"
                stateLabel.Text = "已隐藏身份"
            else
                display = display or (player and player.DisplayName) or "玩家"
                initials.Text = string.upper(string.sub(display, 1, 1))
                stateLabel.Text = "点击切换匿名"
            end
            nameLabel.Text = display
        end

        function user:SetAnonymous(state)
            self.Anonymous = state == true
            renderUser()
            if self.Anonymous then
                avatar.Image = ""
                initials.Visible = true
            end
        end
        function user:SetName(name)
            self.Name = tostring(name or "")
            renderUser()
        end
        function user:GetAnonymous()
            return self.Anonymous
        end

        card.MouseEnter:Connect(function()
            library:_tween(card, 0.15, { BackgroundTransparency = 0.24 })
        end)
        card.MouseLeave:Connect(function()
            library:_tween(card, 0.15, { BackgroundTransparency = 0.4 })
        end)
        card.MouseButton1Click:Connect(function()
            user:SetAnonymous(not user.Anonymous)
            if type(userConfig.Callback) == "function" then
                task.spawn(userConfig.Callback, user.Anonymous)
            end
        end)

        renderUser()
        if not user.Anonymous then
            task.spawn(function()
                local player = Players.LocalPlayer
                if not player then
                    return
                end
                local ok, image = pcall(function()
                    return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                end)
                if ok and type(image) == "string" and image ~= "" and not user.Anonymous then
                    avatar.Image = image
                    initials.Visible = false
                end
            end)
        end
    end

    self.SettingsNavHolder = new("Frame", {
        Position = UDim2.fromOffset(8, hasUser and 72 or 10),
        Size = UDim2.new(1, -16, 0, 36),
        BackgroundTransparency = 1,
        ZIndex = 12,
    }, sidebarBottom)
    self:_text(sidebarBottom, {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -10),
        Size = UDim2.new(1, -20, 0, 14),
        Text = "WindUI  v" .. library.Version,
        TextSize = 9,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 12,
    }, "Regular")

    self.Content = new("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(self.SideBarWidth, 62),
        Size = UDim2.new(1, -self.SideBarWidth, 1, -62),
        BackgroundTransparency = 1,
        ZIndex = 10,
    }, self.Gui)
    self.PageTitle = self:_text(self.Content, {
        Position = UDim2.fromOffset(20, 12),
        Size = UDim2.new(1, -222, 0, 20),
        Text = "欢迎",
        TextSize = 16,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 11,
    }, "Bold")
    self.PageDescription = self:_text(self.Content, {
        Position = UDim2.fromOffset(20, 34),
        Size = UDim2.new(1, -222, 0, 14),
        Text = "开始构建你的界面",
        TextSize = 11,
        TextColor3 = theme.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 11,
    }, "Regular")
    local badge = new("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -18, 0, 21),
        Size = UDim2.fromOffset(68, 22),
        BackgroundColor3 = theme.SurfaceAlt,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, self.Content)
    addCorner(badge, 11)
    local badgeDot = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.fromOffset(5, 5),
        BackgroundColor3 = library.Accent,
        BorderSizePixel = 0,
        ZIndex = 12,
    }, badge)
    addCorner(badgeDot, 3)
    library:_bindAccent(badgeDot, function(color)
        badgeDot.BackgroundColor3 = color
    end)
    self:_text(badge, {
        Position = UDim2.fromOffset(21, 0),
        Size = UDim2.new(1, -24, 1, 0),
        Text = "v" .. library.Version,
        TextSize = 9,
        TextColor3 = theme.SubText,
        ZIndex = 12,
    }, "Medium")
    new("Frame", {
        Position = UDim2.new(0, 0, 0, 63),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = theme.Stroke,
        BackgroundTransparency = 0.93,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, self.Content)

    self.Scroll = new("ScrollingFrame", {
        Name = "Pages",
        Position = UDim2.fromOffset(0, 64),
        Size = UDim2.new(1, 0, 1, -64),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = library.Accent,
        ScrollBarImageTransparency = 0.55,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 11,
    }, self.Content)
    addPadding(self.Scroll, 4, 18, 24, 18)
    new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, self.Scroll)
    library:_bindAccent(self.Scroll, function(color)
        self.Scroll.ScrollBarImageColor3 = color
    end)

    self.TagHolder = new("Frame", {
        Name = "Tags",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -96, 0, 21),
        Size = UDim2.fromOffset(0, 22),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        ZIndex = 11,
    }, self.Content)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    }, self.TagHolder)

    if self.Resizable then
        local grip = new("TextButton", {
            Name = "ResizeGrip",
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -3, 1, -3),
            Size = UDim2.fromOffset(18, 18),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "◢",
            TextColor3 = theme.Muted,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            ZIndex = 40,
        }, self.Gui)
        self.ResizeGrip = grip
    end

    self:_buildSettings()
    self:_initInteraction()
end

function Window:Show()
    if self.Destroyed then
        return
    end
    if not self.Closed and self.Gui.Visible then
        return
    end
    self._visibilityToken = (self._visibilityToken or 0) + 1
    self.Closed = false
    if self.Minimized then
        self.Minimized = false
        self.Gui.Size = self.ExpandedSize
        self.Sidebar.Visible = true
        self.Content.Visible = true
        self.MinimizeButton.Text = "—"
    end
    self.Gui.Visible = true
    self.Shadow.Visible = true
    self.ShadowInner.Visible = true
    self.Gui.GroupTransparency = 1
    local baseScale = self._userScale or 1
    self.Scale.Scale = baseScale * 0.97
    self.Shadow.BackgroundTransparency = 1
    self.ShadowInner.BackgroundTransparency = 1
    self:_clampToViewport()
    self.Library:_tween(self.Gui, 0.24, { GroupTransparency = 0 })
    self.Library:_tween(self.Scale, 0.28, { Scale = baseScale }, Enum.EasingStyle.Back)
    self.Library:_tween(self.Shadow, 0.24, { BackgroundTransparency = 0.84 })
    self.Library:_tween(self.ShadowInner, 0.24, { BackgroundTransparency = 0.64 })
    if self.OpenButton then
        self.OpenButton.Visible = false
    end
    if self.Config.OnOpen then
        task.spawn(self.Config.OnOpen)
    end
end

function Window:_cancelKeybind()
    local active = self.Library._activeKeybind
    if active and active.Window == self then
        active:Cancel()
    end
end

function Window:Close()
    if self.Destroyed or self.Closed then
        return
    end
    self.Closed = true
    self:_cancelKeybind()
    self._visibilityToken = (self._visibilityToken or 0) + 1
    local token = self._visibilityToken
    self.Library:_closeMenu()
    self.Library:_hideTooltip()
    self.Library:_tween(self.Gui, 0.18, { GroupTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    self.Library:_tween(self.Scale, 0.18, { Scale = (self._userScale or 1) * 0.97 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    self.Library:_tween(self.Shadow, 0.18, { BackgroundTransparency = 1 })
    self.Library:_tween(self.ShadowInner, 0.18, { BackgroundTransparency = 1 })
    task.delay(0.2, function()
        if self._visibilityToken == token and self.Closed then
            self.Gui.Visible = false
            self.Shadow.Visible = false
            self.ShadowInner.Visible = false
            if self.OpenButton then
                self.OpenButton.Visible = true
            end
        end
    end)
    if self.Config.OnClose then
        task.spawn(self.Config.OnClose)
    end
end

function Window:Minimize()
    if self.Destroyed or self.Closed or self.Minimized then
        return
    end
    self.Minimized = true
    self:_cancelKeybind()
    self.Library:_closeMenu()
    self.Library:_hideTooltip()
    self.Sidebar.Visible = false
    self.Content.Visible = false
    self.MinimizeButton.Text = "▢"
    self.Library:_tween(self.Gui, 0.24, { Size = self.MinimizedSize }, Enum.EasingStyle.Quint)
    task.delay(0.26, function()
        self:_clampToViewport()
    end)
end

function Window:Restore()
    if self.Destroyed or not self.Minimized then
        return
    end
    self.Minimized = false
    self.Sidebar.Visible = true
    self.Content.Visible = true
    self.MinimizeButton.Text = "—"
    self.Library:_tween(self.Gui, 0.26, { Size = self.ExpandedSize }, Enum.EasingStyle.Quint)
    task.delay(0.28, function()
        self:_clampToViewport()
    end)
end

function Window:ToggleMinimize()
    if self.Minimized then
        self:Restore()
    else
        self:Minimize()
    end
end

function Window:Toggle()
    if self.Closed then
        self:Show()
    else
        self:Close()
    end
end

function Window:SetToggleKey(key)
    if key == false or key == nil then
        self.ToggleKey = nil
    else
        self.ToggleKey = resolveKey(key)
    end
    return self.ToggleKey
end

function Window:SetUIScale(scale)
    local value = math.clamp(tonumber(scale) or 1, 0.5, 1.6)
    self._userScale = value
    if self.Scale then
        self.Scale.Scale = value
    end
    task.defer(function()
        self:_clampToViewport()
    end)
    return value
end

function Window:Tag(options)
    if type(options) ~= "table" or not self.TagHolder then
        return nil
    end
    local library = self.Library
    local theme = library.Theme
    local label = tostring(options.Title or options.Name or "标签")
    local icon = glyph(options.Icon, "")
    local function pillWidth(text)
        local count = utf8.len(text) or #text
        return 18 + math.min(count * 8, 120) + (icon ~= "" and 15 or 0)
    end
    local width = pillWidth(label)
    local pill = new("Frame", {
        Size = UDim2.fromOffset(width, 22),
        BackgroundColor3 = library.Accent,
        BackgroundTransparency = 0.86,
        BorderSizePixel = 0,
        ZIndex = 12,
    }, self.TagHolder)
    addCorner(pill, 11)
    local stroke = addStroke(pill, library.Accent, 0.6, 1)
    library:_bindAccent(pill, function(color)
        pill.BackgroundColor3 = color
        stroke.Color = color
    end)
    local textX = 10
    if icon ~= "" then
        library:_text(pill, {
            Position = UDim2.fromOffset(9, 0),
            Size = UDim2.fromOffset(12, 22),
            Text = icon,
            TextSize = 10,
            TextColor3 = library.Accent,
            ZIndex = 13,
        }, "Bold")
        textX = 23
    end
    library:_text(pill, {
        Position = UDim2.fromOffset(textX, 0),
        Size = UDim2.new(1, -textX - 6, 1, 0),
        Text = label,
        TextSize = 10,
        TextColor3 = theme.Text,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 13,
    }, "Medium")
    local entry = { Instance = pill, Text = label }
    function entry:Set(text)
        label = tostring(text or "")
        pill.Size = UDim2.fromOffset(pillWidth(label), 22)
    end
    function entry:Destroy()
        pill:Destroy()
    end
    self.Tags = self.Tags or {}
    table.insert(self.Tags, entry)
    return entry
end

function Window:EditOpenButton(options)
    options = options or {}
    if self.OpenButton then
        self.OpenButton:Destroy()
        self.OpenButton = nil
    end
    if options.OnlyMobile and not UserInputService.TouchEnabled then
        return nil
    end
    local library = self.Library
    local theme = library.Theme
    local title = tostring(options.Title or self.Config.Title or "打开")
    local onlyIcon = options.OnlyIcon == true
    local width = onlyIcon and 50 or math.clamp(46 + #title * 8, 104, 240)
    local height = 46
    local radius = math.floor(height / 2)
    if typeof(options.CornerRadius) == "UDim" and options.CornerRadius.Scale == 0 then
        radius = math.clamp(options.CornerRadius.Offset, 6, radius)
    end

    local button = new("TextButton", {
        Name = "WindUIOpenButton",
        Position = UDim2.new(0, 24, 0, 96),
        Size = UDim2.fromOffset(width, height),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.04,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 60,
    }, self.Library._gui)
    addCorner(button, radius)
    local stroke = addStroke(button, library.Accent, 0, math.max(1, tonumber(options.StrokeThickness) or 2))
    if typeof(options.Color) == "ColorSequence" then
        new("UIGradient", { Color = options.Color, Rotation = 0 }, stroke)
    else
        library:_bindAccent(stroke, function(color)
            stroke.Color = color
        end)
    end

    local iconSize = 22
    local hasImage = type(options.Icon) == "string" and (options.Icon:sub(1, 11) == "rbxassetid:" or options.Icon:sub(1, 4) == "http")
    local iconX = onlyIcon and math.floor((width - iconSize) / 2) or 12
    if hasImage then
        new("ImageLabel", {
            Position = UDim2.fromOffset(iconX, math.floor((height - iconSize) / 2)),
            Size = UDim2.fromOffset(iconSize, iconSize),
            BackgroundTransparency = 1,
            Image = options.Icon,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 62,
        }, button)
    else
        library:_text(button, {
            Position = UDim2.fromOffset(iconX, 0),
            Size = UDim2.fromOffset(iconSize, height),
            Text = glyph(options.Icon, "✦"),
            TextSize = 14,
            TextColor3 = library.Accent,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 62,
        }, "Bold")
    end
    if not onlyIcon then
        library:_text(button, {
            Position = UDim2.fromOffset(iconX + iconSize + 6, 0),
            Size = UDim2.new(1, -(iconX + iconSize + 14), 1, 0),
            Text = title,
            TextSize = 12,
            TextColor3 = theme.Text,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 62,
        }, "Medium")
    end

    button.MouseEnter:Connect(function()
        library:_tween(button, 0.15, { BackgroundTransparency = -0.06 })
    end)
    button.MouseLeave:Connect(function()
        library:_tween(button, 0.15, { BackgroundTransparency = 0.04 })
    end)

    local startPosition
    local startOffset
    local dragging = false
    button.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if options.Draggable == false then
            return
        end
        dragging = true
        startPosition = input.Position
        startOffset = Vector2.new(button.Position.X.Offset, button.Position.Y.Offset)
    end)
    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local delta = input.Position - startPosition
        local viewport = self:_viewport()
        local x = math.clamp(startOffset.X + delta.X, 0, math.max(0, viewport.X - button.AbsoluteSize.X))
        local y = math.clamp(startOffset.Y + delta.Y, 0, math.max(0, viewport.Y - button.AbsoluteSize.Y))
        button.Position = UDim2.fromOffset(x, y)
    end)
    table.insert(self.Library._globalConnections, connection)

    button.MouseButton1Click:Connect(function()
        self:Show()
    end)

    self.OpenButton = button
    if self.Closed then
        button.Visible = true
    end
    return button
end

function Window:SetBackgroundImage(value)
    local image = tostring(value or "")
    image = image:gsub("^%s+", ""):gsub("%s+$", "")
    if image == "" then
        self.BackgroundImage.Visible = false
        self.BackgroundImage.Image = ""
        return
    end
    if tonumber(image) then
        image = "rbxassetid://" .. image
    end
    self.BackgroundImage.Image = image
    self.BackgroundImage.ImageTransparency = self.ImageTransparency
    self.BackgroundImage.Visible = true
end

function Window:SetImageTransparency(percent)
    percent = math.clamp(tonumber(percent) or 0, 0, 100)
    self.ImageTransparency = percent / 100
    self.BackgroundImage.ImageTransparency = self.ImageTransparency
end

function Window:SetBackgroundDim(percent)
    percent = math.clamp(tonumber(percent) or 0, 0, 100)
    self.BackgroundDim = percent
    self.Tint.BackgroundTransparency = 1 - percent / 100
end

function Window:SetCornerRadius(radius)
    radius = math.clamp(tonumber(radius) or 0, 0, 28)
    self.CornerRadius = radius
    self.Gui.UICorner.CornerRadius = UDim.new(0, radius)
    self.Shadow.UICorner.CornerRadius = UDim.new(0, radius + 22)
    self.ShadowInner.UICorner.CornerRadius = UDim.new(0, radius + 9)
end

function Window:SetAccent(color)
    self.Library:SetAccent(color)
end

function Window:SetFont(name)
    self.Library:SetFont(name)
end

function Window:Notify(data)
    return self.Library:Notify(data)
end

function Window:Announce(options)
    options = options or {}
    if self.Destroyed then
        return
    end
    if self.Announcement then
        self.Announcement.Dismiss()
    end
    local library = self.Library
    local theme = library.Theme
    local token = {}
    local canvas = new("CanvasGroup", {
        Name = "Announcement",
        Position = UDim2.new(0, 12, 0, 66),
        Size = UDim2.new(1, -24, 0, 54),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.02,
        GroupTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 45,
    }, self.Gui)
    addCorner(canvas, 10)
    local announcementStroke = addStroke(canvas, library.Accent, 0.72, 1)
    library:_bindAccent(announcementStroke, function(color)
        announcementStroke.Color = color
    end)
    local scale = new("UIScale", { Scale = 0.98 }, canvas)
    local strip = new("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = library.Accent,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, canvas)
    library:_bindAccent(strip, function(color)
        strip.BackgroundColor3 = color
    end)
    local iconBox = new("Frame", {
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = library.Accent,
        BackgroundTransparency = 0.84,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, canvas)
    addCorner(iconBox, 9)
    library:_bindAccent(iconBox, function(color)
        iconBox.BackgroundColor3 = color
    end)
    local announcementIcon = library:_text(iconBox, {
        Size = UDim2.fromScale(1, 1),
        Text = glyph(options.Icon, "✦"),
        TextSize = 13,
        TextColor3 = library.Accent,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 3,
    }, "Bold")
    library:_bindAccent(announcementIcon, function(color)
        announcementIcon.TextColor3 = color
    end)
    library:_text(canvas, {
        Position = UDim2.fromOffset(52, 9),
        Size = UDim2.new(1, -92, 0, 16),
        Text = options.Title or "公告",
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 2,
    }, "Bold")
    library:_text(canvas, {
        Position = UDim2.fromOffset(52, 27),
        Size = UDim2.new(1, -92, 0, 18),
        Text = options.Text or options.Content or "",
        TextSize = 10,
        TextColor3 = theme.SubText,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 2,
    }, "Regular")
    local close = library:_text(canvas, {
        ClassName = "TextButton",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -9, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "✕",
        TextColor3 = theme.Muted,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 3,
    }, "Regular")
    local announcement = {}
    local dismissed = false
    function announcement.Dismiss()
        if dismissed then
            return
        end
        dismissed = true
        if self.Announcement == announcement then
            self.Announcement = nil
        end
        if not canvas or not canvas.Parent then
            return
        end
        library:_tween(canvas, 0.18, { GroupTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        library:_tween(scale, 0.18, { Scale = 0.98 })
        task.delay(0.2, function()
            if canvas and canvas.Parent then
                canvas:Destroy()
            end
        end)
    end
    close.MouseButton1Click:Connect(announcement.Dismiss)
    self.Announcement = announcement
    library:_tween(canvas, 0.24, { GroupTransparency = 0 })
    library:_tween(scale, 0.26, { Scale = 1 }, Enum.EasingStyle.Back)
    if options.Duration == nil then
        options.Duration = 7
    end
    if options.Duration > 0 then
        task.delay(options.Duration, function()
            if not dismissed then
                announcement.Dismiss()
            end
        end)
    end
    return announcement
end

function Window:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    self._visibilityToken = (self._visibilityToken or 0) + 1
    self.Library:_closeMenu()
    self.Library:_hideTooltip()
    self.Library.KeybindCapturing = false
    self.Library._activeKeybind = nil
    for _, connection in ipairs(self._connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    self._connections = {}
    if self.Announcement then
        self.Announcement.Dismiss()
        self.Announcement = nil
    end
    if self.Gui then
        self.Gui:Destroy()
    end
    if self.Shadow then
        self.Shadow:Destroy()
    end
    if self.ShadowInner then
        self.ShadowInner:Destroy()
    end
    if self.OpenButton then
        self.OpenButton:Destroy()
        self.OpenButton = nil
    end
    if self.Tags then
        for _, tag in ipairs(self.Tags) do
            pcall(function()
                tag:Destroy()
            end)
        end
        self.Tags = {}
    end
    for index = #self.Library._windows, 1, -1 do
        if self.Library._windows[index] == self then
            table.remove(self.Library._windows, index)
        end
    end
end

local function bindRowHover(library, row, object)
    object.MouseEnter:Connect(function()
        library:_tween(row, 0.14, { BackgroundTransparency = 0.34 })
    end)
    object.MouseLeave:Connect(function()
        library:_tween(row, 0.14, { BackgroundTransparency = 0.5 })
    end)
end

Tab = {}
Tab.__index = Tab

function Tab:Select()
    self.Window:_selectTab(self)
end

function Tab:Section(options)
    options = compat(options)
    local library = self.Window.Library
    local theme = library.Theme
    self.SectionCount = (self.SectionCount or 0) + 1
    local frame = new("Frame", {
        Name = options.Title or "Section",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.14,
        BorderSizePixel = 0,
        LayoutOrder = self.SectionCount,
    }, self.Page)
    addCorner(frame, 12)
    addStroke(frame, theme.Stroke, 0.93, 1)
    new("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, frame)
    addPadding(frame, 14, 14, 14, 14)

    local header = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
    }, frame)
    local dot = new("Frame", {
        Position = UDim2.fromOffset(0, 2),
        Size = UDim2.fromOffset(3, 14),
        BackgroundColor3 = library.Accent,
        BorderSizePixel = 0,
    }, header)
    addCorner(dot, 2)
    library:_bindAccent(dot, function(color)
        dot.BackgroundColor3 = color
    end)
    library:_text(header, {
        Position = UDim2.fromOffset(11, 0),
        Size = UDim2.new(1, -11, 0, 16),
        Text = options.Title or "设置",
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, "Medium")
    if options.Description and options.Description ~= "" then
        library:_text(header, {
            Position = UDim2.fromOffset(11, 20),
            Size = UDim2.new(1, -11, 0, 14),
            Text = options.Description,
            TextSize = 10,
            TextColor3 = theme.SubText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Regular")
    end

    local content = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
    }, frame)
    new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, content)

    local opened = options.Opened ~= false
    local chevron = library:_text(header, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(14, 16),
        Text = opened and "▾" or "▸",
        TextSize = 11,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 5,
    }, "Medium")
    local headerHit = new("TextButton", {
        Name = "SectionHeader",
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 4,
    }, header)
    content.Visible = opened
    headerHit.MouseButton1Click:Connect(function()
        opened = not opened
        content.Visible = opened
        chevron.Text = opened and "▾" or "▸"
    end)

    local section = setmetatable({
        Window = self.Window,
        Tab = self,
        Frame = frame,
        Content = content,
        Count = 0,
    }, Section)
    function section:SetOpened(state)
        opened = state and true or false
        content.Visible = opened
        chevron.Text = opened and "▾" or "▸"
    end
    function section:GetOpened()
        return opened
    end
    return section
end

Section = {}
Section.__index = Section

function Section:_row(height)
    local library = self.Window.Library
    self.Count = self.Count + 1
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = library.Theme.SurfaceAlt,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = self.Count,
    }, self.Content)
    addCorner(row, 9)
    return row
end

function Section:Toggle(options)
    options = compat(options)
    if options.Description == "" then
        options.Description = nil
    end
    local library = self.Window.Library
    local theme = library.Theme
    local state = options.Default == true
    local row = self:_row(46)
    library:_text(row, {
        Position = UDim2.new(0, 12, options.Description and 0 or 0.5, options.Description and 6 or -8),
        Size = UDim2.new(1, -76, 0, 16),
        Text = options.Name or "开关",
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, "Medium")
    if options.Description and options.Description ~= "" then
        library:_text(row, {
            Position = UDim2.fromOffset(12, 24),
            Size = UDim2.new(1, -76, 0, 14),
            Text = options.Description,
            TextSize = 10,
            TextColor3 = theme.SubText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Regular")
    end

    local switch = new("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(40, 22),
        BackgroundColor3 = theme.Elevated,
        BorderSizePixel = 0,
    }, row)
    addCorner(switch, 11)
    local switchStroke = addStroke(switch, theme.Stroke, 0.9, 1)
    local knob = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    }, switch)
    addCorner(knob, 8)

    local hit = new("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 5,
    }, row)

    local function render(animate)
        if state then
            if animate then
                library:_tween(switch, 0.16, { BackgroundColor3 = library.Accent })
                library:_tween(knob, 0.18, { Position = UDim2.new(1, -19, 0.5, 0) }, Enum.EasingStyle.Quint)
            else
                switch.BackgroundColor3 = library.Accent
                knob.Position = UDim2.new(1, -19, 0.5, 0)
            end
            switchStroke.Color = library.Accent
            switchStroke.Transparency = 0.4
        else
            if animate then
                library:_tween(switch, 0.16, { BackgroundColor3 = theme.Elevated })
                library:_tween(knob, 0.18, { Position = UDim2.new(0, 3, 0.5, 0) }, Enum.EasingStyle.Quint)
            else
                switch.BackgroundColor3 = theme.Elevated
                knob.Position = UDim2.new(0, 3, 0.5, 0)
            end
            switchStroke.Color = theme.Stroke
            switchStroke.Transparency = 0.9
        end
    end

    local toggle = {}
    function toggle:Set(value, fire)
        state = value and true or false
        render(true)
        if fire and options.Callback then
            task.spawn(options.Callback, state)
        end
    end
    function toggle:Get()
        return state
    end
    toggle.Instance = row

    hit.MouseButton1Click:Connect(function()
        state = not state
        render(true)
        if options.Callback then
            task.spawn(options.Callback, state)
        end
    end)
    bindRowHover(library, row, hit)
    addTooltip(library, hit, options.Tooltip)
    library:_bindAccent(switch, function(color)
        if state then
            switch.BackgroundColor3 = color
            switchStroke.Color = color
        end
    end)
    if options.Flag then
        self.Window.Flags[options.Flag] = toggle
    end
    render(false)
    return withValue(toggle, function()
        return state
    end, function(value)
        toggle:Set(value)
    end)
end

function Section:Button(options)
    options = compat(options)
    if options.Description == "" then
        options.Description = nil
    end
    local library = self.Window.Library
    local theme = library.Theme
    local primary = options.Variant == "Primary" or options.Variant == "Accent"
    local height = options.Description and 56 or 42
    self.Count = self.Count + 1
    local button = new("TextButton", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = primary and library.Accent or theme.SurfaceAlt,
        BackgroundTransparency = primary and 0 or 0.42,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = self.Count,
    }, self.Content)
    addCorner(button, 9)
    if primary then
        local primaryStroke = addStroke(button, library.Accent, 0.25, 1)
        local gradient = new("UIGradient", { Rotation = 0 }, button)
        library:_bindAccent(button, function(color)
            button.BackgroundColor3 = color
            gradient.Color = accentSequence(color)
            primaryStroke.Color = color
        end)
    else
        addStroke(button, theme.Stroke, 0.93, 1)
    end
    local hover = new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1,
    }, button)
    addCorner(hover, 9)
    local scale = new("UIScale", { Scale = 1 }, button)

    local textX = 12
    if options.Icon and options.Icon ~= "" then
        local chip = new("Frame", {
            Position = UDim2.fromOffset(10, height / 2 - 13),
            Size = UDim2.fromOffset(26, 26),
            BackgroundColor3 = primary and Color3.new(1, 1, 1) or library.Accent,
            BackgroundTransparency = primary and 0.84 or 0.86,
            BorderSizePixel = 0,
            ZIndex = 2,
        }, button)
        addCorner(chip, 8)
        local icon = library:_text(chip, {
            Size = UDim2.fromScale(1, 1),
            Text = options.Icon,
            TextSize = 12,
            TextColor3 = primary and Color3.new(1, 1, 1) or library.Accent,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 3,
        }, "Medium")
        if not primary then
            library:_bindAccent(chip, function(color)
                chip.BackgroundColor3 = color
            end)
            library:_bindAccent(icon, function(color)
                icon.TextColor3 = color
            end)
        end
        textX = 46
    end
    local title = library:_text(button, {
        Position = options.Description and UDim2.new(0, textX, 0, 8) or UDim2.new(0, textX, 0.5, -8),
        Size = UDim2.new(1, -textX - 34, 0, 16),
        Text = options.Name or "按钮",
        TextSize = 12,
        TextColor3 = primary and Color3.new(1, 1, 1) or theme.Text,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 2,
    }, "Medium")
    if options.Description and options.Description ~= "" then
        library:_text(button, {
            Position = UDim2.fromOffset(textX, 27),
            Size = UDim2.new(1, -textX - 34, 0, 14),
            Text = options.Description,
            TextSize = 10,
            TextColor3 = primary and Color3.fromRGB(238, 238, 255) or theme.SubText,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 2,
        }, "Regular")
    end
    library:_text(button, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -13, 0.5, 0),
        Size = UDim2.fromOffset(16, 20),
        Text = "›",
        TextSize = 16,
        TextColor3 = primary and Color3.fromRGB(238, 238, 255) or theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 2,
    }, "Medium")

    button.MouseEnter:Connect(function()
        library:_tween(hover, 0.14, { BackgroundTransparency = primary and 0.9 or 0.93 })
    end)
    button.MouseLeave:Connect(function()
        library:_tween(hover, 0.14, { BackgroundTransparency = 1 })
        library:_tween(scale, 0.12, { Scale = 1 })
    end)
    button.MouseButton1Down:Connect(function()
        library:_tween(scale, 0.1, { Scale = 0.985 })
    end)
    button.MouseButton1Up:Connect(function()
        library:_tween(scale, 0.12, { Scale = 1 })
    end)
    button.MouseButton1Click:Connect(function()
        if options.Callback then
            task.spawn(options.Callback)
        end
    end)
    addTooltip(library, button, options.Tooltip)
    local object = { Instance = button }
    function object:SetText(value)
        title.Text = tostring(value)
    end
    return object
end

function Section:Slider(options)
    options = compat(options)
    if options.Description == "" then
        options.Description = nil
    end
    local library = self.Window.Library
    local theme = library.Theme
    local window = self.Window
    local minimum = tonumber(options.Min) or 0
    local maximum = tonumber(options.Max) or 100
    if maximum < minimum then
        minimum, maximum = maximum, minimum
    end
    local step = tonumber(options.Step) or 1
    if step <= 0 then
        step = 1
    end
    local decimals = options.Decimals
    if decimals == nil then
        decimals = 0
        if step < 1 then
            decimals = 1
        end
        if step < 0.1 then
            decimals = 2
        end
    end
    local value = math.clamp(tonumber(options.Default) or minimum, minimum, maximum)
    value = minimum + math.floor((value - minimum) / step + 0.5) * step
    value = math.clamp(value, minimum, maximum)
    local rowHeight = options.Description and 72 or 58
    local row = self:_row(rowHeight)
    library:_text(row, {
        Position = UDim2.fromOffset(12, 6),
        Size = UDim2.new(1, -112, 0, 16),
        Text = options.Name or "滑块",
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, "Medium")
    if options.Description and options.Description ~= "" then
        library:_text(row, {
            Position = UDim2.fromOffset(12, 23),
            Size = UDim2.new(1, -112, 0, 14),
            Text = options.Description,
            TextSize = 10,
            TextColor3 = theme.SubText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Regular")
    end
    local valueLabel = library:_text(row, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 7),
        Size = UDim2.fromOffset(84, 14),
        Text = "",
        TextSize = 10,
        TextColor3 = library.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, "Medium")
    library:_bindAccent(valueLabel, function(color)
        valueLabel.TextColor3 = color
    end)
    local trackY = options.Description and 48 or 34
    local holder = new("Frame", {
        Position = UDim2.fromOffset(12, trackY),
        Size = UDim2.new(1, -24, 0, 18),
        BackgroundTransparency = 1,
        ZIndex = 2,
    }, row)
    local track = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = theme.Elevated,
        BorderSizePixel = 0,
    }, holder)
    addCorner(track, 3)
    local fill = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 6),
        BackgroundColor3 = library.Accent,
        BorderSizePixel = 0,
    }, track)
    addCorner(fill, 3)
    local knob = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 3,
    }, holder)
    addCorner(knob, 7)
    local knobStroke = addStroke(knob, library.Accent, 0.1, 2)
    local hit = new("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 6,
    }, holder)

    local slider = {}
    local dragging = false
    local function formatValue()
        return string.format("%." .. decimals .. "f", value) .. (options.Suffix or "")
    end
    local function applyVisual(animate)
        local fraction = (value - minimum) / (maximum - minimum)
        if maximum == minimum then
            fraction = 0
        end
        if animate then
            library:_tween(fill, 0.1, { Size = UDim2.new(fraction, 0, 0, 6) })
            library:_tween(knob, 0.1, { Position = UDim2.new(fraction, 0, 0.5, 0) })
        else
            fill.Size = UDim2.new(fraction, 0, 0, 6)
            knob.Position = UDim2.new(fraction, 0, 0.5, 0)
        end
        valueLabel.Text = formatValue()
    end
    local function updateFromPosition(position)
        local trackPosition = track.AbsolutePosition
        local trackSize = track.AbsoluteSize
        if trackSize.X <= 0 then
            return
        end
        local fraction = math.clamp((position.X - trackPosition.X) / trackSize.X, 0, 1)
        local raw = minimum + fraction * (maximum - minimum)
        raw = minimum + math.floor((raw - minimum) / step + 0.5) * step
        value = math.clamp(raw, minimum, maximum)
        applyVisual(false)
    end
    function slider:Set(newValue, fire)
        local raw = math.clamp(tonumber(newValue) or minimum, minimum, maximum)
        raw = minimum + math.floor((raw - minimum) / step + 0.5) * step
        value = math.clamp(raw, minimum, maximum)
        applyVisual(true)
        if fire and options.Callback then
            task.spawn(options.Callback, value)
        end
    end
    function slider:Get()
        return value
    end
    slider.Instance = row

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromPosition(input.Position)
        end
    end)
    window:_track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromPosition(input.Position)
        end
    end))
    window:_track(UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            if options.Callback then
                task.spawn(options.Callback, value)
            end
        end
    end))
    bindRowHover(library, row, hit)
    addTooltip(library, hit, options.Tooltip)
    library:_bindAccent(fill, function(color)
        fill.BackgroundColor3 = color
    end)
    library:_bindAccent(knobStroke, function(color)
        knobStroke.Color = color
    end)
    if options.Flag then
        self.Window.Flags[options.Flag] = slider
    end
    applyVisual(false)
    return withValue(slider, function()
        return value
    end, function(newValue)
        slider:Set(newValue)
    end)
end

function Section:_dropdown(options, multiple)
    options = compat(options)
    if options.Description == "" then
        options.Description = nil
    end
    local library = self.Window.Library
    local theme = library.Theme
    local window = self.Window
    local function parseItems(list)
        local parsed = {}
        for _, raw in ipairs(list or {}) do
            if type(raw) == "table" then
                local value = raw.Value
                if value == nil then
                    value = raw.Text
                end
                if value == nil then
                    value = ""
                end
                parsed[#parsed + 1] = {
                    Text = tostring(raw.Text or value or ""),
                    Value = value,
                    Icon = raw.Icon,
                }
            else
                parsed[#parsed + 1] = {
                    Text = tostring(raw),
                    Value = raw,
                }
            end
        end
        return parsed
    end
    local items = parseItems(options.Options)
    local placeholder = options.Placeholder or "请选择…"
    local row = self:_row(50)
    library:_text(row, {
        Position = UDim2.new(0, 12, options.Description and 0 or 0.5, options.Description and 6 or -8),
        Size = UDim2.new(1, -206, 0, 16),
        Text = options.Name or "下拉选项",
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, "Medium")
    if options.Description and options.Description ~= "" then
        library:_text(row, {
            Position = UDim2.fromOffset(12, 24),
            Size = UDim2.new(1, -206, 0, 14),
            Text = options.Description,
            TextSize = 10,
            TextColor3 = theme.SubText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Regular")
    end

    local field = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(172, 32),
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = 0.25,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 3,
    }, row)
    addCorner(field, 8)
    addStroke(field, theme.Stroke, 0.9, 1)
    local fieldText = library:_text(field, {
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Text = placeholder,
        TextSize = 11,
        TextColor3 = theme.Muted,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 4,
    }, "Medium")
    local chevron = library:_text(field, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        Text = "▾",
        TextSize = 11,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 4,
    }, "Regular")

    local current
    local selected = {}
    if multiple then
        if type(options.Default) == "table" then
            for _, value in ipairs(options.Default) do
                selected[value] = true
            end
        elseif options.Default ~= nil then
            selected[options.Default] = true
        end
    else
        current = options.Default
        if type(current) == "number" and items[current] then
            current = items[current].Value
        end
    end

    local function indexOf(value)
        for _, item in ipairs(items) do
            if item.Value == value then
                return item
            end
        end
        return nil
    end
    local function getSelected()
        local values = {}
        for _, item in ipairs(items) do
            if selected[item.Value] then
                values[#values + 1] = item.Value
            end
        end
        return values
    end
    local function updateField()
        if multiple then
            local names = {}
            local count = 0
            for _, item in ipairs(items) do
                if selected[item.Value] then
                    count = count + 1
                    names[#names + 1] = item.Text
                end
            end
            if count == 0 then
                fieldText.Text = placeholder
                fieldText.TextColor3 = theme.Muted
            else
                fieldText.TextColor3 = theme.Text
                if count <= 2 then
                    fieldText.Text = table.concat(names, " / ")
                else
                    fieldText.Text = tostring(count) .. " 项已选择"
                end
            end
        else
            local item = indexOf(current)
            if item then
                fieldText.Text = item.Text
                fieldText.TextColor3 = theme.Text
            else
                fieldText.Text = placeholder
                fieldText.TextColor3 = theme.Muted
            end
        end
    end

    local isOpen = false
    local function openMenu()
        if isOpen then
            library:_closeMenu()
            return
        end
        local viewport = window:_viewport()
        local fieldPosition = field.AbsolutePosition
        local fieldSize = field.AbsoluteSize
        local width = math.max(196, fieldSize.X)
        local listHeight = math.min(math.max(#items * 34 + 6, 42), 232)
        local footerHeight = multiple and 40 or 0
        local height = listHeight + footerHeight + 12
        local x = math.clamp(fieldPosition.X, 8, math.max(8, viewport.X - width - 8))
        local y = fieldPosition.Y + fieldSize.Y + 6
        if y + height > viewport.Y - 8 then
            y = fieldPosition.Y - height - 6
        end
        y = math.clamp(y, 8, math.max(8, viewport.Y - height - 8))

        local backdrop = new("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            BorderSizePixel = 0,
            ZIndex = 1,
        })
        backdrop.MouseButton1Click:Connect(function()
            library:_closeMenu()
        end)
        local menu = new("Frame", {
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, height),
            BackgroundColor3 = theme.Elevated,
            BackgroundTransparency = 0.02,
            BorderSizePixel = 0,
            ZIndex = 2,
        })
        addCorner(menu, 10)
        addStroke(menu, theme.Stroke, 0.86, 1)
        local scroller = new("ScrollingFrame", {
            Position = UDim2.fromOffset(6, 6),
            Size = UDim2.new(1, -12, 0, listHeight),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = library.Accent,
            ScrollBarImageTransparency = 0.5,
            ZIndex = 2,
        }, menu)
        new("UIListLayout", {
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, scroller)

        if #items == 0 then
            library:_text(scroller, {
                Size = UDim2.new(1, 0, 0, 32),
                Text = "暂无选项",
                TextSize = 11,
                TextColor3 = theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Center,
            }, "Regular")
        end

        for index, item in ipairs(items) do
            local option = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = theme.SurfaceAlt,
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Text = "",
                BorderSizePixel = 0,
                LayoutOrder = index,
                ZIndex = 2,
            }, scroller)
            addCorner(option, 7)
            local check
            local checkbox
            local checkboxStroke
            local optionTextX = 9
            if multiple then
                optionTextX = 32
                checkbox = new("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 9, 0.5, 0),
                    Size = UDim2.fromOffset(16, 16),
                    BackgroundColor3 = library.Accent,
                    BackgroundTransparency = selected[item.Value] and 0 or 1,
                    BorderSizePixel = 0,
                    ZIndex = 3,
                }, option)
                addCorner(checkbox, 4)
                checkboxStroke = addStroke(checkbox, theme.Stroke, selected[item.Value] and 1 or 0.55, 1)
                check = library:_text(checkbox, {
                    Size = UDim2.fromScale(1, 1),
                    Text = "✓",
                    TextSize = 9,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    Visible = selected[item.Value] == true,
                    ZIndex = 4,
                }, "Bold")
            end
            if item.Icon and item.Icon ~= "" then
                library:_text(option, {
                    Position = UDim2.fromOffset(optionTextX, 0),
                    Size = UDim2.fromOffset(16, 32),
                    Text = item.Icon,
                    TextSize = 12,
                    TextColor3 = theme.SubText,
                    ZIndex = 3,
                }, "Medium")
                optionTextX = optionTextX + 20
            end
            local label = library:_text(option, {
                Position = UDim2.fromOffset(optionTextX, 0),
                Size = UDim2.new(1, -optionTextX - (multiple and 8 or 24), 1, 0),
                Text = item.Text,
                TextSize = 11,
                TextColor3 = (not multiple and current == item.Value) and library.Accent or theme.Text,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 3,
            }, "Medium")
            if not multiple then
                local mark = library:_text(option, {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.fromOffset(14, 14),
                    Text = "✓",
                    TextSize = 10,
                    TextColor3 = library.Accent,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Visible = current == item.Value,
                    ZIndex = 3,
                }, "Bold")
                check = mark
            end
            local function paint(hovered)
                if not multiple and current == item.Value then
                    option.BackgroundColor3 = library.Accent
                    option.BackgroundTransparency = hovered and 0.86 or 0.91
                else
                    option.BackgroundColor3 = theme.SurfaceAlt
                    option.BackgroundTransparency = hovered and 0.55 or 1
                end
            end
            paint(false)
            option.MouseEnter:Connect(function()
                paint(true)
            end)
            option.MouseLeave:Connect(function()
                paint(false)
            end)
            option.MouseButton1Click:Connect(function()
                if multiple then
                    selected[item.Value] = not selected[item.Value] or nil
                    local isSelected = selected[item.Value] == true
                    check.Visible = isSelected
                    checkbox.BackgroundTransparency = isSelected and 0 or 1
                    checkboxStroke.Transparency = isSelected and 1 or 0.55
                    updateField()
                    if options.Callback then
                        task.spawn(options.Callback, getSelected())
                    end
                else
                    current = item.Value
                    updateField()
                    library:_closeMenu()
                    if options.Callback then
                        task.spawn(options.Callback, current)
                    end
                end
            end)
        end

        if multiple then
            local divider = new("Frame", {
                Position = UDim2.new(0, 0, 1, -footerHeight),
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = theme.Stroke,
                BackgroundTransparency = 0.9,
                BorderSizePixel = 0,
                ZIndex = 2,
            }, menu)
            local done = new("TextButton", {
                Position = UDim2.new(0, 6, 1, -footerHeight + 7),
                Size = UDim2.new(1, -12, 0, 26),
                BackgroundColor3 = library.Accent,
                BackgroundTransparency = 0.12,
                AutoButtonColor = false,
                Text = "完成",
                BorderSizePixel = 0,
                Font = library:_fontFor("Medium"),
                TextSize = 11,
                TextColor3 = Color3.new(1, 1, 1),
                ZIndex = 2,
            }, menu)
            addCorner(done, 7)
            library:_bindAccent(done, function(color)
                done.BackgroundColor3 = color
            end)
            done.MouseButton1Click:Connect(function()
                library:_closeMenu()
            end)
        end

        library:_showMenu(menu, backdrop, function()
            isOpen = false
            chevron.Text = "▾"
            chevron.TextColor3 = theme.Muted
        end)
        isOpen = true
        chevron.Text = "▴"
        chevron.TextColor3 = library.Accent
    end

    local dropdown = {}
    function dropdown:Set(value)
        if multiple then
            selected = {}
            if type(value) == "table" then
                for _, item in ipairs(value) do
                    selected[item] = true
                end
            elseif value ~= nil then
                selected[value] = true
            end
        else
            if type(value) == "number" and items[value] then
                value = items[value].Value
            end
            current = value
        end
        updateField()
    end
    function dropdown:Get()
        if multiple then
            return getSelected()
        end
        return current
    end
    function dropdown:Select(value, fire)
        dropdown:Set(value)
        if fire ~= false and options.Callback then
            task.spawn(options.Callback, dropdown:Get())
        end
    end
    function dropdown:Refresh(list)
        items = parseItems(list)
        if multiple then
            for value in pairs(selected) do
                if not indexOf(value) then
                    selected[value] = nil
                end
            end
        elseif current ~= nil and not indexOf(current) then
            current = nil
        end
        updateField()
        return dropdown
    end
    dropdown.Instance = row
    dropdown.Field = field

    field.MouseEnter:Connect(function()
        library:_tween(field, 0.14, { BackgroundTransparency = 0.12 })
    end)
    field.MouseLeave:Connect(function()
        library:_tween(field, 0.14, { BackgroundTransparency = 0.25 })
    end)
    field.MouseButton1Click:Connect(openMenu)
    addTooltip(library, field, options.Tooltip)
    if options.Flag then
        self.Window.Flags[options.Flag] = dropdown
    end
    updateField()
    return withValue(dropdown, function()
        return dropdown:Get()
    end, function(value)
        dropdown:Set(value)
    end)
end

function Section:Dropdown(options)
    return self:_dropdown(options, false)
end

function Section:MultiDropdown(options)
    return self:_dropdown(options, true)
end

function Section:Keybind(options)
    options = compat(options)
    if options.Description == "" then
        options.Description = nil
    end
    local library = self.Window.Library
    local theme = library.Theme
    local window = self.Window
    local row = self:_row(46)
    local current = resolveKey(options.Default)
    library:_text(row, {
        Position = UDim2.new(0, 12, options.Description and 0 or 0.5, options.Description and 6 or -8),
        Size = UDim2.new(1, -172, 0, 16),
        Text = options.Name or "快捷键",
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, "Medium")
    if options.Description and options.Description ~= "" then
        library:_text(row, {
            Position = UDim2.fromOffset(12, 24),
            Size = UDim2.new(1, -172, 0, 14),
            Text = options.Description,
            TextSize = 10,
            TextColor3 = theme.SubText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Regular")
    end
    local field = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(138, 32),
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = 0.25,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 3,
    }, row)
    addCorner(field, 8)
    addStroke(field, theme.Stroke, 0.9, 1)
    local fieldLabel = library:_text(field, {
        Size = UDim2.fromScale(1, 1),
        Text = keyName(current),
        TextSize = 11,
        TextColor3 = current and library.Accent or theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 4,
    }, "Medium")
    library:_bindAccent(fieldLabel, function(color)
        if current then
            fieldLabel.TextColor3 = color
        end
    end)

    local keybind = {}
    local listening = false
    local listenConnection
    local function stopListening()
        listening = false
        if listenConnection then
            listenConnection:Disconnect()
            listenConnection = nil
        end
        if library._activeKeybind == keybind then
            library._activeKeybind = nil
            library.KeybindCapturing = false
        end
        field.BackgroundColor3 = theme.Background
        field.BackgroundTransparency = 0.25
        fieldLabel.Text = keyName(current)
        fieldLabel.TextColor3 = current and library.Accent or theme.Muted
    end
    function keybind:Cancel()
        if listening then
            stopListening()
        end
    end
    function keybind:Set(key, fire)
        current = resolveKey(key)
        fieldLabel.Text = keyName(current)
        fieldLabel.TextColor3 = current and library.Accent or theme.Muted
        if fire and options.Callback then
            task.spawn(options.Callback, current)
        end
    end
    function keybind:Get()
        return current
    end
    keybind.Instance = row
    keybind.Window = window
    keybind.Field = field

    local trigger = UserInputService.InputBegan:Connect(function(input, processed)
        if processed or not current then
            return
        end
        if input.KeyCode ~= current then
            return
        end
        if library.KeybindCapturing or UserInputService:GetFocusedTextBox() then
            return
        end
        if options.Callback then
            task.spawn(options.Callback, current)
        end
    end)
    window:_track(trigger)

    if options.Locked then
        fieldLabel.TextColor3 = theme.Muted
    end
    if options.Flag then
        self.Window.Flags[options.Flag] = keybind
    end

    local function startListening()
        if options.Locked then
            return
        end
        if listening then
            stopListening()
            return
        end
        if library._activeKeybind then
            library._activeKeybind:Cancel()
        end
        library:_closeMenu()
        listening = true
        library.KeybindCapturing = true
        library._activeKeybind = keybind
        fieldLabel.Text = "按下按键…"
        fieldLabel.TextColor3 = library.Accent
        field.BackgroundColor3 = library.Accent
        field.BackgroundTransparency = 0.86
        listenConnection = UserInputService.InputBegan:Connect(function(input)
            local key = input.KeyCode
            if key == Enum.KeyCode.Unknown then
                return
            end
            if key == Enum.KeyCode.Escape then
                stopListening()
                return
            end
            if key == Enum.KeyCode.Backspace then
                keybind:Set(nil, true)
                stopListening()
                return
            end
            keybind:Set(key, true)
            stopListening()
        end)
        window:_track(listenConnection)
    end

    field.MouseEnter:Connect(function()
        if not listening then
            library:_tween(field, 0.14, { BackgroundTransparency = 0.12 })
        end
    end)
    field.MouseLeave:Connect(function()
        if not listening then
            library:_tween(field, 0.14, { BackgroundTransparency = 0.25 })
        end
    end)
    field.MouseButton1Click:Connect(startListening)
    field.MouseButton2Click:Connect(function()
        keybind:Set(nil, true)
        stopListening()
    end)
    addTooltip(library, field, options.Locked and "已锁定，无法修改" or (options.Tooltip or "点击后按下按键，Esc 取消，Backspace 清除"))
    return withValue(keybind, function()
        return keyName(current)
    end, function(value)
        keybind:Set(value)
    end)
end

function Section:Input(options)
    options = compat(options)
    local library = self.Window.Library
    local theme = library.Theme
    local hasDescription = options.Description and options.Description ~= ""
    local row = self:_row(hasDescription and 84 or 66)
    library:_text(row, {
        Position = UDim2.fromOffset(12, 6),
        Size = UDim2.new(1, -24, 0, 16),
        Text = options.Name or "输入框",
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, "Medium")
    if hasDescription then
        library:_text(row, {
            Position = UDim2.fromOffset(12, 23),
            Size = UDim2.new(1, -24, 0, 14),
            Text = options.Description,
            TextSize = 10,
            TextColor3 = theme.SubText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Regular")
    end
    local box = new("TextBox", {
        Position = UDim2.fromOffset(10, hasDescription and 42 or 27),
        Size = UDim2.new(1, -20, 0, 32),
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = options.Default or "",
        PlaceholderText = options.Placeholder or "输入内容…",
        PlaceholderColor3 = theme.Muted,
        TextColor3 = theme.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 3,
    }, row)
    addCorner(box, 8)
    local boxStroke = addStroke(box, theme.Stroke, 0.9, 1)
    addPadding(box, 0, 9, 0, 9)
    library:_registerText(box, "Regular")
    box.Focused:Connect(function()
        boxStroke.Color = library.Accent
        boxStroke.Transparency = 0.4
    end)
    box.FocusLost:Connect(function()
        boxStroke.Color = theme.Stroke
        boxStroke.Transparency = 0.9
        if options.Callback then
            task.spawn(options.Callback, box.Text)
        end
    end)
    addTooltip(library, box, options.Tooltip)
    local object = {
        Instance = row,
        Field = box,
    }
    function object:Get()
        return box.Text
    end
    function object:Set(value)
        box.Text = tostring(value or "")
    end
    if options.Flag then
        self.Window.Flags[options.Flag] = object
    end
    return withValue(object, function()
        return box.Text
    end, function(value)
        box.Text = tostring(value or "")
    end)
end

function Section:Paragraph(options)
    options = compat(options)
    local library = self.Window.Library
    self.Count = self.Count + 1
    local label = library:_text(self.Content, {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Text = options.Text or "",
        TextSize = options.TextSize or 11,
        TextColor3 = options.Color or library.Theme.SubText,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        LineHeight = 1.35,
        LayoutOrder = self.Count,
    }, "Regular")
    return label
end

Section.Label = Section.Paragraph

local HttpService = game:GetService("HttpService")

local ConfigManager = {}
ConfigManager.__index = ConfigManager

local function ensureFolder(path)
    if type(path) ~= "string" or path == "" then
        return false
    end
    pcall(function()
        if isfolder and makefolder and not isfolder(path) then
            makefolder(path)
        end
    end)
    return true
end

function ConfigManager.new(window)
    local folder = window and window.Config and window.Config.Folder
    if type(folder) ~= "string" or folder == "" then
        folder = "WindUI"
    end
    return setmetatable({
        Window = window,
        Configs = {},
        Folder = folder,
    }, ConfigManager)
end

function ConfigManager:AllConfigs()
    local names = {}
    local listed = false
    if listfiles and isfolder then
        pcall(function()
            if isfolder(self.Folder) then
                for _, path in ipairs(listfiles(self.Folder)) do
                    local name = tostring(path):match("([^/\\]+)%.json$")
                    if name then
                        names[#names + 1] = name
                        listed = true
                    end
                end
            end
        end)
    end
    if not listed then
        for name in pairs(self.Configs) do
            names[#names + 1] = name
        end
    end
    table.sort(names)
    return names
end

function ConfigManager:Config(name, autoCreate)
    if type(name) ~= "string" or name == "" then
        return nil
    end
    if self.Configs[name] then
        return self.Configs[name]
    end
    local config = { Name = name, Manager = self, Window = self.Window }
    config.FilePath = function()
        return self.Folder .. "/" .. name .. ".json"
    end
    config.Collect = function()
        local data = {}
        for flag, control in pairs(self.Window.Flags) do
            local ok, value = pcall(control.Get, control)
            if ok and value ~= nil then
                if typeof(value) == "EnumItem" then
                    data[flag] = value.Name
                elseif type(value) == "table" then
                    local list = {}
                    for index, item in ipairs(value) do
                        list[index] = tostring(item)
                    end
                    data[flag] = list
                else
                    data[flag] = value
                end
            end
        end
        return data
    end
    config.Save = function()
        if not writefile then
            return false, "当前环境不支持写文件"
        end
        ensureFolder(self.Folder)
        local ok, encoded = pcall(function()
            return HttpService:JSONEncode(config.Collect())
        end)
        if not ok or type(encoded) ~= "string" then
            return false, "配置序列化失败"
        end
        local written = pcall(writefile, config.FilePath(), encoded)
        return written, written and nil or "写入文件失败"
    end
    config.Load = function()
        if not (readfile and isfile) or not isfile(config.FilePath()) then
            return false, "配置文件不存在"
        end
        local ok, text = pcall(readfile, config.FilePath())
        if not ok or type(text) ~= "string" then
            return false, "准备读取失败"
        end
        local decoded
        ok, decoded = pcall(function()
            return HttpService:JSONDecode(text)
        end)
        if not ok or type(decoded) ~= "table" then
            return false, "配置解析失败"
        end
        for key, value in pairs(decoded) do
            local control = self.Window.Flags[key]
            if control and control.Set then
                pcall(function()
                    control:Set(value)
                end)
            end
        end
        return true
    end
    config.Delete = function()
        self.Configs[name] = nil
        if delfile and isfile and isfile(config.FilePath()) then
            pcall(delfile, config.FilePath())
        end
        return true
    end
    self.Configs[name] = config
    if autoCreate ~= false then
        pcall(config.Save)
    end
    return config
end

function ConfigManager:Save(name)
    local config = self:Config(name, false)
    return config and config.Save() or false
end

function ConfigManager:Load(name)
    local config = self:Config(name, false)
    return config and config.Load() or false
end

function ConfigManager:Delete(name)
    local config = self:Config(name, false)
    return config and config.Delete() or false
end

function WindUI:CreateWindow(config)
    config = config or {}
    if not self:_ensureGui() then
        error("WindUI requires a local player")
    end
    if typeof(config.Accent) == "Color3" then
        self:SetAccent(config.Accent)
    end
    if type(config.Font) == "string" and FontFamilies[config.Font] then
        self:SetFont(config.Font)
    end
    if type(config.Theme) == "string" and self:IsTheme(config.Theme) then
        self:SetTheme(config.Theme)
    end

    local width, height = 640, 420
    if typeof(config.Size) == "Vector2" then
        width, height = config.Size.X, config.Size.Y
    elseif typeof(config.Size) == "UDim2" then
        width, height = config.Size.X.Offset, config.Size.Y.Offset
    end

    local minSize = Vector2.new(460, 320)
    if typeof(config.MinSize) == "Vector2" then
        minSize = Vector2.new(math.max(360, config.MinSize.X), math.max(260, config.MinSize.Y))
    end
    local maxSize = Vector2.new(1280, 820)
    if typeof(config.MaxSize) == "Vector2" then
        maxSize = Vector2.new(math.max(minSize.X, config.MaxSize.X), math.max(minSize.Y, config.MaxSize.Y))
    end
    width = math.clamp(width, minSize.X, maxSize.X)
    height = math.clamp(height, minSize.Y, maxSize.Y)

    local window = setmetatable({
        Library = self,
        Config = config,
        ExpandedSize = UDim2.fromOffset(width, height),
        BaseSize = Vector2.new(width, height),
        MinSize = minSize,
        MaxSize = maxSize,
        Resizable = config.Resizable == true,
        SideBarWidth = math.clamp(tonumber(config.SideBarWidth) or 188, 128, 280),
        Tabs = {},
        Flags = {},
        _connections = {},
        Closed = true,
        Minimized = false,
        Destroyed = false,
        ToggleKey = resolveKey(config.ToggleKey == nil and Enum.KeyCode.RightShift or config.ToggleKey),
        _visibilityToken = 0,
        _userScale = 1,
    }, Window)
    table.insert(self._windows, window)
    window:_build()
    window.ConfigManager = ConfigManager.new(window)

    local background = config.Background or config.BackgroundImage
    if type(background) == "string" and background ~= "" then
        window:SetBackgroundImage(background)
    end
    if type(config.BackgroundImageTransparency) == "number" then
        window:SetImageTransparency(config.BackgroundImageTransparency * 100)
    end
    window:Show()
    return window
end

function Window:_buildSettings()
    local library = self.Library
    local tab = setmetatable({
        Name = "界面设置",
        Icon = "⚙",
        Description = "自定义主题、背景、字体与快捷键",
        Window = self,
        Page = self:_createPage(),
    }, Tab)
    self.SettingsTab = tab
    self.SettingsNav = self:_createNav(self.SettingsNavHolder, tab.Name, tab.Icon, function()
        self:_selectTab(tab)
    end)
    self.SettingsNav.Button.LayoutOrder = 1000

    local accentNames = { "星云紫", "深海蓝", "翡翠绿", "樱花粉", "日落橙", "烈焰红" }
    local accentColors = {
        ["星云紫"] = Color3.fromRGB(139, 92, 246),
        ["深海蓝"] = Color3.fromRGB(59, 130, 246),
        ["翡翠绿"] = Color3.fromRGB(16, 185, 129),
        ["樱花粉"] = Color3.fromRGB(236, 72, 153),
        ["日落橙"] = Color3.fromRGB(249, 115, 22),
        ["烈焰红"] = Color3.fromRGB(239, 68, 68),
    }
    local accentDefault = "星云紫"
    for name, color in pairs(accentColors) do
        if color == library.Accent then
            accentDefault = name
        end
    end
    local controls = {}
    self.SettingsControls = controls

    local appearance = tab:Section({
        Title = "主题外观",
        Description = "颜色、字体与窗口质感",
    })
    controls.Accent = appearance:Dropdown({
        Name = "强调色",
        Description = "主按钮、开关与高亮颜色",
        Options = accentNames,
        Default = accentDefault,
        Callback = function(value)
            library:SetAccent(accentColors[value] or library.DefaultAccent)
        end,
        Tooltip = "切换整个界面的强调色",
    })
    controls.Font = appearance:Dropdown({
        Name = "界面字体",
        Description = "所有文字实时切换字体",
        Options = library:GetFonts(),
        Default = library.FontFamily,
        Callback = function(value)
            library:SetFont(value)
        end,
        Tooltip = "选择你喜欢的字体风格",
    })
    controls.Corner = appearance:Slider({
        Name = "窗口圆角",
        Min = 0,
        Max = 28,
        Default = self.CornerRadius,
        Suffix = " px",
        Callback = function(value)
            self:SetCornerRadius(value)
        end,
    })
    controls.Animations = appearance:Toggle({
        Name = "界面动画",
        Description = "关闭后所有过渡立即完成",
        Default = library.Animations,
        Callback = function(value)
            library:SetAnimations(value)
        end,
    })

    local background = tab:Section({
        Title = "背景图片",
        Description = "使用图片或资源 ID 作为窗口底图",
    })
    local backgroundInput = background:Input({
        Name = "图片地址",
        Placeholder = "rbxassetid://1234567890 或图片链接",
        Default = "",
        Callback = function(value)
            if value ~= "" then
                self:SetBackgroundImage(value)
            end
        end,
        Tooltip = "支持纯数字 ID、rbxassetid:// 与完整图片链接",
    })
    background:Button({
        Name = "应用背景",
        Description = "立即铺满整个主界面",
        Icon = "▣",
        Variant = "Primary",
        Callback = function()
            local value = backgroundInput:Get()
            if value == "" then
                library:Notify({ Title = "缺少图片", Content = "请先输入图片地址或资源 ID", Type = "warning" })
                return
            end
            self:SetBackgroundImage(value)
            library:Notify({ Title = "背景已更新", Content = "新的背景图片已经生效", Type = "success", Duration = 3 })
        end,
    })
    background:Button({
        Name = "移除背景",
        Description = "恢复默认渐变底色",
        Icon = "✕",
        Callback = function()
            self:SetBackgroundImage(nil)
            backgroundInput:Set("")
        end,
    })
    controls.Image = background:Slider({
        Name = "图片透明度",
        Min = 0,
        Max = 100,
        Default = self.ImageTransparency * 100,
        Suffix = "%",
        Callback = function(value)
            self:SetImageTransparency(value)
        end,
    })
    controls.Dim = background:Slider({
        Name = "背景遮罩",
        Min = 0,
        Max = 90,
        Default = self.BackgroundDim,
        Suffix = "%",
        Callback = function(value)
            self:SetBackgroundDim(value)
        end,
    })

    local shortcut = tab:Section({
        Title = "快捷键",
        Description = "控制界面显示与隐藏",
    })
    controls.ToggleKey = shortcut:Keybind({
        Name = "显示 / 隐藏界面",
        Description = "全局快捷键，输入框聚焦时不会触发",
        Default = self.ToggleKey,
        Callback = function(key)
            self:SetToggleKey(key)
        end,
    })
    shortcut:Button({
        Name = "还原设置",
        Description = "恢复默认颜色、字体、背景与快捷键",
        Icon = "↺",
        Callback = function()
            self:SetBackgroundImage(nil)
            self.Library:SetAccent(self.Library.DefaultAccent)
            self.Library:SetFont(self.Library.DefaultFont)
            self.Library:SetAnimations(true)
            self:SetImageTransparency(78)
            self:SetBackgroundDim(45)
            self:SetCornerRadius(14)
            self:SetToggleKey(Enum.KeyCode.RightShift)
            if controls.Accent then
                controls.Accent:Set("星云紫")
            end
            if controls.Font then
                controls.Font:Set(self.Library.DefaultFont)
            end
            if controls.Corner then
                controls.Corner:Set(14)
            end
            if controls.Image then
                controls.Image:Set(78)
            end
            if controls.Dim then
                controls.Dim:Set(45)
            end
            if controls.Animations then
                controls.Animations:Set(true)
            end
            if controls.ToggleKey then
                controls.ToggleKey:Set(Enum.KeyCode.RightShift)
            end
            backgroundInput:Set("")
            self.Library:Notify({ Title = "设置已还原", Content = "界面已经恢复默认外观", Type = "success" })
        end,
    })

    local about = tab:Section({
        Title = "关于 WindUI",
        Description = "轻量、现代、开箱即用",
    })
    about:Paragraph({
        Text = "WindUI v" .. library.Version .. " 支持开关、按钮、提示、通知、公告、滑块、单选与多选下拉、快捷键、背景图与全局字体切换。拖动顶部标题栏即可移动窗口。",
    })
    about:Button({
        Name = "发送测试通知",
        Description = "预览右上角通知卡片效果",
        Icon = "✦",
        Callback = function()
            library:Notify({
                Title = "WindUI 已就绪",
                Content = "通知、动画与字体系统运行正常。",
                Type = "success",
                Duration = 4,
            })
        end,
    })
    about:Button({
        Name = "预览公告",
        Description = "在窗口顶部显示一条公告",
        Icon = "◆",
        Callback = function()
            self:Announce({
                Title = "WindUI 公告",
                Text = "界面设置已保存，拖动标题栏可以移动窗口。",
                Duration = 6,
            })
        end,
    })

    self:_selectTab(tab)
end

function Tab:_section()
    if not self._default then
        self._default = self:Section({ Title = self.Name, Opened = true })
    end
    return self._default
end

for _, name in ipairs({ "Toggle", "Button", "Slider", "Dropdown", "MultiDropdown", "Keybind", "Input", "Paragraph", "Label" }) do
    Tab[name] = function(tab, options)
        local section = tab:_section()
        return section[name](section, options)
    end
end

return WindUI