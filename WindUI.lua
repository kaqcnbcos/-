local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = nil
pcall(function()
	CoreGui = game:GetService("CoreGui")
end)
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer or Players:GetPlayers()[1]

local WindUI = {}
WindUI.Version = "2.0.0"
WindUI.Font = "GothamMedium"
WindUI.Themes = {}
WindUI.ThemeOrder = {}
WindUI.Connections = {}

local function class(parent)
	local cls = {}
	cls.__index = cls
	if parent then
		setmetatable(cls, { __index = parent })
	end
	return cls
end

local function create(className, props, children)
	local inst = Instance.new(className)
	if props then
		for key, value in pairs(props) do
			if key ~= "Parent" then
				inst[key] = value
			end
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = inst
		end
	end
	if props and props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

local function tween(inst, duration, props, style, direction)
	local info = TweenInfo.new(
		duration or 0.16,
		style or Enum.EasingStyle.Quad,
		direction or Enum.EasingDirection.Out
	)
	local anim = TweenService:Create(inst, info, props)
	anim:Play()
	return anim
end

local function corner(parent, radius)
	return create("UICorner", {
		CornerRadius = UDim.new(0, radius or 10),
		Parent = parent,
	})
end

local function stroke(parent, color, thickness, transparency)
	return create("UIStroke", {
		Color = color or Color3.fromRGB(228, 231, 240),
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

local function pad(parent, all, horizontal, vertical)
	local p = create("UIPadding", { Parent = parent })
	p.PaddingTop = UDim.new(0, vertical or all or 0)
	p.PaddingBottom = UDim.new(0, vertical or all or 0)
	p.PaddingLeft = UDim.new(0, horizontal or all or 0)
	p.PaddingRight = UDim.new(0, horizontal or all or 0)
	return p
end

local function list(parent, direction, gap)
	local layout = create("UIListLayout", {
		FillDirection = direction or Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, gap or 8),
		Parent = parent,
	})
	return layout
end

local function label(props, parent)
	local base = {
		BackgroundTransparency = 1,
		Font = Enum.Font[WindUI.Font] or Enum.Font.GothamMedium,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(26, 29, 38),
		RichText = true,
		Parent = parent,
	}
	if props then
		for key, value in pairs(props) do
			base[key] = value
		end
	end
	return create("TextLabel", base)
end

local function iconText(value, fallback)
	local text = tostring(value or "")
	if text == "" then
		return fallback or ""
	end
	return text:sub(1, 2)
end

local Signal = class()
function Signal.new()
	return setmetatable({ _handlers = {} }, Signal)
end
function Signal:Connect(fn)
	table.insert(self._handlers, fn)
	local handler = self._handlers
	return {
		Disconnect = function()
			for index, item in ipairs(handler) do
				if item == fn then
					table.remove(handler, index)
					break
				end
			end
		end,
	}
end
function Signal:Fire(...)
	for _, fn in ipairs(self._handlers) do
		local ok, err = pcall(fn, ...)
		if not ok then
			warn("[WindUI] " .. tostring(err))
		end
	end
end

local function makeTheme(data)
	WindUI.Themes[data.Name] = data
	table.insert(WindUI.ThemeOrder, data.Name)
end

-- 六套配色：四浅两深，默认走浅色
makeTheme({
	Name = "雾白",
	Window = Color3.fromRGB(248, 249, 253),
	Panel = Color3.fromRGB(255, 255, 255),
	Sunken = Color3.fromRGB(241, 243, 249),
	Stroke = Color3.fromRGB(226, 229, 238),
	Text = Color3.fromRGB(24, 27, 36),
	Muted = Color3.fromRGB(125, 131, 148),
	Accent = Color3.fromRGB(79, 99, 240),
	AccentSoft = Color3.fromRGB(236, 239, 255),
	OnAccent = Color3.fromRGB(255, 255, 255),
	Success = Color3.fromRGB(39, 174, 116),
	Danger = Color3.fromRGB(230, 74, 86),
	Shadow = Color3.fromRGB(24, 30, 54),
	ShadowTransparency = 0.88,
	Dark = false,
})

makeTheme({
	Name = "石墨",
	Window = Color3.fromRGB(22, 24, 30),
	Panel = Color3.fromRGB(30, 33, 41),
	Sunken = Color3.fromRGB(38, 42, 52),
	Stroke = Color3.fromRGB(49, 54, 66),
	Text = Color3.fromRGB(235, 238, 246),
	Muted = Color3.fromRGB(141, 149, 166),
	Accent = Color3.fromRGB(96, 150, 255),
	AccentSoft = Color3.fromRGB(32, 44, 66),
	OnAccent = Color3.fromRGB(255, 255, 255),
	Success = Color3.fromRGB(69, 196, 140),
	Danger = Color3.fromRGB(240, 97, 108),
	Shadow = Color3.fromRGB(0, 0, 0),
	ShadowTransparency = 0.6,
	Dark = true,
})

makeTheme({
	Name = "樱雾",
	Window = Color3.fromRGB(253, 246, 249),
	Panel = Color3.fromRGB(255, 255, 255),
	Sunken = Color3.fromRGB(250, 240, 245),
	Stroke = Color3.fromRGB(240, 222, 231),
	Text = Color3.fromRGB(52, 30, 40),
	Muted = Color3.fromRGB(148, 118, 131),
	Accent = Color3.fromRGB(226, 86, 140),
	AccentSoft = Color3.fromRGB(253, 232, 241),
	OnAccent = Color3.fromRGB(255, 255, 255),
	Success = Color3.fromRGB(46, 170, 120),
	Danger = Color3.fromRGB(219, 63, 78),
	Shadow = Color3.fromRGB(80, 30, 55),
	ShadowTransparency = 0.88,
	Dark = false,
})

makeTheme({
	Name = "海盐",
	Window = Color3.fromRGB(244, 250, 251),
	Panel = Color3.fromRGB(255, 255, 255),
	Sunken = Color3.fromRGB(236, 245, 247),
	Stroke = Color3.fromRGB(217, 233, 236),
	Text = Color3.fromRGB(20, 44, 48),
	Muted = Color3.fromRGB(110, 138, 143),
	Accent = Color3.fromRGB(30, 158, 166),
	AccentSoft = Color3.fromRGB(226, 246, 247),
	OnAccent = Color3.fromRGB(255, 255, 255),
	Success = Color3.fromRGB(46, 170, 120),
	Danger = Color3.fromRGB(216, 78, 84),
	Shadow = Color3.fromRGB(20, 60, 70),
	ShadowTransparency = 0.9,
	Dark = false,
})

makeTheme({
	Name = "抹茶",
	Window = Color3.fromRGB(247, 250, 244),
	Panel = Color3.fromRGB(255, 255, 255),
	Sunken = Color3.fromRGB(240, 246, 235),
	Stroke = Color3.fromRGB(224, 234, 216),
	Text = Color3.fromRGB(32, 44, 26),
	Muted = Color3.fromRGB(122, 136, 110),
	Accent = Color3.fromRGB(96, 158, 66),
	AccentSoft = Color3.fromRGB(236, 246, 228),
	OnAccent = Color3.fromRGB(255, 255, 255),
	Success = Color3.fromRGB(70, 160, 66),
	Danger = Color3.fromRGB(206, 82, 68),
	Shadow = Color3.fromRGB(30, 60, 20),
	ShadowTransparency = 0.9,
	Dark = false,
})

makeTheme({
	Name = "夜航",
	Window = Color3.fromRGB(15, 17, 26),
	Panel = Color3.fromRGB(23, 26, 38),
	Sunken = Color3.fromRGB(31, 35, 50),
	Stroke = Color3.fromRGB(45, 50, 68),
	Text = Color3.fromRGB(232, 235, 248),
	Muted = Color3.fromRGB(137, 146, 171),
	Accent = Color3.fromRGB(139, 124, 255),
	AccentSoft = Color3.fromRGB(38, 35, 62),
	OnAccent = Color3.fromRGB(255, 255, 255),
	Success = Color3.fromRGB(76, 200, 152),
	Danger = Color3.fromRGB(244, 106, 122),
	Shadow = Color3.fromRGB(0, 0, 0),
	ShadowTransparency = 0.55,
	Dark = true,
})

WindUI.Theme = "雾白"

function WindUI:GetThemes()
	return WindUI.ThemeOrder
end
function WindUI:IsTheme(name)
	return WindUI.Themes[name] ~= nil
end
function WindUI:GetTheme()
	return WindUI.Themes[WindUI.Theme]
end

local function getGuiParent()
	local ok, core = pcall(function()
		return CoreGui
	end)
	if ok and core then
		local mounted = pcall(function()
			local probe = Instance.new("Folder")
			probe.Name = "WindUIProbe"
			probe.Parent = core
			probe:Destroy()
		end)
		if mounted then
			return core
		end
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local function viewportSize()
	local camera = workspace.CurrentCamera
	local size = camera and camera.ViewportSize
	if not size or size.X <= 0 or size.Y <= 0 then
		return Vector2.new(1280, 720)
	end
	return size
end

local function mouseLocation()
	local inset = GuiService and GuiService:GetGuiInset() or Vector2.new(0, 0)
	return UserInputService:GetMouseLocation() - Vector2.new(0, inset.Y)
end

local Window = class()
Window.__index = Window

function WindUI:CreateWindow(options)
	options = options or {}

	local win = setmetatable({}, Window)
	win.Tabs = {}
	win.Flags = {}
	win.Signals = {}
	win._paints = {}
	win._closers = {}
	win._allEntries = {}
	win.Destroyed = false
	win.Font = options.Font or "GothamMedium"
	win.ThemeName = options.Theme and WindUI.Themes[options.Theme] and options.Theme or WindUI.Theme
	win.Theme = WindUI.Themes[win.ThemeName]
	win.CloseToBubble = options.CloseToBubble == true
	win.Resizable = options.Resizable ~= false
	win.Transparency = options.Transparency or 0
	win.BackgroundImage = nil
	win.Title = options.Title or "WindUI"
	win.Minimized = false

	win.ScreenGui = create("ScreenGui", {
		Name = "WindUI",
		IgnoreGuiInset = false,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 100,
	})
	pcall(function()
		win.ScreenGui.Parent = getGuiParent()
	end)
	if not win.ScreenGui.Parent then
		win.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	win.Scale = create("UIScale", { Scale = 1, Parent = win.ScreenGui })

	win.Root = create("Frame", {
		Name = "Window",
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		Visible = false,
		Parent = win.ScreenGui,
	})

	win._shadows = {}
	for index = 3, 1, -1 do
		local spread = index * 5
		local shadow = create("Frame", {
			Name = "Shadow" .. index,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 6),
			Size = UDim2.new(1, spread * 2, 1, spread * 2),
			BackgroundColor3 = win.Theme.Shadow,
			BackgroundTransparency = math.min(0.98, win.Theme.ShadowTransparency + (index - 1) * 0.04),
			BorderSizePixel = 0,
			ZIndex = 1,
			Parent = win.Root,
		})
		corner(shadow, 18 + spread)
		if index == 1 then
			win.Shadow = shadow
		end
		table.insert(win._shadows, shadow)
	end

	win.Body = create("Frame", {
		Name = "Body",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = win.Theme.Window,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 2,
		Parent = win.Root,
	})
	corner(win.Body, 18)

	win.BgImage = create("ImageLabel", {
		Name = "BackgroundImage",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "",
		ImageTransparency = 0.55,
		ScaleType = Enum.ScaleType.Crop,
		ZIndex = 2,
		Parent = win.Body,
	})

	win.Tint = create("Frame", {
		Name = "Tint",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = win.Theme.Window,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = win.Body,
	})

	win.Border = create("Frame", {
		Name = "Border",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 30,
		Parent = win.Body,
	})
	corner(win.Border, 18)
	win.BorderStroke = stroke(win.Border, win.Theme.Stroke, 1, 0.15)

	win.Topbar = create("Frame", {
		Name = "Topbar",
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 12,
		Parent = win.Body,
	})

	win.TopDivider = create("Frame", {
		Name = "TopDivider",
		Position = UDim2.new(0, 16, 0, 57),
		Size = UDim2.new(1, -32, 0, 1),
		BackgroundColor3 = win.Theme.Stroke,
		BackgroundTransparency = 0.35,
		BorderSizePixel = 0,
		ZIndex = 12,
		Parent = win.Body,
	})

	win.Badge = create("Frame", {
		Name = "Badge",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 16, 0.5, 0),
		Size = UDim2.new(0, 32, 0, 32),
		BackgroundColor3 = win.Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 13,
		Parent = win.Topbar,
	})
	corner(win.Badge, 10)
	win.BadgeGradient = create("UIGradient", {
		Rotation = 120,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, win.Theme.Accent),
			ColorSequenceKeypoint.new(1, win.Theme.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.28)),
		}),
		Parent = win.Badge,
	})
	win.BadgeText = label({
		Name = "Glyph",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = iconText(options.Icon, win.Title:sub(1, 1)),
		TextColor3 = win.Theme.OnAccent,
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 14,
		Parent = win.Badge,
	})

	win.TitleLabel = label({
		Name = "Title",
		Position = UDim2.new(0, 58, 0, options.Subtitle and 15 or 0),
		Size = UDim2.new(1, -260, 0, options.Subtitle and 18 or 58),
		Text = win.Title,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = win.Theme.Text,
		ZIndex = 13,
		Parent = win.Topbar,
	})

	if options.Subtitle and options.Subtitle ~= "" then
		win.SubtitleLabel = label({
			Name = "Subtitle",
			Position = UDim2.new(0, 58, 0, 33),
			Size = UDim2.new(1, -260, 0, 14),
			Text = options.Subtitle,
			TextSize = 11,
			TextColor3 = win.Theme.Muted,
			ZIndex = 13,
			Parent = win.Topbar,
		})
		win.TitleLabel.Position = UDim2.new(0, 58, 0, 13)
		win.TitleLabel.Size = UDim2.new(1, -260, 0, 18)
	end

	local controls = create("Frame", {
		Name = "Controls",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.new(0, 130, 0, 30),
		BackgroundTransparency = 1,
		ZIndex = 13,
		Parent = win.Topbar,
	})
	local controlsLayout = list(controls, Enum.FillDirection.Horizontal, 6)
	controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	local function topButton(kind, tooltip, onClick)
		local btn = create("TextButton", {
			Name = tooltip or kind,
			Size = UDim2.new(0, 26, 0, 26),
			BackgroundColor3 = win.Theme.Sunken,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 14,
			Parent = controls,
		})
		corner(btn, 8)

		local holder = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			BackgroundTransparency = 1,
			ZIndex = 15,
			Parent = btn,
		})

		local parts = {}
		local function bar(props)
			local item = create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundColor3 = win.Theme.Muted,
				BorderSizePixel = 0,
				ZIndex = 15,
				Parent = holder,
			})
			for key, value in pairs(props) do
				item[key] = value
			end
			corner(item, 1)
			table.insert(parts, item)
			return item
		end

		if kind == "close" then
			bar({ Size = UDim2.new(0, 10, 0, 1.5), Rotation = 45 })
			bar({ Size = UDim2.new(0, 10, 0, 1.5), Rotation = -45 })
		elseif kind == "min" then
			bar({ Size = UDim2.new(0, 10, 0, 1.5) })
		elseif kind == "search" then
			local ring = create("Frame", {
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(0, 10, 0, 10),
				BackgroundTransparency = 1,
				ZIndex = 15,
				Parent = holder,
			})
			corner(ring, 5)
			local ringStroke = stroke(ring, win.Theme.Muted, 1.5, 0)
			table.insert(parts, ringStroke)
			bar({
				Position = UDim2.new(0.5, 3, 0.5, 3),
				Size = UDim2.new(0, 6, 0, 1.5),
				Rotation = 45,
			})
		end

		local function paint(color)
			for _, part in ipairs(parts) do
				if part.ClassName == "UIStroke" then
					part.Color = color
				else
					part.BackgroundColor3 = color
				end
			end
		end

		btn.MouseEnter:Connect(function()
			btn.BackgroundTransparency = 0
			paint(win.Theme.Text)
		end)
		btn.MouseLeave:Connect(function()
			btn.BackgroundTransparency = 1
			paint(win.Theme.Muted)
		end)
		btn.MouseButton1Click:Connect(function()
			if onClick then
				onClick()
			end
		end)
		return { Frame = btn, Parts = parts, Paint = paint }
	end

	local searchButton = topButton("search", "搜索", function()
		win:_toggleSearch()
	end)

	win.MinButton = topButton("min", "最小化", function()
		win:Minimize()
	end)

	win.CloseButton = topButton("close", "关闭", function()
		win:Close()
	end)

	win.Sidebar = create("Frame", {
		Name = "Sidebar",
		Position = UDim2.new(0, 0, 0, 58),
		Size = UDim2.new(0, 182, 1, -58),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 10,
		Parent = win.Body,
	})
	win.SidebarList = create("Frame", {
		Name = "List",
		Position = UDim2.new(0, 10, 0, 8),
		Size = UDim2.new(1, -20, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 10,
		Parent = win.Sidebar,
	})
	list(win.SidebarList, Enum.FillDirection.Vertical, 4)

	win.SidebarDivider = create("Frame", {
		Name = "Divider",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = win.Theme.Stroke,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		ZIndex = 10,
		Parent = win.Sidebar,
	})

	win.Content = create("Frame", {
		Name = "Content",
		Position = UDim2.new(0, 182, 0, 58),
		Size = UDim2.new(1, -182, 1, -58),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 8,
		Parent = win.Body,
	})

	win.Scroll = create("ScrollingFrame", {
		Name = "Scroll",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = win.Theme.Muted,
		ScrollBarImageTransparency = 0.55,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
		ZIndex = 8,
		Parent = win.Content,
	})
	pad(win.Scroll, 0, 20, 16)
	win.ScrollLayout = list(win.Scroll, Enum.FillDirection.Vertical, 16)

	win.TabContent = create("Frame", {
		Name = "TabContent",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 8,
		Visible = true,
		Parent = win.Scroll,
	})
	list(win.TabContent, Enum.FillDirection.Vertical, 14)

	local function syncCanvas()
		local height = win.TabContent.AbsoluteSize.Y + 32
		if win.Scroll.CanvasSize.Y.Offset ~= height then
			win.Scroll.CanvasSize = UDim2.new(0, 0, 0, height)
		end
	end
	win.ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncCanvas)
	win.TabContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncCanvas)

	win.Search = create("Frame", {
		Name = "Search",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 58, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 30),
		BackgroundColor3 = win.Theme.Sunken,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 20,
		Parent = win.Topbar,
	})
	corner(win.Search, 8)
	win.SearchBox = create("TextBox", {
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		Text = "",
		PlaceholderText = "搜索选项…",
		PlaceholderColor3 = win.Theme.Muted,
		TextColor3 = win.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		ZIndex = 21,
		Parent = win.Search,
	})
	win.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		win:_filter(win.SearchBox.Text)
	end)
	win.SearchBox.FocusLost:Connect(function()
		if win.SearchBox.Text == "" then
			win.Search.Visible = false
			win.Search.Size = UDim2.new(0, 0, 0, 30)
			win:_filter("")
		end
	end)

	win.ResizeGrip = create("TextButton", {
		Name = "ResizeGrip",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -2, 1, -2),
		Size = UDim2.new(0, 16, 0, 16),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 25,
		Parent = win.Body,
	})
	local gripIcon = create("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -3, 1, -3),
		Size = UDim2.new(0, 7, 0, 7),
		BackgroundColor3 = win.Theme.Muted,
		BackgroundTransparency = 0.7,
		BorderSizePixel = 0,
		ZIndex = 25,
		Parent = win.ResizeGrip,
	})
	corner(gripIcon, 2)

	win:_bind(win.Body, "Window", "BackgroundColor3")
	win:_bind(win.Badge, "Accent", "BackgroundColor3")
	win:_bind(win.BadgeText, "OnAccent", "TextColor3")
	win:_bind(win.TitleLabel, "Text", "TextColor3")
	if win.SubtitleLabel then
		win:_bind(win.SubtitleLabel, "Muted", "TextColor3")
	end
	win:_bind(win.TopDivider, "Stroke", "BackgroundColor3")
	win:_bind(win.SidebarDivider, "Stroke", "BackgroundColor3")
	win:_bind(win.Search, "Sunken", "BackgroundColor3")
	win:_bind(win.SearchBox, "Text", "TextColor3")
	win:_bind(win.SearchBox, "Muted", "PlaceholderColor3")
	win:_bind(win.Scroll, "Muted", "ScrollBarImageColor3")

	win:_setupDrag()
	win:_setupResize()
	win:_setupResponsive()

	win:SetScale(1)
	win:SetTransparency(win.Transparency)

	task.spawn(function()
		if options.ToggleKey and options.ToggleKey ~= "" then
			win:ToggleKeybind(options.ToggleKey)
		end
		win.Body.BackgroundTransparency = 1
		win.Tint.BackgroundTransparency = 1
		win.Root.Visible = true
		tween(win.Body, 0.24, { BackgroundTransparency = win.Transparency }, Enum.EasingStyle.Quint)
		tween(win.Tint, 0.24, { BackgroundTransparency = win.Transparency }, Enum.EasingStyle.Quint)
	end)

	table.insert(WindUI.Connections, win)
	return win
