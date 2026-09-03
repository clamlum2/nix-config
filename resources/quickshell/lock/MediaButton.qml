import QtQuick
import "../"

Item {
    id: root
    property string icon: ""
    property int size: 16
    signal clicked

    implicitWidth: size + 12
    implicitHeight: size + 12

    Text {
        anchors.centerIn: parent
        text: root.icon
        color: mouse.containsMouse ? Theme.accent : Theme.text
        font.pixelSize: root.size
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
