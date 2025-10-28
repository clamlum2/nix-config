{   config, pkgs, lib, ... }:

let
    buttonNames = [
        "dashboard" 
        "windowtitle" 
        "media"
        "systray" 
        "volume" 
        "bluetooth"
        "network" 
        "clock" 
        "notifications"
    ];
    buttonAttrs = builtins.listToAttrs (map (name: {
        name = name;
            value = {
            background = "#00000000";
            text = "#FFFFFF";
            icon = "#57f7fc";
            border = "#FFFFFF";
        };
    }) buttonNames);
in

{
    programs.hyprpanel = {
        enable = true;

        settings = {
            bar = {
                launcher.autoDetectIcon = true;
                clock.format = "%a %b %d %I:%M %p";
                layouts = {
                    "*" = {
                        left = [
                            "dashboard"
                            "workspaces"
                            "windowtitle"
                        ];
                        middle = [ "media" ];
                        right = [
                            "systray"
                            "volume"
                            "bluetooth"
                            "network"
                            "clock"
                            "notifications"
                        ];
                    };
                };
            };
            theme = {
                bar = {
                    floating = true;
                    transparent = true;
                    scaling = 85;
                    buttons = buttonAttrs // {
                        enableBorders = true;
                        workspaces = {
                            background = "#00000000";
                            text = "#FFFFFF";
                            icon = "#57f7fc";
                            border = "#FFFFFF";
                            active = "#57f7fc";
                            occupied = "#57f7fc";
                            available = "#579599";
                            hover = "#FFFFFF";
                        };
                        y_margins = "0em";
                    };
                    margin_top = "-0.1em";
                    margin_bottom = "0.1em";
                    margin_sides = "-0.1em";
                    outer_spacing = "-2";
                    menus = {
                        menu = {
                            media = {
                                card.tint = 50;
                                song = "#FFFFFF";
                                artist = "#FFFFFF";
                                album = "#FFFFFF";
                                buttons = {
                                    background = "#579599";
                                    text = "#000000";
                                    active = "#57f7fc";
                                    inactive = "#00000000";
                                    enabled = "#57f7fc";
                                };
                                slider = {
                                    puck = "#57f7fc";
                                    primary = "#579599";
                                    background = "#313850";
                                    backgroundhover = "#313850";
                                };
                                background.color = "#0d1520";
                                border.color = "#FFFFFF";
                            };
                            volume = {
                                card.color = "#0d1520cc";
                                audio_slider = {
                                    puck = "#57f7fc";
                                    primary = "#579599";
                                    background = "#313850";
                                    backgroundhover = "#313850";
                                };
                                input_slider = {
                                    puck = "#57f7fc";
                                    primary = "#579599";
                                    background = "#313850";
                                    backgroundhover = "#313850";
                                };
                                background.color = "#0d1520";
                                border.color = "#FFFFFF";
                                icons.active = "#57f7fc";
                                icons.passive = "#579599";
                                text = "#FFFFFF";
                                label.color = "#FFFFFF";
                                listitems.active = "#57f7fc";
                                iconbutton.active = "#579599";
                                iconbutton.passive = "#57f7fc";
                            };
                            network = {
                                card.color = "#0d1520cc";
                                background.color = "#0d1520cc";
                                border.color = "#FFFFFF";
                                icons.active = "#57f7fc";
                                icons.passive = "#579599";
                                text = "#FFFFFF";
                                label.color = "#FFFFFF";
                                listitems.active = "#57f7fc";
                                iconbutton.active = "#579599";
                                iconbutton.passive = "#57f7fc";
                                switch = {
                                    puck = "#57f7fc";
                                    enabled = "#579599";
                                    disabled = "#313850";
                                };
                            };
                            bluetooth = {
                                card.color = "#0d1520cc";
                                background.color = "#0d1520cc";
                                border.color = "#FFFFFF";
                                icons.active = "#57f7fc";
                                icons.passive = "#579599";
                                text = "#FFFFFF";
                                label.color = "#FFFFFF";
                                listitems.active = "#57f7fc";
                                iconbutton.active = "#579599";
                                iconbutton.passive = "#57f7fc";
                                switch = {
                                    puck = "#57f7fc";
                                    enabled = "#579599";
                                    disabled = "#313850";
                                };
                            };
                        };
                    };
                };
            };
        };
    };
}