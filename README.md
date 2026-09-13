# Aurora UI

A modern, lightweight, and customizable Roblox Lua UI library inspired by WindUI.

Aurora includes animated tabs, buttons, toggles, sliders, dropdowns, inputs, keybinds, notifications, themes, config flags, and a minimize-to-icon window system. It is distributed as a single Lua file with no external dependencies.

## Features

- Customizable tabs with icons, colors, ordering, and lock states
- Buttons with ripple feedback and hover animations
- Animated toggles
- Mouse and touch-compatible sliders
- Single-select and multi-select dropdowns
- Text inputs and keybind controls
- Information paragraphs, sections, and dividers
- Title bar with a custom icon, subtitle, minimize button, and close button
- Minimizes into one draggable custom icon
- Bottom-left user panel with an avatar, username, tag, and settings button
- Built-in settings tab for themes, interface scale, and minimize key
- Five included themes: Aurora, Midnight, Rose, Emerald, and Daylight
- Runtime theme and accent switching
- Notifications with icons and duration indicators
- Flag-based values with JSON config saving and loading
- Connection cleanup when elements or the library are unloaded
- Single-file library with no dependencies

## Installation

Host `aurora.lua` somewhere that provides a raw file URL, then load it with:

```lua
local Aurora = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/public/aurora.lua"
))()
```

Replace `USERNAME` and `REPOSITORY` with your GitHub details.

You can also copy `aurora.lua` directly into your project or executor.

## Quick Start

```lua
local Aurora = loadstring(game:HttpGet("YOUR_RAW_URL"))()

local Window = Aurora:CreateWindow({
    Title = "Aurora Hub",
    SubTitle = "v1.0.0",
    Icon = "rbxassetid://10723407389",
    MinimizeIcon = "rbxassetid://10734896206",
    Theme = "Aurora",
    ToggleKey = Enum.KeyCode.RightShift,
})

local Main = Window:CreateTab({
    Title = "Main",
    Icon = "home",
})

Main:CreateToggle({
    Title = "Example Toggle",
    Default = false,
    Flag = "ExampleToggle",
    Callback = function(value)
        print("Toggle:", value)
    end,
})

Main:CreateSlider({
    Title = "Walk Speed",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(value)
        print("Speed:", value)
    end,
})

Aurora:Notify({
    Title = "Aurora UI",
    Content = "Loaded successfully.",
    Duration = 5,
})
```

A larger example containing every component is available in [`example.lua`](./public/example.lua).

## Components

| Component | Method |
| --- | --- |
| Tab | `Window:CreateTab(config)` |
| Section | `Tab:CreateSection(text)` |
| Divider | `Tab:CreateDivider()` |
| Information text | `Tab:CreateParagraph(config)` |
| Button | `Tab:CreateButton(config)` |
| Toggle | `Tab:CreateToggle(config)` |
| Slider | `Tab:CreateSlider(config)` |
| Dropdown | `Tab:CreateDropdown(config)` |
| Input | `Tab:CreateInput(config)` |
| Keybind | `Tab:CreateKeybind(config)` |
| Notification | `Aurora:Notify(config)` |

Short aliases are also available, including `Tab:Button()`, `Tab:Toggle()`, `Tab:Slider()`, and `Tab:Dropdown()`.

## Window Options

| Option | Type | Description |
| --- | --- | --- |
| `Title` | string | Main window title |
| `SubTitle` | string | Small text beside the title |
| `Icon` | asset ID or icon name | Icon displayed beside the title |
| `Size` | UDim2 | Window size |
| `Theme` | string | Name of an included theme |
| `Accent` | Color3 | Custom accent color |
| `ToggleKey` | KeyCode | Key used to minimize or restore the window |
| `MinimizeIcon` | asset ID or icon name | Icon used for the minimized bubble |
| `MinimizePosition` | UDim2 | Initial minimized bubble position |
| `Username` | string | Name shown in the user panel |
| `UserTag` | string | Secondary name shown in the user panel |
| `UserAvatar` | asset ID | Custom user avatar |
| `SettingsIcon` | asset ID | Custom settings button icon |
| `SidebarWidth` | number | Width of the tab sidebar |
| `DestroyOnClose` | boolean | Whether closing destroys the interface |
| `OnSettings` | function | Called when the settings button is clicked |
| `OnMinimize` | function | Called when the minimized state changes |
| `OnClose` | function | Called when the window closes |

## Icons

Icons can be supplied as a Roblox asset URL, a numeric asset ID, or an included icon name.

```lua
Icon = "rbxassetid://10723407389"
Icon = 10723407389
Icon = "home"
```

Included names include `home`, `star`, `settings`, `user`, `sword`, `eye`, `bolt`, `globe`, `code`, `palette`, `shield`, and `rocket`.

## Themes

Change the complete interface theme at runtime:

```lua
Aurora:SetTheme("Midnight")
```

Change only the accent color:

```lua
Aurora:SetAccent(Color3.fromRGB(64, 156, 255))
```

Custom theme tables are also supported when they contain the same color keys as an included theme.

## Flags and Configs

Add a `Flag` to supported elements to store their current value in `Aurora.Flags`.

```lua
local enabled = Aurora:GetFlag("ExampleToggle", false)
local json = Aurora:SaveConfig()
Aurora:LoadConfig(json)
```

File reading and writing are intentionally left to the environment using the library.

## Window Methods

```lua
Window:Minimize()
Window:Restore()
Window:Toggle()
Window:Close()
Window:Destroy()
Window:SetTitle("New Title", "v1.1.0")
Window:SetIcon("home")
Window:SetMinimizeIcon("rocket")
Window:SetScale(0.9)
Window:OpenSettings()
Window:SelectTab(1)
```

Unload every Aurora window and disconnect tracked listeners with:

```lua
Aurora:Unload()
```

## Compatibility

Aurora is written for Roblox Luau environments that support `loadstring` and `game:HttpGet` when loading from a URL. GUI parenting supports `gethui`, `syn.protect_gui`, `CoreGui`, and `PlayerGui` fallbacks.

Availability of HTTP requests and filesystem functions depends on the environment running the library.

## Files

| File | Description |
| --- | --- |
| [`aurora.lua`](./public/aurora.lua) | Complete library source |
| [`example.lua`](./public/example.lua) | Full usage example |

## Credits

Aurora UI is inspired by the clean layout and interaction style of WindUI. It is an independent library and is not affiliated with WindUI or Roblox.
