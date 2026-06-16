import QtQuick
import Quickshell.Io

Item {
    id: root

    implicitWidth: available ? (level >= 100 ? 42 : level <= 9 ? 26 : 34) : 0
    implicitHeight: parent.height

    property bool available: false
    property bool charging: false
    property string level: "0"
    property string icon: charging ? "󰂄" : level >= 90 ? "󰁹" : level >= 80 ? "󰂀" : level >= 70 ? "󰁿" : level >= 60 ? "󰁾" : level >= 50 ? "󰁽" : level >= 40 ? "󰁼" : level >= 30 ? "󰁻" : level >= 20 ? "󰁺" : level >= 10 ? "󰂃" : "󰂎"

    Process {
        id: batteryProc
        command: ["sh", "-c", "upower -b | awk '/percentage/{pct=int($2)} /state/{st=$2} END{print pct, st}'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                const parsedLevel = parseInt(parts[0]);
                root.available = !isNaN(parsedLevel);
                root.level = root.available ? parsedLevel : "0";
                root.charging = root.available && parts[1] === "charging";
            }
        }
    }

    Process {
        id: monitor
        command: ["sh", "-c", "upower -m"]
        running: true
        stdout: SplitParser {
            onRead: batteryProc.running = true
        }
    }

    Text {
        id: battery_icon
        visible: root.available
        text: root.icon
        width: 12
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
        color: Theme.text
        font.family: Theme.font
        scale: 1.25
        transformOrigin: Item.Center
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: battery_level
        visible: root.available
        text: root.level
        width: root.level >= 100 ? 24 : root.level <= 9 ? 8 : 16
        height: parent.height
        anchors.left: battery_icon.right
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1
        color: Theme.text
        font {
            family: Theme.font
            pixelSize: Theme.fontSize
            bold: true
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