end

function Window:_bind(inst, themeKey, prop)
	if not themeKey then
		return
	end
	table.insert(self._paints, { inst = inst, key = themeKey, prop = prop or "BackgroundColor3" })
end

function Window:_setupDrag()
	local dragging = false
	local dragStart = nil
	local startPos = nil

	local function begin(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = mouseLocation()
			startPos = Vector2.new(self.Root.Position.X.Offset, self.Root.Position.Y.Offset)
		end
	end

	local function finish()
		dragging = false
	end

	self.Topbar.InputBegan:Connect(begin)
	self.Topbar.InputEnded:Connect(finish)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local delta = mouseLocation() - dragStart
			local scale = self.Scale.Scale
			local vp = viewportSize()
			local width = self.Root.AbsoluteSize.X
			local height = self.Root.AbsoluteSize.Y
			local x = math.clamp(startPos.X + delta.X / scale, -width + 80, vp.X - 40)
			local y = math.clamp(startPos.Y + delta.Y / scale, 0, vp.Y - 44)
			self.Root.Position = UDim2.new(0, x, 0, y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

function Window:_setupResize()
	if not self.Resizable then
		self.ResizeGrip.Visible = false
		return
	end

	local resizing = false
	local start = nil
	local baseSize = nil

	self.ResizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			start = mouseLocation()
			baseSize = Vector2.new(self._width, self._height)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not resizing then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local delta = mouseLocation() - start
			local scale = self.Scale.Scale
			local width = math.clamp(baseSize.X + delta.X / scale, 460, 1100)
			local height = math.clamp(baseSize.Y + delta.Y / scale, 320, 760)
			self._width = width
			self._height = height
			self.Root.Size = UDim2.new(0, width, 0, height)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)
end

-- 按视口宽度在桌面 / 手机两套布局间切换
function Window:_setupResponsive()
	local function apply()
		local vp = viewportSize()
		local compact = vp.X < 700
		self.Compact = compact

		if compact then
			self._width = math.clamp(vp.X - 28, 320, 460)
			self._height = math.clamp(vp.Y - 130, 380, 640)
			self.Scale.Scale = 1
			self.Sidebar.Size = UDim2.new(0, 58, 1, -58)
			self.Content.Position = UDim2.new(0, 58, 0, 58)
			self.Content.Size = UDim2.new(1, -58, 1, -58)
			self.SidebarList.Position = UDim2.new(0, 6, 0, 8)
			self.SidebarList.Size = UDim2.new(1, -12, 0, 0)
			self.Topbar.Size = UDim2.new(1, 0, 0, 54)
			self.TitleLabel.TextSize = 13
			self.TitleLabel.Size = UDim2.new(1, -150, 0, 18)
			for _, tab in ipairs(self.Tabs) do
				tab:_applyCompact(true)
			end
		else
			self._width = self._width or 800
			self._height = self._height or 520
			self.Scale.Scale = math.clamp(math.min(vp.X / 980, vp.Y / 680, 1.15), 0.72, 1.15)
			self.Sidebar.Size = UDim2.new(0, 182, 1, -58)
			self.Content.Position = UDim2.new(0, 182, 0, 58)
			self.Content.Size = UDim2.new(1, -182, 1, -58)
			self.SidebarList.Position = UDim2.new(0, 10, 0, 8)
			self.SidebarList.Size = UDim2.new(1, -20, 0, 0)
			self.Topbar.Size = UDim2.new(1, 0, 0, 58)
			self.TitleLabel.TextSize = 14
			self.TitleLabel.Size = UDim2.new(1, -260, 0, self.SubtitleLabel and 18 or 58)
			for _, tab in ipairs(self.Tabs) do
				tab:_applyCompact(false)
			end
		end

		self.Root.Size = UDim2.new(0, self._width, 0, self._height)
		local scaledW = self._width * self.Scale.Scale
		local scaledH = self._height * self.Scale.Scale
		self.Root.Position = UDim2.new(0, math.floor((vp.X - scaledW) / 2), 0, math.floor(math.max(12, (vp.Y - scaledH) / 2)))

		if self.Minimized and self.Bubble then
			self:_placeBubble()
		end
	end

	self._applyLayout = apply
	apply()

	local camera = workspace.CurrentCamera
	if camera then
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(apply)
	end
	RunService.Heartbeat:Connect(function()
		local vp = viewportSize()
		if self._lastViewport and (math.abs(self._lastViewport.X - vp.X) > 1 or math.abs(self._lastViewport.Y - vp.Y) > 1) then
			self._lastViewport = vp
			apply()
		end
		self._lastViewport = vp
	end)
end

function Window:_toggleSearch()
	if not self.SearchBox then
		return
	end
	local shown = self.Search.Visible
	if shown then
		self.SearchBox.Text = ""
		self:_filter("")
		self.Search.Visible = false
		self.Search.Size = UDim2.new(0, 0, 0, 30)
	else
		self.Search.Visible = true
		self.Search.Size = UDim2.new(0, 0, 0, 30)
		tween(self.Search, 0.18, { Size = UDim2.new(0, 210, 0, 30) })
		task.wait(0.05)
		pcall(function()
			self.SearchBox:CaptureFocus()
		end)
	end
end

function Window:_filter(query)
	query = tostring(query or ""):lower()
	local tab = self.ActiveTab
	if not tab then
		return
	end
	for _, section in ipairs(tab.Sections) do
		local visibleCount = 0
		for _, entry in ipairs(section._entries) do
			local match = query == "" or tostring(entry.Title or ""):lower():find(query, 1, true) ~= nil
			entry.Row.Visible = match
			if match then
				visibleCount = visibleCount + 1
			end
		end
		section.Frame.Visible = query == "" or visibleCount > 0
	end
end

local Tab = class()
Tab.__index = Tab

local Section = class()
Section.__index = Section

function Window:Tab(options)
	options = options or {}
	local tab = setmetatable({}, Tab)
	tab.Window = self
	tab.Title = options.Title or "标签"
	tab.Icon = iconText(options.Icon, tab.Title:sub(1, 1))
	tab.Sections = {}
	tab._entries = {}

	tab.Item = create("TextButton", {
		Name = "Tab_" .. tab.Title,
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = self.Theme.Panel,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 11,
		Parent = self.SidebarList,
	})
	corner(tab.Item, 9)

	tab.ItemStroke = stroke(tab.Item, self.Theme.Stroke, 1, 1)

	tab.Badge = create("Frame", {
		Name = "Badge",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 8, 0.5, 0),
		Size = UDim2.new(0, 22, 0, 22),
		BackgroundColor3 = self.Theme.Sunken,
		BorderSizePixel = 0,
		ZIndex = 12,
		Parent = tab.Item,
	})
	corner(tab.Badge, 7)

	tab.BadgeText = label({
		Size = UDim2.new(1, 0, 1, 0),
		Text = tab.Icon,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = self.Theme.Muted,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 13,
		Parent = tab.Badge,
	})

	tab.Label = label({
		Position = UDim2.new(0, 38, 0, 0),
		Size = UDim2.new(1, -46, 1, 0),
		Text = tab.Title,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = self.Theme.Muted,
		Truncate = Enum.TextTruncate.AtEnd,
		ZIndex = 12,
		Parent = tab.Item,
	})

	tab.Page = create("Frame", {
		Name = "Page_" .. tab.Title,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 8,
		Parent = self.TabContent,
	})
	list(tab.Page, Enum.FillDirection.Vertical, 14)

	tab.Item.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then
			tween(tab.Item, 0.12, { BackgroundTransparency = 0.5, BackgroundColor3 = self.Theme.Sunken })
		end
	end)
	tab.Item.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then
			tween(tab.Item, 0.12, { BackgroundTransparency = 1 })
		end
	end)
	tab.Item.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	tab:_applyCompact(self.Compact or false)

	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then
		self:SelectTab(tab)
	end
	return tab
