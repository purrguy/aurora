--[[

    █████╗ ██╗   ██╗██████╗  ██████╗ ██████╗  █████╗     ██╗   ██╗██╗
   ██╔══██╗██║   ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗    ██║   ██║██║
   ███████║██║   ██║██████╔╝██║   ██║██████╔╝███████║    ██║   ██║██║
   ██╔══██║██║   ██║██╔══██╗██║   ██║██╔══██╗██╔══██║    ██║   ██║██║
   ██║  ██║╚██████╔╝██║  ██║╚██████╔╝██║  ██║██║  ██║    ╚██████╔╝██║
   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚═╝

   Aurora UI  •  v1.0.0
   A modern, lightweight and fully themeable interface library for Roblox.

   Usage:
     local Aurora = loadstring(game:HttpGet("https://raw.githubusercontent.com/mixask/aurora/refs/heads/main/aurora.lua"))()

   Features:
     - Customizable tabs (icon, color, order, lock)
     - Buttons / Toggles / Sliders / Dropdowns (single + multi) / Inputs / Keybinds
     - Info paragraphs, sections and dividers
     - Title bar with icon, subtitle, minimize and close
     - Minimize collapses the window into a single draggable icon (rbxassetid customizable)
     - Bottom-left user panel: avatar, username and a settings gear
     - Notifications, themes, UI scaling, config flags

]]

--// Services
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")
local HttpService       = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--// Library
local Aurora = {
	Version      = "1.0.0",
	Flags        = {},   -- Flag -> value
	Options      = {},   -- Flag -> element object
	Windows      = {},
	ThemeName    = "Aurora",
	Connections  = {},
	Unloaded     = false,
}
Aurora.__index = Aurora

----------------------------------------------------------------------
-- THEMES
----------------------------------------------------------------------
Aurora.Themes = {
	Aurora = {
		Accent        = Color3.fromRGB(124, 106, 255),
		AccentSoft    = Color3.fromRGB(168, 120, 255),
		Background    = Color3.fromRGB(13, 13, 18),
		Sidebar       = Color3.fromRGB(17, 17, 23),
		Topbar        = Color3.fromRGB(16, 16, 22),
		Element       = Color3.fromRGB(24, 24, 32),
		ElementHover  = Color3.fromRGB(31, 31, 41),
		Stroke        = Color3.fromRGB(45, 45, 58),
		Text          = Color3.fromRGB(240, 240, 248),
		SubText       = Color3.fromRGB(146, 146, 166),
		Success       = Color3.fromRGB(87, 214, 148),
		Danger        = Color3.fromRGB(255, 96, 110),
	},
	Midnight = {
		Accent        = Color3.fromRGB(64, 156, 255),
		AccentSoft    = Color3.fromRGB(96, 208, 255),
		Background    = Color3.fromRGB(11, 14, 20),
		Sidebar       = Color3.fromRGB(14, 18, 26),
		Topbar        = Color3.fromRGB(13, 17, 25),
		Element       = Color3.fromRGB(20, 26, 36),
		ElementHover  = Color3.fromRGB(27, 34, 46),
		Stroke        = Color3.fromRGB(38, 48, 64),
		Text          = Color3.fromRGB(233, 240, 250),
		SubText       = Color3.fromRGB(132, 148, 170),
		Success       = Color3.fromRGB(72, 214, 168),
		Danger        = Color3.fromRGB(255, 104, 112),
	},
	Rose = {
		Accent        = Color3.fromRGB(255, 92, 148),
		AccentSoft    = Color3.fromRGB(255, 142, 176),
		Background    = Color3.fromRGB(18, 12, 16),
		Sidebar       = Color3.fromRGB(23, 15, 20),
		Topbar        = Color3.fromRGB(21, 14, 19),
		Element       = Color3.fromRGB(31, 20, 27),
		ElementHover  = Color3.fromRGB(40, 26, 34),
		Stroke        = Color3.fromRGB(58, 38, 50),
		Text          = Color3.fromRGB(250, 238, 244),
		SubText       = Color3.fromRGB(176, 146, 162),
		Success       = Color3.fromRGB(104, 214, 156),
		Danger        = Color3.fromRGB(255, 96, 110),
	},
	Emerald = {
		Accent        = Color3.fromRGB(52, 211, 153),
		AccentSoft    = Color3.fromRGB(110, 231, 183),
		Background    = Color3.fromRGB(10, 17, 15),
		Sidebar       = Color3.fromRGB(13, 22, 19),
		Topbar        = Color3.fromRGB(12, 20, 18),
		Element       = Color3.fromRGB(18, 30, 26),
		ElementHover  = Color3.fromRGB(24, 39, 34),
		Stroke        = Color3.fromRGB(35, 56, 48),
		Text          = Color3.fromRGB(232, 248, 242),
		SubText       = Color3.fromRGB(130, 166, 156),
		Success       = Color3.fromRGB(52, 211, 153),
		Danger        = Color3.fromRGB(255, 108, 108),
	},
	Daylight = {
		Accent        = Color3.fromRGB(99, 91, 255),
		AccentSoft    = Color3.fromRGB(140, 122, 255),
		Background    = Color3.fromRGB(244, 245, 250),
		Sidebar       = Color3.fromRGB(238, 240, 247),
		Topbar        = Color3.fromRGB(240, 242, 248),
		Element       = Color3.fromRGB(255, 255, 255),
		ElementHover  = Color3.fromRGB(246, 247, 252),
		Stroke        = Color3.fromRGB(218, 221, 233),
		Text          = Color3.fromRGB(24, 25, 34),
		SubText       = Color3.fromRGB(112, 116, 134),
		Success       = Color3.fromRGB(36, 176, 118),
		Danger        = Color3.fromRGB(226, 68, 84),
	},
}

Aurora.Theme = table.clone(Aurora.Themes.Aurora)

----------------------------------------------------------------------
-- ICON PACK (lucide uploads) - pass any rbxassetid:// yourself to override
----------------------------------------------------------------------
Aurora.Icons = {
	["home"]      = "rbxassetid://10723407389",
	["star"]      = "rbxassetid://10734949856",
	["settings"]  = "rbxassetid://10734950309",
	["user"]      = "rbxassetid://10747373176",
	["sword"]     = "rbxassetid://10747384394",
	["eye"]       = "rbxassetid://10723346959",
	["bolt"]      = "rbxassetid://10723345540",
	["globe"]     = "rbxassetid://10723405373",
	["code"]      = "rbxassetid://10723380675",
	["palette"]   = "rbxassetid://10734896206",
	["shield"]    = "rbxassetid://10747384394",
	["rocket"]    = "rbxassetid://10723415903",
	["minimize"]  = "rbxassetid://10734896206",
	["close"]     = "rbxassetid://10747384394",
	["chevron"]   = "rbxassetid://10709790948",
	["check"]     = "rbxassetid://10709790644",
	["info"]      = "rbxassetid://10723415903",
}

----------------------------------------------------------------------
-- UTILITIES
----------------------------------------------------------------------
local ThemeBindings = {}   -- { Object, Property, Token, Modifier }

