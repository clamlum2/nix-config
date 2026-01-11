import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "modules"

PanelWindow {
    id: root

    property bool bottom: false

    anchors.top: !bottom
    anchors.bottom: bottom
    anchors.left: true
    anchors.right: true

    property color backgroundColor: "#0C0F1B"
    property color textColor: "#c8c8e6"
    property color primaryColor: "#4ea1ff"
    property color secondaryColor: "#6c8aff"
    property color inactiveColor: "#595959"
    property color mutedColor: "#44475a"
    property string fontFamily: "DejaVuSansM Nerd Font Mono"
    property int fontSize: 14

    implicitHeight: 32
    color: backgroundColor

    property var classOverrides: {
        "code": { name: "Visual Studio Code", icon: "" },
        "helium": { name: "Helium", icon: "" },
        "spotify": { name: "Spotify", icon: "" },
        "vesktop": { name: "Vesktop", icon: "" },
        "com.mitchellh.ghostty": { name: "Ghostty", icon: "" },
    }

    WindowModule {
        id: windowModule
        classOverrides: root.classOverrides
    }

    Volume {
        id: volumeModule
    }

    Microphone {
        id: microphoneModule
    }

    Network {
        id: network
    }

    Bluetooth {
        id: bluetoothModule
    }

    TimeDisplay {
        id: timeDisplay
    }

    Item {
        id: barContent

        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 8
        anchors.bottomMargin: 8

        Component.onCompleted: {
            console.log("Bar loaded")
        }

        // LEFT SECTION
        RowLayout {
            id: leftSection

            anchors.left: parent.left


            Item {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height + 1

                Workspaces {}
            }

            Item { width: 180 }

            Item {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height

                RowLayout {
                    anchors.fill: parent
                    spacing: 6

                    Text {
                        id: windowIcon
                        text: windowModule.displayIcon
                        color: textColor
                        font.pixelSize: root.fontSize
                        scale: 1.1
                    }

                    Text {
                        id: windowTitle
                        text: windowModule.displayName
                        color: textColor
                        font { family: root.fontFamily; pixelSize: fontSize; bold: true }
                    }
                }
            }
        }

        // CENTER SECTION
        Item {
            id: centerSection

            anchors.bottom: parent.bottom
            anchors.bottomMargin: -1
            anchors.horizontalCenter: parent.horizontalCenter

            width: Math.min(barContent.width * 0.5, 500)
            height: parent.height

            Mpris {
                id: mprisModule
                anchors.centerIn: parent
            }
        }

        // RIGHT SECTION
        RowLayout {
            id: rightSection

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            SystemTray {}

            Rectangle {
                width:1
                height:20
                color: mutedColor
            }

            Item {}

            Item {
                width: 32
                height: 32

                Text {
                    id: volume_icon
                    width: 16
                    height: parent.height
                    text: volumeModule.icon
                    color: textColor
                    font.family: root.fontFamily
                    scale: 2.25
                    transformOrigin: Item.Center
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 1
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: volume_level
                    width: 16
                    height: parent.height
                    text: volumeModule.level
                    color: textColor
                    font { family: root.fontFamily; pixelSize: fontSize; bold: true }
                    transformOrigin: Item.Center
                    anchors.left: volume_icon.right
                    anchors.leftMargin: 2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 1
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: volumeModule.muteUnmute()
                    onWheel: {
                        if (wheel.angleDelta.y > 0) {
                            volumeModule.volumeMod("up")
                        } else {
                            volumeModule.volumeMod("down")
                        }
                    }
                }
            }

            Item {}

            Rectangle {
                width:1
                height:20
                color: mutedColor
            }

            Item {
                width: 16
                height: 32

                Text {
                    id: microphone
                    width: parent.width
                    height: parent.height
                    text: microphoneModule.icon
                    color: textColor
                    font.family: root.fontFamily
                    scale: 2.5
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: microphoneModule.toggle()
                }
            }

            Rectangle {
                width:1
                height:20
                color: mutedColor
            }

            Item {
                width: 16
                height: 32
                Text {
                    id: bluetooth_status
                    text: bluetoothModule.icon
                    color: textColor
                    font.family: root.fontFamily
                    scale: 1.5
                    width: parent.width
                    height: parent.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: bluetoothModule.toggle()
                }
            }

            Rectangle {
                width:1
                height:20
                color: mutedColor
            }

            Item {
                width: 16
                height: 32
                Text {
                    id: network_status
                    text: network.icon
                    color: textColor
                    font.family: root.fontFamily
                    scale: 1.9
                    width: parent.width
                    height: parent.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width:1
                height:20
                color: mutedColor
            }

            Item {}

            Text {
                id: clock
                text: timeDisplay.text
                color: textColor
                font { family: root.fontFamily; pixelSize: fontSize; bold: true}
            }

            Item {}
        }
    }
}