import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: root

    implicitWidth: level >= 100 ? 40 : level <= 9 ? 24 : 31
    implicitHeight: parent.height

    property PwNode sink: Pipewire.defaultAudioSink
    property int level: sink?.audio ? Math.round(sink.audio.volume * 100) : 0
    property bool muted: sink?.audio?.muted ?? false

    property string icon: {
        if (!sink || !sink.audio) return ""
        if (muted) return level < 50 ? "󰸈" : "󰖁"
        if (level >= 75) return ""
        if (level >= 50) return ""
        if (level >= 25) return ""
        if (level > 0) return ""
        return ""
    }

    readonly property var oversizedIcons: ["󰸈", "󰖁"]
    readonly property real iconScaleCorrection: oversizedIcons.includes(icon) ? 0.8 : 1.0

    PwObjectTracker {
        objects: [root.sink]
    }

    function muteToggle() {
        if (root.sink?.audio) {
            root.sink.audio.muted = !root.sink.audio.muted
        }
    }

    function volumeMod(direction) {
        if (!root.sink?.audio) return
        const step = 0.01
        const delta = direction === "up" ? step : -step
        root.sink.audio.volume = Math.max(0, root.sink.audio.volume + delta)
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
        scale: 2.25 * root.iconScaleCorrection
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
        onClicked: root.muteToggle()
        onWheel: wheel.angleDelta.y > 0 ? root.volumeMod("up") : root.volumeMod("down")
    }
}
