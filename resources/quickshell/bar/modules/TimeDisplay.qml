import QtQuick

Item {
    id: timeDisplay

    property string text: Qt.formatDateTime(new Date(), "ddd MMM dd - hh:mm AP")

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: text = Qt.formatDateTime(new Date(), "ddd MMM dd - hh:mm AP")
    }
}