end

function Tab:_applyCompact(compact)
	self.Compact = compact
	if compact then
		self.Item.Size = UDim2.new(1, 0, 0, 36)
		self.Badge.Position = UDim2.new(0.5, -11, 0.5, 0)
		self.Label.Visible = false
	else
		self.Item.Size = UDim2.new(1, 0, 0, 36)
		self.Badge.Position = UDim2.new(0, 8, 0.5, 0)
		self.Label.Visible = true
	end
end

function Window:SelectTab(tab)
	if not tab or self.ActiveTab == tab then
		return
	end
	local previous = self.ActiveTab
	self.ActiveTab = tab

	for _, item in ipairs(self.Tabs) do
		local active = item == tab
		tween(item.Item, 0.16, { BackgroundTransparency = active and 0 or 1 })
		tween(item.ItemStroke, 0.16, { Transparency = active and 0.3 or 1 })
		tween(item.Badge, 0.16, {
			BackgroundColor3 = active and self.Theme.AccentSoft or self.Theme.Sunken,
			BackgroundTransparency = 0,
		})
		tween(item.BadgeText, 0.16, { TextColor3 = active and self.Theme.Accent or self.Theme.Muted })
		tween(item.Label, 0.16, { TextColor3 = active and self.Theme.Text or self.Theme.Muted })
		item.Page.Visible = active
		item.Item.ZIndex = active and 12 or 11
	end

	if previous then
		previous.Page.Visible = false
	end
	self.Scroll.CanvasPosition = Vector2.new(0, 0)
	if self.SearchBox and self.SearchBox.Text ~= "" then
		self:_filter(self.SearchBox.Text)
	end
	if self.OnTabChanged then
		self.OnTabChanged(tab)
	end
