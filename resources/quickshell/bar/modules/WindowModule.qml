import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: windowModule

    required property var classOverrides

    property string windowClass: ""

    property string displayName: classOverrides[windowClass] ? classOverrides[windowClass].name : windowClass
    property string displayIcon: classOverrides[windowClass] ? classOverrides[windowClass].icon : ""

    Process {
        id: winTitleProc
        command: ["sh", "-c", "hyprctl -j activewindow | jq -r '.class'"]
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
        interval: 50
        repeat: true
        running: true
        onTriggered: winTitleProc.running = true
    }
}
