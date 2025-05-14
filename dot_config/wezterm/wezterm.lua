-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This table will hold the configuration.
local config = {}
local launch_menu = {}
config.launch_menu = launch_menu
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.native_macos_fullscreen_mode = true
wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():toggle_fullscreen()
end)
-- config.color_scheme = 'Dracula+'
config.color_scheme = "Tokyo Night"
config.default_prog = { "/bin/zsh", "-l" }
config.font = wezterm.font("Fira Code Nerd Font", { weight = "Bold", italic = true })
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font Mono",
})
config.font_size = 18.0

-- config.debug_key_events = true
config.keys = {
	{
		key = "p",
		mods = "CMD",
		action = wezterm.action.ActivateCommandPalette,
	},
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "UpArrow",
		mods = "CMD|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Up", 1 }),
	},
	{
		key = "DownArrow",
		mods = "CMD|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Down", 1 }),
	},
	{
		key = "LeftArrow",
		mods = "CMD|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Left", 1 }),
	},
	{
		key = "RightArrow",
		mods = "CMD|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Right", 1 }),
	},
	{
		key = "UpArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "x",
		mods = "CMD",
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = "s",
		mods = "CMD",
		action = wezterm.action.QuickSelect,
	},
	{
		key = "z",
		mods = "CMD",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "r",
		mods = "CMD",
		action = wezterm.action.ReloadConfiguration,
	},
}
config.enable_scroll_bar = true

local ssh_config_file = wezterm.home_dir .. "~/.ssh/config"
local f = io.open(ssh_config_file)
if f then
	local line = f:read("*l")
	while line do
		if line:find("Host ") == 1 then
			local host = line:gsub("Host ", "")
			table.insert(launch_menu, {
				label = "SSH " .. host,
				args = { "wezterm", "ssh", host },
			})
		end
		line = f:read("*l")
	end
	f:close()
end

-- and finally, return the configuration to wezterm
return config
