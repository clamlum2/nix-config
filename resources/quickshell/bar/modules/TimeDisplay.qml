import QtQuick

Item {
    id: root

    implicitWidth: clock.implicitWidth
    implicitHeight: Theme.barHeight


    property string text: Qt.formatDateTime(new Date(), "ddd MMM dd - hh:mm AP")

    Timer {
        id: clockTimer
        interval: {
            const now = new Date();
            return (60 - now.getSeconds()) * 1000 - now.getMilliseconds();
        }
        repeat: false
        running: true
        onTriggered: {
            root.text = Qt.formatDateTime(new Date(), "ddd MMM dd - hh:mm AP");
            interval = 60000;
            repeat = true;
            start();
        }
    }

    Text {
        id: clock
        text: root.text
        color: Theme.text
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1.5

        font {
            family: Theme.font
            pixelSize: Theme.fontSize
            bold: true
        }
    }
}
