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

    WindowModule {
        id: windowModule
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
    Battery {
        id: batteryModule
    }

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
            anchors.bottom: parent.bottom
            height: parent.height
            spacing: 10

            WorkspacesAuto {
                Layout.alignment: Qt.AlignBottom
                Layout.bottomMargin: 0
            }

            Text {
                id: windowIcon
                text: windowModule.displayIcon
                color: textColor
                font.pixelSize: root.fontSize
                scale: 1.1
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                verticalAlignment: Text.AlignVCenter
                Layout.bottomMargin: 17
            }

            Text {
                id: windowTitle
                text: windowModule.displayName
                color: textColor
                font {
                    family: root.fontFamily
                    pixelSize: fontSize
                    bold: true
                }
                elide: Text.ElideRight
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                verticalAlignment: Text.AlignVCenter
                Layout.bottomMargin: 15
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
                debug: false
            }

            Item {
                id: mprisDisplay
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                visible: mprisModule.active

                RowLayout {
                    id: mprisRow
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: mprisModule.icon
                        color: textColor
                        font {
                            family: root.fontFamily
                            pixelSize: fontSize
                            bold: true
                        }
                        scale: 1.4
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        id: mprisTrack
                        text: mprisModule.trackText
                        color: textColor
                        font {
                            family: root.fontFamily
                            pixelSize: fontSize
                            bold: true
                        }
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        // Size to content, but cap to available space so eliding works.
                        width: Math.min(implicitWidth, Math.max(0, mprisDisplay.width - 32))
                    }
                }

                MouseArea {
                    // Extend into barContent's top/bottom padding so the MPRIS area
                    // is clickable across the full bar height (even at screen edges).
                    anchors.horizontalCenter: mprisRow.horizontalCenter
                    width: mprisRow.width
                    y: -barContent.anchors.topMargin
                    height: parent.height + barContent.anchors.topMargin + barContent.anchors.bottomMargin
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                    onClicked: event => {
                        if (event.button === Qt.LeftButton)
                            mprisModule.playPause();
                        else if (event.button === Qt.MiddleButton)
                            mprisModule.previous();
                        else if (event.button === Qt.RightButton)
                            mprisModule.next();
                    }

                    onWheel: {
                        mprisModule.wheelVolume(wheel.angleDelta.y);
                    }
                }
            }
        }

        // RIGHT SECTION
        RowLayout {
            id: rightSection

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            SystemTray {}

            Rectangle {
                width: 1
                height: 20
                color: mutedColor
            }
            Item {}

            Item {
                Layout.preferredWidth: volumeModule.level >= 100 ? 40 : 32
                height: 32

                Text {
                    id: volume_icon
                    width: 12
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
                    width: volumeModule.level >= 100 ? 24 : 16
                    height: parent.height
                    text: volumeModule.level
                    color: textColor
                    font {
                        family: root.fontFamily
                        pixelSize: fontSize
                        bold: true
                    }
                    transformOrigin: Item.Center
                    anchors.left: volume_icon.right
                    anchors.leftMargin: 6
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
                        if (wheel.angleDelta.y > 0)
                            volumeModule.volumeMod("up");
                        else
                            volumeModule.volumeMod("down");
                    }
                }
            }

            Item {}
            Rectangle {
                width: 1
                height: 20
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
                width: 1
                height: 20
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

            Item {
                width: 32
                height: 32
                visible: batteryModule.available

                Text {
                    id: battery_icon
                    width: 14
                    height: parent.height
                    text: batteryModule.icon
                    color: textColor
                    font.family: root.fontFamily
                    scale: 1.5
                    transformOrigin: Item.Center
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 0
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: battery_level
                    width: 16
                    height: parent.height
                    text: batteryModule.level
                    color: textColor
                    font {
                        family: root.fontFamily
                        pixelSize: fontSize
                        bold: true
                    }
                    transformOrigin: Item.Center
                    anchors.left: battery_icon.right
                    anchors.leftMargin: 2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 1
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width: 1
                height: 20
                color: mutedColor
                visible: batteryModule.available
            }

            Rectangle {
                width: 1
                height: 20
                color: mutedColor
            }
            Item {}

            Text {
                id: clock
                text: timeDisplay.text
                color: textColor
                font {
                    family: root.fontFamily
                    pixelSize: fontSize
                    bold: true
                }
            }

            Item {}
        }
    }
}
