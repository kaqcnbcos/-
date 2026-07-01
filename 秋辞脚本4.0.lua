local AimSettings = {
    Enabled = false,
    FOV = 100,
    FOVEnabled = true,
    FOVRainbowEnabled = false,
    FOVRainbowSpeed = 5,
    FOVColor = Color3.fromRGB(255, 255, 255),
    Smoothness = 5,
    CrosshairDistance = 0,
    WallCheck = false,
    FriendCheck = false,
    TargetAll = true,
    TargetPlayer = nil
}

local DrawingObjects = {}
local FOVCircle = nil
local CurrentFOVHue = 0
local ESPEnabled = false
local ESPRainbowEnabled = false
local ESPNameColor = Color3.fromRGB(255, 255, 255)
local ESPBodyColor = Color3.fromRGB(255, 255, 255)
local ESPNameSize = 14
local CurrentESPHue = 0
local ESPRainbowSpeed = 5
local BackstabCheckEnabled = false
local BackstabCooldown = 0
local BACKSTAB_COOLDOWN_TIME = 3
local DeathCheckEnabled = false
local originalGravity = workspace.Gravity
local SpeedValue = 1
local SpeedEnabled = false
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YIRDEX/Miscs/refs/heads/main/YXWindUI.lua"))()

WindUI:AddTheme({
    Name = "AF Hub", 
    Accent = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#FF4C4C"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#FF1A1A"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#CC0000"), Transparency = 0}
    }, {Rotation = 90}),
    Background = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#FF4C4C"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#FF1A1A"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#CC0000"), Transparency = 0}
    }, {Rotation = 90}),
    Outline = Color3.fromHex("#FF6666"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#AAAAAA"),
    Button = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#FF4C4C"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#FF1A1A"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#CC0000"), Transparency = 0}
    }, {Rotation = 90}),
    Icon = Color3.fromHex("#FF6666")
})

-- 月夜
WindUI:AddTheme({
    Name = "月夜",
    Accent = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#232526"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#636363"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#E0E0E0"), Transparency = 0}
    }, {Rotation = 90}),
    Dialog = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#1C1C1C"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#3A3A3A"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#636363"), Transparency = 0}
    }, {Rotation = 90}),
    Outline = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#B0B0B0"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#C0C0C0"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#E0E0E0"), Transparency = 0}
    }, {Rotation = 90}),
    Text = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#FFFFFF"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#D9D9D9"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#BFBFBF"), Transparency = 0}
    }, {Rotation = 90}),
    Placeholder = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#A0A0A0"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#B0B0B0"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#C0C0C0"), Transparency = 0}
    }, {Rotation = 90}),
    Background = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#101010"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#3A3A3A"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#636363"), Transparency = 0}
    }, {Rotation = 90}),
    Button = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#3A3A3A"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#636363"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#A2A2A2"), Transparency = 0}
    }, {Rotation = 90}),
    Icon = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#C0C0C0"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#E0E0E0"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#FFFFFF"), Transparency = 0}
    }, {Rotation = 90})
})

-- 冬日霜雪
WindUI:AddTheme({
    Name = "冬日霜雪",
    Accent = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#D0E8F2"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#A0D4F2"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#70C0F2"), Transparency = 0}
    }, {Rotation = 45}),
    Dialog = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#E0F7FF"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#B0EFFF"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#80E7FF"), Transparency = 0}
    }, {Rotation = 45}),
    Outline = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#70C0F2"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#50B0E0"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#30A0D0"), Transparency = 0}
    }, {Rotation = 45}),
    Text = Color3.fromHex("#000000"),
    Placeholder = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#7FB3D5"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#5FA2C5"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#3F91B5"), Transparency = 0}
    }, {Rotation = 45}),
    Background = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#E6F0FA"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#CDE0F5"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#B4D1F0"), Transparency = 0}
    }, {Rotation = 45}),
    Button = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#50B0E0"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#30A0D0"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#108FC0"), Transparency = 0}
    }, {Rotation = 45}),
    Icon = Color3.fromHex("#00FFFF")
})

-- 月渊
WindUI:AddTheme({
    Name = "月渊",
    Accent = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#0D0D1A"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#1A1A33"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#2E2E5C"), Transparency = 0}
    }, {Rotation = 90}),
    Dialog = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#101026"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#1A1A3D"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#333366"), Transparency = 0}
    }, {Rotation = 90}),
    Outline = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#2E2E5C"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#404080"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#5050A0"), Transparency = 0}
    }, {Rotation = 90}),
    Text = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#A0A0FF"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#C0C0FF"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#E0E0FF"), Transparency = 0}
    }, {Rotation = 90}),
    Placeholder = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#6060A0"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#8080C0"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#A0A0E0"), Transparency = 0}
    }, {Rotation = 90}),
    Background = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#0A0A1A"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#1A1A33"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#2E2E5C"), Transparency = 0}
    }, {Rotation = 90}),
    Button = WindUI:Gradient({
        ["0"] = {Color = Color3.fromHex("#404080"), Transparency = 0},
        ["50"] = {Color = Color3.fromHex("#5050A0"), Transparency = 0},
        ["100"] = {Color = Color3.fromHex("#6060C0"), Transparency = 0}
    }, {Rotation = 90}),
    Icon = Color3.fromHex("#00FFFF")
})

WindUI:SetFont("rbxassetid://12187369639")

local Window = WindUI:CreateWindow({
    Title = '<font color="#FF0000">A</font><font color="#00F0FF">F</font><font color="#00E5FF">-</font><font color="#00D5FF">H</font><font color="#00C8FF">U</font><font color="#00BBFF">B</font>', -- 窗口标题
    Icon = "rbxassetid://82225829203828", 
    Author = "@秋辞", -- 窗口副标题，可选
    Folder = "YX-Hub文件夹", -- 保存密钥和图片的文件夹
    Size = UDim2.fromOffset(520, 400), -- 窗口大小
    MinSize = Vector2.new(560, 350), -- 窗口最小尺寸
    MaxSize = Vector2.new(850, 560), -- 窗口最大尺寸
    Transparent = true, -- 窗口透明度
    Theme = "冬日霜雪", 
    Resizable = true, -- 是否可调整窗口大小
    SideBarWidth = 150, -- 侧边栏（标签页）宽度
    HideSearchBar = false, -- 隐藏搜索栏
    ScrollBarEnabled = true, -- 位于滚动框右侧的滚动条
Background = "rbxassetid://123887383447725",
    
    User = { -- 位于左下角的用户信息
        Enabled = false,
        Anonymous = false,
        Callback = function() -- 点击时的回调函数，可选，可移除
            print("点击")
        end,
    },
})



-- 编辑窗口展开按钮配置
Window:EditOpenButton({
    Title = '<font color="#FF0000">A</font><font color="#00F0FF">F</font><font color="#00E5FF">-</font><font color="#00D5FF">H</font><font color="#00C8FF">U</font><font color="#00BBFF">B</font>',
    Icon = "snowflake",
    CornerRadius = UDim.new(99,99),
    StrokeThickness = 3,
    IconSize = 30,
    Color = ColorSequence.new(Color3.fromHex("00FFFF"), Color3.fromHex("00BBFF")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("00FFFF")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("0000FF"))
    }), "palette"},
}

local borderAnimation
local animationSpeed = 5

local function createRainbowBorder(window, colorScheme)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end

    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then existingStroke:Destroy() end

    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end

    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 2
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Parent = mainFrame

    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    local schemeData = COLOR_SCHEMES[colorScheme or "彩虹颜色"]
    glowEffect.Color = schemeData and schemeData[1] or COLOR_SCHEMES["彩虹颜色"][1]
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke

    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke then return nil end
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end

    return game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil then return end
        glowEffect.Rotation = (tick() * speed * 10) % 360
    end)
end

local rainbowStroke = createRainbowBorder(Window, "彩虹颜色")
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

local Lighting = game:GetService("Lighting")
local TweenServiceBlur = game:GetService("TweenService")

local blur = Lighting:FindFirstChildOfClass("BlurEffect")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
end

task.spawn(function()
    local wasOpen = false
    while true do
        task.wait(0.1)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        local isOpen = mainFrame and mainFrame.Visible or false
        
        if isOpen ~= wasOpen then
            wasOpen = isOpen
            TweenServiceBlur:Create(blur, TweenInfo.new(0.3), {
                Size = isOpen and 20 or 0
            }):Play()
        end
    end
end)

local info = Window:Section({
    Title = "主页",
    Icon = "star",
    Opened = true
})

local Tab1 = info:Tab({
    Title = "信息",
    Icon = "info", -- optional
    Locked = false,
})



local Paragraph = Tab1:Paragraph({
    Title = 'AF Hub',
    Desc = '欢迎使用YX-HUB脚本(＾ν＾)',
    Thumbnail = "rbxassetid://100781334247855",
    ThumbnailSize = 200,
    Locked = false,
})

local Paragraph1 = Tab1:Paragraph({
    Title = 'AF Hun',
    Desc = '主打缝合 :D',
    Thumbnail = "rbxassetid://72531855816776",
    ThumbnailSize = 200,
    Locked = false,
})

Tab1:Section({ 
    Title = "开发者",
    TextXAlignment = "Center",
    TextSize = 20,
})

local Paragraph = Tab1:Paragraph({
    Title = "秋词",
    Desc = "AF Hub作者",
    Image = "rbxassetid://138882879525986",
    ImageSize = 60,
    Locked = false,
})

local Paragraph = Tab1:Paragraph({
    Title = "YirdeX",
    Desc = "ui背景设计者",
    Image = "rbxassetid://90051928527603",
    ImageSize = 60,
    Locked = false,
})

local Tab3 = info:Tab({
    Title = "复制",
    Icon = "file-code",
    Locked = false,
})

local Button1 = Tab3:Button({
    Title = "复制主群",
    Desc = "复制作者QQ群", -- 可选参数
    Icon = "file-code", -- 图标名称 或 资源ID链接，可选参数
    IconAlign = "Left",
    Locked = false, -- 是否禁用按钮，可选参数
    LockedTitle = "已锁定", -- 按钮禁用时显示的文字，可选参数
    Callback = function()
setclipboard("938714427")
    end
})

local Tab2 = info:Tab({
    Title = "公告",
    Icon = "menu",
    Locked = false,
})
local Section1 = Tab2:Section({
    Title = "AF Hub[公告]", -- 分区标题
    Icon = "component", -- 图标，支持图标名称或资源ID（可选）
    TextSize = 30, -- 标题文字大小（可选）
    TextXAlignment = "Left", -- 文字水平对齐方式：左对齐/居中/右对齐（可选）
    Box = true, -- 是否显示分区外框（可选）
    BoxBorder = true, -- 是否显示外框边框（可选）
    Opened = true, -- 分区默认是否展开（可选）
    FontWeight = Enum.FontWeight.SemiBold, -- 标题字体粗细（可选）
    DescFontWeight = Enum.FontWeight.Medium, -- 描述文字字体粗细（可选）
    TextTransparency = 0, -- 标题文字透明度（可选）
    DescTextTransparency = 0, -- 描述文字透明度（可选）
})

Section1:Paragraph({
    Title = "后续我会添加脚本的卡密\n不过卡密是免费获取的加群：938714427里面\n就可以直接获取卡密不想进群的可以去复制解卡链接\n自己去获得卡密\n感谢您的使用",
    TextSize = 30, 
    Thumbnail = "rbxassetid://85076999766387",
    ThumbnailSize = 100,
})

local adSection = Window:Section({
    Title = "广告专区",
    Icon = "badge-info",
    Opened = true,
})

local adTab = adSection:Tab({
    Title = "广告",
    Icon = "badge-dollar-sign",
    Locked = false,
})

adTab:Paragraph({
    Title = "🎉 限时优惠 🎉",
    Desc = "感谢使用我的脚本\n最良心的免费缝合作者。\nQQ群：938714427",
    Thumbnail = "rbxassetid://123887383447725",
    ThumbnailSize = 150,
})

adTab:Button({
    Title = "点击查看广告详情",
    Desc = "了解更多关于AF Hub的功能",
    Icon = "arrow-up-right",
    Callback = function()
        WindUI:Notify({
            Title = "广告信息",
            Content = "感谢您支持AF Hub！更多功能即将推出。",
            Duration = 5
        })
    end
})

adTab:Divider()

adTab:Paragraph({
    Title = "📢 赞助商推荐",
    Desc = "感谢以下赞助商对AF Hub的支持！",
})

adTab:Button({
    Title = "访问赞助商网站",
    Icon = "globe",
    Callback = function()
        WindUI:Notify({
            Title = "赞助商",
            Content = "即将跳转到赞助商页面...",
            Duration = 2
        })
    end
})

Window:Divider()

