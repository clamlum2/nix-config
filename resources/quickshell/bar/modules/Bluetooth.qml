import Quickshell.Io
import QtQuick

Item {
    id: bluetoothModule

    property bool bluetoothStatus: false
    property string icon: bluetoothStatus ? "" : "󰂲"

    Process {
        id: bluetoothStatusProc
        command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
        stdout: SplitParser {
            onRead: data => {
                bluetoothModule.bluetoothStatus = data.trim() === "yes";
            }
        }
    }

    Process {
        id: monitor
        command: ["sh", "-c", "bluetoothctl monitor"]
        running: true
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
        command: ["sh", "-c", "bluetoothctl power " + (bluetoothModule.bluetoothStatus ? "off" : "on")]
        // qmllint disable signal-handler-parameters
        onExited: {
            bluetoothStatusProc.running = true;
        }
        // qmllint enable signal-handler-parameters
    }
}
