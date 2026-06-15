import QtQuick
import Quickshell.Io

Item {
    id: microphoneModule

    property bool muted: false
    property string icon: muted ? "" : ""

    Process {
        id: micStatusProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@"]
        stdout: SplitParser {
            onRead: data => {
                microphoneModule.muted = data.includes("MUTED");
            }
        }
    }

    Process {
        id: micWatcher
        command: ["inotifywait", "-m", "-e", "close_write", "/tmp/mic-changed"]
        running: true
        stdout: SplitParser {
            onRead: micStatusProc.running = true
        }
    }

    function toggle() {
        toggleMicProc.running = true;
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: micStatusProc.running = true
    }

    Process {
        id: toggleMicProc
        command: ["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"]
        // qmllint disable signal-handler-parameters
        onExited: {
            micStatusProc.running = true;
        }
        // qmllint enable signal-handler-parameters
    }
}
