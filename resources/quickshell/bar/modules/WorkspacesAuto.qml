import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    // true => load `Niri.qml`; false => load `Workspaces.qml`
    property bool useNiri: false

    implicitWidth: loader.implicitWidth
    implicitHeight: loader.implicitHeight

    Process {
        id: detectProc
        // Decide from $XDG_CURRENT_DESKTOP (e.g. "niri" or "Hyprland").
        command: ["sh", "-c", "printf '%s' \"${XDG_CURRENT_DESKTOP:-}\"" ]
        stdout: SplitParser {
            onRead: data => {
                const v = data.trim().toLowerCase()
                const parts = v.split(":").map(p => p.trim()).filter(p => p.length > 0)
                root.useNiri = parts.includes("niri") || v.includes("niri")
            }
        }
    }

    Component.onCompleted: detectProc.running = true

    Loader {
        id: loader
        anchors.fill: parent
        sourceComponent: root.useNiri ? niriComp : hyprComp
    }

    Component {
        id: niriComp
        Niri {}
    }

    Component {
        id: hyprComp
        Workspaces {}
    }
}
