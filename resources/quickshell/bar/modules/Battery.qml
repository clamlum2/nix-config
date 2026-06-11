import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: batteryModule

    property bool available: false
    property bool charging: false
    property string level: "0"
    property string icon: charging ? "󰂄" : level >= 90 ? "󰁹" : level >= 80 ? "󰂀" : level >= 70 ? "󰁿" : level >= 60 ? "󰁾" : level >= 50 ? "󰁽" : level >= 40 ? "󰁼" : level >= 30 ? "󰁻" : level >= 20 ? "󰁺" : level >= 10 ? "󰂃" : "󰂎"

    Process {
        id: batteryProc
        command: ["sh", "-c", "upower -b | awk '/percentage/{pct=int($2)} /state/{st=$2} END{print pct, st}'"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                const parsedLevel = parseInt(parts[0]);
                available = !isNaN(parsedLevel);
                level = available ? parsedLevel : "0";
                charging = available && parts[1] === "charging";
            }
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: batteryProc.running = true
    }
}