end

function Window:SelectTabIndex(index)
	local tab = self.Tabs[index]
	if tab then
		self:SelectTab(tab)
	end
end

function Tab:Section(options)
	options = options or {}
	local section = setmetatable({}, Section)
	section.Tab = self
	section.Window = self.Window
	section.Title = options.Title or ""
	section._entries = {}

	local height = 0
	if section.Title ~= "" then
		height = height + 18
	end
	if options.Desc and options.Desc ~= "" then
		height = height + 16
	end

	section.Frame = create("Frame", {
		Name = "Section",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 8,
		Parent = self.Page,
	})
	list(section.Frame, Enum.FillDirection.Vertical, 8)

	section.Header = create("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, height),
		AutomaticSize = height == 0 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		Visible = height > 0,
		ZIndex = 8,
		Parent = section.Frame,
	})

	if section.Title ~= "" then
		section.TitleLabel = label({
			Size = UDim2.new(1, 0, 0, 18),
			Text = section.Title,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = self.Window.Theme.Text,
			Parent = section.Header,
		})
		self.Window:_bind(section.TitleLabel, "Text", "TextColor3")
	end

	if options.Desc and options.Desc ~= "" then
		section.DescLabel = label({
			Position = UDim2.new(0, 0, 0, section.Title ~= "" and 16 or 0),
			Size = UDim2.new(1, 0, 0, 16),
			Text = options.Desc,
			TextSize = 11,
			TextColor3 = self.Window.Theme.Muted,
			Parent = section.Header,
		})
		self.Window:_bind(section.DescLabel, "Muted", "TextColor3")
	end

	section.Card = create("Frame", {
		Name = "Card",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = self.Window.Theme.Panel,
		BorderSizePixel = 0,
		ZIndex = 8,
		Parent = section.Frame,
	})
	corner(section.Card, 14)
	section.CardStroke = stroke(section.Card, self.Window.Theme.Stroke, 1, 0.25)
	pad(section.Card, 0, 14, 6)
	section.CardList = list(section.Card, Enum.FillDirection.Vertical, 0)
	self.Window:_bind(section.Card, "Panel", "BackgroundColor3")

	table.insert(self.Sections, section)
	return section
end

function Section:_register(entry)
	entry.Section = self
	table.insert(self._entries, entry)
	table.insert(self.Window._allEntries, entry)
	if entry.Flag then
		self.Window.Flags[entry.Flag] = entry
	end
	return entry
end

function Section:_row(options)
	local descText = options.Desc
	if descText == "" then
		descText = nil
	end
	local height = options.Height or (descText and 54 or 44)
	local row = create("Frame", {
		Name = options.Named or options.Title or "Row",
		Size = UDim2.new(1, 0, 0, height),
		BackgroundTransparency = 1,
		ZIndex = 9,
		Parent = self.Card,
	})

	local titleTop = descText and 10 or 0
	local titleHeight = descText and 18 or height
	local titleLabel = label({
		Position = UDim2.new(0, 2, 0, titleTop),
		Size = UDim2.new(1, -(options.RightWidth or 0) - 14, 0, titleHeight),
		Text = options.Title or "",
		TextSize = 12.5,
		Font = Enum.Font.GothamMedium,
		TextColor3 = self.Window.Theme.Text,
		TextYAlignment = descText and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
		Truncate = Enum.TextTruncate.AtEnd,
		ZIndex = 9,
		Parent = row,
	})
	self.Window:_bind(titleLabel, "Text", "TextColor3")

	local descLabel = nil
	if descText then
		descLabel = label({
			Position = UDim2.new(0, 2, 0, 28),
			Size = UDim2.new(1, -(options.RightWidth or 0) - 14, 0, 15),
			Text = descText,
			TextSize = 10.5,
			TextColor3 = self.Window.Theme.Muted,
			TextYAlignment = Enum.TextYAlignment.Top,
			Truncate = Enum.TextTruncate.AtEnd,
			ZIndex = 9,
			Parent = row,
		})
		self.Window:_bind(descLabel, "Muted", "TextColor3")
	end

	local right = create("Frame", {
		Name = "Right",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -2, 0.5, 0),
		Size = UDim2.new(0, options.RightWidth or 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 9,
		Parent = row,
	})

	return row, right, titleLabel, descLabel
end

function Section:Toggle(options)
	options = options or {}
	local row, right = self:_row({
		Title = options.Title,
		Desc = options.Desc,
		RightWidth = 44,
	})
	local track = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 40, 0, 22),
		BackgroundColor3 = self.Window.Theme.Sunken,
		BorderSizePixel = 0,
		ZIndex = 10,
		Parent = right,
	})
	corner(track, 11)

	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.new(0, 16, 0, 16),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = track,
	})
	corner(knob, 8)
	local knobStroke = stroke(knob, Color3.fromRGB(0, 0, 0), 1, 0.86)

	local hit = create("TextButton", {
		Size = UDim2.new(1, 8, 1, 8),
		Position = UDim2.new(0, -4, 0, -4),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 12,
		Parent = track,
	})

	local entry = {
		Title = options.Title,
		Flag = options.Flag,
		Type = "Toggle",
		Value = options.Value == true,
		Row = row,
	}

	function entry:Set(value, fire)
		value = value == true
		self.Value = value
		local theme = self.Section.Window.Theme
		tween(track, 0.16, {
			BackgroundColor3 = value and theme.Accent or theme.Sunken,
		}, Enum.EasingStyle.Quad)
		tween(knob, 0.18, {
			Position = value and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		}, Enum.EasingStyle.Quint)
		if fire and options.Callback then
			task.spawn(options.Callback, value)
		end
		if fire and entry.OnChanged then
			entry.OnChanged(value)
		end
	end

	function entry:Get()
		return self.Value
	end

	entry.Section = self
	entry.Instance = track
	entry.Field = hit

	hit.MouseButton1Click:Connect(function()
		entry:Set(not entry.Value, true)
	end)
	track.MouseButton1Click:Connect(function()
		entry:Set(not entry.Value, true)
	end)

	self:_register(entry)
	entry:Set(entry.Value, false)
	return entry
end

function Section:Button(options)
	options = options or {}
	local row = create("Frame", {
		Name = options.Title or "Button",
		Size = UDim2.new(1, 0, 0, 46),
		BackgroundTransparency = 1,
		ZIndex = 9,
		Parent = self.Card,
	})
	pad(row, 0, 0, 6)

	local accent = options.Variant ~= "ghost"
	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = accent and self.Window.Theme.Accent or self.Window.Theme.Sunken,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 10,
		Parent = row,
	})
	corner(btn, 9)

	local text = label({
		Size = UDim2.new(1, 0, 1, 0),
		Text = options.Title or "按钮",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = accent and self.Window.Theme.OnAccent or self.Window.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 11,
		Parent = btn,
	})

	btn.MouseEnter:Connect(function()
		tween(btn, 0.12, {
			BackgroundColor3 = accent
					and self.Window.Theme.Accent:Lerp(Color3.fromRGB(0, 0, 0), 0.08)
				or self.Window.Theme.Stroke,
		})
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, 0.12, {
			BackgroundColor3 = accent and self.Window.Theme.Accent or self.Window.Theme.Sunken,
		})
	end)
	btn.MouseButton1Click:Connect(function()
		if options.Callback then
			task.spawn(options.Callback)
		end
	end)

	local entry = {
		Title = options.Title,
		Flag = options.Flag,
		Type = "Button",
		Row = row,
		Instance = btn,
	}
	self:_register(entry)
	return entry
