{ config, pkgs, lib, ... }:

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
                windowtitle.middleClick = "hyprctl dispatch killactive";
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
                    margin_sides = "-0.2em";
                    outer_spacing = "-2";
                    menus = {
                        # text = "#FFFFFF";
                        # dimtext = "#579599";
                        # feinttext = "#313850";
                        # label = "#FFFFFF";
                        # background = "#0d1520cc";
                        # cards = "#0d1520cc";
                        tooltip = {
                            text = "#FFFFFF";
                            background = "#0d1520cc";
                        };
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
                                background.color = "#0d1520cc";
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
                                background.color = "#0d1520cc";
                                border.color = "#FFFFFF";
                                icons.active = "#57f7fc";
                                icons.passive = "#57f7fc";
                                text = "#FFFFFF";
                                label.color = "#FFFFFF";
                                listitems.active = "#57f7fc";
                                iconbutton.active = "#57f7fc";
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
                            notifications = {
                                card = "#0d1520cc";
                                background = "#0d1520cc";
                                switch = {
                                    puck = "#57f7fc";
                                    enabled = "#579599";
                                    disabled = "#313850";
                                };
                                label = "#FFFFFF";
                                clear = "#57f7fc";
                            };
                            systray = {
                                dropdownmenu = {
                                    background = "#0d1520";
                                    text = "#FFFFFF";
                                    divider = "#579599";
                                };
                            };
                            clock = {
                                weather = {
                                    hourly = {
                                        temperature = "#FFFFFF";
                                        icon = "#57f7fc";
                                        time = "#FFFFFF";
                                    };
                                    thermometer = {
                                        extremelycold = "#8be9fd";
                                        cold = "#50fa7b";
                                        moderate = "#f1fa8c";
                                        hot = "#ffb86c";
                                        extremelyhot = "#ff5555";
                                    };
                                    stats = "#FFFFFF";
                                    status = "#FFFFFF";
                                    temperature = "#FFFFFF";
                                    icon = "#57f7fc";
                                };
                                calendar = {
                                    contextdays = "#579599";
                                    days = "#FFFFFF";
                                    currentday = "#57f7fc";
                                    paginator = "#FFFFFF";
                                    weekdays = "#FFFFFF";
                                    yearmonth = "#FFFFFF";
                                };
                                time = {
                                    timeperiod = "#57f7fc";
                                    time = "#FFFFFF";
                                };
                                text = "#FFFFFF";
                                background.color = "#0d1520cc";
                                card.color = "#0d1520cc";
                                border.color = "#FFFFFF";
                            };
                            dashboard = {
                                scaling = 85;
                                background.color = "#0d1520cc";
                                border.color = "#FFFFFF";
                                card.color = "#0d1520cc";
                                profile.name = "#57f7fc";
                                powermenu = {
                                    sleep = "#57f7fc";
                                    logout = "#57f7fc";
                                    restart = "#57f7fc";
                                    shutdown = "#57f7fc";
                                };
                                controls = {
                                    input = {
                                        text = "#000000";
                                        background = "#57f7fc";
                                    };
                                    volume = {
                                        text = "#000000";
                                        background = "#57f7fc";
                                    };
                                    notifications = {
                                        text = "#000000";
                                        background = "#57f7fc";
                                    };
                                    bluetooth = {
                                        text = "#000000";
                                        background = "#57f7fc";
                                    };
                                    wifi = {
                                        text = "#000000";
                                        background = "#57f7fc";
                                    };
                                    disabled = "#313850";
                                };
                                shortcuts = {
                                    text = "#000000";
                                    background = "#57f7fc";
                                };
                                directories = {
                                    right = {
                                        bottom.color = "#57f7fc";
                                        middle.color = "#57f7fc";
                                        top.color = "#57f7fc";
                                    };
                                    left = {
                                        bottom.color = "#57f7fc";
                                        middle.color = "#57f7fc";
                                        top.color = "#57f7fc";
                                    };
                                };
                                monitors = {
                                    disk = {
                                        label = "#FFFFFF";
                                        bar = "#579599";
                                        icon = "#57f7fc";
                                    };
                                    gpu = {
                                        label = "#FFFFFF";
                                        bar = "#579599";
                                        icon = "#57f7fc";
                                    };
                                    ram = {
                                        label = "#FFFFFF";
                                        bar = "#579599";
                                        icon = "#57f7fc";
                                    };
                                    cpu = {
                                        label = "#FFFFFF";
                                        bar = "#579599";
                                        icon = "#57f7fc";
                                    };
                                    bar_background = "#313850";
                                };
                                powermenu = {
                                    confirmation = {
                                        button_text = "#000000";
                                        deny = "#57f7fc";
                                        confirm = "#57f7fc";
                                        body = "#FFFFFF";
                                        label = "#FFFFFF";
                                        border = "#FFFFFF";
                                        background = "#0d1520cc";
                                        card = "#0d1520cc";
                                    };
                                };
                            };
                        };
                    };
                };
                notification = {
                    background = "#0d1520cc";
                    text = "#FFFFFF";
                    close_button = {
                        background = "#579599";
                        label = "#FFFFFF";
                    };
                    label = "#FFFFFF";
                    actions = {
                        background = "#579599";
                        text = "#FFFFFF";
                    };
                    time = "#FFFFFF";
                    labelicon = "#57f7fc";
                    border = "#FFFFFF";
                };
            };
            menus = {
                volume.raiseMaximumVolume = true;
                clock = {
                    weather = {
                        location = "Auckland";
                        unit = "metric";
                        key = "003bd2c5c54b48d2a28154312250108";
                    };
                };
                dashboard = {
                    powermenu.avatar.image = "/etc/nixos/resources/wallpapers/icon.png";
                    stats.enable_gpu = true;
                    shortcuts = {
                        left = {
                            shortcut1 = {
                                icon = "󰇩";
                                command = "helium-browser";
                                tooltip = "Helium Browser";
                            };
                            shortcut2 = {
                                icon = "";
                                command = "spotify";
                                tooltip = "Spotify";
                            };
                            shortcut3 = {
                                icon = "";
                                command = "vesktop";
                                tooltip = "Vesktop";
                            };
                            shortcut4 = {
                                icon = "󰨞";
                                command = "code";
                                tooltip = "VS Code";
                            };
                        };
                        right = {
                            shortcut1 = {
                                icon = "";
                                command = "hyprshade off && hyprpicker -a && hyprshade on extravibrance";
                                tooltip = "Color Picker";
                            };
                            shortcut3 = {
                                icon = "󰄀";
                                command = "bash -c \"/nix/store/bpbr2ka76yzpgwm8yzbqb4k2ad9lsh8m-hyprpanel-0-unstable-2025-06-20/share/scripts/snapshot.sh\"";
                                tooltip = "Screenshot";
                            };
                            shortcut4 = {
                                icon = "󰝰";
                                command = "dolphin";
                                tooltip = "Dolphin File Manager";
                            };
                        };
                    };
                };
            };
        };
    };
}