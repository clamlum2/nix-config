import QtQuick
import QtQuick.Layouts
import "../"
import "../services" as Services

Item {
    id: root
    implicitWidth: 280
    implicitHeight: 72
    visible: Services.Mpris.active

    readonly property string title: Services.Mpris.title
    readonly property string artist: Services.Mpris.artist
    readonly property string album: Services.Mpris.album

    RowLayout {
        anchors.fill: parent
        spacing: 14

        Rectangle {
            Layout.preferredWidth: root.implicitHeight
            Layout.preferredHeight: root.implicitHeight
            radius: 8
            color: Theme.surface
            clip: true

            Image {
                id: art
                anchors.fill: parent
                source: Services.Mpris.artUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: false
                mipmap: true
                smooth: true
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                visible: art.status !== Image.Ready
                text: Services.Mpris.icon !== "" ? Services.Mpris.icon : ""
                color: Theme.subtext
                font.pixelSize: 24
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                Layout.fillWidth: true
                text: Services.Mpris.title || "Nothing playing"
                color: Theme.text
                font { pixelSize: 15; family: Theme.font; bold: true }
                elide: Text.ElideRight
            }
            Text {
                Layout.fillWidth: true
                text: artist
                color: Theme.textSecondary
                font { pixelSize: 12; family: Theme.font }
                elide: Text.ElideRight
                visible: text !== ""
            }
            Text {
                Layout.fillWidth: true
                text: album
                color: Theme.textSecondary
                font { pixelSize: 12; family: Theme.font }
                elide: Text.ElideRight
                visible: text !== ""
            }

            RowLayout {
                spacing: 18
                Layout.topMargin: -4

                MediaButton {
                    icon: ""
                    onClicked: Services.Mpris.previous()
                }
                MediaButton {
                    icon: Services.Mpris.player?.isPlaying ? "" : ""
                    size: 20
                    onClicked: Services.Mpris.playPause()
                }
                MediaButton {
                    icon: ""
                    onClicked: Services.Mpris.next()
                }
            }
        }
    }
}