end

function Section:Slider(options)
	options = options or {}
	local min = options.Min or 0
	local max = options.Max or 100
	local step = options.Step or 1

	local row = create("Frame", {
		Name = options.Title or "Slider",
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundTransparency = 1,
		ZIndex = 9,
		Parent = self.Card,
	})

	local title = label({
		Position = UDim2.new(0, 2, 0, 8),
		Size = UDim2.new(1, -80, 0, 18),
		Text = options.Title or "",
		TextSize = 12.5,
		Font = Enum.Font.GothamMedium,
		TextColor3 = self.Window.Theme.Text,
		ZIndex = 9,
		Parent = row,
	})
	self.Window:_bind(title, "Text", "TextColor3")

	local valueLabel = label({
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -2, 0, 8),
		Size = UDim2.new(0, 70, 0, 18),
		Text = "0",
		TextSize = 11.5,
		Font = Enum.Font.GothamBold,
		TextColor3 = self.Window.Theme.Accent,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 9,
		Parent = row,
	})
	self.Window:_bind(valueLabel, "Accent", "TextColor3")

	local bar = create("Frame", {
		Name = "Bar",
		Position = UDim2.new(0, 2, 0, 37),
		Size = UDim2.new(1, -8, 0, 5),
		BackgroundColor3 = self.Window.Theme.Sunken,
		BorderSizePixel = 0,
		ZIndex = 10,
		Parent = row,
	})
	corner(bar, 3)
	self.Window:_bind(bar, "Sunken", "BackgroundColor3")

	local fill = create("Frame", {
		Name = "Fill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = self.Window.Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = bar,
	})
	corner(fill, 3)
	self.Window:_bind(fill, "Accent", "BackgroundColor3")

	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 13, 0, 13),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 12,
		Parent = bar,
	})
	corner(knob, 7)
	stroke(knob, self.Window.Theme.Accent, 2, 0)

	local hit = create("TextButton", {
		Position = UDim2.new(0, -6, 0, -14),
		Size = UDim2.new(1, 12, 0, 34),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 13,
		Parent = bar,
	})

	local entry = {
		Title = options.Title,
		Flag = options.Flag,
		Type = "Slider",
		Value = options.Value or min,
		Row = row,
		Instance = bar,
	}

	local function roundTo(value)
		if step >= 1 then
			return math.floor(value / step + 0.5) * step
		end
		return math.floor(value / step + 0.5) * step
	end

	local function format(value)
		if options.Format then
			return options.Format(value)
		end
		if step >= 1 then
			return tostring(math.floor(value + 0.5))
		end
		return string.format("%.2f", value)
	end

	local function paint(value, fire)
		local theme = self.Window.Theme
		fill.BackgroundColor3 = theme.Accent
		bar.BackgroundColor3 = theme.Sunken
		valueLabel.TextColor3 = theme.Accent
		local alpha = 0
		if max > min then
			alpha = (value - min) / (max - min)
		end
		alpha = math.clamp(alpha, 0, 1)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		valueLabel.Text = format(value)
		entry.Value = value
		if fire then
			if options.Callback then
				task.spawn(options.Callback, value)
			end
			if entry.OnChanged then
				entry.OnChanged(value)
			end
		end
	end

	function entry:Set(value, fire)
		value = math.clamp(roundTo(value or 0), min, max)
		paint(value, fire)
	end

	function entry:Get()
		return self.Value
	end

	local function fromX(x)
		local width = bar.AbsoluteSize.X
		if width <= 0 then
			return
		end
		local alpha = math.clamp((x - bar.AbsolutePosition.X) / width, 0, 1)
		entry:Set(min + (max - min) * alpha, true)
	end

	local dragging = false
	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			fromX(input.Position.X)
		end
	end)
	hit.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			fromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	self:_register(entry)
	entry:Set(entry.Value, false)
	return entry
end

local function chevron(parent, size, color, thickness, rotation)
	local holder = create("Frame", {
		Size = UDim2.new(0, size, 0, size),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	local angle = rotation or 0
	local a = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, -1.6, 0.5, -0.6),
		Size = UDim2.new(0, size * 0.5, 0, thickness or 1.6),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Rotation = 45 + angle,
		Parent = holder,
	})
	corner(a, 1)
	local b = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 1.6, 0.5, -0.6),
		Size = UDim2.new(0, size * 0.5, 0, thickness or 1.6),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Rotation = -45 + angle,
		Parent = holder,
	})
	corner(b, 1)
	return holder, { a, b }
end

function Window:_closePopup()
	if self._popupLayer then
		self._popupLayer:Destroy()
		self._popupLayer = nil
	end
end

function Window:_popup(anchor, config)
	self:_closePopup()

	local theme = self.Theme
	local scale = self.Scale.Scale
	local rootAbs = self.Root.AbsolutePosition
	local abs = anchor.AbsolutePosition
	local anchorSize = anchor.AbsoluteSize
	local itemHeight = config.ItemHeight or 30
	local width = config.Width or (anchorSize.X / scale)
	local contentHeight = #config.Items * itemHeight + 8
	local height = math.min(contentHeight, config.MaxHeight or 210)

	local x = (abs.X - rootAbs.X) / scale
	local y = (abs.Y - rootAbs.Y) / scale + anchorSize.Y / scale + 4
	if y + height > self._height - 8 then
		y = (abs.Y - rootAbs.Y) / scale - height - 4
	end
	if y < 4 then
		y = 4
		height = math.min(height, self._height - 12)
	end
	x = math.clamp(x, 6, math.max(6, self._width - width - 6))

	local layer = create("Frame", {
		Name = "Popup",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 60,
		Parent = self.Root,
	})
	self._popupLayer = layer

	local blocker = create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 60,
		Parent = layer,
	})

	local card = create("Frame", {
		Position = UDim2.new(0, x, 0, y),
		Size = UDim2.new(0, width, 0, 0),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 62,
		Parent = layer,
	})
	corner(card, 10)
	stroke(card, theme.Stroke, 1, 0)

	local scroll = create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, contentHeight),
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = theme.Muted,
		ScrollBarImageTransparency = 0.5,
		ZIndex = 63,
		Parent = card,
	})
	pad(scroll, 4)
	list(scroll, Enum.FillDirection.Vertical, 0)

	local function close()
		self:_closePopup()
	end

	blocker.MouseButton1Click:Connect(close)

	for _, item in ipairs(config.Items) do
		local selected = item.Selected == true
		local row = create("TextButton", {
			Size = UDim2.new(1, 0, 0, itemHeight),
			BackgroundColor3 = selected and theme.AccentSoft or theme.Panel,
			BackgroundTransparency = selected and 0 or 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 63,
			Parent = scroll,
		})
		corner(row, 7)

		if item.Checkbox then
			local box = create("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 8, 0.5, 0),
				Size = UDim2.new(0, 15, 0, 15),
				BackgroundColor3 = selected and theme.Accent or theme.Sunken,
				BorderSizePixel = 0,
				ZIndex = 64,
				Parent = row,
			})
			corner(box, 5)
			stroke(box, selected and theme.Accent or theme.Stroke, 1.4, 0)
			if selected then
				local mark = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 7, 0, 4),
					BackgroundColor3 = theme.OnAccent,
					BorderSizePixel = 0,
					Rotation = -45,
					ZIndex = 65,
					Parent = box,
				})
				corner(mark, 1)
			end
			local txt = label({
				Position = UDim2.new(0, 30, 0, 0),
				Size = UDim2.new(1, -38, 1, 0),
				Text = item.Text,
				TextSize = 12,
				TextColor3 = theme.Text,
				Truncate = Enum.TextTruncate.AtEnd,
				ZIndex = 64,
				Parent = row,
			})
		else
			local txt = label({
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -24, 1, 0),
				Text = item.Text,
				TextSize = 12,
				TextColor3 = selected and theme.Accent or theme.Text,
				Font = selected and Enum.Font.GothamBold or Enum.Font.GothamMedium,
				Truncate = Enum.TextTruncate.AtEnd,
				ZIndex = 64,
				Parent = row,
			})
			if selected then
				local bar = create("Frame", {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 3, 0.5, 0),
					Size = UDim2.new(0, 2, 0.5, 0),
					BackgroundColor3 = theme.Accent,
					BorderSizePixel = 0,
					ZIndex = 65,
					Parent = row,
				})
				corner(bar, 1)
			end
		end

		row.MouseEnter:Connect(function()
			if not selected then
				row.BackgroundTransparency = 0.5
				row.BackgroundColor3 = theme.Sunken
			end
		end)
		row.MouseLeave:Connect(function()
			row.BackgroundTransparency = selected and 0 or 1
			if not selected then
				row.BackgroundColor3 = theme.Panel
			end
		end)
		row.MouseButton1Click:Connect(function()
			close()
			if config.OnPick then
				config.OnPick(item)
			end
		end)
	end

	tween(card, 0.14, { Size = UDim2.new(0, width, 0, height) }, Enum.EasingStyle.Quint)
end

