import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: networkModule

    property bool ethernetStatus: false
    property bool wifiStatus: false
    property string icon: ethernetStatus ? "" : wifiStatus ? "" : ""

    Process {
        id: networkStatusProc
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE device | grep -E 'ethernet|wifi'"]
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("ethernet:connected")) {
                    ethernetStatus = true
                } else if (data.includes("ethernet:disconnected")) {
                    ethernetStatus = false
                }

                if (data.includes("wifi:connected")) {
                    wifiStatus = true
                } else if (data.includes("wifi:disconnected")) {
                    wifiStatus = false
                }
            }
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: networkStatusProc.running = true
    }

    Component.onCompleted: {
        networkStatusProc.running = true
    }
}
