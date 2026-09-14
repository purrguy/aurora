# Aurora UI

Lightweight Roblox Luau UI library (single file). Tabs, toggles, sliders, dropdowns, keybinds, themes, notifications, minimize-to-icon.

## Load

```lua
local Aurora = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/mixask/aurora/refs/heads/main/aurora.lua"
))()
```

## Minimal example

```lua
local Aurora = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/mixask/aurora/refs/heads/main/aurora.lua"
))()

local Window = Aurora:CreateWindow({
	Title = "My Hub",
	SubTitle = "v1",
	Theme = "Midnight",
	ToggleKey = Enum.KeyCode.RightShift,
})

local Main = Window:CreateTab({ Title = "Main", Icon = "home" })

Main:CreateToggle({
	Title = "Enabled",
	Default = false,
	Flag = "Enabled",
	Callback = function(v)
		print(v)
	end,
})

Main:CreateSlider({
	Title = "Speed",
	Min = 16,
	Max = 100,
	Default = 16,
	Callback = function(v)
		print(v)
	end,
})

Aurora:Notify({ Title = "Ready", Content = "Aurora loaded", Duration = 3 })
```

## Elements

| UI | Code |
| --- | --- |
| Tab | `Window:CreateTab({ Title, Icon, Order, Color, Locked, Hidden })` |
| Section | `Tab:CreateSection("Title")` |
| Divider | `Tab:CreateDivider()` |
| Paragraph | `Tab:CreateParagraph({ Title, Content })` |
| Button | `Tab:CreateButton({ Title, Description, Callback })` |
| Toggle | `Tab:CreateToggle({ Title, Default, Flag, Callback })` |
| Slider | `Tab:CreateSlider({ Title, Min, Max, Default, Suffix, Flag, Callback })` |
| Dropdown | `Tab:CreateDropdown({ Title, Values, Default, Multi, Flag, Callback })` |
| Input | `Tab:CreateInput({ Title, Default, Placeholder, Flag, Callback })` |
| Keybind | `Tab:CreateKeybind({ Title, Default, Flag, Callback, Changed })` |
| Notify | `Aurora:Notify({ Title, Content, Icon, Duration })` |

Aliases: `Tab:Button`, `Tab:Toggle`, `Tab:Slider`, `Tab:Dropdown`, `Tab:Input`, `Tab:Keybind`.

### Hidden tabs

```lua
-- Not shown in the sidebar (e.g. Settings via gear)
Window:CreateTab({ Title = "Settings", Icon = "settings", Hidden = true })
```

Built-in **Settings** (theme, scale, minimize key) opens only from the user-panel gear and uses `Hidden = true`.

## Icons

Supported forms:

```lua
Icon = "home"                    -- built-in alias or Lucide name
Icon = "lucide:settings"         -- Lucide pack
Icon = "rbxassetid://123456789"  -- your asset
Icon = 123456789                 -- numeric asset id
```

### Lucide (auto)

Aurora loads the **Lucide** set from [Footagesus/Icons](https://github.com/Footagesus/Icons) (`lucide/dist/Icons.lua`) on first use. Names match [lucide.dev](https://lucide.dev/icons/) (e.g. `home`, `settings`, `sword`, `zap`).

Browse icons: https://lucide.dev/icons  

Roblox asset pack source: https://github.com/Footagesus/Icons/tree/main/lucide  

Optional helpers:

```lua
Aurora.EnsureLucide()
Aurora.ApplyIcon(imageLabel, "settings")
```

### Custom icon

Upload a decal / image on Roblox, then:

```lua
Window:CreateTab({ Title = "Farm", Icon = "rbxassetid://YOUR_ID" })
```

## Themes

```lua
Aurora:SetTheme("Midnight") -- Aurora | Midnight | Rose | Emerald | Daylight
Aurora:SetAccent(Color3.fromRGB(232, 195, 106))
```

## Flags / config

```lua
local on = Aurora:GetFlag("Enabled", false)
local json = Aurora:SaveConfig()
Aurora:LoadConfig(json)
```

## Window API

```lua
Window:Minimize()
Window:Restore()
Window:Toggle()      -- ToggleKey (default RightShift)
Window:Close()
Window:Destroy()
Window:SetTitle("Title", "Subtitle")
Window:SetScale(1)
Window:OpenSettings() -- hidden settings page
Window:SelectTab(1)
Aurora:Unload()
```

## Window config

| Option | Meaning |
| --- | --- |
| `Title`, `SubTitle` | Header text |
| `Icon` | Title icon |
| `Size` | `UDim2` (default ~680×460) |
| `Theme`, `Accent` | Colors |
| `ToggleKey` | Minimize / restore key |
| `MinimizeIcon`, `MinimizePosition` | Floating bubble |
| `Username`, `UserTag`, `UserAvatar` | User panel |
| `SidebarWidth` | Sidebar width |
| `DestroyOnClose` | Destroy UI on close |
| `OnSettings`, `OnMinimize`, `OnClose` | Callbacks |

## Notes

- Parent order: `syn.protect_gui` → `gethui()` → `CoreGui` → `PlayerGui`
- Keybind rebind shows `...` until a key is pressed; **Escape** cancels
- No extra dependencies beyond optional Lucide HTTP load

## Themes (v1.0.5+)

```lua
Aurora:SetTheme("Mono")   -- black & white
Aurora:SetTheme("Gold")   -- black-gold
Aurora:SetTheme("Navy")   -- dark blue
Aurora:SetTheme("Uzi")    -- random images on UI chrome
-- also: Aurora, Midnight, Rose, Emerald, Daylight
```

### Uzi images

Default asset ids can be replaced:

```lua
Aurora:SetUziImages({
	17241967074,
	7951058019,
	12704861818,
	9457982962,
	13735942638,
})
Aurora:SetTheme("Uzi")
```

### Per-element color & image

Any element config accepts:

| Field | Effect |
| --- | --- |
| `Color` | Solid background `Color3` |
| `Image` / `BackgroundImage` | `rbxassetid://...` behind the card |
| `ImageTransparency` | 0–1 (default ~0.4–0.55) |
| `Uzi` | force / disable random Uzi image on this element |

```lua
Main:CreateButton({
	Title = "Farm",
	Color = Color3.fromRGB(40, 20, 10),
	Image = "rbxassetid://17241967074",
	ImageTransparency = 0.5,
	Callback = function() end,
})

Window:CreateTab({
	Title = "Combat",
	Icon = "sword",
	Color = Color3.fromRGB(30, 10, 10),
	Image = "rbxassetid://9457982962",
})

-- window-wide background
Aurora:CreateWindow({
	Title = "Hub",
	Theme = "Gold",
	BackgroundImage = "rbxassetid://12704861818",
	BackgroundImageTransparency = 0.7,
})
```
