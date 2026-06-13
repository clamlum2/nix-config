import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root
    implicitHeight: Theme.barHeight

    property var preferredPlayers: ["kopuz", "spotify", "helium"]
    property var playerList: Mpris.players ? Mpris.players.values : []

    function matches(pref, p) {
        return ((p?.identity) || "").toString().toLowerCase().includes(pref);
    }
    function isPlaying(p) {
        return p?.playbackStatus === "Playing" || p?.isPlaying === true;
    }

    property var player: {
        const list = playerList;
        if (!list || list.length === 0)
            return null;
        for (const pref of preferredPlayers) {
            const p = list.find(pl => matches(pref, pl) && isPlaying(pl));
            if (p) return p;
        }
        for (const pref of preferredPlayers) {
            const p = list.find(pl => matches(pref, pl));
            if (p) return p;
        }
        return list.find(pl => isPlaying(pl)) || list[0] || null;
    }
    property string title: player?.metadata?.["xesam:title"] || ""
    property string artist: player?.metadata?.["xesam:artist"]?.join(", ") || ""
    property string trackText: title && artist ? (title + " - " + artist) : (title || artist || "")
    property bool active: !!player && player.playbackStatus !== "Stopped"
    property string identity: (player?.identity || "").toString()

    property string icon: {
        const id = identity.toLowerCase();
        if (id.includes("spotify"))
            return "";
        else if (id.includes("helium"))
            return "";
        else if (player !== null)
            return "";
        return "";
    }

    function playPause() {
        if (!player)
            return;
        if (player.isPlaying === true)
            player.pause();
        else
            player.play();
    }

    function previous() {
        if (!player)
            return;
        player.previous();
    }

    function next() {
        if (!player)
            return;
        player.next();
    }

    function wheelVolume(up) {
        if (!player)
            return;
        if (up)
            player.volume = Math.min(1.0, player.volume + 0.05);
        else
            player.volume = Math.max(0.0, player.volume - 0.05);
    }

    Row {
        id: row
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            visible: root.icon !== ""
            text: root.icon
            color: Theme.text
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenterOffset: -2
        }

        Text {
            text: root.trackText
            color: Theme.text
            font {
                pixelSize: 14
                family: Theme.font
                bold: true
            }
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        anchors.horizontalCenter: row.horizontalCenter
        width: row.width
        y: -8
        height: parent.height + 16
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onClicked: event => {
            if (event.button === Qt.LeftButton)
                playPause();
            else if (event.button === Qt.MiddleButton)
                previous();
            else if (event.button === Qt.RightButton)
                next();
        }

        onWheel: {
            wheelVolume(wheel.angleDelta.y > 0);
        }
    }
}
