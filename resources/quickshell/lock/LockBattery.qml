import QtQuick
import "../"
import "../services" as Services

Item {
    id: root
    property int level: Services.Battery.level
    property string icon: Services.Battery.icon

    implicitWidth: Math.max(iconText.implicitWidth, levelText.implicitWidth)
    implicitHeight: row.height

    Row {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        Text {
            id: iconText
            text: root.icon
            color: Theme.text
            anchors.verticalCenter: parent.verticalCenter
            font {
                family: Theme.font
                pixelSize: 24
                bold: true
            }
        }

        Text {
            id: levelText
            text: root.level
            color: Theme.text
            anchors.verticalCenter: parent.verticalCenter
            font {
                family: Theme.font
                pixelSize: 24
                bold: true
            }
        }
    }
}