local adSection = Window:Section({
    Title = "功能区",
    Icon = "badge-info",
    Opened = true,
})
local Tab = Window:Tab({
    Title = "通用脚本",
    Icon = "bird",
    Locked = false,
})
local Dsb = Window:Tab({
    Title = "玩家功能",
    Icon = "bird",
    Locked = false,
})
local AimTab = Window:Tab({  
    Title = "自瞄设置",  
    Icon = "crown",  
    Locked = false,
})
local Rnm = Window:Tab({  
    Title = "音乐设置",  
    Icon = "music",  
    Locked = false,
})
local Fnm = Window:Tab({  
    Title = "服务器脚本",  
    Icon = "music",  
    Locked = false,
})
Tab:Button({
    Title = "V3飞行脚本",
    Desc = "加载V3飞行脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "V3飞行",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "上升"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "下降"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "飞行"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "秋辞飞行V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false


game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "秋辞V3飞行";
	Text = "BY 秋辞";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;

Frame.Active = true
Frame.Draggable = true

onof.MouseButton1Down:connect(function()

	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true

for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end
	
if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then

		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0

		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
					end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		
plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false

	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0

		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
					end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false
    end
end)
local tis

up.MouseButton1Down:connect(function()
	tis = up.MouseEnter:connect(function()
		while tis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
		end
	end)
end)

up.MouseLeave:connect(function()
	if tis then
		tis:Disconnect()
		tis = nil
	end
end)

local dis

down.MouseButton1Down:connect(function()
	dis = down.MouseEnter:connect(function()
		while dis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
		end
	end)
end)

down.MouseLeave:connect(function()
	if dis then
		dis:Disconnect()
		dis = nil
	end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false

end)

plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then

		tpwalking = false
		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	

				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
			       end
			    end
			end)
		end
	end
end)
mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'cannot be less than 1'
		wait(1)
		speed.Text = speeds
	else
		speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()

					local hb = game:GetService("RunService").Heartbeat	

					tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end
				end)
			end
		end
	end
end)

closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	up.Visible = false
	down.Visible = false
	onof.Visible = false
	plus.Visible = false
	speed.Visible = false
	mine.Visible = false
	mini.Visible = false
	mini2.Visible = true
	main.Frame.BackgroundTransparency = 1
	closebutton.Position =  UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible = true
	down.Visible = true
	onof.Visible = true
	plus.Visible = true
	speed.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0 
	closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)
            end)
            WindUI:Notify({
                Title = "V3飞行",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "踏空脚本",
    Desc = "加载踏空脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "踏空",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
            end)
            WindUI:Notify({
                Title = "踏空",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "爬墙脚本",
    Desc = "加载爬墙脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "爬墙",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
            end)
            WindUI:Notify({
                Title = "爬墙",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "史蒂夫脚本",
    Desc = "加载史蒂夫脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "斯蒂夫",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Steve"))()
            end)
            WindUI:Notify({
                Title = "斯蒂夫",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "索尼克脚本",
    Desc = "加载索尼克脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "索尼克",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Azizanzz0/FE-R15-Sonic-X-Super/refs/heads/main/Protected%20SonicXSuper.txt"))()
            end)
            WindUI:Notify({
                Title = "索尼克",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "TX全自动翻译",
    Desc = "加载TX全自动翻译",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "翻译",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/Auto-language"))()
            end)
            WindUI:Notify({
                Title = "翻译",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "音乐播放器",
    Desc = "加载音乐播放器",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "音乐",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fningna51-stack/-/main/AF%20%E9%9F%B3%E4%B9%90%E8%84%9A%E6%9C%AC"))()
            end)
            WindUI:Notify({
                Title = "音乐",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "SX翻译",
    Desc = "加载翻译脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "翻译",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/SQ182/y/refs/heads/main/翻译.lua"))()
            end)
            WindUI:Notify({
                Title = "翻译",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "通用甩飞",
    Desc = "开启后自动甩飞",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "甩飞",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                local ScriptContent = game:HttpGet("https://pastebin.com/raw/zqyDSUWX")
            end)
            WindUI:Notify({
                Title = "甩飞",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "AK47脚本",
    Desc = "加载后给你一把AK47（别人看不见能攻击）",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "AK47",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/sinret/rbxscript.com-scripts-reuploads-/main/ak47", true))()
            end)
            WindUI:Notify({
                Title = "AK47",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "四千种动作脚本",
    Desc = "不知名外国作者",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "动作",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()
            end)
            WindUI:Notify({
                Title = "动作",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "飞踢脚本",
    Desc = "不知名外国作者",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "飞踢",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-DropKick-Script-165813"))()
            end)
            WindUI:Notify({
                Title = "飞踢",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "🦌管脚本（R15）",
    Desc = "不知名外国作者",
    Icon = "ghost",
    Callback = function()
        WindUI:Notify({
            Title = "R15",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
            end)
            WindUI:Notify({
                Title = "R15",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "🦌管脚本（R6）",
    Desc = "不知名外国作者",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "R6",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
            end)
            WindUI:Notify({
                Title = "R6",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Section({
    Title = "下方为通用脚本",
    TextXAlignment = "Center",
    TextSize = 22,
})
Tab:Divider()
Tab:Button({
    Title = "加载AF Hub脚本中心主脚本",
    Desc = "作者：秋辞",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "AF Hub",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(
                    "https://raw.githubusercontent.com/fningna51-stack/-/main/%E7%A7%8B%E8%BE%9E%E7%BC%9D%E5%90%88%E8%84%9A%E6%9C%AC%E6%9C%80%E6%96%B0%E7%89%88%E6%96%B0ui"
                ))()
            end)
            WindUI:Notify({
                Title = "AF Hub",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "加载夜脚本",
    Desc = "作者：夜（联邦）",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "夜脚本",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(
                    "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/yejiaoben"
                ))()
            end)
            WindUI:Notify({
                Title = "夜脚本",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "加载叶脚本",
    Desc = "暂时不知道作者",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "叶脚本",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(
                    "https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/ROBLOX-CNVIP-XIAOYE.lua"
                ))()
            end)
            WindUI:Notify({
                Title = "叶脚本",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "加载XK脚本",
    Desc = "作者：小玄",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "XK Hub",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(
                    "https://github.com/devslopo/DVES/raw/main/XK%20Hub"
                ))()
            end)
            WindUI:Notify({
                Title = "XK Hub",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "加载皮脚本",
    Desc = "作者：小皮",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "皮脚本",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                getgenv().XiaoPi = "皮脚本QQ群1002100032"
                loadstring(game:HttpGet(
                    "https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua"
                ))()
            end)
            WindUI:Notify({
                Title = "皮脚本",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "加载YI脚本",
    Desc = "作者：来自联邦",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "YI-Hub",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                getgenv().YI_HUB = "YI_HUB群979312897"
                loadstring(game:HttpGet(
                    "https://raw.githubusercontent.com/YI-HUB-TEAM/YIscript/refs/heads/main/YI_HUB"
                ))()
            end)
            WindUI:Notify({
                Title = "YI-Hub",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Button({
    Title = "加载Skin脚本",
    Desc = "作者：柳叶",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "SKIN",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(
                    "https://raw.githubusercontent.com/wzhxll/gh/refs/heads/main/Liu%20Ye%20is%20a%20guest..lua"
                ))()
            end)
            WindUI:Notify({
                Title = "SKIN",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Tab:Section({
    Title = "下方为AF自动加载脚本",
    TextXAlignment = "Center",
    TextSize = 22,
})
Tab:Paragraph({
    Title = "AF Hub",
    Desc = "支持服务器：\n1.死铁轨[功能特别少后续添加]\n2.撕咬之夜\n3.闪光\n4.力量传奇\n5.最坚强的战场\n6.GB[10天后]\n7.通缉\n8.九十九夜\n9.决斗场\n10.Chian[还没有该服务器id]\n11.doors\n12.自然灾害\n13.监狱人生\n14.鲨鱼咬\n15.模仿者（第一章.第二章）\n16.战争大亨\n17.破坏者谜团2\n18.手枪竞技场\n19.忍者传奇\n20.启示录\nQQ群：938714427",
    Thumbnail = "rbxassetid://123887383447725",
    ThumbnailSize = 150,
})
Tab:Button({
    Title = "加载AF自动加载脚本",
    Desc = "作者：秋辞",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "AF",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fningna51-stack/-/main/AF%20Hun%E8%87%AA%E5%8A%A8%E5%8A%A0%E8%BD%BD", true))()
            end)
            
            if success then
                WindUI:Notify({
                    Title = "AFZ",
                    Content = "脚本加载完成",
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "加载失败",
                    Content = "错误信息: " .. tostring(err),
                    Icon = "x",
                    Duration = 5
                })
            end
        end)
    end
})
--玩家功能----------------------------------------------------------------
local FlyingEnabled = false
local SpinningEnabled = false
local FlightSpeed = 50
local SpinSpeed = 5

local CurrentAO, CurrentLV, CurrentMoverAttachment
local FlightConnection
local Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function getControlModule()
    local PlayerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
    return require(PlayerModule:WaitForChild("ControlModule"))
end

local function setupBodyMovers(character)
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    local moverParent = workspace:FindFirstChildOfClass("Terrain") or workspace

    local moverAttachment = Instance.new("Attachment", hrp)
    moverAttachment.Name = "FlightAttachment"

    local alignOrientation = Instance.new("AlignOrientation")
    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOrientation.RigidityEnabled = true
    alignOrientation.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    alignOrientation.CFrame = hrp.CFrame
    alignOrientation.Attachment0 = moverAttachment
    alignOrientation.Parent = moverParent

    local linearVelocity = Instance.new("LinearVelocity")
    linearVelocity.VectorVelocity = Vector3.zero
    linearVelocity.MaxForce = 9e9
    linearVelocity.Attachment0 = moverAttachment
    linearVelocity.Parent = moverParent

    return alignOrientation, linearVelocity, humanoid, moverAttachment
end

local function getFlightVector(controlModule)
    local moveVector = controlModule:GetMoveVector()

    Control.F = -moveVector.Z
    Control.B = moveVector.Z
    Control.L = -moveVector.X
    Control.R = moveVector.X
    Control.Q = moveVector.Y
    Control.E = -moveVector.Y

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then Control.F = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then Control.B = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then Control.L = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then Control.R = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Control.Q = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Control.E = 1 end

    local flightVector =
        Camera.CFrame.LookVector * (Control.F - Control.B) +
        Camera.CFrame.RightVector * (Control.R - Control.L) +
        Vector3.new(0, 1, 0) * (Control.Q - Control.E)

    return flightVector.Magnitude > 0 and flightVector.Unit or flightVector
end

local function startFlying()
    if FlyingEnabled then return end

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if not character then return end

    FlyingEnabled = true
    SpinningEnabled = false

    if CurrentAO then CurrentAO:Destroy() end
    if CurrentLV then CurrentLV:Destroy() end
    if CurrentMoverAttachment then CurrentMoverAttachment:Destroy() end

    CurrentAO, CurrentLV, humanoid, CurrentMoverAttachment = setupBodyMovers(character)

    local controlModule = getControlModule()

    FlightConnection = RunService.Heartbeat:Connect(function()
        if not FlyingEnabled or not CurrentLV or not CurrentAO then return end

        local flightVector = getFlightVector(controlModule)

        if flightVector.Magnitude > 0 then
            CurrentLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            CurrentLV.VectorVelocity = flightVector * FlightSpeed
        else
            CurrentLV.VectorVelocity = Vector3.zero
        end

        if SpinningEnabled then
            local targetPart = humanoid.SeatPart or character.HumanoidRootPart
            CurrentAO.CFrame = targetPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
        else
            CurrentAO.CFrame = Camera.CFrame
        end

        humanoid.PlatformStand = true
    end)

    character.AncestryChanged:Connect(function(_, parent)
        if not parent and FlyingEnabled then
            stopFlying()
        end
    end)
end

local function stopFlying()
    if not FlyingEnabled then return end

    FlyingEnabled = false
    SpinningEnabled = false

    if FlightConnection then
        FlightConnection:Disconnect()
        FlightConnection = nil
    end

    if CurrentAO then CurrentAO:Destroy() end
    if CurrentLV then CurrentLV:Destroy() end
    if CurrentMoverAttachment then CurrentMoverAttachment:Destroy() end

    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
end
Dsb:Toggle({
    Title = "飞行模式",
    Desc = "开启后可以起飞",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            startFlying()
            WindUI:Notify({
                Title = "飞行",
                Content = "飞行已启用",
                Icon = "check",
                Duration = 2
            })
        else
            stopFlying()
            WindUI:Notify({
                Title = "飞行",
                Content = "飞行已禁用",
                Icon = "x",
                Duration = 2
            })
        end
    end
})
Dsb:Slider({
    Title = "飞行速度",
    Step = 1,
    Value = {
        Min = 1,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        FlightSpeed = value
        print("飞行速度设置为:", value)
    end
})
Dsb:Slider({
    Title = "移动速度",
    Desc = "可在墨水使用",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        local LocalPlayer = game.Players.LocalPlayer
        if LocalPlayer and LocalPlayer.Character then
            local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = value
            end
        end
    end
})
Dsb:Input({
    Title = "移动速度设置",
    Desc = "输入后实时生效",
    Value = "",
    Placeholder = "输入移动速度值",
    Callback = function(input)
        local numValue = tonumber(input)
        local LocalPlayer = game.Players.LocalPlayer

        if numValue and LocalPlayer and LocalPlayer.Character then
            local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = numValue
            end
        end
    end
})
Dsb:Slider({
    Title = "跳跃高度",
    Desc = "调整角色跳跃力度",
    Step = 10,
    Value = {
        Min = 1,
        Max = 600,
        Default = game.Players.LocalPlayer.Character and 
                  game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and 
                  game.Players.LocalPlayer.Character.Humanoid.JumpPower or 50
    },
    Callback = function(value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = value
            
            if value > 100 then
                WindUI:Notify({
                    Title = "超级跳跃",
                    Content = "跳跃高度: " .. tostring(value),
                    Icon = "arrow-up",
                    Duration = 1
                })
            end
        end
    end
})
Dsb:Slider({
    Title = "世界重力",
    Desc = "调整整个游戏的重力强度",
    Step = 10,
    Value = {
        Min = 1,
        Max = 500,
        Default = workspace.Gravity
    },
    Callback = function(value)
        workspace.Gravity = value
        
        if value < 100 then
            WindUI:Notify({
                Title = "低重力模式",
                Content = "重力已降至: " .. tostring(value),
                Icon = "moon",
                Duration = 1.5
            })
        elseif value > 300 then
            WindUI:Notify({
                Title = "高重力模式",
                Content = "重力已升至: " .. tostring(value),
                Icon = "arrow-down",
                Duration = 1.5
            })
        end
    end
})
Dsb:Input({
    Title = "设置血量",
    Desc = "输入血量值 (0-999999999)",
    Value = tostring(game.Players.LocalPlayer.Character and 
                     game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and 
                     game.Players.LocalPlayer.Character.Humanoid.Health or 100),
    Type = "Input",
    Placeholder = "例如: 100",
    Callback = function(input)
        local numValue = tonumber(input)
        if numValue and numValue >= 0 then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.Health = numValue
                WindUI:Notify({
                    Title = "血量设置",
                    Content = "血量已设置为: " .. tostring(numValue),
                    Icon = "heart",
                    Duration = 2
                })
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "角色或Humanoid不存在",
                    Icon = "x",
                    Duration = 2
                })
            end
        else
            WindUI:Notify({
                Title = "错误",
                Content = "请输入有效的数字 (≥ 0)",
                Icon = "x",
                Duration = 2
            })
        end
    end
})
Dsb:Input({
    Title = "设置最大血量",
    Desc = "调整角色最大生命值上限",
    Value = tostring(game.Players.LocalPlayer.Character and 
                     game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and 
                     game.Players.LocalPlayer.Character.Humanoid.MaxHealth or 100),
    Type = "Input",
    Placeholder = "例如: 100",
    Callback = function(input)
        local numValue = tonumber(input)
        if numValue and numValue >= 0 then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.MaxHealth = numValue
                character.Humanoid.Health = numValue
                WindUI:Notify({
                    Title = "最大血量设置",
                    Content = "最大血量已设置为: " .. tostring(numValue),
                    Icon = "shield",
                    Duration = 2
                })
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "角色或Humanoid不存在",
                    Icon = "x",
                    Duration = 2
                })
            end
        else
            WindUI:Notify({
                Title = "错误",
                Content = "请输入有效的数字 (≥ 0)",
                Icon = "x",
                Duration = 2
            })
        end
    end
})
Dsb:Button({
    Title = "一键恢复满血",
    Desc = "立即将血量恢复至最大值",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.Health = character.Humanoid.MaxHealth
            WindUI:Notify({
                Title = "血量恢复",
                Content = "已恢复至满血状态!",
                Icon = "heart-pulse",
                Duration = 2
            })
        end
    end
})
Dsb:Input({
    Title = "传送距离",
    Desc = "设置每次传送的距离 (无上限)",
    Value = tostring(getgenv().TeleportSpeedValue or 5),
    Type = "Input",
    Placeholder = "例如: 5",
    Callback = function(input)
        local numValue = tonumber(input)
        if numValue and numValue >= 0 then
            getgenv().TeleportSpeedValue = numValue
            WindUI:Notify({
                Title = "传送设置",
                Content = "传送距离已设置为: " .. tostring(numValue) .. " studs",
                Icon = "move",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "错误",
                Content = "请输入有效的数字 (≥ 0)",
                Icon = "x",
                Duration = 2
            })
        end
    end
})
Dsb:Button({
    Title = "向前传送",
    Desc = "朝当前面向方向移动",
    Callback = function()
        local speed = getgenv().TeleportSpeedValue or 5
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -speed)
            WindUI:Notify({
                Title = "传送成功",
                Content = "向前移动了 " .. tostring(speed) .. " studs",
                Icon = "arrow-up",
                Duration = 1
            })
        end
    end
})
Dsb:Button({
    Title = "向后传送",
    Desc = "朝当前面向反方向移动",
    Callback = function()
        local speed = getgenv().TeleportSpeedValue or 5
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, speed)
            WindUI:Notify({
                Title = "传送成功",
                Content = "向后移动了 " .. tostring(speed) .. " studs",
                Icon = "arrow-down",
                Duration = 1
            })
        end
    end
})
Dsb:Button({
    Title = "向上传送",
    Desc = "垂直向上移动",
    Callback = function()
        local speed = getgenv().TeleportSpeedValue or 5
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, speed, 0)
            WindUI:Notify({
                Title = "传送成功",
                Content = "向上移动了 " .. tostring(speed) .. " studs",
                Icon = "chevron-up",
                Duration = 1
            })
        end
    end
})
Dsb:Button({
    Title = "向下传送",
    Desc = "垂直向下移动",
    Callback = function()
        local speed = getgenv().TeleportSpeedValue or 5
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, -speed, 0)
            WindUI:Notify({
                Title = "传送成功",
                Content = "向下移动了 " .. tostring(speed) .. " studs",
                Icon = "chevron-down",
                Duration = 1
            })
        end
    end
})
Dsb:Button({
    Title = "重置角色属性",
    Desc = "恢复所有属性为默认值",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            humanoid.JumpPower = 50
            humanoid.Health = humanoid.MaxHealth
            workspace.Gravity = 196.2 -- Roblox默认重力
            
            WindUI:Notify({
                Title = "属性重置",
                Content = "所有角色属性已恢复为默认值",
                Icon = "refresh-cw",
                Duration = 2
            })
        end
    end
})
Dsb:Slider({
    Title = "超广角设置",
    Desc = "可在墨水使用",
    Step = 1,
    Value = {
        Min = 20,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        local Camera = workspace.CurrentCamera
        Camera.FieldOfView = value
    end
})
local InfiniteJumpConnection
local InfiniteJumpEnabled = false
local FirstRun = true
Dsb:Toggle({
    Title = "无限跳",
    Desc = "开启后可以无限跳跃",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state

        if InfiniteJumpConnection then
            InfiniteJumpConnection:Disconnect()
            InfiniteJumpConnection = nil
        end

        if state then
            InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local LocalPlayer = game.Players.LocalPlayer
                if LocalPlayer and LocalPlayer.Character then
                    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)

            if not FirstRun then
                WindUI:Notify({
                    Title = "无限跳",
                    Content = "已启用",
                    Icon = "check",
                    Duration = 2
                })
            end
        else
            if not FirstRun then
                WindUI:Notify({
                    Title = "无限跳",
                    Content = "已禁用",
                    Icon = "x",
                    Duration = 2
                })
            end
        end

        FirstRun = false
    end
})
Dsb:Button({
    Title = "重新加载角色",
    Desc = "重置当前角色（BreakJoints）",
    Icon = "refresh-cw",
    Callback = function()
        local LocalPlayer = game.Players.LocalPlayer
        if LocalPlayer and LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
            WindUI:Notify({
                Title = "角色",
                Content = "角色已重新加载",
                Icon = "check",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "角色",
                Content = "未找到角色",
                Icon = "x",
                Duration = 2
            })
        end
    end
})
local NoclipEnabled = false
local NoclipConnection
Dsb:Button({
    Title = "穿墙模式",
    Desc = "循环关闭碰撞（Noclip）",
    Icon = "ghost",
    Callback = function()
        NoclipEnabled = not NoclipEnabled

        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end

        if NoclipEnabled then
            NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
                local LocalPlayer = game.Players.LocalPlayer
                if LocalPlayer and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)

            WindUI:Notify({
                Title = "穿墙",
                Content = "穿墙模式已开启",
                Icon = "check",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "穿墙",
                Content = "穿墙模式已关闭",
                Icon = "x",
                Duration = 2
            })
        end
    end
})
Dsb:Toggle({
    Title = "RageBot",
    Desc = "自动锁定并射击可见敌人",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        getgenv().RageBotState = getgenv().RageBotState or {
            Connection = nil,
            CurrentTarget = nil,
            LastShotTime = 0
        }
        
        local RageBot = getgenv().RageBotState
        
        if state then
            if RageBot.Connection then
                RageBot.Connection:Disconnect()
                RageBot.Connection = nil
            end
            
            RageBot.Connection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    
                    if RageBot.CurrentTarget and not isDead(RageBot.CurrentTarget) then
                        local targetChar = RageBot.CurrentTarget.Character
                        if targetChar then
                            local visiblePart, visiblePos, origin = getVisiblePart(targetChar)
                            if visiblePart and visiblePos and origin then
                                shoot(RageBot.CurrentTarget, visiblePart, visiblePos, origin)
                            else
                                RageBot.CurrentTarget = nil
                            end
                        end
                    else
                        RageBot.CurrentTarget = nil
                    end
                    if not RageBot.CurrentTarget then
                        local targets = getVisibleTargets()
                        if #targets > 0 then
                            RageBot.CurrentTarget = targets[1].player
                        end
                    end
                end)
            end)
            if not getgenv().RageBotFirstRun then
                WindUI:Notify({
                    Title = "RageBot",
                    Content = "已启用 - 自动攻击可见敌人",
                    Icon = "target",
                    Duration = 2
                })
            end
        else          
            if RageBot.Connection then
                RageBot.Connection:Disconnect()
                RageBot.Connection = nil
            end
            RageBot.CurrentTarget = nil
            RageBot.LastShotTime = 0
            if not getgenv().RageBotFirstRun then
                WindUI:Notify({
                    Title = "RageBot",
                    Content = "已禁用",
                    Icon = "x",
                    Duration = 2
                })
            end
        end
        getgenv().RageBotFirstRun = false
    end
})
Dsb:Toggle({
    Title = "开启杀戮光环",
    Desc = "自动攻击周围玩家",
    Default = false,
    Callback = function(enabled)
        if enabled then
            -- 清理旧实例
            if getgenv().configs then
                if getgenv().configs.Disable then
                    getgenv().configs.Disable:Fire()
                    getgenv().configs.Disable:Destroy()
                end
                if getgenv().configs.connections then
                    for _, v in pairs(getgenv().configs.connections) do v:Disconnect() end
                end
                table.clear(getgenv().configs)
            end

            getgenv().configs = {
                connections = {},
                Disable = Instance.new("BindableEvent"),
                Size = Vector3.new(10, 10, 10),
                DeathCheck = true,
            }

            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local localPlayer = Players.LocalPlayer
            local isRunning = true
            local overlapParams = OverlapParams.new()
            overlapParams.FilterType = Enum.RaycastFilterType.Include

            local function GetCharacter(p)
                return (p or localPlayer).Character
            end
            local function GetHumanoid(m)
                if not m then return nil end
                if m:IsA("Player") then m = GetCharacter(m) end
                if m and m:IsA("Model") then return m:FindFirstChildWhichIsA("Humanoid") end
                if m:IsA("Humanoid") then return m end
                return nil
            end
            local function IsAlive(h) return h and h.Health > 0 end
            local function HasTouchTransmitter(tool)
                return tool and tool:FindFirstChildWhichIsA("TouchTransmitter", true)
            end
            local function GetOtherCharacters(exclude)
                local chars = {}
                for _, p in pairs(Players:GetPlayers()) do
                    local c = GetCharacter(p)
                    if c and c ~= exclude then table.insert(chars, c) end
                end
                return chars
            end
            local function ActivateTool(tool, part, target)
                if tool:IsDescendantOf(workspace) then
                    tool:Activate()
                    firetouchinterest(part, target, 1)
                    firetouchinterest(part, target, 0)
                end
            end

            table.insert(getgenv().configs.connections, getgenv().configs.Disable.Event:Connect(function()
                isRunning = false
            end))

            task.spawn(function()
                while isRunning do
                    local char = GetCharacter()
                    local hum = GetHumanoid(char)
                    if IsAlive(hum) then
                        local tool = char:FindFirstChildWhichIsA("Tool")
                        local transmitter = tool and HasTouchTransmitter(tool)
                        if transmitter then
                            local tPart = transmitter.Parent
                            local others = GetOtherCharacters(char)
                            overlapParams.FilterDescendantsInstances = others
                            local parts = workspace:GetPartBoundsInBox(tPart.CFrame, tPart.Size + getgenv().configs.Size, overlapParams)
                            for _, part in pairs(parts) do
                                local model = part:FindAncestorWhichIsA("Model")
                                if table.find(others, model) then
                                    local targetHum = GetHumanoid(model)
                                    if getgenv().configs.DeathCheck and IsAlive(targetHum) then
                                        ActivateTool(tool, tPart, part)
                                    elseif not getgenv().configs.DeathCheck then
                                        ActivateTool(tool, tPart, part)
                                    end
                                end
                            end
                        end
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
        else
            if getgenv().configs and getgenv().configs.Disable then
                getgenv().configs.Disable:Fire()
            end
        end
    end
})
Dsb:Toggle({
    Title = "循环恢复血量",
    Desc = "锁定生命值至最大值",
    Default = false,
    Callback = function(enabled)
        getgenv().HFLoop = enabled
        if enabled then
            task.spawn(function()
                while getgenv().HFLoop do
                    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                    if hum then hum.Health = 9e37 end
                    task.wait(0.5)
                end
            end)
        end
    end
})
Dsb:Toggle({
    Title = "子弹追踪 (Silent)",
    Desc = "命中最近敌人 (需重启游戏关闭)",
    Default = false,
    Callback = function(enabled)
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        
        if enabled then
            local camera = workspace.CurrentCamera
            local Players = game:GetService("Players")
            local localPlayer = Players.LocalPlayer
            
            mt.__namecall = newcclosure(function(self, ...)
                local args = {...}
                if getnamecallmethod() == "FindPartOnRayWithIgnoreList" and not checkcaller() then
                    local closest, dist = nil, math.huge
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= localPlayer and p.Team ~= localPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                            local head = p.Character.Head
                            local screenPos, vis = camera:WorldToScreenPoint(head.Position)
                            if vis then
                                local mag = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                                if mag < dist then dist = mag; closest = p end
                            end
                        end
                    end
                    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                        args[1] = Ray.new(camera.CFrame.Position, (closest.Character.Head.Position - camera.CFrame.Position).Unit * 1000)
                        return mt.__namecall(self, unpack(args))
                    end
                end
                return mt.__namecall(self, ...)
            end)
            WindUI:Notify({Title="子弹追踪", Content="已启用", Icon="check"})
        else
            if mt.__original_namecall then
                mt.__namecall = mt.__original_namecall
                WindUI:Notify({Title="子弹追踪", Content="已尝试禁用 (建议重进)", Icon="info"})
            end
        end
        setreadonly(mt, true)
    end
})
Dsb:Toggle({
    Title = "解锁最大视野",
    Desc = "解除相机距离限制",
    Default = false,
    Callback = function(enabled)
        getgenv().Cam1 = enabled
        task.spawn(function()
            while getgenv().Cam1 == enabled do
                local lp = game.Players.LocalPlayer
                lp.CameraMaxZoomDistance = enabled and 9e37 or 32
                task.wait(0.1)
            end
        end)
    end
})
Dsb:Button({
    Title = "查看所有玩家",
    Desc = "显示玩家列表及血条",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/G2zb992X", true))()
    end
})
Dsb:Button({
    Title = "Dex Explorer",
    Desc = "打开实例浏览器",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/renlua/Script-Tutorial/refs/heads/main/dex.lua"))()
    end
})
Dsb:Button({
    Title = "隐身道具",
    Desc = "使当前手持道具隐形",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/skid123skidlol/cd0d2dce51b3f20ad1aac941da06a1a1/raw/f58b98cce7d51e53ade94e7bb460e4f24fb7e0ff/%257BFE%257D%2520Invisible%2520Tool%2520(can%2520hold%2520tools)", true))()
    end
})
Dsb:Button({
    Title = "工具包 (BTools)",
    Desc = "获取建造者工具",
    Callback = function()
        loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/BTools.txt"))()
    end
})
Dsb:Button({
    Title = "锁定视野",
    Desc = "锁定当前摄像机角度",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/nekmtvpA/raw"))()
    end
})
Dsb:Button({
    Title = "老外传送GUI",
    Desc = "打开玩家传送菜单",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Infinity2346/Tect-Menu/main/Teleport%20Gui.lua"))()
    end
})
Dsb:Button({
    Title = "点击传送道具",
    Desc = "点击地面传送到该位置",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/Jf2QXOwa/raw"))()
    end
})
local selectedPlayer = nil
local PlayerDropdown = Dsb:Dropdown({
    Title = "玩家列表",
    Desc = "自动获取当前服务器玩家",
    Values = (function()
        local names = {}
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                table.insert(names, plr.Name)
            end
        end
        return names
    end)(),
    Value = nil,
    Callback = function(playerName)
        if playerName then
            selectedPlayer = game.Players:FindFirstChild(playerName)
            print("[回调] 选中玩家:", playerName)
        else
            selectedPlayer = nil
            print("[回调] 未选中任何玩家")
        end
    end
})
game.Players.PlayerAdded:Connect(function(plr)
    PlayerDropdown:SetValues((function()
        local names = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                table.insert(names, p.Name)
            end
        end
        return names
    end)())
end)
game.Players.PlayerRemoving:Connect(function(plr)
    if selectedPlayer == plr then
        selectedPlayer = nil
        PlayerDropdown:Set(nil)
    end
    PlayerDropdown:SetValues((function()
        local names = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                table.insert(names, p.Name)
            end
        end
        return names
    end)())
end)
Dsb:Button({
    Title = "选择玩家传送",
    Desc = "传送到选中的玩家位置",
    Icon = "arrow-right",
    Callback = function()
        if not selectedPlayer then
            WindUI:Notify({
                Title = "传送",
                Content = "请先在下拉列表中选择一个玩家！",
                Icon = "x",
                Duration = 3
            })
            return
        end

        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        if not selectedPlayer.Parent then
            WindUI:Notify({
                Title = "传送",
                Content = "目标玩家已退出游戏！",
                Icon = "x",
                Duration = 3
            })
            selectedPlayer = nil
            return
        end

        if selectedPlayer == LocalPlayer then
            WindUI:Notify({
                Title = "传送",
                Content = "不能传送到自己！",
                Icon = "x",
                Duration = 3
            })
            return
        end

        local targetChar = selectedPlayer.Character
        if not targetChar or not targetChar.Parent then
            WindUI:Notify({
                Title = "传送",
                Content = "目标玩家尚未加载角色！",
                Icon = "x",
                Duration = 3
            })
            return
        end

        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP then
            targetHRP = targetChar:WaitForChild("HumanoidRootPart", 2)
            if not targetHRP then
                WindUI:Notify({
                    Title = "传送",
                    Content = "无法获取目标玩家位置！",
                    Icon = "x",
                    Duration = 3
                })
                return
            end
        end

        local myChar = LocalPlayer.Character
        if not myChar or not myChar.Parent then
            myChar = LocalPlayer.CharacterAdded:Wait()
        end

        local myHRP = myChar:WaitForChild("HumanoidRootPart", 2)
        if not myHRP then
            WindUI:Notify({
                Title = "传送",
                Content = "无法获取你的位置！",
                Icon = "x",
                Duration = 3
            })
            return
        end

        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)

        WindUI:Notify({
            Title = "传送",
            Content = "已传送到玩家：" .. selectedPlayer.Name,
            Icon = "check",
            Duration = 3
        })
    end
})
Dsb:Section({
    Title = "下方为玩家透视功能",
    TextXAlignment = "Center",
    TextSize = 22,
})
Dsb:Divider()
local FirstRun = true
Dsb:Toggle({
    Title = "方框透视",
    Desc = "显示玩家方框 ESP",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera
        local LocalPlayer = Players.LocalPlayer

        if state then
            if getgenv().cyberline_esp_boxes then
                for _, v in pairs(getgenv().cyberline_esp_boxes) do
                    pcall(function() v.box:Remove() end)
                    pcall(function() v.outline:Remove() end)
                end
            end
            getgenv().cyberline_esp_boxes = {}

            local function create_box()
                local outline = Drawing.new("Square")
                outline.Color = Color3.new(0, 0, 0)
                outline.Thickness = 1
                outline.Filled = false
                outline.Visible = false

                local box = Drawing.new("Square")
                box.Color = Color3.fromRGB(255, 255, 255)
                box.Thickness = 1
                box.Filled = false
                box.Visible = false

                return { box = box, outline = outline }
            end

            local function get_bounds(char)
                local min, max = Vector3.new(1e9,1e9,1e9), Vector3.new(-1e9,-1e9,-1e9)
                for _, p in char:GetDescendants() do
                    if p:IsA("BasePart") then
                        local pos = p.Position
                        min = Vector3.new(math.min(min.X,pos.X),math.min(min.Y,pos.Y),math.min(min.Z,pos.Z))
                        max = Vector3.new(math.max(max.X,pos.X),math.max(max.Y,pos.Y),math.max(max.Z,pos.Z))
                    end
                end
                return min, max
            end

            getgenv().cyberline_esp_conn = RunService.RenderStepped:Connect(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local min, max = get_bounds(plr.Character)
                        local points = {
                            Vector3.new(min.X,min.Y,min.Z),
                            Vector3.new(min.X,max.Y,min.Z),
                            Vector3.new(max.X,min.Y,min.Z),
                            Vector3.new(max.X,max.Y,min.Z),
                            Vector3.new(min.X,min.Y,max.Z),
                            Vector3.new(min.X,max.Y,max.Z),
                            Vector3.new(max.X,min.Y,max.Z),
                            Vector3.new(max.X,max.Y,max.Z),
                        }

                        local min2d, max2d = Vector2.new(1e9,1e9), Vector2.new(-1e9,-1e9)
                        local visible = false

                        for _, pt in ipairs(points) do
                            local screen, onScreen = Camera:WorldToViewportPoint(pt)
                            if onScreen then
                                visible = true
                                min2d = Vector2.new(math.min(min2d.X,screen.X),math.min(min2d.Y,screen.Y))
                                max2d = Vector2.new(math.max(max2d.X,screen.X),math.max(max2d.Y,screen.Y))
                            end
                        end

                        if not getgenv().cyberline_esp_boxes[plr] then
                            getgenv().cyberline_esp_boxes[plr] = create_box()
                        end

                        local b = getgenv().cyberline_esp_boxes[plr]
                        if visible then
                            local size = max2d - min2d
                            b.box.Position, b.box.Size, b.box.Visible = min2d, size, true
                            b.outline.Position, b.outline.Size, b.outline.Visible =
                                min2d - Vector2.new(1,1), size + Vector2.new(2,2), true
                        else
                            b.box.Visible, b.outline.Visible = false, false
                        end
                    end
                end
            end)

            if not FirstRun then
                WindUI:Notify({Title="方框透视",Content="已启用",Icon="check",Duration=2})
            end
        else
            if getgenv().cyberline_esp_conn then
                getgenv().cyberline_esp_conn:Disconnect()
            end
            if getgenv().cyberline_esp_boxes then
                for _, v in pairs(getgenv().cyberline_esp_boxes) do
                    pcall(function() v.box:Remove() end)
                    pcall(function() v.outline:Remove() end)
                end
            end
            getgenv().cyberline_esp_boxes = nil

            if not FirstRun then
                WindUI:Notify({Title="方框透视",Content="已禁用",Icon="x",Duration=2})
            end
        end

        FirstRun = false
    end
})
local FirstRun = true
Dsb:Toggle({
    Title = "人物透视",
    Desc = "显示玩家模型高亮透视",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        if state then
            if getgenv().cyberline_chams then
                for _, hl in pairs(getgenv().cyberline_chams) do
                    pcall(function() hl:Destroy() end)
                end
            end
            getgenv().cyberline_chams = {}

            getgenv().cyberline_chams_conn = RunService.RenderStepped:Connect(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and not getgenv().cyberline_chams[plr] then
                        local hl = Instance.new("Highlight")
                        hl.Name = "CyberlineChams"
                        hl.FillColor = getgenv().cyberline_chams_color or Color3.fromRGB(255,255,255)
                        hl.OutlineColor = Color3.new(0,0,0)
                        hl.FillTransparency = 0.8
                        hl.OutlineTransparency = 1
                        hl.Adornee = plr.Character
                        hl.Parent = game.CoreGui
                        getgenv().cyberline_chams[plr] = hl
                    end
                end
            end)

            if not FirstRun then
                WindUI:Notify({Title="人物透视",Content="已启用",Icon="check",Duration=2})
            end
        else
            if getgenv().cyberline_chams_conn then
                getgenv().cyberline_chams_conn:Disconnect()
            end
            if getgenv().cyberline_chams then
                for _, hl in pairs(getgenv().cyberline_chams) do
                    pcall(function() hl:Destroy() end)
                end
            end
            getgenv().cyberline_chams = nil

            if not FirstRun then
                WindUI:Notify({Title="人物透视",Content="已禁用",Icon="x",Duration=2})
            end
        end
    FirstRun = false
    end
})
local FirstRun = true
Dsb:Toggle({
    Title = "名字透视",
    Desc = "显示玩家头顶名字",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera

        if state then
            if getgenv().cyberline_name_esp then
                for _, txt in pairs(getgenv().cyberline_name_esp) do
                    pcall(function() txt:Remove() end)
                end
            end
            getgenv().cyberline_name_esp = {}

            local function create_label()
                local t = Drawing.new("Text")
                t.Size,t.Center,t.Outline,t.Font = 12,true,true,2
                t.Color = Color3.fromRGB(255,255,255)
                t.Visible = false
                return t
            end

            getgenv().cyberline_name_esp_conn = RunService.RenderStepped:Connect(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                        local head = plr.Character.Head
                        local pos, vis = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.8,0))
                        if not getgenv().cyberline_name_esp[plr] then
                            getgenv().cyberline_name_esp[plr] = create_label()
                        end
                        local txt = getgenv().cyberline_name_esp[plr]
                        if vis then
                            txt.Position,txt.Text,txt.Visible = Vector2.new(pos.X,pos.Y),plr.Name,true
                        else
                            txt.Visible = false
                        end
                    end
                end
            end)

            if not FirstRun then
                WindUI:Notify({Title="名字透视",Content="已启用",Icon="check",Duration=2})
            end
        else
            if getgenv().cyberline_name_esp_conn then
                getgenv().cyberline_name_esp_conn:Disconnect()
            end
            if getgenv().cyberline_name_esp then
                for _, txt in pairs(getgenv().cyberline_name_esp) do
                    pcall(function() txt:Remove() end)
                end
            end
            getgenv().cyberline_name_esp = nil

            if not FirstRun then
                WindUI:Notify({Title="名字透视",Content="已禁用",Icon="x",Duration=2})
            end
        end
    FirstRun = false
    end
})
local FirstRun = true

Dsb:Toggle({
    Title = "骨骼透视",
    Desc = "显示玩家骨骼线条",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera
        local LocalPlayer = Players.LocalPlayer

        if state then
            if getgenv().cyberline_skeleton then
                for _, skel in pairs(getgenv().cyberline_skeleton) do
                    for _, line in pairs(skel) do
                        pcall(function() line:Remove() end)
                    end
                end
            end
            getgenv().cyberline_skeleton = {}

            local function create_line()
                local line = Drawing.new("Line")
                line.Color = Color3.new(1, 1, 1)
                line.Thickness = 1
                line.Transparency = 1
                line.Visible = false
                return line
            end

            local function create_skeleton()
                return {
                    head = create_line(),
                    torso = create_line(),
                    left_arm = create_line(),
                    right_arm = create_line(),
                    left_leg = create_line(),
                    right_leg = create_line()
                }
            end

            getgenv().cyberline_skeleton_conn = RunService.RenderStepped:Connect(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local char = plr.Character

                        local parts = {
                            head = char:FindFirstChild("Head"),
                            upper = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
                            lower = char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart"),
                            left_arm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"),
                            right_arm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"),
                            left_leg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"),
                            right_leg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg"),
                        }

                        if not getgenv().cyberline_skeleton[plr] then
                            getgenv().cyberline_skeleton[plr] = create_skeleton()
                        end

                        local skel = getgenv().cyberline_skeleton[plr]

                        local function to_screen(part)
                            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            return Vector2.new(pos.X, pos.Y), onScreen
                        end

                        local allVisible = true
                        for _, part in pairs(parts) do
                            if not part then
                                allVisible = false
                                break
                            end
                        end

                        if allVisible then
                            local head_pos = to_screen(parts.head)
                            local upper_pos = to_screen(parts.upper)
                            local lower_pos = to_screen(parts.lower)
                            local larm_pos = to_screen(parts.left_arm)
                            local rarm_pos = to_screen(parts.right_arm)
                            local lleg_pos = to_screen(parts.left_leg)
                            local rleg_pos = to_screen(parts.right_leg)

                            skel.head.From, skel.head.To = head_pos, upper_pos
                            skel.torso.From, skel.torso.To = upper_pos, lower_pos
                            skel.left_arm.From, skel.left_arm.To = upper_pos, larm_pos
                            skel.right_arm.From, skel.right_arm.To = upper_pos, rarm_pos
                            skel.left_leg.From, skel.left_leg.To = lower_pos, lleg_pos
                            skel.right_leg.From, skel.right_leg.To = lower_pos, rleg_pos

                            for _, line in pairs(skel) do
                                line.Visible = true
                            end
                        else
                            for _, line in pairs(skel) do
                                line.Visible = false
                            end
                        end
                    elseif getgenv().cyberline_skeleton[plr] then
                        for _, line in pairs(getgenv().cyberline_skeleton[plr]) do
                            line.Visible = false
                        end
                    end
                end
            end)

            if not FirstRun then
                WindUI:Notify({Title="骨骼透视",Content="已启用",Icon="check",Duration=2})
            end
        else
            if getgenv().cyberline_skeleton_conn then
                getgenv().cyberline_skeleton_conn:Disconnect()
            end
            if getgenv().cyberline_skeleton then
                for _, skel in pairs(getgenv().cyberline_skeleton) do
                    for _, line in pairs(skel) do
                        pcall(function() line:Remove() end)
                    end
                end
            end
            getgenv().cyberline_skeleton = nil

            if not FirstRun then
                WindUI:Notify({Title="骨骼透视",Content="已禁用",Icon="x",Duration=2})
            end
        end

        FirstRun = false
    end
})
local FirstRun = true

Dsb:Toggle({
    Title = "射线透视",
    Desc = "从屏幕顶部指向玩家",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera
        local LocalPlayer = Players.LocalPlayer

        if state then
            if getgenv().cyberline_tracers then
                for _, line in pairs(getgenv().cyberline_tracers) do
                    pcall(function() line:Remove() end)
                end
            end
            getgenv().cyberline_tracers = {}

            local function create_tracer()
                local line = Drawing.new("Line")
                line.Color = Color3.fromRGB(255, 255, 255)
                line.Thickness = 1
                line.Transparency = 1
                line.Visible = false
                return line
            end

            getgenv().cyberline_tracer_conn = RunService.RenderStepped:Connect(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer
                        and plr.Character
                        and plr.Character:FindFirstChild("HumanoidRootPart") then

                        local root = plr.Character.HumanoidRootPart
                        local screenPos, onScreen =
                            Camera:WorldToViewportPoint(root.Position)

                        if not getgenv().cyberline_tracers[plr] then
                            getgenv().cyberline_tracers[plr] = create_tracer()
                        end

                        local tracer = getgenv().cyberline_tracers[plr]

                        if onScreen then
                            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                            tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                            tracer.Visible = true
                        else
                            tracer.Visible = false
                        end
                    elseif getgenv().cyberline_tracers[plr] then
                        getgenv().cyberline_tracers[plr].Visible = false
                    end
                end
            end)

            if not FirstRun then
                WindUI:Notify({Title="射线透视",Content="已启用",Icon="check",Duration=2})
            end
        else
            if getgenv().cyberline_tracer_conn then
                getgenv().cyberline_tracer_conn:Disconnect()
            end
            if getgenv().cyberline_tracers then
                for _, line in pairs(getgenv().cyberline_tracers) do
                    pcall(function() line:Remove() end)
                end
            end
            getgenv().cyberline_tracers = nil

            if not FirstRun then
                WindUI:Notify({Title="射线透视",Content="已禁用",Icon="x",Duration=2})
            end
        end

        FirstRun = false
    end
})
Dsb:Section({
    Title = "下方为旋转功能控制",
    TextXAlignment = "Center",
    TextSize = 22,
})
local SpinBV = nil
local FirstRun = true
local function SetSpinSpeed(speed)
    local LocalPlayer = game.Players.LocalPlayer
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    if SpinBV then
        SpinBV:Destroy()
        SpinBV = nil
    end

    if speed > 0 then
        SpinBV = Instance.new("BodyAngularVelocity")
        SpinBV.Name = "CustomSpin"
        SpinBV.MaxTorque = Vector3.new(0, 4e5, 0)
        SpinBV.AngularVelocity = Vector3.new(0, speed, 0)
        SpinBV.Parent = HRP
    end
end

local speeds = {10, 20, 30, 50, 100, 200, 500}
for _, speed in ipairs(speeds) do
    Dsb:Button({
        Title = "旋转 " .. speed,
        Desc = "设置旋转速度",
        Icon = "rotate-cw",
        Callback = function()
            SetSpinSpeed(speed)
            SpinSlider:Set(speed)
            WindUI:Notify({
                Title = "旋转",
                Content = "旋转速度：" .. speed,
                Icon = "check",
                Duration = 1
            })
        end
    })
end
Dsb:Button({
    Title = "停止旋转",
    Desc = "关闭角色旋转",
    Icon = "square",
    Callback = function()
        SetSpinSpeed(0)
        SpinSlider:Set(0)
        WindUI:Notify({
            Title = "旋转",
            Content = "已停止旋转",
            Icon = "x",
            Duration = 1
        })
    end
})
Dsb:Slider({
    Title = "旋转速度",
    Desc = "拖动调节旋转速度",
    Step = 1,
    Value = {
        Min = 0,
        Max = 500,
        Default = 0,
    },
    Callback = function(value)
        SetSpinSpeed(value)
        if not FirstRun then
            WindUI:Notify({
                Title = "旋转",
                Content = "旋转速度：" .. value,
                Icon = "check",
                Duration = 1
            })
        end
        FirstRun = false
    end
})
--自瞄功能---------------------------------------------------------------
local function InitializeAimDrawings()
    pcall(function()
        if not FOVCircle then
            FOVCircle = Drawing.new("Circle")
            FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
            FOVCircle.Thickness = 2
            FOVCircle.Filled = false
            FOVCircle.Radius = AimSettings.FOV
            FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
            table.insert(DrawingObjects, FOVCircle)
        end
    end)
end

local function UpdateFOVCircle()
    pcall(function()
        if FOVCircle then
            FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
            FOVCircle.Radius = AimSettings.FOV
            if AimSettings.FOVRainbowEnabled then
                FOVCircle.Color = GetRainbowColor(CurrentFOVHue)
            else
                FOVCircle.Color = AimSettings.FOVColor
            end
            FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
        end
    end)
end

local function CleanupDrawings()
    pcall(function()
        for _, drawing in ipairs(DrawingObjects) do
            if drawing then
                drawing:Remove()
            end
        end
        DrawingObjects = {}
        FOVCircle = nil
    end)
end

local function IsFriend(player)
    if not AimSettings.FriendCheck then
        return false
    end
    local success, result = pcall(function()
        if LocalPlayer:IsFriendsWith(player.UserId) then
            return true
        end
        return false
    end)
    return success and result
end

local function WallCheck(targetPosition, targetCharacter)
    if not AimSettings.WallCheck then
        return true
    end
    local success, result = pcall(function()
        local camera = workspace.CurrentCamera
        local origin = camera.CFrame.Position
        local direction = (targetPosition - origin).Unit
        local distance = (targetPosition - origin).Magnitude
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.IgnoreWater = true
        raycastParams.CollisionGroup = "Default"
        local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
        return raycastResult == nil
    end)
    return success and result
end

local function GetTargetPosition(character, partName)
    if not character then return nil end
    local part
    if partName == "头" then
        part = character:FindFirstChild("Head")
    elseif partName == "上身" then
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    elseif partName == "左腿" then
        part = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("LeftUpperLeg")
    elseif partName == "右腿" then
        part = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLowerLeg") or character:FindFirstChild("RightUpperLeg")
    elseif partName == "裆部" then
        part = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso")
    elseif partName == "胸部" then
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    else
        part = character:FindFirstChild("Head")
    end
    return part and part.Position
end

local function GetClosestPlayer()
    local camera = workspace.CurrentCamera
    local mousePos = camera.ViewportSize / 2
    local nearestPlayer = nil
    local shortestDistance = AimSettings.FOV

    if AimSettings.TargetPlayer and not AimSettings.TargetAll then
        local target = Players:FindFirstChild(AimSettings.TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local inBlacklist = false
            for _, blackName in ipairs(AimBlacklist) do
                if target.Name == blackName then
                    inBlacklist = true
                    break
                end
            end
            if not inBlacklist then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and target.Team == myTeam then
                        CurrentTarget = nil
                        return nil
                    end
                end
                local humanoid = target.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local targetPos = target.Character.HumanoidRootPart.Position
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distance <= AimSettings.FOV and WallCheck(targetPos, target.Character) then
                            if not AimSettings.FriendCheck or not IsFriend(target) then
                                CurrentTarget = target
                                return target
                            end
                        end
                    end
                end
            end
        end
        CurrentTarget = nil
        return nil
    end

    if CurrentTarget and CurrentTarget ~= LocalPlayer and CurrentTarget.Character then
        local hrp = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = CurrentTarget.Character:FindFirstChild("Humanoid")
        if hrp and humanoid and humanoid.Health > 0 then
            local inBlacklist = false
            for _, blackName in ipairs(AimBlacklist) do
                if CurrentTarget.Name == blackName then
                    inBlacklist = true
                    break
                end
            end
            if not inBlacklist then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and CurrentTarget.Team == myTeam then
                        CurrentTarget = nil
                        return nil
                    end
                end
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance <= AimSettings.FOV and WallCheck(hrp.Position, CurrentTarget.Character) then
                        if not AimSettings.FriendCheck or not IsFriend(CurrentTarget) then
                            return CurrentTarget
                        end
                    end
                end
            end
        end
    end

    CurrentTarget = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local skip = false
            if AimSettings.FriendCheck and IsFriend(player) then
                skip = true
            end
            if not skip then
                for _, blackName in ipairs(AimBlacklist) do
                    if player.Name == blackName then
                        skip = true
                        break
                    end
                end
            end
            if not skip then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and player.Team == myTeam then
                        skip = true
                    end
                end
            end
            if not skip then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoidRootPart and humanoid and humanoid.Health > 0 then
                    if WallCheck(humanoidRootPart.Position, player.Character) then
                        local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    if nearestPlayer then
        CurrentTarget = nearestPlayer
    end
    return nearestPlayer
end

local function AimBot()
    if not AimSettings.Enabled then
        return
    end
    pcall(function()
        local camera = workspace.CurrentCamera
        local target = GetClosestPlayer()
        if target and target.Character then
            local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
            local head = target.Character:FindFirstChild("Head")
            local targetPosition = GetTargetPosition(target.Character, AimTargetPart) or (head and head.Position) or (humanoidRootPart and humanoidRootPart.Position)
            if not targetPosition then return end
            if humanoidRootPart then
                local targetVelocity = humanoidRootPart.Velocity
                if AimSettings.CrosshairDistance > 0 then
                    local distance = (targetPosition - camera.CFrame.Position).Magnitude
                    local timeToTarget = distance / 1000
                    targetPosition = targetPosition + (targetVelocity * timeToTarget * AimSettings.CrosshairDistance)
                end
            end
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
            local smoothedCFrame = currentCFrame:Lerp(targetCFrame, 1 / AimSettings.Smoothness)
            camera.CFrame = smoothedCFrame
        end
    end)
end

local function CreateRainbowUI()
    if RainbowUIScreenGui then
        RainbowUIScreenGui:Destroy()
        RainbowUIScreenGui = nil
    end
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    RainbowUIScreenGui = Instance.new("ScreenGui")
    RainbowUIScreenGui.Name = "RainbowCircleUI"
    RainbowUIScreenGui.ResetOnSpawn = false
    RainbowUIScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    RainbowUIScreenGui.DisplayOrder = 99999
    RainbowUIScreenGui.IgnoreGuiInset = true
    RainbowUIScreenGui.Enabled = true
    RainbowUIScreenGui.Parent = playerGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "RainbowCircle"
    mainFrame.Size = UDim2.new(0, 80, 0, 80)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundTransparency = 1
    mainFrame.ZIndex = 100000
    mainFrame.Parent = RainbowUIScreenGui
    mainFrame.Active = true
    mainFrame.Selectable = true
    mainFrame.Draggable = false
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = mainFrame
    local rainbowBackground = Instance.new("Frame")
    rainbowBackground.Name = "RainbowBackground"
    rainbowBackground.Size = UDim2.new(1, 0, 1, 0)
    rainbowBackground.Position = UDim2.new(0, 0, 0, 0)
    rainbowBackground.BackgroundTransparency = 0
    rainbowBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    rainbowBackground.ZIndex = 100001
    rainbowBackground.Parent = mainFrame
    rainbowBackground.Active = true
    rainbowBackground.Selectable = true
    local rainbowCorner = Instance.new("UICorner")
    rainbowCorner.CornerRadius = UDim.new(1, 0)
    rainbowCorner.Parent = rainbowBackground
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Color = Color3.fromRGB(255, 255, 255)
    rainbowStroke.Thickness = 3
    rainbowStroke.Transparency = 0
    rainbowStroke.Parent = mainFrame
    local innerStroke = Instance.new("UIStroke")
    innerStroke.Name = "InnerStroke"
    innerStroke.Color = Color3.fromRGB(0, 0, 0)
    innerStroke.Thickness = 1
    innerStroke.Transparency = 0.3
    innerStroke.Parent = rainbowBackground
    StatusIndicator = Instance.new("Frame")
    StatusIndicator.Name = "StatusIndicator"
    StatusIndicator.Size = UDim2.new(0, 15, 0, 15)
    StatusIndicator.Position = UDim2.new(1, -18, 1, -18)
    StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    StatusIndicator.BackgroundTransparency = 0
    StatusIndicator.ZIndex = 100002
    StatusIndicator.Parent = mainFrame
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = StatusIndicator
    local indicatorStroke = Instance.new("UIStroke")
    indicatorStroke.Color = Color3.fromRGB(255, 255, 255)
    indicatorStroke.Thickness = 2
    indicatorStroke.Parent = StatusIndicator
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 0, 25)
    statusText.Position = UDim2.new(0, 0, 1, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamBold
    statusText.TextStrokeTransparency = 0.3
    statusText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    statusText.TextStrokeTransparency = 0.3
    statusText.ZIndex = 100002
    statusText.Parent = mainFrame
    local clickArea = Instance.new("TextButton")
    clickArea.Name = "ClickArea"
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.Position = UDim2.new(0, 0, 0, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 100003
    clickArea.Parent = mainFrame
    local rainbowColors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 95, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 215, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(144, 238, 144),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 200, 200),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(138, 43, 226),
        Color3.fromRGB(148, 0, 211),
        Color3.fromRGB(199, 21, 133),
        Color3.fromRGB(255, 20, 147)
    }
    local rainbowColors2 = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 127, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(148, 0, 211)
    }
    local timeOffset = 0
    local hoverAmplitude = 4
    local hoverSpeed = 4
    local pulseSpeed = 2
    local pulseAmount = 0.1
    local colorIndex = 1
    local colorIndex2 = 3
    local transitionTime = 0.8
    local transitionTime2 = 0.5
    local elapsedTime = 0
    local elapsedTime2 = 0
    local pulseScale = 1
    local isPulsingOut = true
    if animationConnection then
        animationConnection:Disconnect()
    end
    animationConnection = RunService.RenderStepped:Connect(function(deltaTime)
        pcall(function()
            if not RainbowUIEnabled or not RainbowUIScreenGui or not RainbowUIScreenGui.Parent then
                animationConnection:Disconnect()
                animationConnection = nil
                return
            end
            elapsedTime = elapsedTime + deltaTime
            if elapsedTime >= transitionTime then
                elapsedTime = 0
                colorIndex = colorIndex + 1
                if colorIndex > #rainbowColors then
                    colorIndex = 1
                end
            end
            local nextColorIndex = colorIndex + 1
            if nextColorIndex > #rainbowColors then
                nextColorIndex = 1
            end
            local alpha = elapsedTime / transitionTime
            local currentBgColor = rainbowColors[colorIndex]:Lerp(rainbowColors[nextColorIndex], alpha)
            rainbowBackground.BackgroundColor3 = currentBgColor
            elapsedTime2 = elapsedTime2 + deltaTime
            if elapsedTime2 >= transitionTime2 then
                elapsedTime2 = 0
                colorIndex2 = colorIndex2 + 1
                if colorIndex2 > #rainbowColors2 then
                    colorIndex2 = 1
                end
            end
            local nextColorIndex2 = colorIndex2 + 1
            if nextColorIndex2 > #rainbowColors2 then
                nextColorIndex2 = 1
            end
            local alpha2 = elapsedTime2 / transitionTime2
            local currentStrokeColor = rainbowColors2[colorIndex2]:Lerp(rainbowColors2[nextColorIndex2], alpha2)
            rainbowStroke.Color = currentStrokeColor
            if isPulsingOut then
                pulseScale = pulseScale + deltaTime * pulseSpeed * pulseAmount
                if pulseScale >= 1 + pulseAmount then
                    isPulsingOut = false
                end
            else
                pulseScale = pulseScale - deltaTime * pulseSpeed * pulseAmount
                if pulseScale <= 1 - pulseAmount then
                    isPulsingOut = true
                end
            end
            rainbowBackground.Size = UDim2.new(pulseScale, 0, pulseScale, 0)
            rainbowBackground.Position = UDim2.new((1 - pulseScale) / 2, 0, (1 - pulseScale) / 2, 0)
            timeOffset = timeOffset + deltaTime * hoverSpeed
            local hoverOffset = math.sin(timeOffset) * hoverAmplitude
            mainFrame.Position = UDim2.new(0, 10, 0, 10 + hoverOffset)
            innerStroke.Transparency = 0.2 + 0.3 * math.sin(timeOffset * 2)
            if StatusIndicator then
                StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
            if statusText then
                statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
                statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
            end
        end)
    end)
    local function handleClick()
        AimSettings.Enabled = not AimSettings.Enabled
        if AimSettings.Enabled then
            InitializeAimDrawings()
            UpdateFOVCircle()
            if AimConnection then
                AimConnection:Disconnect()
            end
            AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                pcall(function()
                    if AimSettings.FOVRainbowEnabled then
                        CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                    end
                    UpdateFOVCircle()
                    AimBot()
                end)
            end)
        else
            if AimConnection then
                AimConnection:Disconnect()
                AimConnection = nil
            end
            CleanupDrawings()
            CurrentTarget = nil
        end
        if StatusIndicator then
            StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        if statusText then
            statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
            statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
        end
        local originalSize = rainbowBackground.Size
        local originalPosition = rainbowBackground.Position
        local tweenInfo1 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenInfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        local clickScaleUp = TweenService:Create(rainbowBackground, tweenInfo1, {
            Size = originalSize * 0.7,
            Position = UDim2.new(0.15, 0, 0.15, 0)
        })
        local clickScaleDown = TweenService:Create(rainbowBackground, tweenInfo2, {
            Size = originalSize,
            Position = originalPosition
        })
        local originalStrokeColor = rainbowStroke.Color
        local flashTween = TweenService:Create(rainbowStroke, tweenInfo1, {
            Color = Color3.fromRGB(255, 255, 255)
        })
        local revertStroke = TweenService:Create(rainbowStroke, tweenInfo2, {
            Color = originalStrokeColor
        })
        clickScaleUp:Play()
        flashTween:Play()
        clickScaleUp.Completed:Connect(function()
            clickScaleDown:Play()
            revertStroke:Play()
        end)
    end
    clickArea.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 6
        })
        pulseAmount = 0.15
        tween1:Play()
    end)
    mainFrame.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 3
        })
        pulseAmount = 0.1
        tween1:Play()
    end)
    rainbowBackground.BackgroundTransparency = 1
    rainbowStroke.Transparency = 1
    local fadeIn = TweenService:Create(rainbowBackground, TweenInfo.new(0.5), {
        BackgroundTransparency = 0
    })
    local strokeFadeIn = TweenService:Create(rainbowStroke, TweenInfo.new(0.5), {
        Transparency = 0
    })
    task.wait(0.2)
    fadeIn:Play()
    strokeFadeIn:Play()
    return true
