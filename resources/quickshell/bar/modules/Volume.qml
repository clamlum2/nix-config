import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: volumeModule

    property string level: "0"
    property string icon: muted ? "" : level >= 66 ? "" : level >= 33 ? "" : level > 0 ? "" : ""
    property bool muted: false
    property string change: "0%"

    Process {
        id: volumeProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                muted = data.includes("MUTED")
                level = parseInt(parseFloat(data.split(" ")[1]) * 100)
            }
        }
    }

    Timer {
        interval: 100
        repeat: true
        running: true
        onTriggered: volumeProc.running = true
    }

    function muteUnmute() {
        toggleMuteProc.running = true
    }

    Process {
        id: toggleMuteProc
        command: ["wpctl", "set-mute", "@DEFAULT_SINK@", "toggle"]
        onExited: {
            volumeProc.running = true
        }
    }

    function volumeMod(direction) {
        let change = direction === "up" ? "1%+" : direction === "down" ? "1%-" : "0%"
        changeVolumeProc.command = ["wpctl", "set-volume", "@DEFAULT_SINK@", change]
        changeVolumeProc.running = true
    }

    Process {
        id: changeVolumeProc
        command: ["sh", "-c", "wpctl set-volume @DEFAULT_SINK@ " + change]
        onExited: {
            volumeProc.running = true
        }
    }
}