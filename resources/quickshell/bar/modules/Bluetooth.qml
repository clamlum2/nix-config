import Quickshell.Bluetooth
import QtQuick
import "../../"

Item {
    id: root

    visible: available

    implicitWidth: available ? 16 : 0
    implicitHeight: parent.height

    property bool available: Bluetooth.defaultAdapter !== null
    property bool bluetoothStatus: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false
    property string icon: bluetoothStatus ? "" : "󰂲"

    function toggle() {
        if (Bluetooth.defaultAdapter)
            Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
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