end

local function ToggleRainbowUI(state)
    RainbowUIEnabled = state
    if state then
        local success = CreateRainbowUI()
        if success then
            WindUI:Notify({
                Title = "自瞄快捷UI",
                Content = "快捷UI 让你秒人更加高效",
                Icon = "sparkles",
            })
        end
    else
        if RainbowUIScreenGui then
            RainbowUIScreenGui:Destroy()
            RainbowUIScreenGui = nil
        end
        WindUI:Notify({
            Title = "自瞄快捷UI",
            Content = "快捷UI已隐藏",
            Icon = "sparkles",
        })
    end
end

do
    AimTab:Section({
        Title = "自瞄设置",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    AimTab:Toggle({
        Title = "启用自瞄",
        Desc = "开启/关闭自瞄功能",
        Callback = function(enabled)
            AimSettings.Enabled = enabled
            if enabled then
                InitializeAimDrawings()
                UpdateFOVCircle()
                if AimConnection then
                    AimConnection:Disconnect()
                end
                AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                    pcall(function()
                        if AimSettings.FOVRainbowEnabled then
                            CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                        end
                        UpdateFOVCircle()
                        AimBot()
                    end)
                end)
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已开启",
                    Icon = "crosshair",
                })
            else
                if AimConnection then
                    AimConnection:Disconnect()
                    AimConnection = nil
                end
                CleanupDrawings()
                CurrentTarget = nil
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已关闭",
                    Icon = "crosshair",
                })
            end
            if StatusIndicator then
                StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "自瞄快捷UI",
        Desc = "快捷UI 让你秒人更加高效",
        Callback = function(enabled)
            ToggleRainbowUI(enabled)
        end
    })
    AimTab:Toggle({
        Title = "FOV开关",
        Desc = "显示自瞄范围圆圈",
        Value = AimSettings.FOVEnabled,
        Callback = function(enabled)
            AimSettings.FOVEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Toggle({
        Title = "FOV彩虹效果",
        Desc = "开启FOV圆圈彩虹效果",
        Value = AimSettings.FOVRainbowEnabled,
        Callback = function(enabled)
            AimSettings.FOVRainbowEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Slider({
        Title = "FOV彩虹速度",
        Desc = "调整彩虹流动的速度",
        Value = {
            Min = 1,
            Max = 20,
            Default = AimSettings.FOVRainbowSpeed,
        },
        Callback = function(value)
            AimSettings.FOVRainbowSpeed = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄范围 (FOV)",
        Desc = "设置自瞄FOV大小",
        Value = {
            Min = 50,
            Max = 500,
            Default = AimSettings.FOV,
        },
        Callback = function(value)
            AimSettings.FOV = value
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄平滑度",
        Desc = "数值越小越强锁",
        Value = {
            Min = 1,
            Max = 50,
            Default = AimSettings.Smoothness,
        },
        Callback = function(value)
            AimSettings.Smoothness = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "预判距离",
        Desc = "设置预判距离(需要强锁直接调到0-3)",
        Value = {
            Min = 0,
            Max = 20,
            Default = AimSettings.CrosshairDistance,
        },
        Callback = function(value)
            AimSettings.CrosshairDistance = value
        end
    })
    AimTab:Space()
    AimTab:Colorpicker({
        Title = "FOV圆圈颜色",
        Desc = "彩虹模式关闭时生效",
        Default = AimSettings.FOVColor,
        Callback = function(color)
            AimSettings.FOVColor = color
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "好友检测",
        Desc = "不秒好友",
        Value = AimSettings.FriendCheck,
        Callback = function(enabled)
            AimSettings.FriendCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "墙壁检测",
        Desc = "开启墙壁检测 避免自瞄乱飞",
        Value = AimSettings.WallCheck,
        Callback = function(enabled)
            AimSettings.WallCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "队伍检测",
        Desc = "不攻击同队队友",
        Value = AimTeamCheck,
        Callback = function(enabled)
            AimTeamCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "目标自瞄模式",
        Desc = "开启后可以选择目标进行制裁",
        Value = false,
        Callback = function(enabled)
            AimSettings.TargetAll = not enabled
            CurrentTarget = nil
        end
    })
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    local targetDropdown = AimTab:Dropdown({
        Title = "选择目标玩家",
        Desc = "选择要自瞄的玩家",
        Values = playerList,
        Value = nil,
        AllowNone = true,
        Callback = function(selected)
            AimSettings.TargetPlayer = selected
            CurrentTarget = nil
        end
    })
    Players.PlayerAdded:Connect(function(player)
        table.insert(playerList, player.Name)
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        for i, name in ipairs(playerList) do
            if name == player.Name then
                table.remove(playerList, i)
                break
            end
        end
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    AimTab:Space()
    AimTab:Section({
        Title = "自瞄部位设置",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    AimTab:Dropdown({
        Title = "自瞄部位",
        Desc = "选择要瞄准的身体部位",
        Values = {"头", "上身", "左腿", "右腿", "鸡巴", "奶子"},
        Value = AimTargetPart,
        Callback = function(selected)
            AimTargetPart = selected
        end
    })
    AimTab:Space()
    AimTab:Section({
        Title = "黑名单管理",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    blacklistInput = AimTab:Input({
        Title = "自瞄黑名单",
        Desc = "输入不攻击的玩家名字，多个用逗号分隔",
        Placeholder = "例如: Player1,Player2,Player3",
        Callback = function(value)
            local names = {}
            for name in string.gmatch(value, "[^,]+") do
                name = name:match("^%s*(.-)%s*$")
                if name ~= "" then
                    table.insert(names, name)
                end
            end
            AimBlacklist = names
        end
    })
    AimTab:Button({
        Title = "添加当前目标到黑名单",
        Justify = "Center",
        Callback = function()
            if CurrentTarget and CurrentTarget.Name then
                local targetName = CurrentTarget.Name
                for _, name in ipairs(AimBlacklist) do
                    if name == targetName then
                        WindUI:Notify({
                            Title = "黑名单",
                            Content = targetName .. " 已在黑名单中",
                            Icon = "info",
                        })
                        return
                    end
                end
                table.insert(AimBlacklist, targetName)
                local newValue = table.concat(AimBlacklist, ", ")
                if blacklistInput and blacklistInput.SetValue then
                    blacklistInput:SetValue(newValue)
                else
                    WindUI:Notify({
                        Title = "黑名单",
                        Content = "已添加 " .. targetName .. "，请手动更新输入框",
                        Icon = "info",
                    })
                end
            else
                WindUI:Notify({
                    Title = "黑名单",
                    Content = "没有当前目标",
                    Icon = "alert-circle",
                })
            end
        end
    })
    AimTab:Space()
    AimTab:Button({
        Title = "清空白名单",
        Justify = "Center",
        Callback = function()
            AimBlacklist = {}
            if blacklistInput and blacklistInput.SetValue then
                blacklistInput:SetValue("")
            end
            WindUI:Notify({
                Title = "黑名单",
                Content = "黑名单已清空",
                Icon = "check",
            })
        end
    })
    AimTab:Space()
    local statusText = "自瞄状态: 未启用"
    if AimSettings.Enabled then
        statusText = "自瞄状态: 已启用 模式: " .. (AimSettings.TargetAll and "全部玩家" or "目标玩家")
    end
    AimTab:Section({
        Title = statusText,
        TextSize = 14,
        FontWeight = Enum.FontWeight.Medium,
        TextColor = AimSettings.Enabled and Green or Grey,
    })
    local QuickSettings = AimTab:Group({})
    QuickSettings:Button({
        Title = "快速设置: 强锁[子弹有延迟类]",
        Desc = "FOV99 平滑1 预判0.96",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 99
            AimSettings.Smoothness = 1
            AimSettings.CrosshairDistance = 0.96
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用近距离设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 强锁[子弹无延迟]",
        Desc = "FOV120, 平滑1 预判0",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 120
            AimSettings.Smoothness = 1
            AimSettings.CrosshairDistance = 0
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用强锁设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 平滑类[]",
        Desc = "FOV130 平滑6 预判1",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 130
            AimSettings.Smoothness = 6
            AimSettings.CrosshairDistance = 1
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用远距离设置",
                Icon = "settings",
            })
        end
    })
end
--音乐功能---------------------------------------------------------------
Rnm:Section({
    Title = "音乐功能公告",
    Icon = "component",
    TextSize = 30,
    TextXAlignment = "Left",
    Box = true,
    BoxBorder = true,
    Opened = true,
    FontWeight = Enum.FontWeight.SemiBold,
    DescFontWeight = Enum.FontWeight.Medium,
    TextTransparency = 0,
    DescTextTransparency = 0,
})

Rnm:Paragraph({
    Title = "该功能无法通过下拉选项选择歌曲只能一首一首听\n不好意思只能这样我也想不到怎么去搞这个音乐播放器\n有建议的复制下面的源码可以去改\n来找我进行修改",
    TextSize = 30, 
    Thumbnail = "rbxassetid://123887383447725",
    ThumbnailSize = 100,
})
local Audio = Instance.new("Sound")
Audio.Parent = game:GetService("SoundService")
Audio.Volume = 0.8
local State = {
    IsPlaying = false,
    CurrentSong = nil,
    Source = "网易云",
    LoopMode = 1,
    Results = {},
    CurrentIndex = 0
}
local resultsDropdown
local playToggle
local function notify(title, content, duration)
    WindUI:Notify({
        Title = title,
        Content = content,
        Icon = "music",
        Duration = duration or 3
    })
end
local function searchMusic(query, page)
    if query == "" then 
        notify("搜索失败", "请输入歌曲名称")
        return 
    end
    notify("搜索中...", "正在搜索: " .. query, 2)
    local url = "http://music.163.com/api/search/get/web?s=" .. game:GetService("HttpService"):UrlEncode(query) .. "&type=1&limit=15&offset=" .. ((page or 1)-1)*15
    local success, response = pcall(function()
        return request({
            Url = url,
            Method = "GET",
            Headers = {["User-Agent"] = "Mozilla/5.0"}
        })
    end)
    if success and response.StatusCode == 200 then
        local data = game:GetService("HttpService"):JSONDecode(response.Body)
        if data.result and data.result.songs and #data.result.songs > 0 then
            State.Results = data.result.songs
            local options = {}
            
            for i, song in ipairs(data.result.songs) do
                local artists = ""
                if song.artists then
                    for j, artist in ipairs(song.artists) do
                        if j > 1 then artists = artists .. ", " end
                        artists = artists .. (artist.name or "未知")
                    end
                end
                table.insert(options, string.format("[%02d] %s - %s", i, song.name, artists))
            end
            
            if resultsDropdown then
                resultsDropdown:UpdateValues(options)
            end
            
            notify("搜索成功", "找到 " .. #options .. " 首歌曲", 2)
        else
            notify("无结果", "未找到相关歌曲", 3)
            if resultsDropdown then
                resultsDropdown:UpdateValues({"暂无结果"})
            end
        end
    else
        notify("搜索失败", "网络请求失败，请重试", 3)
    end
end
local function playSong(index)
    if not State.Results[index] then 
        notify("播放失败", "无效的歌曲索引")
        return 
    end
    
    local song = State.Results[index]
    State.CurrentIndex = index
    State.CurrentSong = song
    
    notify("加载中...", "正在加载: " .. song.name, 2)
    Audio:Stop()
    
    local audioUrls = {
        "http://music.163.com/song/media/outer/url?id=" .. song.id .. ".mp3",
        "https://music.163.com/song/media/outer/url?id=" .. song.id .. ".mp3"
    }
    
    local played = false
    for _, audioUrl in ipairs(audioUrls) do
        local success, response = pcall(function()
            return request({
                Url = audioUrl,
                Method = "GET",
                Headers = {["User-Agent"] = "Mozilla/5.0"}
            })
        end)
        
        if success and response.StatusCode == 200 and #response.Body > 1000 then
            local fileName = "music_" .. song.id .. ".mp3"
            
            local fileExists = false
            pcall(function() readfile(fileName) fileExists = true end)
            
            if not fileExists then
                writefile(fileName, response.Body)
            end
            
            Audio.SoundId = getcustomasset(fileName)
            Audio:Play()
            State.IsPlaying = true
            
            if playToggle then
                playToggle:UpdateValue(true)
                playToggle:SetTitle("⏸ 暂停")
            end
            
            notify("开始播放", song.name, 3)
            played = true
            break
        end
    end
    
    if not played then
        notify("播放失败", "无法获取音频资源", 3)
    end
end
Rnm:Input({
    Title = "搜索歌曲",
    Desc = "输入歌名，回车搜索",
    Value = "",
    Placeholder = "例如：起风了",
    Type = "Input",
    Callback = function(text)
        searchMusic(text, 1)
    end
})
resultsDropdown = Rnm:Dropdown({
    Title = "搜索结果 (点击勾选播放)",
    Values = { "暂无结果" },
    Multi = true,
    AllowNone = true,
    Callback = function(selectedOptions) 
        if type(selectedOptions) == "table" and #selectedOptions > 0 then
            local lastSelected = selectedOptions[#selectedOptions]
            local index = tonumber(string.match(lastSelected, "%[(%d+)%]"))
            if index then
                playSong(index)
            end
        end
    end
})
Rnm:Button({
    Title = "上一首",
    Callback = function()
        if State.CurrentIndex > 1 then
            playSong(State.CurrentIndex - 1)
        elseif #State.Results > 0 then
            playSong(#State.Results)
        end
    end
})
Rnm:Button({
    Title = "下一首",
    Callback = function()
        if State.CurrentIndex < #State.Results then
            playSong(State.CurrentIndex + 1)
        else
            playSong(1)
        end
    end
})
playToggle = Rnm:Toggle({
    Title = "播放/暂停",
    Desc = "点击切换播放状态",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            if Audio.TimeLength > 0 then
                Audio:Resume()
            elseif State.CurrentIndex > 0 then
                playSong(State.CurrentIndex)
            end
        else
            Audio:Pause()
        end
        State.IsPlaying = state
    end
})
Rnm:Slider({
    Title = "音量",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 80
    },
    Callback = function(value)
        Audio.Volume = value / 100
    end
})
Rnm:Dropdown({
    Title = "循环模式",
    Values = {"列表循环", "单曲循环"},
    Value = "列表循环",
    Multi = false,
    Callback = function(option)
        if option == "单曲循环" then
            State.LoopMode = 2
            Audio.Looped = true
        else
            State.LoopMode = 1
            Audio.Looped = false
        end
    end
})
Rnm:Dropdown({
    Title = "音源",
    Values = {"网易云", "QQ", "酷我"},
    Value = "网易云",
    Multi = false,
    Callback = function(option)
        State.Source = option
    end
})
Rnm:Button({
    Title = "音乐播放器",
    Desc = "加载音乐播放器",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "音乐",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fningna51-stack/-/main/AF%20%E9%9F%B3%E4%B9%90%E8%84%9A%E6%9C%AC"))()
            end)
            WindUI:Notify({
                Title = "音乐",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Audio.Ended:Connect(function()
    if State.LoopMode == 2 then
        return
    elseif State.LoopMode == 1 and State.CurrentIndex < #State.Results then
        playSong(State.CurrentIndex + 1)
    elseif State.LoopMode == 1 and State.CurrentIndex == #State.Results then
        playSong(1)
    end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.Space then
        if State.IsPlaying then
            Audio:Pause()
            playToggle:UpdateValue(false)
        else
            if Audio.TimeLength > 0 then
                Audio:Resume()
                playToggle:UpdateValue(true)
            elseif State.CurrentIndex > 0 then
                playSong(State.CurrentIndex)
            end
        end
        State.IsPlaying = not State.IsPlaying
    end
end)

Rnm:Code({
    Title = "这个音乐功能源码.lua",
    Code = [[local Audio = Instance.new("Sound")
Audio.Parent = game:GetService("SoundService")
Audio.Volume = 0.8
local State = {
    IsPlaying = false,
    CurrentSong = nil,
    Source = "网易云",
    LoopMode = 1,
    Results = {},
    CurrentIndex = 0
}
local resultsDropdown
local playToggle
local function notify(title, content, duration)
    WindUI:Notify({
        Title = title,
        Content = content,
        Icon = "music",
        Duration = duration or 3
    })
end
local function searchMusic(query, page)
    if query == "" then 
        notify("搜索失败", "请输入歌曲名称")
        return 
    end
    notify("搜索中...", "正在搜索: " .. query, 2)
    local url = "http://music.163.com/api/search/get/web?s=" .. game:GetService("HttpService"):UrlEncode(query) .. "&type=1&limit=15&offset=" .. ((page or 1)-1)*15
    local success, response = pcall(function()
        return request({
            Url = url,
            Method = "GET",
            Headers = {["User-Agent"] = "Mozilla/5.0"}
        })
    end)
    if success and response.StatusCode == 200 then
        local data = game:GetService("HttpService"):JSONDecode(response.Body)
        if data.result and data.result.songs and #data.result.songs > 0 then
            State.Results = data.result.songs
            local options = {}
            
            for i, song in ipairs(data.result.songs) do
                local artists = ""
                if song.artists then
                    for j, artist in ipairs(song.artists) do
                        if j > 1 then artists = artists .. ", " end
                        artists = artists .. (artist.name or "未知")
                    end
                end
                table.insert(options, string.format("[%02d] %s - %s", i, song.name, artists))
            end
            
            if resultsDropdown then
                resultsDropdown:UpdateValues(options)
            end
            
            notify("搜索成功", "找到 " .. #options .. " 首歌曲", 2)
        else
            notify("无结果", "未找到相关歌曲", 3)
            if resultsDropdown then
                resultsDropdown:UpdateValues({"暂无结果"})
            end
        end
    else
        notify("搜索失败", "网络请求失败，请重试", 3)
    end
end
local function playSong(index)
    if not State.Results[index] then 
        notify("播放失败", "无效的歌曲索引")
        return 
    end
    
    local song = State.Results[index]
    State.CurrentIndex = index
    State.CurrentSong = song
    
    notify("加载中...", "正在加载: " .. song.name, 2)
    Audio:Stop()
    
    local audioUrls = {
        "http://music.163.com/song/media/outer/url?id=" .. song.id .. ".mp3",
        "https://music.163.com/song/media/outer/url?id=" .. song.id .. ".mp3"
    }
    
    local played = false
    for _, audioUrl in ipairs(audioUrls) do
        local success, response = pcall(function()
            return request({
                Url = audioUrl,
                Method = "GET",
                Headers = {["User-Agent"] = "Mozilla/5.0"}
            })
        end)
        
        if success and response.StatusCode == 200 and #response.Body > 1000 then
            local fileName = "music_" .. song.id .. ".mp3"
            
            local fileExists = false
            pcall(function() readfile(fileName) fileExists = true end)
            
            if not fileExists then
                writefile(fileName, response.Body)
            end
            
            Audio.SoundId = getcustomasset(fileName)
            Audio:Play()
            State.IsPlaying = true
            
            if playToggle then
                playToggle:UpdateValue(true)
                playToggle:SetTitle("⏸ 暂停")
            end
            
            notify("开始播放", song.name, 3)
            played = true
            break
        end
    end
    
    if not played then
        notify("播放失败", "无法获取音频资源", 3)
    end
end
Rnm:Input({
    Title = "搜索歌曲",
    Desc = "输入歌名，回车搜索",
    Value = "",
    Placeholder = "例如：起风了",
    Type = "Input",
    Callback = function(text)
        searchMusic(text, 1)
    end
})
resultsDropdown = Rnm:Dropdown({
    Title = "搜索结果 (点击勾选播放)",
    Values = { "暂无结果" },
    Multi = true,
    AllowNone = true,
    Callback = function(selectedOptions) 
        if type(selectedOptions) == "table" and #selectedOptions > 0 then
            local lastSelected = selectedOptions[#selectedOptions]
            local index = tonumber(string.match(lastSelected, "%[(%d+)%]"))
            if index then
                playSong(index)
            end
        end
    end
})
Rnm:Button({
    Title = "上一首",
    Callback = function()
        if State.CurrentIndex > 1 then
            playSong(State.CurrentIndex - 1)
        elseif #State.Results > 0 then
            playSong(#State.Results)
        end
    end
})
Rnm:Button({
    Title = "下一首",
    Callback = function()
        if State.CurrentIndex < #State.Results then
            playSong(State.CurrentIndex + 1)
        else
            playSong(1)
        end
    end
})
playToggle = Rnm:Toggle({
    Title = "播放/暂停",
    Desc = "点击切换播放状态",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            if Audio.TimeLength > 0 then
                Audio:Resume()
            elseif State.CurrentIndex > 0 then
                playSong(State.CurrentIndex)
            end
        else
            Audio:Pause()
        end
        State.IsPlaying = state
    end
})
Rnm:Slider({
    Title = "音量",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 80
    },
    Callback = function(value)
        Audio.Volume = value / 100
    end
})
Rnm:Dropdown({
    Title = "循环模式",
    Values = {"列表循环", "单曲循环"},
    Value = "列表循环",
    Multi = false,
    Callback = function(option)
        if option == "单曲循环" then
            State.LoopMode = 2
            Audio.Looped = true
        else
            State.LoopMode = 1
            Audio.Looped = false
        end
    end
})
Rnm:Dropdown({
    Title = "音源",
    Values = {"网易云", "QQ", "酷我"},
    Value = "网易云",
    Multi = false,
    Callback = function(option)
        State.Source = option
    end
})
Tab:Button({
    Title = "音乐播放器",
    Desc = "加载音乐播放器",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "音乐",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fningna51-stack/-/main/AF%20%E9%9F%B3%E4%B9%90%E8%84%9A%E6%9C%AC"))()
            end)
            WindUI:Notify({
                Title = "音乐",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Audio.Ended:Connect(function()
    if State.LoopMode == 2 then
        return
    elseif State.LoopMode == 1 and State.CurrentIndex < #State.Results then
        playSong(State.CurrentIndex + 1)
    elseif State.LoopMode == 1 and State.CurrentIndex == #State.Results then
        playSong(1)
    end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.Space then
        if State.IsPlaying then
            Audio:Pause()
            playToggle:UpdateValue(false)
        else
            if Audio.TimeLength > 0 then
                Audio:Resume()
                playToggle:UpdateValue(true)
            elseif State.CurrentIndex > 0 then
                playSong(State.CurrentIndex)
            end
        end
        State.IsPlaying = not State.IsPlaying
    end
end)
]],
})

Rnm:Code({
    Code = [[print("WindUI on top!")]],
})
--服务器脚本----------------------------------------------------------------------------
Fnm:Section({
    Title = "九十九夜",
    TextXAlignment = "Center",
    TextSize = 22,
})
Fnm:Divider()
Fnm:Button({
    Title = "九十九AF脚本",
    Desc = "加载AF脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "九十九",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fningna51-stack/-/main/AF%20Hun%E8%87%AA%E5%8A%A8%E5%8A%A0%E8%BD%BD",true))()
            end)
            WindUI:Notify({
                Title = "九十九",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Button({
    Title = "九十九夜虚空汉化",
    Desc = "加载虚空脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "九十九",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/atnew2025/Chinese-scripts/refs/heads/main/voidware-cn.txt"))()
            end)
            WindUI:Notify({
                Title = "九十九",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Button({
    Title = "九十九夜ringta汉化",
    Desc = "加载ringta脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "九十九",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/99Nights"))()
            end)
            WindUI:Notify({
                Title = "九十九",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Section({
    Title = "死铁轨",
    TextXAlignment = "Center",
    TextSize = 22,
})
Fnm:Divider()
Fnm:Button({
    Title = "死铁轨速通脚本",
    Desc = "加载速通脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "死铁轨",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fningna51-stack/-/main/%E6%AD%BB%E9%93%81%E8%BD%A8%E6%B1%89%E5%8C%96%E8%84%9A%E6%9C%AC"))()
            end)
            WindUI:Notify({
                Title = "死铁轨",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Button({
    Title = "死铁轨仿红叶脚本",
    Desc = "加载仿红叶脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "死铁轨",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fningna51-stack/-/main/%E4%BB%BF%E7%BA%A2%E5%8F%B6%E8%84%9A%E6%9C%AC%E6%B1%89%E5%8C%96"))()
            end)
            WindUI:Notify({
                Title = "死铁轨",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Button({
    Title = "死铁轨红叶脚本",
    Desc = "加载红叶脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "死铁轨",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/stghongye.lua"))()
            end)
            WindUI:Notify({
                Title = "死铁轨",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Section({
    Title = "DOORS",
    TextXAlignment = "Center",
    TextSize = 22,
})
Fnm:Divider()
Fnm:Button({
    Title = "doors最新脚本",
    Desc = "加载doors脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "doors",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Loader.luau"))()
            end)
            WindUI:Notify({
                Title = "doors",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Button({
    Title = "doors Abysall汉化脚本",
    Desc = "加载Abysall脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "doors",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/atnew2025/Chinese-scripts/refs/heads/main/Abysallcn-hub"))()
            end)
            WindUI:Notify({
                Title = "doors",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Button({
    Title = "doors mshax汉化脚本",
    Desc = "加载mshax脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "doors",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/atnew2025/Chinese-scripts/refs/heads/main/mshax(prohax).txt"))()
            end)
            WindUI:Notify({
                Title = "doors",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Section({
    Title = "战争大亨",
    TextXAlignment = "Center",
    TextSize = 22,
})
Fnm:Divider()
Fnm:Button({
    Title = "AF Hub战争大亨脚本",
    Desc = "加载AF脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "战争大亨",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fningna51-stack/-/main/AF%20Hun%E8%87%AA%E5%8A%A8%E5%8A%A0%E8%BD%BD",true))()
            end)
            WindUI:Notify({
                Title = "战争大亨",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Button({
    Title = "战争大亨kenny汉化",
    Desc = "加载战争大亨脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "战争大亨",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%88%98%E4%BA%89%E5%A4%A7%E4%BA%A8.txt"))()
            end)
            WindUI:Notify({
                Title = "战争大亨",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Section({
    Title = "亡命速递",
    TextXAlignment = "Center",
    TextSize = 22,
})
Fnm:Divider()
Fnm:Button({
    Title = "亡命速递霜溺脚本",
    Desc = "加载霜溺脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "亡命速递",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ShenJiaoBen/ScriptLoader/refs/heads/main/Linni_FreeLoader.lua"))()
            end)
            WindUI:Notify({
                Title = "亡命速递",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Button({
    Title = "亡命速递脚本",
    Desc = "加载亡命速递脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "亡命速递",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/JanseJYC/Script/refs/heads/main/Deadly-Deliver.lua"))()
            end)
            WindUI:Notify({
                Title = "亡命速递",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Section({
    Title = "监狱生活",
    TextXAlignment = "Center",
    TextSize = 22,
})
Fnm:Divider()
Fnm:Button({
    Title = "监狱生活有芙同享汉化",
    Desc = "加载监狱生活脚本",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "监狱生活",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fningna51-stack/-/main/%E7%9B%91%E7%8B%B1%E7%94%9F%E6%B4%BB%E8%84%9A%E6%9C%AC"))()
            end)
            WindUI:Notify({
                Title = "监狱生活",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Button({
    Title = "监狱人生Rayfield脚本汉化",
    Desc = "Rayfield",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "监狱人生",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Clover781/m/refs/heads/main/prisonlife-Rayfield-robot"))()
            end)
            WindUI:Notify({
                Title = "监狱人生",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Section({
    Title = "盲射",
    TextXAlignment = "Center",
    TextSize = 22,
})
Fnm:Divider()
Fnm:Button({
    Title = "盲射ToralsMe汉化脚本",
    Desc = "盲射",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Clover781/m/refs/heads/main/blindshot-ToraIsMe-robot"))()
            end)
            WindUI:Notify({
                Title = "盲射",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})
Fnm:Section({
    Title = "死亡球",
    TextXAlignment = "Center",
    TextSize = 22,
})
Fnm:Button({
    Title = "死亡球stark汉化",
    Desc = "stark",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "死亡球",
            Content = "正在加载脚本...",
            Duration = 3
        })
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Clover781/m/refs/heads/main/Deathballs-stark-robot"))()
            end)
            WindUI:Notify({
                Title = "死亡球",
                Content = "脚本加载完成",
                Duration = 3
            })
        end)
    end
})






Window:Divider()
local SettingsTab = Window:Tab({
    Title = "Ui设置",
    Desc = "Ui美术设置", -- 可选
    Icon = "settings", -- lucide 图标 或 "rbxassetid://" 或 URL，可选
    IconThemed = true, -- 使用主题颜色，可选
    Locked = false, -- 禁用标签页交互，可选
    ShowTabTitle = false, -- 在标签页内显示标题，可选
    Border = true, -- 在标签页周围添加边框，可选
})

local ThemeSelectDropdown = SettingsTab:Dropdown({
    Title = "选择主题",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = {"AF Hub", "月夜", "冬日霜雪", "月渊"},
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})


SettingsTab:Divider()
SettingsTab:Section({ 
    Title = "背景选择",
    TextXAlignment = "Center",
    TextSize = 20,
})

local Dropdown = SettingsTab:Dropdown({
    Title = "切换背景图",
    Values = {
        {
            Title = "无背景",
            Icon = "app-window",
            Callback = function()
                -- 清除背景图
                Window:SetBackgroundImage("rbxassetid://0")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换为无背景",
                    Duration = 3
                })
            end
        },
        {
            Title = "背景图1(默认)",
            Desc = "秋词提供",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://123887383447725")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图1",
                    Duration = 3
                })
            end
        },
        {
            Title = "背景图Max",
            Icon = "app-window",
            Callback = function()
       Window:SetBackgroundImage("rbxassetid://136059273188532")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图Max",
                    Duration = 3
                })
            end
        },
        {
            Title = "背景图2",
            Icon = "app-window",
            Callback = function()
       Window:SetBackgroundImage("rbxassetid://101182501948173")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图2",
                    Duration = 3
                })
            end
        },
        {
            Title = "背景图3",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://90514823373955")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图3",
                    Duration = 3
                })
            end
        },
        {
            Title = "背景图4",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://103858984350097")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图4",
                    Duration = 3
                })
            end
        },
        {
            Title = "背景图5",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://137662774446930")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图5",
                    Duration = 3
                })
            end
        },
                {
            Title = "背景图6",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://73618579935939")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图6",
                    Duration = 3
                })
            end
        },
                {
            Title = "背景图7",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://131845772886226")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图7",
                    Duration = 3
                })
            end
        },
                {
            Title = "背景图8",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://92388982051300")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图8",
                    Duration = 3
                })
            end
        },
                        {
            Title = "背景图9",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://103197377834563")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图9",
                    Duration = 3
                })
            end
        },
                        {
            Title = "背景图10",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://123887383447725")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图10",
                    Duration = 3
                })
            end
        },
                        {
            Title = "背景图11",
            Icon = "app-window",
            Callback = function()
 Window:SetBackgroundImage("rbxassetid://84371548883810")
                WindUI:Notify({
                    Title = "AF Hub",
                    Content = "已切换背景图11",
                    Duration = 3
                })
            end
        },
    }
})

SettingsTab:Section({ 
    Title = "自定义背景",
    TextXAlignment = "Center",
    TextSize = 20,
})
SettingsTab:Divider()

local CustomBackground = SettingsTab:Input({
    Title = "背景 ID",
    Type = "Input",
    Placeholder = "输入图片ID",
    Callback = function(input)
        if input ~= "" then
            _G.BackgroundImage = "rbxassetid://" .. input
            Window:SetBackgroundImage(_G.BackgroundImage)
        end
    end
})

local Keybind = SettingsTab:Keybind({
    Title = "关闭界面的快捷键",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})