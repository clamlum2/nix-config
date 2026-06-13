import Quickshell.Io
import QtQuick

Item {
    id: root
    height: 32
    width: row.width

    implicitWidth: row.width
    implicitHeight: 32

    property string outputName: ""
    property var workspaceData: []

    Process {
        id: workspacesProc
        command: ["sh", "-c", "niri msg -j workspaces | jq -c ."]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    const p = JSON.parse(data.trim());
                    if (Array.isArray(p))
                        root.workspaceData = p;
                } catch (e) {}
            }
        }
    }

    Process {
        id: eventStream
        command: ["niri", "msg", "-j", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: workspacesProc.running = true
        }
    }

    Process {
        id: focusProc
        command: ["niri", "msg", "action", "focus-workspace", "1"]
    }

    function focusWorkspace(idx) {
        focusProc.command = ["niri", "msg", "action", "focus-workspace", String(idx)];
        focusProc.running = true;
    }

    Row {
        id: row
        height: parent.height
        spacing: 0

        Repeater {
            model: root.workspaceData.filter(w => w.output === root.outputName).filter(w => w.is_focused || w.active_window_id !== null).sort((a, b) => a.idx - b.idx)

            Item {
                required property var modelData
                width: 20
                height: row.height

                Rectangle {
                    id: visual
                    width: parent.width
                    height: 24
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: modelData.idx
                    color: (modelData.is_focused && modelData.active_window_id === null) ? "#595959" : "#6c8aff"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.horizontalCenter: visual.horizontalCenter
                    anchors.verticalCenter: visual.verticalCenter
                    anchors.verticalCenterOffset: -2 - (3 * 0.5)  // textYOffset - underlineHeight * 0.5
                }

                Rectangle {
                    width: visual.width
                    height: 3
                    color: modelData.is_focused ? "#4ea1ff" : "transparent"
                    anchors.horizontalCenter: visual.horizontalCenter
                    anchors.bottom: visual.bottom
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.focusWorkspace(modelData.idx)
                }
            }
        }
    }
}
