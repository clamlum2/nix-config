import QtQuick
import Quickshell.Io

Item {
    id: microphoneModule

    property bool muted: false
    property string icon: muted ? "" : ""

    Process {
        id: micStatusProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_SOURCE@"]
        stdout: SplitParser {
            onRead: data => {
                microphoneModule.muted = data.includes("MUTED");
            }
        }
    }

    Timer {
        interval: 200
        repeat: true
        running: true
        onTriggered: micStatusProc.running = true
    }

    function toggle() {
        toggleMicProc.running = true;
    }

    Process {
        id: toggleMicProc
        command: ["sh", "-c", "wpctl set-mute @DEFAULT_SOURCE@ toggle"]
        onExited: {
            micStatusProc.running = true;
        }
    }
}
