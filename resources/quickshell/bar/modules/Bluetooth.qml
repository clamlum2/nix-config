import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: bluetoothModule

    property bool bluetoothStatus: false
    property string icon: bluetoothStatus ? "" : "󰂲"

    Process {
        id: bluetoothStatusProc
        command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'" ]
        stdout: SplitParser {
            onRead: data => {
                bluetoothStatus = data.trim() === "yes"
            }
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: bluetoothStatusProc.running = true
    }

    Component.onCompleted: {
        bluetoothStatusProc.running = true
    }

    function toggle() {
        toggleBluetoothProc.running = true
    }

    Process {
        id: toggleBluetoothProc
        command: ["sh", "-c", "bluetoothctl power " + (bluetoothStatus ? "off" : "on")]
        onExited: {
            bluetoothStatusProc.running = true
        }
    }
}