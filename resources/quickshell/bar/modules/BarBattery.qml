import QtQuick
import "../../"
import "../../services" as Services

Item {
    id: root

    property bool available: Services.Battery.available
    property int level: Services.Battery.level
    property string icon: Services.Battery.icon

    visible: available
    implicitWidth: available ? (level.toString().length === 3 ? 42 : level.toString().length === 1 ? 26 : 34) : 0
    implicitHeight: parent.height

    Text {
        id: battery_icon
        visible: root.available
        text: root.icon
        width: 12
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
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
