import QtQuick
import Quickshell.Io

Item {
    id: root

    implicitWidth: level >= 100 ? 40 : level <= 9 ? 24 : 31
    implicitHeight: parent.height

    property int level: 0
    property string icon: muted ? "" : level >= 66 ? "" : level >= 33 ? "" : level > 0 ? "" : ""
    property bool muted: false

    Process {
        id: volumeProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_SINK@"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.muted = data.includes("MUTED");
                root.level = parseInt(parseFloat(data.split(" ")[1]) * 100);
            }
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: volumeProc.running = true
    }

    function muteUnmute() {
        toggleMuteProc.running = true;
    }

    Process {
        id: toggleMuteProc
        command: ["wpctl", "set-mute", "@DEFAULT_SINK@", "toggle"]
        // qmllint disable signal-handler-parameters
        onExited: volumeProc.running = true
        // qmllint enable signal-handler-parameters
    }

    function volumeMod(direction) {
        changeVolumeProc.command = ["wpctl", "set-volume", "@DEFAULT_SINK@", direction === "up" ? "1%+" : direction === "down" ? "1%-" : "0%"];
        changeVolumeProc.running = true;
    }

    Process {
        id: changeVolumeProc
        command: []
        // qmllint disable signal-handler-parameters
        onExited: volumeProc.running = true
        // qmllint enable signal-handler-parameters
    }

    Text {
        id: iconText
        width: 12
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
        text: root.icon
        color: Theme.text
        font.family: Theme.font
        scale: 2.25
        transformOrigin: Item.Center
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: levelText
        width: root.level >= 100 ? 24 : root.level <= 9 ? 8 : 16
        height: parent.height
        anchors.left: iconText.right
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1
        text: root.level
        color: Theme.text
        font {
            family: Theme.font
            pixelSize: Theme.fontSize
            bold: true
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.muteUnmute()
        onWheel: wheel.angleDelta.y > 0 ? root.volumeMod("up") : root.volumeMod("down")
    }
}
