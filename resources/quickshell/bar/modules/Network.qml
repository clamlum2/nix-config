import QtQuick
import Quickshell.Io

Item {
    id: networkModule

    property bool ethernetStatus: false
    property bool wifiStatus: false
    property int wifiStrength: 0
    property string icon: ethernetStatus ? "" : wifiStatus ? wifiStrengthIcon : "󰌙"
    property string wifiStrengthIcon: wifiStrength > 75 ? "󰤨" : wifiStrength > 50 ? "󰤥" : wifiStrength > 25 ? "󰤢" : "󰤟"

    Process {
        id: networkStatusProc
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE device | grep -E 'ethernet|wifi'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("ethernet:connected")) {
                    networkModule.ethernetStatus = true;
                } else if (data.includes("ethernet:disconnected")) {
                    networkModule.ethernetStatus = false;
                }

                if (data.includes("wifi:connected")) {
                    networkModule.wifiStatus = true;
                } else if (data.includes("wifi:disconnected")) {
                    networkModule.wifiStatus = false;
                }
            }
        }
    }

    Process {
        id: wifiStrengthProc
        command: ["sh", "-c", "nmcli -t -f active,signal dev wifi list | grep '^yes' | cut -d: -f2"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                networkModule.wifiStrength = data;
            }
        }
    }

    Process {
        id: monitor
        command: ["sh", "-c", "nmcli m"]
        running: true
        stdout: SplitParser {
            onRead: networkStatusProc.running = true
        }
    }

    Timer {
        id: wifiStrengthTimer
        interval: 5000
        repeat: true
        running: true
        onTriggered: wifiStrengthProc.running = true
    }
}
