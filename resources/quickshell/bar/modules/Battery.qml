import QtQuick
import Quickshell.Services.UPower
import qs

Item {
    id: root

    property var batteryDevice: {
        for (const d of UPower.devices.values) {
            if (d.isLaptopBattery) return d
        }
        return null
    }

    property bool available: batteryDevice !== null && batteryDevice.ready
    property bool charging: batteryDevice?.state === UPowerDeviceState.Charging
    property int level: batteryDevice ? Math.round(batteryDevice.percentage * 100) : 0

    property string icon: {
        if (!available) return "󰂎"
        if (charging) return "󰂄"
        if (level >= 90) return "󰁹"
        if (level >= 80) return "󰂀"
        if (level >= 70) return "󰁿"
        if (level >= 60) return "󰁾"
        if (level >= 50) return "󰁽"
        if (level >= 40) return "󰁼"
        if (level >= 30) return "󰁻"
        if (level >= 20) return "󰁺"
        if (level >= 10) return "󰂃"
        return "󰂎"
    }

    visible: available
    implicitWidth: available ? (level.toString().length === 3 ? 42 : level.toString().length === 1 ? 26 : 34) : 0
    implicitHeight: parent.height

    Component.onCompleted: {
        console.log(available)
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
