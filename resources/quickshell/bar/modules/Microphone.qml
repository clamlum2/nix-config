import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: root

    implicitWidth: 16
    implicitHeight: parent.height

    property PwNode source: Pipewire.defaultAudioSource
    property bool muted: source?.audio?.muted ?? false
    property string icon: muted ? "" : ""

    PwObjectTracker {
        objects: [root.source]
    }

    function toggle() {
        if (root.source?.audio)
            root.source.audio.muted = !root.source.audio.muted
    }

    Text {
        id: microphone
        width: parent.width
        height: parent.height
        text: root.icon
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: 28
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggle()
    }
}
