pragma Singleton
import QtQuick
import Quickshell.Services.UPower

QtObject {
    id: root

    property var batteryDevice: {
        for (const d of UPower.devices.values) {
            if (d.isLaptopBattery) return d
        }
        return null
    }

    readonly property bool available: batteryDevice !== null && batteryDevice.ready
    readonly property bool charging: batteryDevice?.state === UPowerDeviceState.Charging
    readonly property int level: batteryDevice ? Math.round(batteryDevice.percentage * 100) : 0

    readonly property string icon: {
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
}
