import Quickshell.Hyprland
import QtQuick

Item {
    id: workspaces

    implicitHeight: childrenRect.height
    implicitWidth: childrenRect.width

    property color primaryColor: "#4ea1ff"
    property color secondaryColor: "#6c8aff"
    property color inactiveColor: "#595959"
    property real fontSize: 14.5
    property int spacing: 0

    property int itemWidth: 20
    property int itemHeight: 24
    property int underlineHeight: 3

    property int hitboxHeight: 32
    readonly property real effectiveHeight: (workspaces.parent && workspaces.parent.height > 0)
        ? workspaces.parent.height
        : workspaces.hitboxHeight

    height: effectiveHeight

    property color underlineActiveColor: primaryColor
    property color underlineInactiveColor: "transparent"

    property real textYOffset: -2
    property real visualYOffset: 0

    Row {
        id: row
        spacing: workspaces.spacing
        height: workspaces.effectiveHeight

        Repeater {
            model: 9

            Item {
                width: workspaces.itemWidth
                height: workspaces.effectiveHeight

                property int workspaceId: index + 1
                property var workspace: Hyprland.workspaces.values.find(ws => ws.id === workspaceId) || null
                property bool isActive: (Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === workspaceId)
                property bool hasWindows: workspace !== null

                Rectangle {
                    id: visual
                    width: parent.width
                    height: workspaces.itemHeight
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.topMargin: workspaces.visualYOffset
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: parent.workspaceId
                    color: parent.isActive
                        ? workspaces.secondaryColor
                        : (parent.hasWindows ? workspaces.secondaryColor : workspaces.inactiveColor)
                    font.pixelSize: workspaces.fontSize
                    font.bold: true
                    anchors.horizontalCenter: visual.horizontalCenter
                    anchors.verticalCenter: visual.verticalCenter
                    anchors.verticalCenterOffset: workspaces.textYOffset - (workspaces.underlineHeight * 0.5)
                }

                Rectangle {
                    width: visual.width
                    height: workspaces.underlineHeight
                    color: parent.isActive ? workspaces.underlineActiveColor : workspaces.underlineInactiveColor
                    anchors.horizontalCenter: visual.horizontalCenter
                    anchors.bottom: visual.bottom
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + parent.workspaceId)
                }
            }
        }
    }
}