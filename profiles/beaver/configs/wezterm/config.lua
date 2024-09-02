local wezterm = require "wezterm"
local is_windows <const> = wezterm.target_triple:find("windows") ~= nil

local function get_config()
  local c = wezterm.config_builder()

  c.color_scheme = "Catppuccin Mocha"
  c.font = wezterm.font "Source Code Pro"
  c.hide_tab_bar_if_only_one_tab = true

  c.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  }

  c.leader = {
    key = "Space",
    mods = "CTRL|SHIFT",
  }

  c.disable_default_key_bindings = true
  c.keys = {
    {
      mods = "CTRL",
      key = "c",
      action = wezterm.action.CopyTo "Clipboard",
    },
    {
      mods = "CTRL",
      key = "v",
      action = wezterm.action.PasteFrom "Clipboard",
    },
    {
      mods = "LEADER",
      key = "h",
      action = wezterm.action.QuickSelect,
    },
  }

  if is_windows then
    c.default_prog = { "C:\\Windows\\system32\\wsl.exe", "-d", "NixOS" }
  end

  return c
end

return get_config()