function Section:Dropdown(options)
	options = options or {}
	local values = options.Values or options.Options or {}
	local multi = options.Multi == true

	local rightWidth = self.Window.Compact and 126 or 150
	local row, right = self:_row({
		Title = options.Title,
		Desc = options.Desc,
		RightWidth = rightWidth + 6,
	})

	local button = create("TextButton", {
		Name = "Dropdown",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, rightWidth, 0, 30),
		BackgroundColor3 = self.Window.Theme.Sunken,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 10,
		Parent = right,
	})
	corner(button, 8)

	local textLabel = label({
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(1, -32, 1, 0),
		Text = "选择…",
		TextSize = 11.5,
		TextColor3 = self.Window.Theme.Text,
		Truncate = Enum.TextTruncate.AtEnd,
		ZIndex = 11,
		Parent = button,
	})
	self.Window:_bind(textLabel, "Text", "TextColor3")

	local arrowHolder, arrowParts = chevron(button, 9, self.Window.Theme.Muted, 1.6)
	arrowHolder.Position = UDim2.new(1, -18, 0, 11)
	arrowHolder.ZIndex = 11
	for _, part in ipairs(arrowParts) do
		part.ZIndex = 11
	end

	local entry = {
		Title = options.Title,
		Flag = options.Flag,
		Type = multi and "MultiDropdown" or "Dropdown",
		Row = row,
		Instance = button,
		Section = self,
		Values = values,
		Selected = {},
		Value = options.Value,
	}
	if multi then
		entry.Selected = {}
		for _, value in ipairs(options.Default or {}) do
			entry.Selected[value] = true
		end
	end

	local function refreshText()
		if multi then
			local count = 0
			for _ in pairs(entry.Selected) do
				count = count + 1
			end
			if count == 0 then
				textLabel.Text = "未选择"
			elseif count == #values then
				textLabel.Text = "全部（" .. count .. "）"
			else
				local names = {}
				for _, value in ipairs(values) do
					if entry.Selected[value] then
						table.insert(names, tostring(value))
					end
				end
				textLabel.Text = table.concat(names, "、")
			end
			local list = {}
			for _, value in ipairs(values) do
				if entry.Selected[value] then
					table.insert(list, value)
				end
			end
			entry.Value = list
		else
			textLabel.Text = entry.Value ~= nil and tostring(entry.Value) or "选择…"
		end
	end

	function entry:Get()
		return self.Value
	end

	function entry:Set(value, fire)
		if multi then
			self.Selected = {}
			if type(value) == "table" then
				for _, item in ipairs(value) do
					self.Selected[item] = true
				end
			end
		else
			self.Value = value
		end
		refreshText()
		if fire and options.Callback then
			task.spawn(options.Callback, self.Value)
		end
	end

	function entry:Select(value, fire)
		self:Set(value, fire)
	end

	function entry:Refresh(newValues)
		self.Values = newValues
		values = newValues
		if multi then
			for key in pairs(self.Selected) do
				local found = false
				for _, value in ipairs(newValues) do
					if value == key then
						found = true
						break
					end
				end
				if not found then
					self.Selected[key] = nil
				end
			end
		else
			local found = false
			for _, value in ipairs(newValues) do
				if value == self.Value then
					found = true
					break
				end
			end
			if not found then
				self.Value = newValues[1]
			end
		end
		refreshText()
	end

	local function open()
		local items = {}
		for _, value in ipairs(values) do
			local selected
			if multi then
				selected = entry.Selected[value] == true
			else
				selected = entry.Value == value
			end
			table.insert(items, { Text = tostring(value), Value = value, Selected = selected, Checkbox = multi })
		end
		if #items == 0 then
			table.insert(items, { Text = "（无选项）", Value = nil })
		end

		self.Window:_popup(button, {
			Items = items,
			Width = 168,
			OnPick = function(item)
				if item.Value == nil then
					return
				end
				if multi then
					if entry.Selected[item.Value] then
						entry.Selected[item.Value] = nil
					else
						entry.Selected[item.Value] = true
					end
					refreshText()
					if options.Callback then
						task.spawn(options.Callback, entry.Value)
					end
				else
					entry.Value = item.Value
					refreshText()
					if options.Callback then
						task.spawn(options.Callback, entry.Value)
					end
				end
			end,
		})
	end

	button.MouseButton1Click:Connect(open)

	self:_register(entry)
	if not multi and entry.Value == nil then
		entry.Value = values[1]
	end
	refreshText()
	return entry
end

function Section:MultiDropdown(options)
	options = options or {}
	local copy = {}
	for key, value in pairs(options) do
		copy[key] = value
	end
	copy.Multi = true
	return self:Dropdown(copy)
end

function Section:Keybind(options)
	options = options or {}
	local row, right = self:_row({
		Title = options.Title,
		Desc = options.Desc,
		RightWidth = self.Window.Compact and 82 or 96,
	})

	local button = create("TextButton", {
		Name = "Keybind",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, self.Window.Compact and 78 or 92, 0, 28),
		BackgroundColor3 = self.Window.Theme.Sunken,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 10,
		Parent = right,
	})
	corner(button, 8)
	self.Window:_bind(button, "Sunken", "BackgroundColor3")

	local text = label({
		Size = UDim2.new(1, 0, 1, 0),
		Text = "未设置",
		TextSize = 11.5,
		Font = Enum.Font.GothamBold,
		TextColor3 = self.Window.Theme.Muted,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 11,
		Parent = button,
	})
	self.Window:_bind(text, "Muted", "TextColor3")

	local entry = {
		Title = options.Title,
		Flag = options.Flag,
		Type = "Keybind",
		Row = row,
		Instance = button,
		Section = self,
		Value = options.Value,
		Locked = options.Locked == true,
	}

	local listening = false
	local connection = nil

	local function display()
		if entry.Value then
			text.Text = tostring(entry.Value)
			text.TextColor3 = self.Window.Theme.Text
		else
			text.Text = "未设置"
			text.TextColor3 = self.Window.Theme.Muted
		end
	end

	local function stopListen()
		listening = false
		if connection then
			connection:Disconnect()
			connection = nil
		end
		display()
	end

	local function startListen()
		if entry.Locked or listening then
			return
		end
		listening = true
		text.Text = "按键…"
		text.TextColor3 = self.Window.Theme.Accent
		connection = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then
				return
			end
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			if input.KeyCode == Enum.KeyCode.Escape then
				stopListen()
				return
			end
			entry.Value = input.KeyCode
			stopListen()
			if options.Callback then
				task.spawn(options.Callback, entry.Value)
			end
			if entry.OnChanged then
				entry.OnChanged(entry.Value)
			end
		end)
		task.delay(5, function()
			if listening then
				stopListen()
			end
		end)
	end

	function entry:Set(value, fire)
		self.Value = value
		display()
		if fire and options.Callback then
			task.spawn(options.Callback, value)
		end
	end

	function entry:Get()
		return self.Value
	end

	button.MouseButton1Click:Connect(startListen)
	display()
	self:_register(entry)
	return entry
end

function Section:Input(options)
	options = options or {}
	local row, right = self:_row({
		Title = options.Title,
		Desc = options.Desc,
		RightWidth = self.Window.Compact and 132 or 154,
	})

	local box = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, self.Window.Compact and 128 or 150, 0, 30),
		BackgroundColor3 = self.Window.Theme.Sunken,
		BorderSizePixel = 0,
		ZIndex = 10,
		Parent = right,
	})
	corner(box, 8)
	self.Window:_bind(box, "Sunken", "BackgroundColor3")

	local input = create("TextBox", {
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextSize = 11.5,
		Text = options.Value or "",
		PlaceholderText = options.Placeholder or "输入…",
		PlaceholderColor3 = self.Window.Theme.Muted,
		TextColor3 = self.Window.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		ZIndex = 11,
		Parent = box,
	})
	self.Window:_bind(input, "Text", "TextColor3")

	local entry = {
		Title = options.Title,
		Flag = options.Flag,
		Type = "Input",
		Row = row,
		Instance = input,
		Section = self,
		Value = options.Value or "",
	}

	function entry:Set(value, fire)
		self.Value = tostring(value or "")
		input.Text = self.Value
		if fire and options.Callback then
			task.spawn(options.Callback, self.Value)
		end
	end

	function entry:Get()
		return self.Value
	end

	local function commit()
		entry.Value = input.Text
		if options.Callback then
			task.spawn(options.Callback, entry.Value)
		end
		if entry.OnChanged then
			entry.OnChanged(entry.Value)
		end
	end

	input.FocusLost:Connect(commit)
	input:GetPropertyChangedSignal("Text"):Connect(function()
		entry.Value = input.Text
	end)

	self:_register(entry)
	return entry
end

function Section:Paragraph(options)
	options = options or {}
	if type(options) == "string" then
		options = { Title = options }
	end
	if options.Title == "" then
		options.Title = nil
	end

	local row = create("Frame", {
		Name = "Paragraph",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 9,
		Parent = self.Card,
	})
	pad(row, 8, 2, 6)

	local text = label({
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = options.Title or "",
		TextSize = 11.5,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = self.Window.Theme.Muted,
		ZIndex = 9,
		Parent = row,
	})
	self.Window:_bind(text, "Muted", "TextColor3")

	local entry = {
		Title = options.Title or "",
		Type = "Paragraph",
		Row = row,
		Instance = text,
		Set = function(self2, value)
			text.Text = tostring(value)
		end,
	}
	self:_register(entry)
	return entry
end

function Section:Divider()
	local holder = create("Frame", {
		Name = "Divider",
		Size = UDim2.new(1, 0, 0, 13),
		BackgroundTransparency = 1,
		ZIndex = 9,
		Parent = self.Card,
	})
	local line = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -4, 0, 1),
		BackgroundColor3 = self.Window.Theme.Stroke,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		ZIndex = 9,
		Parent = holder,
	})
	local entry = { Title = "", Type = "Divider", Row = holder, Instance = line }
	self:_register(entry)
	return entry
