import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Io

Item {
    id: mprisModule

    property var currentPlayer: null
    property real volumeStep: 0.05

    function pickCurrentPlayer() {
        const players = (Mpris.players && Mpris.players.values) ? Mpris.players.values : [];
        if (!players || players.length === 0) return null;

        const spotify = players.find(p => ((p.identity || "").toLowerCase().includes("spotify")));
        if (spotify) return spotify;

        const playing = players.find(p => p.playbackStatus === "Playing" || p.isPlaying === true);
        if (playing) return playing;

        return players[0] || null;
    }

    function refreshCurrentPlayer() {
        currentPlayer = pickCurrentPlayer();
    }

    Connections {
        target: Mpris
        ignoreUnknownSignals: true

        function onPlayersChanged() {
            refreshCurrentPlayer();
        }
    }

    Connections {
        target: Mpris.players
        ignoreUnknownSignals: true

        function onCountChanged() {
            refreshCurrentPlayer();
        }

        function onValuesChanged() {
            refreshCurrentPlayer();
        }

        function onRowsInserted() {
            refreshCurrentPlayer();
        }

        function onRowsRemoved() {
            refreshCurrentPlayer();
        }

        function onModelReset() {
            refreshCurrentPlayer();
        }
    }

    Component.onCompleted: {
        refreshCurrentPlayer();
        startupRefresh.running = true;
    }

    Timer {
        id: startupRefresh
        interval: 200
        repeat: true
        running: false
        triggeredOnStart: true
        property int attempts: 0
        onTriggered: {
            attempts++;
            refreshCurrentPlayer();
            if (currentPlayer || attempts >= 10) running = false;
        }
    }

    property string title: currentPlayer && currentPlayer.metadata["xesam:title"] || ""
    property string artist: currentPlayer && currentPlayer.metadata["xesam:artist"]?.join(", ") || ""

    property string effectiveIcon: {
        if (!currentPlayer) return "";
        const id = (currentPlayer.identity || "").toString().toLowerCase();
        if (id.includes("spotify")) return "";
        if (id.includes("helium")) return "";
        return "";
    }

    implicitHeight: 32
    implicitWidth: row.implicitWidth

    Item {
        id: container
        width: row.implicitWidth
        height: 32

        RowLayout {
            id: row
            spacing: 6

            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            visible: !!currentPlayer && currentPlayer.playbackStatus !== "Stopped"

            Text {
                id: iconText
                text: effectiveIcon
                color: "#c8c8e6"
                font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                scale: 1.6
            }

            Text {
                id: trackText
                text: title + " - " + artist
                color: "#c8c8e6"
                font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                elide: Text.ElideRight
            }
        }

        MouseArea {
            anchors.left: row.left
            anchors.right: row.right
            anchors.top: parent.top
            anchors.topMargin: -1
            anchors.bottom: parent.bottom
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

            onClicked: event => {
                if (!currentPlayer) return;
                if (event.button === Qt.LeftButton) {
                    if (currentPlayer.isPlaying == true) {
                        currentPlayer.pause();
                    } else {
                        currentPlayer.play();
                    }
                } else if (event.button === Qt.MiddleButton) {
                    currentPlayer.previous();
                } else if (event.button === Qt.RightButton) {
                    currentPlayer.next();
                }
            }

            onWheel: {
                if (wheel.angleDelta.y > 0) {
                    playerVolumeMod("up");
                } else {
                    playerVolumeMod("down");
                }
            }
        }
    }

    function playerVolumeMod(direction) {
                if (!currentPlayer) return;

                const dir = (direction === "up" || direction === "down") ? direction : "noop";
                const identity = (currentPlayer.identity || "").toString();
                const isSpotify = identity.toLowerCase().includes("spotify");

                if (isSpotify) {
                        const spotifyScript = `
                            dir="$1"
                            step="$2"

                            cur=$(playerctl -p spotify volume 2>/dev/null)
                            if [ -z "$cur" ]; then
                                exit 0
                            fi

                            new=$(awk -v cur="$cur" -v step="$step" -v dir="$dir" 'BEGIN {
                                cur += 0; step += 0;
                                if (dir=="up") cur += step;
                                else if (dir=="down") cur -= step;
                                if (cur > 1.0) cur = 1.0;
                                if (cur < 0.0) cur = 0.0;
                                printf "%.3f", cur;
                            }')

                            playerctl -p spotify volume "$new" >/dev/null 2>&1 || true
                        `;

                        playerVolumeProc.command = ["sh", "-c", spotifyScript, "--", dir, volumeStep.toString()];
                        playerVolumeProc.running = true;
                        return;
                }

                const pipewireScript = `
                    player="$1"
                    dir="$2"
                    step="$3"

                    id=$(wpctl status | awk -v player="$player" '
                        BEGIN { audio=0; streams=0; candidate="" }
                        /^Audio$/ { audio=1; next }
                        /^Video$/ { audio=0; streams=0 }
                        audio && /Streams:/ { streams=1; next }
                        audio && streams {
                            if (match($0, /^[[:space:]]*([0-9]+)\\.[[:space:]]+(.*)$/, m)) {
                                name=m[2]; sub(/[[:space:]]+$/, "", name);
                                pl=tolower(player); nm=tolower(name);
                                if (nm==pl) { print m[1]; exit }
                                if (candidate=="" && (index(nm, pl) > 0 || index(pl, nm) > 0)) {
                                    if (nm !~ /(input|capture|source|mic)/) candidate=m[1]
                                }
                            }
                        }
                        END {
                            if (candidate != "") print candidate
                        }
                    ')

                    if [ -n "$id" ]; then
                        cur=$(wpctl get-volume "$id" 2>/dev/null | awk '{print $2}')
                        if [ -z "$cur" ]; then
                            exit 0
                        fi

                        new=$(awk -v cur="$cur" -v step="$step" -v dir="$dir" 'BEGIN {
                            cur += 0; step += 0;
                            if (dir=="up") cur += step;
                            else if (dir=="down") cur -= step;
                            if (cur > 1.0) cur = 1.0;
                            if (cur < 0.0) cur = 0.0;
                            printf "%.3f", cur;
                        }')

                        wpctl set-volume "$id" "$new" >/dev/null 2>&1 || true
                    fi
                `;
                playerVolumeProc.command = ["sh", "-c", pipewireScript, "--", identity, dir, volumeStep.toString()];
                playerVolumeProc.running = true;
    }

    Process {
        id: playerVolumeProc
        running: false
        command: ["playerctl", "volume", "-p", "spotify", "0%"]
    }
}
