import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    implicitWidth: row.width
    implicitHeight: 32

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

    function refresh() {
        focusedProc.running = true;
    }

    Process {
        id: focusedProc
        command: ["sh", "-c", "niri msg -j focused-window 2>/dev/null | jq -r '.app_id // empty'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const v = data.trim();
                root.windowClass = v || "";
            }
        }
    }

    Process {
        id: eventStream
        command: ["niri", "msg", "-j", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: _ => debounce.restart()
        }
        onExited: poll.running = true
    }

    Timer {
        id: debounce
        interval: 50
        onTriggered: root.refresh()
    }
    Timer {
        id: poll
        interval: 500
        repeat: true
        running: false
        onTriggered: root.refresh()
    }

    Row {
        id: row
        spacing: 6

        Text {
            visible: root.displayIcon !== ""
            text: root.displayIcon
            color: "#c8c8e6"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenterOffset: -4
        }

        Text {
            text: root.displayName
            color: "#c8c8e6"
            font.pixelSize: 14
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenterOffset: -2
        }
    }
}
