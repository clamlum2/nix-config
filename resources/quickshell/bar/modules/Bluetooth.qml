import Quickshell.Io
import QtQuick

Item {
    id: root

    visible: available

    implicitWidth: available ? 16 : 0
    implicitHeight: parent.height

    property bool available: false
    property bool bluetoothStatus: false
    property string icon: bluetoothStatus ? "" : "󰂲"

    Process {
        id: bluetoothCheckProc
        command: ["sh", "-c", "command -v bluetoothctl >/dev/null 2>&1 && echo yes || echo no"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.available = data.trim() === "yes";
                if (root.available) {
                    monitor.running = true;
                }
            }
        }
    }

    Process {
        id: bluetoothStatusProc
        command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                root.bluetoothStatus = data.trim() === "yes";
            }
        }
    }

    Process {
        id: monitor
        command: ["sh", "-c", "bluetoothctl monitor"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                bluetoothStatusProc.running = true;
            }
        }
    }

    function toggle() {
        toggleBluetoothProc.running = true;
    }

    Process {
        id: toggleBluetoothProc
        command: ["sh", "-c", "bluetoothctl power " + (root.bluetoothStatus ? "off" : "on")]
        // qmllint disable signal-handler-parameters
        onExited: {
            bluetoothStatusProc.running = true;
        }
        // qmllint enable signal-handler-parameters
    }

    Text {
        id: bluetooth_status
        text: root.icon
        color: Theme.text
        font.family: Theme.font
        scale: 1.5
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggle()
    }
}
