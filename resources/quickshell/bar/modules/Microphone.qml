import QtQuick
import Quickshell.Io

Item {
    id: root

    implicitWidth: 16
    implicitHeight: parent.height

    property bool muted: false
    property string icon: muted ? "" : ""

    Process {
        id: micStatusProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@"]
        stdout: SplitParser {
            onRead: data => {
                root.muted = data.includes("MUTED");
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

    Text {
        id: microphone
        width: parent.width
        height: parent.height
        text: root.icon
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggle()
    }
}
