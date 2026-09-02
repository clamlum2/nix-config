import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import "../"
import "../bar/modules/"

WlSessionLockSurface {
    id: root
    property var lockContext
    property string wallpaperPath: Quickshell.env("WALLPAPER_PATH") ?? ""

    Image {
        id: wallpaper
        anchors.fill: parent
        source: root.wallpaperPath ? "file://" + root.wallpaperPath : ""
        fillMode: Image.PreserveAspectCrop
        visible: false
    }

    MultiEffect {
        anchors.fill: parent
        source: wallpaper
        blurEnabled: true
        blur: 1.0
        blurMax: 64
        autoPaddingEnabled: false
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.35
    }

    Item {
        id: lockGroup
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -48

        readonly property real spacing: 16
        width: Math.max(clock.implicitWidth, passwordField.width)
        height: clock.implicitHeight + spacing + passwordField.height

        Clock {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }

        InputField {
            id: passwordField
            lockContext: root.lockContext
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: clock.bottom
            anchors.topMargin: lockGroup.spacing
        }

        LockBattery {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: passwordField.bottom
            anchors.topMargin: lockGroup.spacing
        }
    }
}