local function New(class, props, children)
	local inst = Instance.new(class)
	for prop, value in pairs(props or {}) do
		if prop ~= "Parent" and prop ~= "Theme" then
			inst[prop] = value
		end
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	if props and props.Theme then
		for property, token in pairs(props.Theme) do
			table.insert(ThemeBindings, { Object = inst, Property = property, Token = token })
			inst[property] = Aurora.Theme[token]
		end
	end
	if props and props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

local function Bind(object, property, token)
	table.insert(ThemeBindings, { Object = object, Property = property, Token = token })
	object[property] = Aurora.Theme[token]
	return object
end

-- Every signal connection the library makes is tracked here so :Unload()
-- can drop them all instead of leaving dead listeners running forever.
local function Connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(Aurora.Connections, connection)
	return connection
end

local function DisconnectAll(list)
	for _, connection in ipairs(list or {}) do
		pcall(function() connection:Disconnect() end)
	end
	table.clear(list or {})
end

local function Tween(object, duration, props, style, direction)
	local info = TweenInfo.new(
		duration or 0.22,
		style or Enum.EasingStyle.Quint,
		direction or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(object, info, props)
	tween:Play()
	return tween
end

local function Corner(radius, parent)
	return New("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

local function Stroke(parent, token, thickness, transparency)
	local stroke = New("UIStroke", {
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
	Bind(stroke, "Color", token or "Stroke")
	return stroke
end

local function Padding(parent, top, bottom, left, right)
	return New("UIPadding", {
		PaddingTop    = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		PaddingLeft   = UDim.new(0, left or top or 0),
		PaddingRight  = UDim.new(0, right or left or top or 0),
		Parent = parent,
	})
end

local function List(parent, padding, direction)
	return New("UIListLayout", {
		Padding = UDim.new(0, padding or 6),
		FillDirection = direction or Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parent,
	})
end

local function Icon(id)
	if not id then return nil end
	if typeof(id) == "number" then return "rbxassetid://" .. id end
	if Aurora.Icons[string.lower(id)] then return Aurora.Icons[string.lower(id)] end
	if string.match(id, "^%d+$") then return "rbxassetid://" .. id end
	return id
end

local function Ripple(button)
	button.ClipsDescendants = true
	button.MouseButton1Down:Connect(function(x, y)
		local circle = New("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.86,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(x - button.AbsolutePosition.X, y - button.AbsolutePosition.Y),
			Size = UDim2.fromOffset(0, 0),
			ZIndex = 12,
			Parent = button,
		})
		Corner(999, circle)
		local target = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
		Tween(circle, 0.5, { Size = UDim2.fromOffset(target, target), BackgroundTransparency = 1 })
		task.delay(0.5, function() circle:Destroy() end)
	end)
end

local function Hoverable(object, base, hover)
	object.MouseEnter:Connect(function()
		Tween(object, 0.16, { BackgroundColor3 = Aurora.Theme[hover] })
	end)
	object.MouseLeave:Connect(function()
		Tween(object, 0.16, { BackgroundColor3 = Aurora.Theme[base] })
	end)
end

-- Dragging is driven by a single shared InputChanged listener instead of one
-- per draggable object, and writes Position directly (no tween) so it tracks
-- the cursor 1:1 with zero allocation per frame.
local ActiveDrag = nil

Connect(UserInputService.InputChanged, function(input)
	local drag = ActiveDrag
	if not drag then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then return end

	local delta = input.Position - drag.Start
	drag.Frame.Position = UDim2.new(
		drag.Origin.X.Scale, drag.Origin.X.Offset + delta.X,
		drag.Origin.Y.Scale, drag.Origin.Y.Offset + delta.Y
	)
	drag.Moved = drag.Moved or (delta.Magnitude > 3)
end)

Connect(UserInputService.InputEnded, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		ActiveDrag = nil
	end
end)

local function Draggable(frame, handle)
	handle = handle or frame
	local state = {}

	Connect(handle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			ActiveDrag = {
				Frame  = frame,
				Start  = input.Position,
				Origin = frame.Position,
				Moved  = false,
			}
			state.Drag = ActiveDrag
		end
	end)

	-- lets callers ask "was this a click or a drag?"
	return function()
		return state.Drag ~= nil and state.Drag.Moved or false
	end
end

local function Protect(gui)
	if syn and syn.protect_gui then
		syn.protect_gui(gui)
		gui.Parent = CoreGui
	elseif gethui then
		gui.Parent = gethui()
	elseif CoreGui:FindFirstChild("RobloxGui") then
		gui.Parent = CoreGui
	else
		gui.Parent = (LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")) or CoreGui
	end
	return gui
end

----------------------------------------------------------------------
-- THEME SWITCHING
----------------------------------------------------------------------
function Aurora:SetTheme(name)
	local theme = typeof(name) == "table" and name or Aurora.Themes[name]
	if not theme then return end
	Aurora.ThemeName = typeof(name) == "string" and name or "Custom"
	for token, color in pairs(theme) do
		Aurora.Theme[token] = color
	end

	-- walk backwards so destroyed instances can be pruned in the same pass
	for index = #ThemeBindings, 1, -1 do
		local binding = ThemeBindings[index]
		local object = binding.Object
		if not object or not object.Parent then
			table.remove(ThemeBindings, index)
		else
			local color = Aurora.Theme[binding.Token]
			if color then
				Tween(object, 0.25, { [binding.Property] = color })
			end
		end
	end
end

function Aurora:SetAccent(color)
	Aurora.Theme.Accent = color
	Aurora.Theme.AccentSoft = color:Lerp(Color3.fromRGB(255, 255, 255), 0.25)
	for index = #ThemeBindings, 1, -1 do
		local binding = ThemeBindings[index]
		if binding.Token == "Accent" or binding.Token == "AccentSoft" then
			if binding.Object and binding.Object.Parent then
				Tween(binding.Object, 0.25, { [binding.Property] = Aurora.Theme[binding.Token] })
			else
				table.remove(ThemeBindings, index)
			end
		end
	end
end

----------------------------------------------------------------------
-- NOTIFICATIONS
----------------------------------------------------------------------
local NotifyHolder

local function EnsureNotifyHolder()
	if NotifyHolder and NotifyHolder.Parent then return NotifyHolder end
	local gui = Protect(New("ScreenGui", {
		Name = "AuroraNotifications",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 9999,
	}))
	NotifyHolder = New("Frame", {
		Name = "Holder",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -18, 0, 18),
		Size = UDim2.fromOffset(300, 600),
		Parent = gui,
	})
	List(NotifyHolder, 10)
	return NotifyHolder
end

function Aurora:Notify(config)
	config = config or {}
	local holder = EnsureNotifyHolder()

	local card = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 0,
		Position = UDim2.new(1, 0, 0, 0),
		Theme = { BackgroundColor3 = "Sidebar" },
		Parent = holder,
	})
	Corner(12, card)
	Stroke(card, "Stroke", 1, 0.35)
	Padding(card, 12, 12, 14, 14)
	List(card, 4)

	local header = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		Parent = card,
	})

	if config.Icon then
		New("ImageLabel", {
			Image = Icon(config.Icon),
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.fromOffset(0, 1),
			Theme = { ImageColor3 = "Accent" },
			Parent = header,
		})
	end

	New("TextLabel", {
		Text = config.Title or "Notification",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(config.Icon and 24 or 0, 0),
		Size = UDim2.new(1, config.Icon and -24 or 0, 1, 0),
		Theme = { TextColor3 = "Text" },
		Parent = header,
	})

	if config.Content then
		New("TextLabel", {
			Text = config.Content,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Theme = { TextColor3 = "SubText" },
			Parent = card,
		})
	end

	local bar = New("Frame", {
		Size = UDim2.new(1, 0, 0, 2),
		BackgroundTransparency = 0,
		Theme = { BackgroundColor3 = "Accent" },
		Parent = card,
	})
	Corner(2, bar)

	card.Position = UDim2.new(1, 340, 0, 0)
	Tween(card, 0.35, { Position = UDim2.new(0, 0, 0, 0) })

	local duration = config.Duration or 4
	Tween(bar, duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
	task.delay(duration, function()
		Tween(card, 0.3, { Position = UDim2.new(1, 340, 0, 0) })
		task.delay(0.32, function() card:Destroy() end)
	end)

	return card
end

----------------------------------------------------------------------
-- WINDOW
----------------------------------------------------------------------
function Aurora:CreateWindow(config)
	config = config or {}

	local window = {
		Tabs         = {},
		Minimized    = false,
		Destroyed    = false,
		CurrentTab   = nil,
		Title        = config.Title or "Aurora UI",
		SubTitle     = config.SubTitle or config.Subtitle or "v" .. Aurora.Version,
		Size         = config.Size or UDim2.fromOffset(600, 430),
		ToggleKey    = config.ToggleKey or config.MinimizeKey or Enum.KeyCode.RightShift,
		MinimizeIcon = Icon(config.MinimizeIcon or "rbxassetid://10734896206"),
	}

	if config.Theme then Aurora:SetTheme(config.Theme) end
	if config.Accent then Aurora:SetAccent(config.Accent) end

	--// Root
	local screen = Protect(New("ScreenGui", {
		Name = config.Name or "AuroraUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 999,
	}))
	window.ScreenGui = screen

	--// Main frame
	local main = New("Frame", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = config.Position or UDim2.fromScale(0.5, 0.5),
		Size = window.Size,
		ClipsDescendants = true,
		Theme = { BackgroundColor3 = "Background" },
		Parent = screen,
	})
	Corner(14, main)
	Stroke(main, "Stroke", 1, 0.2)
	window.Main = main

	-- UIScale must live inside a GuiObject, not the ScreenGui
	local scaler = New("UIScale", { Scale = config.Scale or 1, Parent = main })
	window.Scaler = scaler

	-- subtle accent glaze at the top of the window
	New("Frame", {
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 120),
		ZIndex = 0,
		Theme = { BackgroundColor3 = "Accent" },
		Parent = main,
	}, {
		New("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	})

	--// Top bar
	local topbar = New("Frame", {
		Name = "Topbar",
		Size = UDim2.new(1, 0, 0, 46),
		BackgroundTransparency = 0,
		Theme = { BackgroundColor3 = "Topbar" },
		Parent = main,
	})
	Corner(14, topbar)
	New("Frame", {   -- square off bottom corners
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 1, -14),
		BorderSizePixel = 0,
		Theme = { BackgroundColor3 = "Topbar" },
		Parent = topbar,
	})
	New("Frame", {   -- divider
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -1),
		BorderSizePixel = 0,
		BackgroundTransparency = 0.45,
		Theme = { BackgroundColor3 = "Stroke" },
		Parent = topbar,
	})
	Draggable(main, topbar)

	--// Title icon
	local titleIcon
	if config.Icon ~= false then
		local holder = New("Frame", {
			Size = UDim2.fromOffset(26, 26),
			Position = UDim2.fromOffset(13, 10),
			BackgroundTransparency = 0,
			Theme = { BackgroundColor3 = "Element" },
			Parent = topbar,
		})
		Corner(8, holder)
		Stroke(holder, "Stroke", 1, 0.4)
		titleIcon = New("ImageLabel", {
			Image = Icon(config.Icon or "rbxassetid://10723407389"),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(15, 15),
			Theme = { ImageColor3 = "Accent" },
			Parent = holder,
		})
		window.TitleIcon = titleIcon
	end

	local titleLabel = New("TextLabel", {
		Text = window.Title,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(titleIcon and 48 or 16, 0),
		Size = UDim2.new(0, 220, 1, 0),
		Theme = { TextColor3 = "Text" },
		Parent = topbar,
	})
	window.TitleLabel = titleLabel

	local subLabel = New("TextLabel", {
		Text = window.SubTitle,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(
			(titleIcon and 48 or 16) + titleLabel.TextBounds.X + 8, 1
		),
		Size = UDim2.new(0, 160, 1, 0),
		Theme = { TextColor3 = "SubText" },
		Parent = topbar,
	})

	--// Window control buttons
	local function ControlButton(order, image, danger, callback)
		local button = New("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.fromOffset(28, 28),
			Position = UDim2.new(1, -14 - (order * 32), 0, 9),
			BackgroundTransparency = 0,
			Theme = { BackgroundColor3 = "Element" },
			Parent = topbar,
		})
		Corner(8, button)
		Stroke(button, "Stroke", 1, 0.45)
		local icon = New("ImageLabel", {
			Image = image,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(14, 14),
			Theme = { ImageColor3 = "SubText" },
			Parent = button,
		})
		button.MouseEnter:Connect(function()
			Tween(button, 0.15, { BackgroundColor3 = danger and Aurora.Theme.Danger or Aurora.Theme.ElementHover })
			Tween(icon, 0.15, { ImageColor3 = danger and Color3.fromRGB(255, 255, 255) or Aurora.Theme.Text })
		end)
		button.MouseLeave:Connect(function()
			Tween(button, 0.15, { BackgroundColor3 = Aurora.Theme.Element })
			Tween(icon, 0.15, { ImageColor3 = Aurora.Theme.SubText })
		end)
		button.MouseButton1Click:Connect(callback)
		return button
	end

	ControlButton(0, "rbxassetid://10747384394", true, function() window:Close() end)
	ControlButton(1, "rbxassetid://10734896206", false, function() window:Minimize() end)

	--// Sidebar
	local sidebar = New("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, config.SidebarWidth or 156, 1, -46),
		Position = UDim2.fromOffset(0, 46),
		BackgroundTransparency = 0,
		Theme = { BackgroundColor3 = "Sidebar" },
		Parent = main,
	})
	New("Frame", {
		Size = UDim2.new(0, 1, 1, 0),
		Position = UDim2.new(1, -1, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 0.45,
		Theme = { BackgroundColor3 = "Stroke" },
		Parent = sidebar,
	})

	local tabList = New("ScrollingFrame", {
		Name = "Tabs",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, -62),
		Position = UDim2.fromOffset(0, 8),
		ScrollBarThickness = 2,
		ScrollBarImageTransparency = 0.6,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = sidebar,
	})
	Bind(tabList, "ScrollBarImageColor3", "Stroke")
	Padding(tabList, 2, 8, 10, 10)
	List(tabList, 4)

	--// Bottom-left user panel  (avatar + username + settings gear)
	local userPanel = New("Frame", {
		Name = "UserPanel",
		Size = UDim2.new(1, -16, 0, 46),
		Position = UDim2.new(0, 8, 1, -54),
		BackgroundTransparency = 0,
		Theme = { BackgroundColor3 = "Element" },
		Parent = sidebar,
	})
	Corner(10, userPanel)
	Stroke(userPanel, "Stroke", 1, 0.5)
	window.UserPanel = userPanel

	local avatarHolder = New("Frame", {
		Size = UDim2.fromOffset(28, 28),
		Position = UDim2.fromOffset(8, 9),
		BackgroundTransparency = 0,
		Theme = { BackgroundColor3 = "Accent" },
		Parent = userPanel,
	})
	Corner(999, avatarHolder)

	local avatar = New("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Image = config.UserAvatar and Icon(config.UserAvatar) or "",
		Parent = avatarHolder,
	})
	Corner(999, avatar)

	if not config.UserAvatar and LocalPlayer then
		task.spawn(function()
			local ok, thumb = pcall(function()
				return Players:GetUserThumbnailAsync(
					LocalPlayer.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size100x100
				)
			end)
			if ok and thumb then avatar.Image = thumb end
		end)
	end

	local userName = New("TextLabel", {
		Text = config.Username or (LocalPlayer and LocalPlayer.DisplayName) or "Guest",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(44, 7),
		Size = UDim2.new(1, -78, 0, 14),
		Theme = { TextColor3 = "Text" },
		Parent = userPanel,
	})

	local userTag = New("TextLabel", {
		Text = config.UserTag or ("@" .. ((LocalPlayer and LocalPlayer.Name) or "player")),
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(44, 22),
		Size = UDim2.new(1, -78, 0, 13),
		Theme = { TextColor3 = "SubText" },
		Parent = userPanel,
	})

	local settingsButton = New("TextButton", {
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.fromOffset(26, 26),
		Position = UDim2.new(1, -32, 0, 10),
		BackgroundTransparency = 0,
		Theme = { BackgroundColor3 = "ElementHover" },
		Parent = userPanel,
	})
	Corner(8, settingsButton)
	local gear = New("ImageLabel", {
		Image = Icon(config.SettingsIcon or "rbxassetid://10734950309"),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(14, 14),
		Theme = { ImageColor3 = "SubText" },
		Parent = settingsButton,
	})
	settingsButton.MouseEnter:Connect(function()
		Tween(gear, 0.2, { ImageColor3 = Aurora.Theme.Accent, Rotation = 90 })
	end)
	settingsButton.MouseLeave:Connect(function()
		Tween(gear, 0.2, { ImageColor3 = Aurora.Theme.SubText, Rotation = 0 })
	end)

	--// Content container
	local container = New("Frame", {
		Name = "Container",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset((config.SidebarWidth or 156), 46),
		Size = UDim2.new(1, -(config.SidebarWidth or 156), 1, -46),
		ClipsDescendants = true,
		Parent = main,
	})
	window.Container = container

	----------------------------------------------------------------
	-- WINDOW METHODS
	----------------------------------------------------------------
	function window:SetTitle(text, subtitle)
		titleLabel.Text = text or titleLabel.Text
		if subtitle then subLabel.Text = subtitle end
		subLabel.Position = UDim2.fromOffset((titleIcon and 48 or 16) + titleLabel.TextBounds.X + 8, 1)
	end

	function window:SetIcon(id)
		if titleIcon then titleIcon.Image = Icon(id) end
	end

	function window:SetUser(name, tag, avatarId)
		if name then userName.Text = name end
		if tag then userTag.Text = tag end
		if avatarId then avatar.Image = Icon(avatarId) end
	end

	function window:SetScale(scale)
		Tween(scaler, 0.2, { Scale = scale })
	end

	--// Minimized bubble (single customizable icon)
	local bubble = New("ImageButton", {
		Name = "MinimizeBubble",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = config.MinimizePosition or UDim2.new(0, 70, 0.5, 0),
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 0,
		AutoButtonColor = false,
		Image = "",
		Visible = false,
		Theme = { BackgroundColor3 = "Sidebar" },
		Parent = screen,
	})
	Corner(999, bubble)
	Stroke(bubble, "Accent", 1.5, 0.25)
	local bubbleWasDragged = Draggable(bubble)

	local bubbleIcon = New("ImageLabel", {
		Image = window.MinimizeIcon,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(24, 24),
		Theme = { ImageColor3 = "Accent" },
		Parent = bubble,
	})
	window.Bubble = bubble

	function window:SetMinimizeIcon(id)
		window.MinimizeIcon = Icon(id)
		bubbleIcon.Image = window.MinimizeIcon
	end

	function window:Minimize()
		if window.Minimized then return window:Restore() end
		window.Minimized = true
		Tween(main, 0.25, { Size = UDim2.fromOffset(window.Size.X.Offset * 0.6, 0) }, Enum.EasingStyle.Quad)
		task.delay(0.22, function()
			main.Visible = false
			bubble.Visible = true
			bubble.Size = UDim2.fromOffset(0, 0)
			Tween(bubble, 0.35, { Size = UDim2.fromOffset(52, 52) }, Enum.EasingStyle.Back)
		end)
		if config.OnMinimize then task.spawn(config.OnMinimize, true) end
	end

	function window:Restore()
		window.Minimized = false
		Tween(bubble, 0.2, { Size = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Quad)
		task.delay(0.18, function()
			bubble.Visible = false
			main.Visible = true
			main.Size = UDim2.fromOffset(window.Size.X.Offset * 0.6, 0)
			Tween(main, 0.35, { Size = window.Size }, Enum.EasingStyle.Back)
		end)
		if config.OnMinimize then task.spawn(config.OnMinimize, false) end
	end

	-- only restore on a real click, so dragging the bubble doesn't reopen it
	bubble.MouseButton1Click:Connect(function()
		if bubbleWasDragged() then return end
		window:Restore()
	end)

	function window:Close()
		Tween(main, 0.22, { Size = UDim2.fromOffset(window.Size.X.Offset, 0) }, Enum.EasingStyle.Quad)
		task.delay(0.25, function()
			if config.OnClose then task.spawn(config.OnClose) end
			if config.DestroyOnClose == false then
				main.Visible = false
				main.Size = window.Size
			else
				window:Destroy()
			end
		end)
	end

	function window:Destroy()
		window.Destroyed = true
		screen:Destroy()
		for index, win in ipairs(Aurora.Windows) do
			if win == window then table.remove(Aurora.Windows, index) end
		end
	end

	function window:Toggle()
		if window.Minimized then window:Restore() else window:Minimize() end
	end

	Connect(UserInputService.InputBegan, function(input, processed)
		if processed or window.Destroyed then return end
		if input.KeyCode == window.ToggleKey then
			window:Toggle()
		end
	end)

	--// Open animation
	main.Size = UDim2.fromOffset(window.Size.X.Offset, 0)
	Tween(main, 0.45, { Size = window.Size }, Enum.EasingStyle.Back)

	----------------------------------------------------------------
	-- TABS
	----------------------------------------------------------------
	function window:CreateTab(tabConfig)
		tabConfig = tabConfig or {}
		local tab = {
			Title    = tabConfig.Title or tabConfig.Name or "Tab",
			Color    = tabConfig.Color,
			Locked   = tabConfig.Locked or false,
			Elements = {},
		}

		local button = New("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 1,
			LayoutOrder = tabConfig.Order or (#window.Tabs + 1),
			Theme = { BackgroundColor3 = "Element" },
			Parent = tabList,
		})
		Corner(9, button)
		tab.Button = button

		local indicator = New("Frame", {
			Size = UDim2.fromOffset(3, 0),
			Position = UDim2.fromOffset(0, 17),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 0,
			Parent = button,
		})
		Corner(999, indicator)
		if tab.Color then
			indicator.BackgroundColor3 = tab.Color
		else
			Bind(indicator, "BackgroundColor3", "Accent")
		end

		local tabIcon
		if tabConfig.Icon then
			tabIcon = New("ImageLabel", {
				Image = Icon(tabConfig.Icon),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(11, 9),
				Size = UDim2.fromOffset(16, 16),
				ImageTransparency = 0.15,
				Theme = { ImageColor3 = "SubText" },
				Parent = button,
			})
		end

		local label = New("TextLabel", {
			Text = tab.Title,
			Font = Enum.Font.GothamMedium,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(tabIcon and 36 or 14, 0),
			Size = UDim2.new(1, tabIcon and -44 or -22, 1, 0),
			Theme = { TextColor3 = "SubText" },
			Parent = button,
		})

		--// Page
		local page = New("ScrollingFrame", {
			Name = tab.Title,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Visible = false,
			ScrollBarThickness = 3,
			ScrollBarImageTransparency = 0.55,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Parent = container,
		})
		Bind(page, "ScrollBarImageColor3", "Stroke")
		Padding(page, 14, 18, 14, 14)
		List(page, 8)
		tab.Page = page

		function tab:Select()
			if tab.Locked then return end
			for _, other in ipairs(window.Tabs) do
				if other ~= tab then
					other.Page.Visible = false
					Tween(other.Button, 0.18, { BackgroundTransparency = 1 })
					Tween(other.Label, 0.18, { TextColor3 = Aurora.Theme.SubText })
					Tween(other.Indicator, 0.18, { Size = UDim2.fromOffset(3, 0) })
					if other.Icon then Tween(other.Icon, 0.18, { ImageColor3 = Aurora.Theme.SubText }) end
				end
			end
			window.CurrentTab = tab
			page.Visible = true
			page.CanvasPosition = Vector2.new(0, 0)
			Tween(button, 0.18, { BackgroundTransparency = 0 })
			Tween(label, 0.18, { TextColor3 = Aurora.Theme.Text })
			Tween(indicator, 0.25, { Size = UDim2.fromOffset(3, 16) }, Enum.EasingStyle.Back)
			if tabIcon then Tween(tabIcon, 0.18, { ImageColor3 = tab.Color or Aurora.Theme.Accent }) end
			if tabConfig.Callback then task.spawn(tabConfig.Callback) end
		end

		tab.Label = label
		tab.Indicator = indicator
		tab.Icon = tabIcon

		button.MouseEnter:Connect(function()
			if window.CurrentTab ~= tab then
				Tween(button, 0.15, { BackgroundTransparency = 0.55 })
				Tween(label, 0.15, { TextColor3 = Aurora.Theme.Text })
			end
		end)
		button.MouseLeave:Connect(function()
			if window.CurrentTab ~= tab then
				Tween(button, 0.15, { BackgroundTransparency = 1 })
				Tween(label, 0.15, { TextColor3 = Aurora.Theme.SubText })
			end
		end)
		button.MouseButton1Click:Connect(function() tab:Select() end)

		function tab:SetTitle(text) label.Text = text; tab.Title = text end
		function tab:SetIcon(id) if tabIcon then tabIcon.Image = Icon(id) end end
		function tab:SetLocked(state) tab.Locked = state; label.TextTransparency = state and 0.5 or 0 end

		------------------------------------------------------------
		-- ELEMENT BASE
		------------------------------------------------------------
		local function Base(height, interactive)
			local frame = New("Frame", {
				Size = UDim2.new(1, 0, 0, height or 44),
				BackgroundTransparency = 0,
				Theme = { BackgroundColor3 = "Element" },
				Parent = page,
			})
			Corner(10, frame)
			Stroke(frame, "Stroke", 1, 0.55)
			if interactive then Hoverable(frame, "Element", "ElementHover") end
			table.insert(tab.Elements, frame)
			return frame
		end

		local function Labels(parent, title, description, rightPad, rowHeight)
			local fullHeight = rowHeight and UDim2.new(1, -(rightPad or 60), 0, rowHeight)
				or UDim2.new(1, -(rightPad or 60), 1, 0)
			local titleLabel = New("TextLabel", {
				Text = title or "",
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(14, description and 8 or 0),
				Size = description and UDim2.new(1, -(rightPad or 60), 0, 15) or fullHeight,
				Theme = { TextColor3 = "Text" },
				Parent = parent,
			})
			local descLabel
			if description then
				descLabel = New("TextLabel", {
					Text = description,
					Font = Enum.Font.Gotham,
					TextSize = 11.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(14, 24),
					Size = UDim2.new(1, -(rightPad or 60), 0, 14),
					Theme = { TextColor3 = "SubText" },
					Parent = parent,
				})
			end
			return titleLabel, descLabel
		end

		------------------------------------------------------------
		-- SECTION
		------------------------------------------------------------
		function tab:CreateSection(text)
			local holder = New("Frame", {
				Size = UDim2.new(1, 0, 0, 26),
				BackgroundTransparency = 1,
				Parent = page,
			})
			local label = New("TextLabel", {
				Text = string.upper(typeof(text) == "table" and (text.Title or "Section") or text or "Section"),
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(4, 8),
				Size = UDim2.new(1, -8, 0, 14),
				Theme = { TextColor3 = "SubText" },
				Parent = holder,
			})
			return {
				Set = function(_, newText) label.Text = string.upper(newText) end,
				Instance = holder,
			}
		end

		function tab:CreateDivider()
			local holder = New("Frame", {
				Size = UDim2.new(1, 0, 0, 9),
				BackgroundTransparency = 1,
				Parent = page,
			})
			local line = New("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.fromOffset(0, 4),
				BorderSizePixel = 0,
				BackgroundTransparency = 0.5,
				Theme = { BackgroundColor3 = "Stroke" },
				Parent = holder,
			})
			return { Instance = holder }
		end

		------------------------------------------------------------
		-- PARAGRAPH / INFO
		------------------------------------------------------------
		function tab:CreateParagraph(cfg)
			cfg = cfg or {}
			local frame = Base(56, false)
			frame.AutomaticSize = Enum.AutomaticSize.Y

			local accentBar = New("Frame", {
				Size = UDim2.new(0, 3, 1, -20),
				Position = UDim2.fromOffset(0, 10),
				BackgroundTransparency = 0,
				Theme = { BackgroundColor3 = "Accent" },
				Parent = frame,
			})
			Corner(999, accentBar)

			local title = New("TextLabel", {
				Text = cfg.Title or "Information",
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(16, 12),
				Size = UDim2.new(1, -30, 0, 15),
				Theme = { TextColor3 = "Text" },
				Parent = frame,
			})

			local content = New("TextLabel", {
				Text = cfg.Content or cfg.Text or "",
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = true,
				RichText = cfg.RichText ~= false,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.fromOffset(16, 31),
				Size = UDim2.new(1, -30, 0, 0),
				Theme = { TextColor3 = "SubText" },
				Parent = frame,
			})
			Padding(frame, 0, 12, 0, 0)

			local object = { Instance = frame }
			function object:SetTitle(text) title.Text = text end
			function object:SetContent(text) content.Text = text end
			function object:Destroy() frame:Destroy() end
			return object
		end
		tab.CreateInfo = tab.CreateParagraph

		------------------------------------------------------------
		-- BUTTON
		------------------------------------------------------------
		function tab:CreateButton(cfg)
			cfg = cfg or {}
			local frame = Base(cfg.Description and 52 or 40, true)
			local button = New("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				AutoButtonColor = false,
				Parent = frame,
			})
			Ripple(button)
			local buttonTitle = Labels(frame, cfg.Title or "Button", cfg.Description, 54)

			local arrow = New("ImageLabel", {
				Image = "rbxassetid://10709791437",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -14, 0.5, 0),
				Size = UDim2.fromOffset(15, 15),
				Theme = { ImageColor3 = "SubText" },
				Parent = frame,
			})

			button.MouseEnter:Connect(function()
				Tween(arrow, 0.18, { ImageColor3 = Aurora.Theme.Accent, Position = UDim2.new(1, -10, 0.5, 0) })
			end)
			button.MouseLeave:Connect(function()
				Tween(arrow, 0.18, { ImageColor3 = Aurora.Theme.SubText, Position = UDim2.new(1, -14, 0.5, 0) })
			end)
			button.MouseButton1Click:Connect(function()
				if cfg.Callback then task.spawn(cfg.Callback) end
			end)

			local object = { Instance = frame }
			function object:SetTitle(text) buttonTitle.Text = text end
			function object:Destroy() frame:Destroy() end
			return object
		end

		------------------------------------------------------------
		-- TOGGLE
		------------------------------------------------------------
		function tab:CreateToggle(cfg)
			cfg = cfg or {}
			local state = cfg.Default or false
			local frame = Base(cfg.Description and 52 or 42, true)

			local button = New("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				AutoButtonColor = false,
				Parent = frame,
			})
			Labels(frame, cfg.Title or "Toggle", cfg.Description, 66)

			local track = New("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -14, 0.5, 0),
				Size = UDim2.fromOffset(40, 22),
				BackgroundTransparency = 0,
				Theme = { BackgroundColor3 = "Stroke" },
				Parent = frame,
			})
			Corner(999, track)

			local knob = New("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 3, 0.5, 0),
				Size = UDim2.fromOffset(16, 16),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Parent = track,
			})
			Corner(999, knob)

			local object = { Instance = frame, Value = state, Type = "Toggle" }

			function object:Set(value, silent)
				state = value and true or false
				object.Value = state
				Tween(track, 0.2, { BackgroundColor3 = state and Aurora.Theme.Accent or Aurora.Theme.Stroke })
				Tween(knob, 0.24, { Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }, Enum.EasingStyle.Back)
				if cfg.Flag then Aurora.Flags[cfg.Flag] = state end
				if not silent and cfg.Callback then task.spawn(cfg.Callback, state) end
			end

			function object:Destroy() frame:Destroy() end

			button.MouseButton1Click:Connect(function() object:Set(not state) end)

			if cfg.Flag then
				Aurora.Flags[cfg.Flag] = state
				Aurora.Options[cfg.Flag] = object
			end
			object:Set(state, true)
			return object
		end

		------------------------------------------------------------
		-- SLIDER
		------------------------------------------------------------
		function tab:CreateSlider(cfg)
			cfg = cfg or {}
			local min       = cfg.Min or cfg.Minimum or 0
			local max       = cfg.Max or cfg.Maximum or 100
			local increment = cfg.Increment or cfg.Step or 1
			local value     = math.clamp(cfg.Default or min, min, max)
			local suffix    = cfg.Suffix or ""

			local frame = Base(cfg.Description and 68 or 56, false)

			New("TextLabel", {
				Text = cfg.Title or "Slider",
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(14, 9),
				Size = UDim2.new(1, -90, 0, 15),
				Theme = { TextColor3 = "Text" },
				Parent = frame,
			})

			if cfg.Description then
				New("TextLabel", {
					Text = cfg.Description,
					Font = Enum.Font.Gotham,
					TextSize = 11.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(14, 25),
					Size = UDim2.new(1, -90, 0, 13),
					Theme = { TextColor3 = "SubText" },
					Parent = frame,
				})
			end

			local valueBox = New("TextLabel", {
				Text = tostring(value) .. suffix,
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -14, 0, 8),
				Size = UDim2.fromOffset(64, 18),
				BackgroundTransparency = 0,
				Theme = { TextColor3 = "Accent", BackgroundColor3 = "ElementHover" },
				Parent = frame,
			})
			Corner(6, valueBox)

			local barY = cfg.Description and 50 or 38
			local track = New("Frame", {
				Position = UDim2.fromOffset(14, barY),
				Size = UDim2.new(1, -28, 0, 6),
				BackgroundTransparency = 0,
				Theme = { BackgroundColor3 = "Stroke" },
				Parent = frame,
			})
			Corner(999, track)

			local fill = New("Frame", {
				Size = UDim2.fromScale((value - min) / (max - min), 1),
				BackgroundTransparency = 0,
				Theme = { BackgroundColor3 = "Accent" },
				Parent = track,
			})
			Corner(999, fill)
			New("UIGradient", {
				Color = ColorSequence.new(Aurora.Theme.Accent, Aurora.Theme.AccentSoft),
				Parent = fill,
			})

			local knob = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 3,
				Parent = track,
			})
			Corner(999, knob)
			Stroke(knob, "Accent", 2, 0)

			local object = { Instance = frame, Value = value, Type = "Slider" }

			local function Round(input)
				local rounded = math.floor((input - min) / increment + 0.5) * increment + min
				return math.clamp(tonumber(string.format("%.4f", rounded)), min, max)
			end

			function object:Set(newValue, silent)
				value = Round(newValue)
				object.Value = value
				local alpha = (value - min) / (max - min)
				Tween(fill, 0.12, { Size = UDim2.fromScale(alpha, 1) }, Enum.EasingStyle.Linear)
				Tween(knob, 0.12, { Position = UDim2.new(alpha, 0, 0.5, 0) }, Enum.EasingStyle.Linear)
				valueBox.Text = tostring(value) .. suffix
				if cfg.Flag then Aurora.Flags[cfg.Flag] = value end
				if not silent and cfg.Callback then task.spawn(cfg.Callback, value) end
			end

			function object:Destroy()
				DisconnectAll(object.Connections)
				frame:Destroy()
			end

			local dragging = false
			local function UpdateFromInput(input)
				local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
				object:Set(min + (max - min) * alpha)
			end

			local hitbox = New("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, -8),
				Size = UDim2.new(1, 0, 1, 16),
				Parent = track,
			})

			local connections = {}
			table.insert(connections, hitbox.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					Tween(knob, 0.15, { Size = UDim2.fromOffset(18, 18) })
					UpdateFromInput(input)
				end
			end))
			table.insert(connections, UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch then
					if dragging then Tween(knob, 0.15, { Size = UDim2.fromOffset(14, 14) }) end
					dragging = false
				end
			end))
			table.insert(connections, UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch) then
					UpdateFromInput(input)
				end
			end))
			for _, connection in ipairs(connections) do
				table.insert(Aurora.Connections, connection)
			end
			object.Connections = connections

			if cfg.Flag then
				Aurora.Flags[cfg.Flag] = value
				Aurora.Options[cfg.Flag] = object
			end
			return object
		end

		------------------------------------------------------------
		-- DROPDOWN  (single + multi select)
		------------------------------------------------------------
		function tab:CreateDropdown(cfg)
			cfg = cfg or {}
			local values   = cfg.Values or cfg.Options or {}
			local multi    = cfg.Multi or cfg.MultiSelect or false
			local selected = multi and (cfg.Default or {}) or (cfg.Default or nil)
			local open     = false
			local rowHeight = cfg.Description and 52 or 42

			local frame = Base(rowHeight, false)
			frame.ClipsDescendants = true

			local header = New("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, rowHeight),
				AutoButtonColor = false,
				Parent = frame,
			})
			Labels(frame, cfg.Title or "Dropdown", cfg.Description, 150, rowHeight)

			local preview = New("TextLabel", {
				Text = "None",
				Font = Enum.Font.GothamMedium,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -34, 0, rowHeight / 2),
				Size = UDim2.fromOffset(120, 18),
				BackgroundTransparency = 1,
				Theme = { TextColor3 = "SubText" },
				Parent = frame,
			})

			local chevron = New("ImageLabel", {
				Image = "rbxassetid://10709790948",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -13, 0, rowHeight / 2),
				Size = UDim2.fromOffset(16, 16),
				Theme = { ImageColor3 = "SubText" },
				Parent = frame,
			})

			local listHolder = New("ScrollingFrame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(8, rowHeight),
				Size = UDim2.new(1, -16, 0, 0),
				ScrollBarThickness = 2,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Parent = frame,
			})
			Bind(listHolder, "ScrollBarImageColor3", "Stroke")
			List(listHolder, 4)
			Padding(listHolder, 2, 8, 0, 0)

			local object = { Instance = frame, Value = selected, Type = "Dropdown" }
			local optionButtons = {}

			local function IsSelected(value)
				if multi then
					for _, item in ipairs(selected or {}) do
						if item == value then return true end
					end
					return false
				end
				return selected == value
			end

			local function UpdatePreview()
				if multi then
					local count = #(selected or {})
					preview.Text = count == 0 and "None"
						or (count <= 2 and table.concat(selected, ", ") or (count .. " selected"))
				else
					preview.Text = selected ~= nil and tostring(selected) or "None"
				end
			end

			local function Refresh()
				for value, row in pairs(optionButtons) do
					local active = IsSelected(value)
					Tween(row.Frame, 0.15, {
						BackgroundTransparency = active and 0 or 1,
						BackgroundColor3 = Aurora.Theme.Accent,
					})
					Tween(row.Label, 0.15, {
						TextColor3 = active and Color3.fromRGB(255, 255, 255) or Aurora.Theme.SubText,
					})
					row.Tick.ImageTransparency = active and 0 or 1
				end
				UpdatePreview()
			end

			local function SetOpen(state)
				open = state
				local height = math.min(#values * 30 + 10, cfg.MaxHeight or 132)
				Tween(frame, 0.25, { Size = UDim2.new(1, 0, 0, state and (rowHeight + height) or rowHeight) })
				Tween(listHolder, 0.25, { Size = UDim2.new(1, -16, 0, state and (height - 6) or 0) })
				Tween(chevron, 0.25, { Rotation = state and 180 or 0 })
			end

			local function BuildOptions()
				for _, child in ipairs(listHolder:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				optionButtons = {}
				for index, value in ipairs(values) do
					local row = New("TextButton", {
						Text = "",
						AutoButtonColor = false,
						Size = UDim2.new(1, 0, 0, 26),
						BackgroundTransparency = 1,
						LayoutOrder = index,
						Parent = listHolder,
					})
					Corner(7, row)
					local rowLabel = New("TextLabel", {
						Text = tostring(value),
						Font = Enum.Font.Gotham,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(10, 0),
						Size = UDim2.new(1, -34, 1, 0),
						Theme = { TextColor3 = "SubText" },
						Parent = row,
					})
					local tick = New("ImageLabel", {
						Image = "rbxassetid://10709790644",
						BackgroundTransparency = 1,
						ImageTransparency = 1,
						ImageColor3 = Color3.fromRGB(255, 255, 255),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -8, 0.5, 0),
						Size = UDim2.fromOffset(14, 14),
						Parent = row,
					})
					optionButtons[value] = { Frame = row, Label = rowLabel, Tick = tick }

					row.MouseButton1Click:Connect(function()
						if multi then
							selected = selected or {}
							local removed = false
							for i, item in ipairs(selected) do
								if item == value then
									table.remove(selected, i)
									removed = true
									break
								end
							end
							if not removed then table.insert(selected, value) end
						else
							selected = value
							SetOpen(false)
						end
						object.Value = selected
						if cfg.Flag then Aurora.Flags[cfg.Flag] = selected end
						Refresh()
						if cfg.Callback then task.spawn(cfg.Callback, selected) end
					end)
				end
				Refresh()
			end

			header.MouseButton1Click:Connect(function() SetOpen(not open) end)

			function object:Set(value, silent)
				selected = value
				object.Value = value
				if cfg.Flag then Aurora.Flags[cfg.Flag] = value end
				Refresh()
				if not silent and cfg.Callback then task.spawn(cfg.Callback, value) end
			end

			function object:Refresh(newValues)
				values = newValues or values
				if multi then
					local filtered = {}
					for _, item in ipairs(selected or {}) do
						for _, value in ipairs(values) do
							if item == value then table.insert(filtered, item) end
						end
					end
					selected = filtered
				elseif selected ~= nil then
					local found = false
					for _, value in ipairs(values) do
						if value == selected then found = true end
					end
					if not found then selected = nil end
				end
				object.Value = selected
				BuildOptions()
			end

			function object:Destroy() frame:Destroy() end

			BuildOptions()
			if cfg.Flag then
				Aurora.Flags[cfg.Flag] = selected
				Aurora.Options[cfg.Flag] = object
			end
			return object
		end

		------------------------------------------------------------
		-- INPUT
		------------------------------------------------------------
		function tab:CreateInput(cfg)
			cfg = cfg or {}
			local frame = Base(cfg.Description and 52 or 42, false)
			Labels(frame, cfg.Title or "Input", cfg.Description, 150)

			local box = New("TextBox", {
				Text = cfg.Default or "",
				PlaceholderText = cfg.Placeholder or "Type here...",
				Font = Enum.Font.Gotham,
				TextSize = 12,
				ClearTextOnFocus = cfg.ClearOnFocus or false,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, 0),
				Size = UDim2.fromOffset(cfg.Width or 130, 26),
				BackgroundTransparency = 0,
				Theme = { TextColor3 = "Text", BackgroundColor3 = "ElementHover", PlaceholderColor3 = "SubText" },
				Parent = frame,
			})
			Corner(7, box)
			Stroke(box, "Stroke", 1, 0.4)
			Padding(box, 0, 0, 8, 8)

			local object = { Instance = frame, Value = box.Text, Type = "Input" }
			box.FocusLost:Connect(function(enter)
				object.Value = box.Text
				if cfg.Flag then Aurora.Flags[cfg.Flag] = box.Text end
				if cfg.Callback then task.spawn(cfg.Callback, box.Text, enter) end
			end)
			function object:Set(text) box.Text = text; object.Value = text end
			function object:Destroy() frame:Destroy() end
			if cfg.Flag then Aurora.Options[cfg.Flag] = object end
			return object
		end

		------------------------------------------------------------
		-- KEYBIND
		------------------------------------------------------------
		function tab:CreateKeybind(cfg)
			cfg = cfg or {}
			local key = cfg.Default or Enum.KeyCode.E
			local listening = false
			local frame = Base(cfg.Description and 52 or 42, false)
			Labels(frame, cfg.Title or "Keybind", cfg.Description, 110)

			local button = New("TextButton", {
				Text = key.Name,
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				AutoButtonColor = false,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, 0),
				Size = UDim2.fromOffset(80, 26),
				BackgroundTransparency = 0,
				Theme = { TextColor3 = "Text", BackgroundColor3 = "ElementHover" },
				Parent = frame,
			})
			Corner(7, button)
			Stroke(button, "Stroke", 1, 0.4)

			local object = { Instance = frame, Value = key, Type = "Keybind" }

			button.MouseButton1Click:Connect(function()
				listening = true
				button.Text = "..."
			end)

			local keyConnection = Connect(UserInputService.InputBegan, function(input, processed)
				if listening and input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode == Enum.KeyCode.Escape then
						listening = false
						button.Text = key.Name
						return
					end
					key = input.KeyCode
					object.Value = key
					button.Text = key.Name
					listening = false
					if cfg.Flag then Aurora.Flags[cfg.Flag] = key end
					if cfg.Changed then task.spawn(cfg.Changed, key) end
					return
				end
				if not processed and not listening and input.KeyCode == key then
					if cfg.Callback then task.spawn(cfg.Callback, key) end
				end
			end)

			function object:Set(newKey) key = newKey; button.Text = newKey.Name end
			function object:Destroy()
				keyConnection:Disconnect()
				frame:Destroy()
			end
			if cfg.Flag then Aurora.Options[cfg.Flag] = object end
			return object
		end

		--// Aliases (WindUI / Rayfield style)
		tab.Button    = tab.CreateButton
		tab.Toggle    = tab.CreateToggle
		tab.Slider    = tab.CreateSlider
		tab.Dropdown  = tab.CreateDropdown
		tab.Input     = tab.CreateInput
		tab.Keybind   = tab.CreateKeybind
		tab.Paragraph = tab.CreateParagraph
		tab.Section   = tab.CreateSection
		tab.Divider   = tab.CreateDivider

		table.insert(window.Tabs, tab)
		if #window.Tabs == 1 then tab:Select() end
		return tab
	end

	----------------------------------------------------------------
	-- BUILT-IN SETTINGS TAB (opened by the gear in the user panel)
	----------------------------------------------------------------
	local settingsTab
	function window:OpenSettings()
		if config.OnSettings then
			task.spawn(config.OnSettings)
			if config.OverrideSettings then return end
		end
		if settingsTab then
			settingsTab:Select()
			return settingsTab
		end
		settingsTab = window:CreateTab({ Title = "Settings", Icon = "rbxassetid://10734950309", Order = 999 })
		settingsTab:CreateSection("Interface")

		local themeNames = {}
		for name in pairs(Aurora.Themes) do table.insert(themeNames, name) end
		table.sort(themeNames)

		settingsTab:CreateDropdown({
			Title = "Theme",
			Description = "Change the color palette of the interface",
			Values = themeNames,
			Default = Aurora.ThemeName,
			Callback = function(value) Aurora:SetTheme(value) end,
		})

		settingsTab:CreateSlider({
			Title = "Interface Scale",
			Min = 70, Max = 130, Default = 100, Suffix = "%",
			Callback = function(value) window:SetScale(value / 100) end,
		})

		settingsTab:CreateKeybind({
			Title = "Minimize Key",
			Default = window.ToggleKey,
			Changed = function(key) window.ToggleKey = key end,
		})

		settingsTab:CreateSection("Library")
		settingsTab:CreateParagraph({
			Title = "Aurora UI v" .. Aurora.Version,
			Content = "Lightweight interface library. Thanks for using it!",
		})
		settingsTab:CreateButton({
			Title = "Unload Interface",
			Description = "Destroys every Aurora window in this session",
			Callback = function() Aurora:Unload() end,
		})
		settingsTab:Select()
		return settingsTab
	end

	settingsButton.MouseButton1Click:Connect(function() window:OpenSettings() end)

	function window:Notify(cfg) return Aurora:Notify(cfg) end
	function window:SelectTab(index)
		local tab = window.Tabs[index]
		if tab then tab:Select() end
	end

	--// Aliases
	window.Tab      = window.CreateTab
	window.AddTab   = window.CreateTab
	window.Hide     = window.Minimize
	window.Show     = window.Restore

	table.insert(Aurora.Windows, window)
	return window
end

----------------------------------------------------------------------
-- GLOBAL HELPERS
----------------------------------------------------------------------
function Aurora:Unload()
	for _, window in ipairs(table.clone(Aurora.Windows)) do
		pcall(function() window:Destroy() end)
	end
	if NotifyHolder and NotifyHolder.Parent then
		NotifyHolder.Parent:Destroy()
		NotifyHolder = nil
	end
	DisconnectAll(Aurora.Connections)
	table.clear(Aurora.Windows)
	table.clear(ThemeBindings)
	table.clear(Aurora.Options)
	ActiveDrag = nil
	Aurora.Unloaded = true
end

function Aurora:GetFlag(flag, fallback)
	local value = Aurora.Flags[flag]
	if value == nil then return fallback end
	return value
end

function Aurora:SaveConfig()
	return HttpService:JSONEncode(Aurora.Flags)
end

function Aurora:LoadConfig(json)
	local ok, decoded = pcall(function() return HttpService:JSONDecode(json) end)
	if not ok then return false end
	for flag, value in pairs(decoded) do
		local option = Aurora.Options[flag]
		if option and option.Set then pcall(option.Set, option, value) end
	end
	return true
end

return Aurora