end

function Section:Label(options)
	options = options or {}
	local row = create("Frame", {
		Name = "Label",
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		ZIndex = 9,
		Parent = self.Card,
	})
	local title = label({
		Position = UDim2.new(0, 2, 0, 0),
		Size = UDim2.new(1, -90, 1, 0),
		Text = options.Title or "",
		TextSize = 12,
		TextColor3 = self.Window.Theme.Muted,
		ZIndex = 9,
		Parent = row,
	})
	self.Window:_bind(title, "Muted", "TextColor3")

	local value = label({
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -2, 0.5, 0),
		Size = UDim2.new(0, 86, 1, 0),
		Text = tostring(options.Value or ""),
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextColor3 = self.Window.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 9,
		Parent = row,
	})
	self.Window:_bind(value, "Text", "TextColor3")

	local entry = {
		Title = options.Title or "",
		Type = "Label",
		Row = row,
		Instance = value,
		Set = function(self2, newValue)
			value.Text = tostring(newValue)
		end,
	}
	self:_register(entry)
	return entry
end

function Tab:_defaultSection()
	if not self._baseSection then
		self._baseSection = self:Section({ Title = "" })
	end
	return self._baseSection
end

for _, name in ipairs({
	"Toggle",
	"Button",
	"Slider",
	"Dropdown",
	"MultiDropdown",
	"Keybind",
	"Input",
	"Paragraph",
	"Divider",
	"Label",
}) do
	Tab[name] = function(self, options)
		local section = self:_defaultSection()
		return section[name](section, options)
	end
end

function Window:SetTheme(name, silent)
	if not WindUI.Themes[name] then
		return
	end
	self.ThemeName = name
	self.Theme = WindUI.Themes[name]
	WindUI.Theme = name
	for _, item in ipairs(self._paints) do
		local ok = pcall(function()
			item.inst[item.prop] = self.Theme[item.key]
		end)
		if not ok then
			item.dead = true
		end
	end
	for _, entry in ipairs(self._allEntries or {}) do
		if entry.Set and entry.Value ~= nil and entry.Type ~= "Paragraph" then
			pcall(function()
				entry:Set(entry.Value, false)
			end)
		end
	end
	pcall(function()
		self.BadgeGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, self.Theme.Accent),
			ColorSequenceKeypoint.new(1, self.Theme.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.28)),
		})
		for _, shadow in ipairs(self._shadows) do
			shadow.BackgroundColor3 = self.Theme.Shadow
		end
		self.BorderStroke.Color = self.Theme.Stroke
		if self.Bubble then
			self.BubbleGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, self.Theme.Accent),
				ColorSequenceKeypoint.new(1, self.Theme.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.3)),
			})
		end
	end)
	if not silent and self.OnThemeChanged then
		self.OnThemeChanged(name, self.Theme)
	end
end

function Window:GetTheme()
	return self.ThemeName
end

function Window:SetFont(fontName)
	local font = Enum.Font[fontName]
	if not font then
		return
	end
	self.Font = fontName
	WindUI.Font = fontName
	local function walk(inst)
		for _, child in ipairs(inst:GetChildren()) do
			if child.ClassName == "TextLabel" or child.ClassName == "TextButton" or child.ClassName == "TextBox" then
				pcall(function()
					child.Font = font
				end)
			end
			walk(child)
		end
	end
	walk(self.ScreenGui)
end

function Window:SetScale(value)
	self.Scale.Scale = value
end

function Window:SetTransparency(value)
	value = math.clamp(value or 0, 0, 0.9)
	self.Transparency = value
	self.Body.BackgroundTransparency = value
	self.Tint.BackgroundTransparency = value
	self.BgImage.ImageTransparency = math.min(1, value + 0.45)
end

function Window:SetBackgroundImage(assetId, transparency)
	if not assetId or assetId == "" then
		self.BgImage.Image = ""
		return
	end
	local id = tostring(assetId)
	if tonumber(id) then
		id = "rbxassetid://" .. id
	end
	self.BackgroundImage = id
	self.BgImage.Image = id
	self.BgImage.ImageTransparency = transparency or 0.5
end

function Window:ToggleKeybind(keyCode)
	local code = keyCode
	if type(keyCode) == "string" then
		code = Enum.KeyCode[keyCode]
	end
	if not code then
		return
	end
	self._toggleKey = code
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		if input.KeyCode == code then
			if self.Minimized then
				self:Restore()
			elseif self.Root.Visible then
				self:Minimize()
			else
				self:Restore()
			end
		end
	end)
end

function Window:_makeBubble()
	if self.Bubble then
		return
	end
	local bubble = create("TextButton", {
		Name = "Bubble",
		Size = UDim2.new(0, 52, 0, 52),
		BackgroundColor3 = self.Theme.Accent,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Visible = false,
		ZIndex = 50,
		Parent = self.ScreenGui,
	})
	corner(bubble, 17)
	local gradient = create("UIGradient", {
		Rotation = 120,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, self.Theme.Accent),
			ColorSequenceKeypoint.new(1, self.Theme.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.3)),
		}),
		Parent = bubble,
	})
	self.BubbleGradient = gradient
	label({
		Size = UDim2.new(1, 0, 1, 0),
		Text = iconText(self.Title, "W"),
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = self.Theme.OnAccent,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 51,
		Parent = bubble,
	})
	local scale = create("UIScale", { Scale = 0, Parent = bubble })
	self.Bubble = bubble
	self.BubbleScale = scale

	local dragging = false
	local dragStart = nil
	local startPos = nil
	bubble.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = mouseLocation()
			startPos = Vector2.new(bubble.Position.X.Offset, bubble.Position.Y.Offset)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local delta = mouseLocation() - dragStart
			if math.abs(delta.X) > 2 or math.abs(delta.Y) > 2 then
				bubble.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	bubble.MouseButton1Click:Connect(function()
		self:Restore()
	end)
end

function Window:_placeBubble()
	local vp = viewportSize()
	local bubble = self.Bubble
	if not bubble then
		return
	end
	bubble.Position = UDim2.new(0, vp.X - 76, 0, vp.Y * 0.42)
end

function Window:Minimize()
	if self.Minimized then
		return
	end
	self.Minimized = true
	self:_makeBubble()
	self:_placeBubble()
	self.Bubble.Visible = true
	tween(self.Root, 0.16, { Size = UDim2.new(0, self._width * 0.9, 0, self._height * 0.9) }, Enum.EasingStyle.Quad)
	self.Root.Visible = false
	tween(self.BubbleScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back)
end

function Window:Restore()
	if not self.Minimized then
		return
	end
	self.Minimized = false
	self.Root.Size = UDim2.new(0, self._width, 0, self._height)
	self.Root.Visible = true
	if self.Bubble then
		tween(self.BubbleScale, 0.14, { Scale = 0 }, Enum.EasingStyle.Quad)
		task.delay(0.15, function()
			if self.Bubble and self.Minimized == false then
				self.Bubble.Visible = false
			end
		end)
	end
end

function Window:Close()
	if self.CloseToBubble then
		self:Minimize()
		return
	end
	self:Destroy()
end

function Window:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true
	for _, closer in ipairs(self._closers) do
		pcall(closer)
	end
	if self.Bubble then
		self.Bubble:Destroy()
	end
	self.ScreenGui:Destroy()
	for index, win in ipairs(WindUI.Connections) do
		if win == self then
			table.remove(WindUI.Connections, index)
			break
		end
	end
end

function Window:GetFlag(name)
	local entry = self.Flags[name]
	if entry then
		return entry.Value
	end
	return nil
end

function Window:SetFlag(name, value, fire)
	local entry = self.Flags[name]
	if entry and entry.Set then
		entry:Set(value, fire ~= false)
		return true
	end
	return false
end

function Window:GetAllFlags()
	local data = {}
	for name, entry in pairs(self.Flags) do
		data[name] = entry.Value
	end
	return data
end

local function serialize(value)
	local kind = typeof and typeof(value) or type(value)
	if kind == "EnumItem" then
		return { __t = "key", v = value.Name }
	elseif kind == "Color3" then
		return { __t = "color", v = { value.R, value.G, value.B } }
	elseif kind == "table" then
		local out = {}
		for key, item in pairs(value) do
			out[key] = serialize(item)
		end
		return out
	end
	return value
end

local function deserialize(value, keyEnum)
	if type(value) == "table" then
		if value.__t == "key" then
			return Enum.KeyCode[value.v]
		elseif value.__t == "color" then
			return Color3.new(value.v[1], value.v[2], value.v[3])
		end
		local out = {}
		for key, item in pairs(value) do
			out[key] = deserialize(item)
		end
		return out
	end
	return value
end

