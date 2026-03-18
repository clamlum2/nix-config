import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: windowModule

    // Window class/app_id -> { name, icon }
    // Bar.qml may pass its own map; this module also has sane defaults.
    property var classOverrides: ({})

    property var defaultOverrides: ({
        "code": { name: "Visual Studio Code", icon: "" },
        "helium": { name: "Helium", icon: "" },
        "spotify": { name: "Spotify", icon: "" },
        "vesktop": { name: "Vesktop", icon: "" },
        "com.mitchellh.ghostty": { name: "Ghostty", icon: "" },
        "org.wezfurlong.wezterm": { name: "WezTerm", icon: "" },
        "org.gnome.nautilus": { name: "Nautilus", icon: "" },
        "feishin": { name: "Feishin", icon: "" },
        "Minecraft* 1.21.11": { name: "Minecraft", icon: "" },
    })

    // Optional: override detection ("niri" or "hyprland"). Leave empty to auto-detect.
    property string compositor: ""

    property string windowClass: ""

    // Keep the window title from expanding forever and breaking the bar layout.
    property int maxTitleChars: 40

    property string windowKey: (windowClass || "").toString().toLowerCase()

    function _overrideFor(key) {
        return (classOverrides && classOverrides[key]) || (defaultOverrides && defaultOverrides[key]) || null;
    }

    function _clip(s) {
        const str = (s || "").toString();
        return (maxTitleChars > 0 && str.length > maxTitleChars)
            ? (str.slice(0, Math.max(0, maxTitleChars - 1)) + "…")
            : str;
    }

    function _fallbackName() {
        // If no override exists, show a short-ish identifier.
        const raw = (windowClass || "").toString();
        const parts = raw.split(".").filter(p => p.length > 0);
        return parts.length ? parts[parts.length - 1] : raw;
    }

    property var activeOverride: _overrideFor(windowClass) || _overrideFor(windowKey)
    property string displayName: _clip(activeOverride ? activeOverride.name : _fallbackName())
    property string displayIcon: activeOverride ? activeOverride.icon : ""

    function resolveCompositor() {
        return compositor || detectedCompositor || "hyprland";
    }

    // Filled by detectProc.
    property string detectedCompositor: ""

    Component.onCompleted: {
        detectProc.running = true;
    }

    Process {
        id: detectProc
        // Simple desktop detection via session env vars.
        // Valid values: "niri", "Hyprland"
        command: ["sh", "-c", "printf '%s' \"${XDG_CURRENT_DESKTOP:-${XDG_SESSION_DESKTOP:-${DESKTOP_SESSION:-}}}\"" ]
        stdout: SplitParser {
            onRead: data => {
                const v = data.trim().toLowerCase();
                detectedCompositor = v.includes("niri") ? "niri" : "hyprland";
                winClassProc.running = true;
            }
        }
    }

    Process {
        id: winClassProc
        command: resolveCompositor() === "niri"
            ? ["sh", "-c",
                                "command -v niri >/dev/null 2>&1 && command -v jq >/dev/null 2>&1 || exit 0; niri msg -j focused-window 2>/dev/null | jq -r '.app_id | select(.)'"
              ]
            : ["sh", "-c",
                                "command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1 || exit 0; hyprctl -j activewindow 2>/dev/null | jq -r '.class | select(.)'"
              ]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() === "null") {
                    windowClass = ""
                } else {
                    windowClass = data.trim()
                }
            }
        }
    }

    Timer {
        interval: 100
        repeat: true
        running: true
        onTriggered: winClassProc.running = true
    }
}
