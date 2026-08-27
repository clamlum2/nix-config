import Quickshell.Io
import QtQuick
import "."

Item {
    id: root

    implicitWidth: row.width
    implicitHeight: Theme.barHeight

    property int maxTitleChars: 40

    property string windowClass: ""
    property string windowTitle: ""

    property var classOverrides: ({
            "code": {
                name: "Visual Studio Code",
                icon: ""
            },
            "helium": {
                name: "Helium",
                icon: ""
            },
            "spotify": {
                name: "Spotify",
                icon: ""
            },
            "vesktop": {
                name: "Vesktop",
                icon: ""
            },
            "discord": {
                name: "Discord",
                icon: ""
            },
            "com.mitchellh.ghostty": {
                name: "Ghostty",
                icon: ""
            },
            "org.wezfurlong.wezterm": {
                name: "WezTerm",
                icon: ""
            },
            "org.gnome.nautilus": {
                name: "Nautilus",
                icon: ""
            },
            "feishin": {
                name: "Feishin",
                icon: ""
            },
            "dev.zed.Zed": {
                name: "Zed",
                icon: ""
            },
            "steam": {
                name: "Steam",
                icon: ""
            }
        })

    function _override() {
        const key = windowClass.toLowerCase();
        return classOverrides[key] || classOverrides[windowClass] || null;
    }

    function _clip(s) {
        const str = (s || "").toString();
        return maxTitleChars > 0 && str.length > maxTitleChars ? str.slice(0, maxTitleChars - 1) + "…" : str;
    }

    property var activeOverride: _override()
    property string displayIcon: activeOverride ? activeOverride.icon : ""
    property string displayName: activeOverride ? activeOverride.name : windowClass

    Process {
        id: focusedProc
        command: ["sh", "-c", "niri msg -j focused-window 2>/dev/null | jq -r '.app_id // \"\"'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const v = data.trim();
                root.windowClass = v;
            }
        }
    }

    Process {
        id: eventStream
        command: ["niri", "msg", "-j", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: focusedProc.running = true
        }
    }

    Row {
        id: row
        spacing: 6

        Text {
            visible: root.displayIcon !== ""
            text: root.displayIcon
            color: Theme.text
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenterOffset: -4
        }

        Text {
            text: root.displayName
            color: Theme.text
            font.pixelSize: Theme.fontSize
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenterOffset: -2.5
        }
    }
}
