local wezterm = require 'wezterm'
local math = require 'math'

local wsl_domains = wezterm.default_wsl_domains()

wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  --window:gui_window():toggle_fullscreen()
end)

local brightness = {
	brightness = 0.3,
}
for _, domain in ipairs(wsl_domains) do
  domain.default_cwd = "~"
end

return {
  adjust_window_size_when_changing_font_size = false,
  audible_bell = 'Disabled',
  background = {
    {
	source = { Color = 'black' }
    },
    {
      source = { File = "C:/Users/rkild/.config/wezterm/Stars/bg.png" },
	opacity = 0.7,
     	repeat_x = "NoRepeat",
	hsb = brightness,
	width = "100%",
	repeat_y = "Mirror", 
	attachment = { Parallax = 0.001 },
    },
    {
      source = { File = "C:/Users/rkild/.config/wezterm/Stars/dim.png" },
     repeat_x = "NoRepeat", 
      repeat_y = "Mirror",
	vertical_align = 'Bottom',

	width = "200%",
	repeat_y_size = '200%',    
	attachment = { Parallax = 0.005 },
},
    {
      source = { File = "C:/Users/rkild/.config/wezterm/Stars/bright.png" },
	repeat_x = "NoRepeat",
	opacity = 0.5,
	width = "200%",
        repeat_y = "Mirror",
	vertical_offset = '10%',
	repeat_y_size = '200%',
	attachment = { Parallax = 0.05 },
    },
    {
      source = { File = "C:/Users/rkild/.config/wezterm/Stars/bright.png" },
     repeat_x = "NoRepeat",
	width = "200%",
      repeat_y = "Mirror",
	opacity = 0.7,
	vertical_offset = '30%',
	repeat_y_size = '200%',

	attachment = { Parallax = 0.2 },
    },
  },
  color_scheme = 'Catppuccin Frappe',
  disable_default_key_bindings = true,
  exit_behavior = 'Close',
  font = wezterm.font {
    family = 'FiraCode Nerd Font Mono',
    weight = 'Light',
    stretch = 'Normal',
    style = 'Normal',
    harfbuzz_features = { 'cv29', 'cv30', 'ss01', 'ss03', 'ss06', 'ss07', 'ss09' },
  },
  font_size = 20,
  force_reverse_video_cursor = true,
  hide_mouse_cursor_when_typing = true,
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    { action = wezterm.action.ActivateCommandPalette, mods = 'CTRL|SHIFT', key =     'P' },
    { action = wezterm.action.CopyTo    'Clipboard' , mods = 'CTRL|SHIFT', key =     'C' },
    { action = wezterm.action.DecreaseFontSize      , mods =       'CTRL', key =     '-' },
    { action = wezterm.action.IncreaseFontSize      , mods =       'CTRL', key =     '=' },
    { action = wezterm.action.Nop                   , mods =        'ALT', key = 'Enter' },
    { action = wezterm.action.PasteFrom 'Clipboard' , mods = 'CTRL|SHIFT', key =     'V' },
    { action = wezterm.action.ResetFontSize         , mods =       'CTRL', key =     '0' },
    { action = wezterm.action.ToggleFullScreen      ,                      key =   'F11' },
  },
  scrollback_lines = 10000,
  show_update_window = true,
  use_dead_keys = false,
  unicode_version = 15,
  macos_window_background_blur = 100,
  window_close_confirmation = 'NeverPrompt',
  window_padding = {
    left = 0,
    right = 0,
    top = '0.6cell',
    bottom = 0,
  },
  wsl_domains = wsl_domains,
}