{  config, pkgs, lib, ... }:

{
    home.file.".wezterm.lua".text = ''
        -- Pull in the wezterm API
        local wezterm = require("wezterm")

        -- This will hold the configuration.
        local config = wezterm.config_builder()

        config.window_background_opacity = 0.8

        config.font = wezterm.font("DejaVuSansMono")
        config.font_size = 11.0

        config.default_cursor_style = "BlinkingBar"

        -- tabs
        config.hide_tab_bar_if_only_one_tab = true
        config.use_fancy_tab_bar = false

        -- This is where you actually apply your config choices

        config.colors = {
        background = "#0d1520",
        foreground = "#FFFFFF",
        cursor_border = "#FFFFFF",
        cursor_bg = "#FFFFFF",
        tab_bar = {
            background = "#0d1520",
            active_tab = {
            bg_color = "#0d1520",
            fg_color = "#FFFFFF",
            intensity = "Normal",
            underline = "None",
            italic = false,
            strikethrough = false,
            },
            inactive_tab = {
            bg_color = "#0d1520",
            fg_color = "#FFFFFF",
            intensity = "Normal",
            underline = "None",
            italic = false,
            strikethrough = false,
            },
            new_tab = {
            bg_color = "#0d1520",
            fg_color = "#FFFFFF",
            },
        },
        }

        -- and finally, return the configuration to wezterm

        return config

    '';
}