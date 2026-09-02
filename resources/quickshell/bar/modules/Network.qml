import QtQuick
import Quickshell.Networking
import qs

Item {
    id: root

    implicitWidth: 20
    implicitHeight: parent.height

    property var ethernetDevice: {
        for (const d of Networking.devices.values)
            if (d.type === DeviceType.Wired) return d
        return null;
    }

    property var wifiDevice: {
        for (const d of Networking.devices.values)
            if (d.type === DeviceType.Wifi) return d
        return null;
    }

    property bool ethernetStatus: ethernetDevice?.connected ?? false
    property bool wifiStatus: wifiDevice?.connected ?? false

    property int wifiStrength: {
        if (!wifiDevice) return 0;
        const net = wifiDevice.networks.values.find(n => n.connected);
        return net ? Math.round(net.signalStrength * 100) : 0
    }

    property string wifiStrengthIcon: wifiStrength > 75 ? "󰤨" : wifiStrength > 50 ? "󰤥" : wifiStrength > 25 ? "󰤢" : "󰤟"
    property string icon: ethernetStatus ? "" : wifiStatus ? wifiStrengthIcon : "󰌙"

    Text {
        id: network_status
        text: root.icon
        color: Theme.text
        font.family: Theme.font
        scale: 1.9
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