function Window:ConfigManager(options)
	options = options or {}
	local folder = options.Folder or "WindUI"
	local name = options.Name or "default"
	local path = folder .. "/" .. name .. ".json"
	local win = self

	local manager = {}

	local function available()
		return type(writefile) == "function" and type(readfile) == "function"
	end

	function manager:Save()
		if not available() then
			return false
		end
		local data = {}
		for flag, entry in pairs(win.Flags) do
			data[flag] = serialize(entry.Value)
		end
		local ok = pcall(function()
			if type(isfolder) == "function" and not isfolder(folder) then
				makefolder(folder)
			end
			writefile(path, HttpService:JSONEncode(data))
		end)
		return ok
	end

	function manager:Load()
		if not available() then
			return false
		end
		if type(isfile) == "function" and not isfile(path) then
			return false
		end
		local ok, content = pcall(readfile, path)
		if not ok or not content then
			return false
		end
		local decoded
		local parsed = pcall(function()
			decoded = HttpService:JSONDecode(content)
		end)
		if not parsed or type(decoded) ~= "table" then
			return false
		end
		for flag, value in pairs(decoded) do
			local entry = win.Flags[flag]
			if entry and entry.Set then
				local restored = deserialize(value)
				if restored ~= nil then
					pcall(function()
						entry:Set(restored, false)
					end)
				end
			end
		end
		return true
	end

	function manager:Delete()
		if not available() then
			return false
		end
		return pcall(function()
			if type(isfile) == "function" and isfile(path) then
				delfile(path)
			end
		end)
	end

	function manager:List()
		if type(listfiles) ~= "function" or not available() then
			return {}
		end
		local ok, files = pcall(listfiles, folder)
		if not ok or not files then
			return {}
		end
		return files
	end

	self.Config = manager
	if options.AutoLoad ~= false and available() then
		task.spawn(function()
			manager:Load()
		end)
	end
	if options.AutoSave then
		local interval = options.AutoSave == true and 8 or options.AutoSave
		task.spawn(function()
			while not self.Destroyed do
				task.wait(interval)
				manager:Save()
			end
		end)
	end
	return manager
end

function Window:Notify(options)
	return WindUI:Notify(options)
end

function Window:Dialog(options)
	return WindUI:Dialog(options)
end

local notifyGui = nil
local notifyList = nil

local function ensureLayers()
	if notifyGui and notifyGui.Parent then
		return
	end
	notifyGui = create("ScreenGui", {
		Name = "WindUI_Overlay",
		IgnoreGuiInset = false,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 120,
	})
	pcall(function()
		notifyGui.Parent = getGuiParent()
	end)
	if not notifyGui.Parent then
		notifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
	local vp = viewportSize()
	local notifyWidth = math.clamp(vp.X - 48, 240, 286)
	notifyList = create("Frame", {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -16, 0, 16),
		Size = UDim2.new(0, notifyWidth, 1, -32),
		BackgroundTransparency = 1,
		Parent = notifyGui,
	})
	local layout = list(notifyList, Enum.FillDirection.Vertical, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
end

function WindUI:Notify(options)
	options = options or {}
	ensureLayers()
	local theme = WindUI.Themes[WindUI.Theme]
	local kind = options.Type or "info"
	local accent = theme.Accent
	if kind == "success" then
		accent = theme.Success
	elseif kind == "error" then
		accent = theme.Danger
	elseif kind == "warning" then
		accent = Color3.fromRGB(228, 160, 54)
	end

	local duration = options.Duration or 4
	local hasBody = options.Content and options.Content ~= ""

	local card = create("Frame", {
		Name = "Notify",
		Size = UDim2.new(1, 0, 0, hasBody and 66 or 48),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Parent = notifyList,
	})
	corner(card, 12)
	stroke(card, theme.Stroke, 1, 0.1)

	local bar = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.new(0, 3, 1, -20),
		BackgroundColor3 = accent,
		BorderSizePixel = 0,
		Parent = card,
	})
	corner(bar, 2)

	local dot = create("Frame", {
		Position = UDim2.new(0, 22, 0, hasBody and 14 or 15),
		Size = UDim2.new(0, 8, 0, 8),
		BackgroundColor3 = accent,
		BorderSizePixel = 0,
		Parent = card,
	})
	corner(dot, 4)

	label({
		Position = UDim2.new(0, 38, 0, hasBody and 11 or 13),
		Size = UDim2.new(1, -50, 0, 16),
		Text = options.Title or "提示",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = theme.Text,
		Truncate = Enum.TextTruncate.AtEnd,
		Parent = card,
	})

	if hasBody then
		label({
			Position = UDim2.new(0, 38, 0, 29),
			Size = UDim2.new(1, -50, 0, 28),
			Text = options.Content,
			TextSize = 11,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = theme.Muted,
			Parent = card,
			Truncate = Enum.TextTruncate.AtEnd,
		})
	end

	local progress = create("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 2),
		BackgroundColor3 = accent,
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Parent = card,
	})

	card.BackgroundTransparency = 1
	card.Position = UDim2.new(0, 30, 0, 0)
	tween(card, 0.26, { BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Quint)
	tween(progress, duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)

	task.delay(duration, function()
		if not card.Parent then
			return
		end
		tween(card, 0.2, { BackgroundTransparency = 1, Position = UDim2.new(0, 26, 0, 0) }, Enum.EasingStyle.Quad)
		task.wait(0.22)
		card:Destroy()
	end)

	return card
end

function WindUI:Dialog(options)
	options = options or {}
	ensureLayers()
	local theme = WindUI.Themes[WindUI.Theme]

	local layer = create("Frame", {
		Name = "Dialog",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Parent = notifyGui,
	})

	local bodyText = options.Content or ""
	local lines = 0
	if bodyText ~= "" then
		lines = math.max(1, math.ceil(#bodyText / 21))
	end
	local bodyHeight = lines > 0 and (lines * 18 + 6) or 0
	local cardHeight = 18 + 22 + (lines > 0 and bodyHeight + 8 or 0) + 36 + 18

	local card = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 10),
		Size = UDim2.new(0, 340, 0, cardHeight),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Parent = layer,
	})
	corner(card, 16)
	stroke(card, theme.Stroke, 1, 0)
	pad(card, 20, 20, 18)

	local content = create("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = card,
	})
	list(content, Enum.FillDirection.Vertical, 8)

	label({
		Size = UDim2.new(1, 0, 0, 20),
		Text = options.Title or "提示",
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextColor3 = theme.Text,
		Parent = content,
	})

	if lines > 0 then
		label({
			Size = UDim2.new(1, 0, 0, bodyHeight),
			Text = options.Content,
			TextSize = 12,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = theme.Muted,
			Parent = content,
		})
	end

	local buttons = create("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		Parent = content,
	})
	local row = list(buttons, Enum.FillDirection.Horizontal, 8)
	row.HorizontalAlignment = Enum.HorizontalAlignment.Right
	row.VerticalAlignment = Enum.VerticalAlignment.Center

	local function close()
		tween(layer, 0.16, { BackgroundTransparency = 1 })
		tween(card, 0.16, { Position = UDim2.new(0.5, 0, 0.5, 12) }, Enum.EasingStyle.Quad)
		task.wait(0.17)
		layer:Destroy()
	end

	local function makeButton(text, primary, callback)
		local btn = create("TextButton", {
			Size = UDim2.new(0, primary and 96 or 80, 0, 32),
			BackgroundColor3 = primary and theme.Accent or theme.Sunken,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			Parent = buttons,
		})
		corner(btn, 9)
		label({
			Size = UDim2.new(1, 0, 1, 0),
			Text = text,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = primary and theme.OnAccent or theme.Text,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = btn,
		})
		btn.MouseButton1Click:Connect(function()
			close()
			if callback then
				task.spawn(callback)
			end
		end)
		return btn
	end

	local cancelText = options.CancelText
	if cancelText ~= false then
		makeButton(cancelText or "取消", false, options.OnCancel)
	end
	makeButton(options.ConfirmText or "确定", true, options.OnConfirm)

	tween(layer, 0.2, { BackgroundTransparency = 0.5 })
	tween(card, 0.24, { Position = UDim2.new(0.5, 0, 0.5, 0) }, Enum.EasingStyle.Quint)

	return { Close = close, Frame = card }
end

function WindUI:Tooltip(target, text)
	ensureLayers()
	local theme = WindUI.Themes[WindUI.Theme]
	local tip = nil
	local token = 0

	local function hide()
		token = token + 1
		if tip then
			tip:Destroy()
			tip = nil
		end
	end

	local function show()
		if tip or text == "" then
			return
		end
		tip = create("TextLabel", {
			Name = "Tooltip",
			BackgroundColor3 = theme.Text,
			BackgroundTransparency = 0.06,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			TextSize = 11,
			Text = text,
			TextColor3 = theme.Panel,
			Size = UDim2.new(0, 0, 0, 24),
			AutomaticSize = Enum.AutomaticSize.X,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = notifyGui,
		})
		corner(tip, 7)
		pad(tip, 0, 8, 0)
		local pos = UserInputService:GetMouseLocation()
		tip.Position = UDim2.new(0, pos.X + 14, 0, pos.Y + 18)
		tip.BackgroundTransparency = 1
		tween(tip, 0.12, { BackgroundTransparency = 0.06 })
	end

	target.MouseEnter:Connect(function()
		token = token + 1
		local myToken = token
		task.delay(0.42, function()
			if token == myToken then
				show()
			end
		end)
	end)
	target.MouseLeave:Connect(hide)

	return {
		Destroy = function()
			hide()
		end,
	}
end

WindUI.Creator = {
	Theme = WindUI.Theme,
}

function WindUI:SetTheme(name)
	WindUI.Theme = name
	WindUI.Creator.Theme = name
	for _, win in ipairs(WindUI.Connections) do
		if win.ThemeName ~= name and not win.Destroyed then
			win:SetTheme(name, true)
		end
	end
end

function WindUI:Destroy()
	for _, win in ipairs(WindUI.Connections) do
		pcall(function()
			win:Destroy()
		end)
	end
	WindUI.Connections = {}
	if notifyGui then
		notifyGui:Destroy()
		notifyGui = nil
	end
end

return WindUI
