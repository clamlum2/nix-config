import Quickshell
import QtQuick
import QtQuick.Layouts
import "modules"
import "../"

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    property bool bottom: Config.barPosition === "bottom"

    anchors.top: !bottom
    anchors.bottom: bottom
    anchors.left: true
    anchors.right: true

    implicitHeight: Theme.barHeight
    color: Theme.background

    Item {
        id: barContent

        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 8
        anchors.bottomMargin: 8

        // LEFT SECTION
        RowLayout {
            id: leftSection
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            spacing: 8

            Workspaces {
                Layout.alignment: Qt.AlignVCenter
                outputName: root.screen.name
            }

            Windows {
                Layout.alignment: Qt.AlignVCenter
            }
        }

        // CENTER SECTION
        Item {
            id: centerSection

            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter

            width: Math.min(barContent.width * 0.5, 500)
            height: parent.height

            Mpris {
                id: mprisModule
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // RIGHT SECTION
        RowLayout {
            id: rightSection

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            SystemTray {
                isBottom: root.bottom
            }

            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 20
                color: Theme.muted
            }

            Item {}
            Volume {
                id: volumeModule
                Layout.preferredWidth: implicitWidth
                Layout.alignment: Qt.AlignVCenter
            }
            Item {}

            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 20
                color: Theme.muted
            }

            Microphone {
                id: microphoneModule
                Layout.preferredWidth: implicitWidth
                Layout.alignment: Qt.AlignVCenter
            }

            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 20
                color: Theme.muted
            }

            Bluetooth {
                id: bluetoothModule
                Layout.preferredWidth: implicitWidth
                Layout.alignment: Qt.AlignVCenter
            }

            Network {
                id: network
                Layout.preferredWidth: implicitWidth
                Layout.alignment: Qt.AlignVCenter
            }

            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 20
                color: Theme.muted
                visible: batteryModule.available
            }

            Battery {
                id: batteryModule
                Layout.preferredWidth: implicitWidth
                Layout.alignment: Qt.AlignVCenter
            }

            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 20
                color: Theme.muted
            }

            TimeDisplay {
                id: timeDisplay
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignVCenter
            }

            Item {}
        }
    }
}
// qmllint enable uncreatable-type
