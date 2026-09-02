import QtQuick
import "../"

Item {
    id: root

    property string time: Qt.formatDateTime(new Date(), "hh:mm")
    property string date: Qt.formatDateTime(new Date(), "ddd MMM dd")

    implicitWidth: Math.max(time.implicitWidth, date.implicitWidth)
    implicitHeight: column.height

    Column {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0

        Text {
            id: time
            text: root.time
            color: Theme.text
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                family: Theme.font
                pixelSize: 64
                bold: true
            }
        }
        Text {
            id: date
            text: root.date
            color: Theme.text
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                family: Theme.font
                pixelSize: 32
                bold: true
            }
        }
    }
}
