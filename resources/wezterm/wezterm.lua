-- Pull in the wezterm API
        local wezterm = require("wezterm")

        -- This will hold the configuration.
        local config = wezterm.config_builder()

        config.window_background_opacity = 0.8

        config.font = wezterm.font("JetBrains Mono Nerd Font")
        config.font_size = 11.0

        config.default_cursor_style = "BlinkingBar"

        -- tabs
        config.hide_tab_bar_if_only_one_tab = true
        config.use_fancy_tab_bar = false

        -- This is where you actually apply your config choices

        config.colors = {
        background = "#1f2134",
        foreground = "#FFFFFF",
        cursor_border = "#FFFFFF",
        cursor_bg = "#FFFFFF",
            tab_bar = {
                background = "#1f2134",
                active_tab = {
                    bg_color = "#1f2134",
                    fg_color = "#FFFFFF",
                    intensity = "Normal",
                    underline = "None",
                    italic = false,
                    strikethrough = false,
                },
                inactive_tab = {
                    bg_color = "#1f2134",
                    fg_color = "#FFFFFF",
                    intensity = "Normal",
                    underline = "None",
                    italic = false,
                    strikethrough = false,
                },
                new_tab = {
                    bg_color = "#1f2134",
                    fg_color = "#FFFFFF",
                },
            },
        }

        -- and finally, return the configuration to wezterm

        return config