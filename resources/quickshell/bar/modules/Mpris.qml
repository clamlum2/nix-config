import QtQuick
import Quickshell.Services.Mpris
import Quickshell.Io

Item {
    id: mpris

    property bool debug: true

    // Fall back to null if no player is found.
    property var player: null

    // Ordered list of plays by preference.
    property var preferredPlayers: ["kopuz", "spotify", "helium"]

    // How much the mouse wheel changes volume.
    property real volumeStep: 0.05

    // Convenience properties for UI code.
    property string title: player && player.metadata && player.metadata["xesam:title"] || ""
    property string artist: player && player.metadata && player.metadata["xesam:artist"]?.join(", ") || ""
    property string trackText: title && artist ? (title + " - " + artist) : (title || artist || "")
    property bool active: !!player && player.playbackStatus !== "Stopped"
    property string identity: (player && player.identity || "").toString()

    // Best-effort name for playerctl; works for common players like Spotify.
    property string playerctlName: identity.toLowerCase().replace(/\s+/g, "")

    // Icon to display next to the track text.
    property string icon: {
        const id = identity.toLowerCase();
        if (id.includes("spotify"))
            return "";
        if (id.includes("helium"))
            return "";
        return "";
    }

    // Small helper so we don’t repeat the defensive checks.
    function players() {
        return (Mpris.players && Mpris.players.values) ? Mpris.players.values : [];
    }

    // Pick a “best” player:
    // 1) if a preferred player is currently playing, pick the highest priority one
    // 2) else if a preferred player exists, pick the highest priority one
    // 3) else if anything is playing, pick that
    // 4) else fall back to the first available player
    function pickPlayer() {
        const list = players();
        if (!list || list.length === 0)
            return null;

        function matches(pref, p) {
            const id = ((p && p.identity) || "").toString().toLowerCase();
            return id.includes(pref);
        }

        function isPlaying(p) {
            return p && (p.playbackStatus === "Playing" || p.isPlaying === true);
        }

        // Preferred + playing
        for (const pref of preferredPlayers) {
            const p = list.find(pl => matches(pref, pl) && isPlaying(pl));
            if (p)
                return p;
        }

        // Preferred (present)
        for (const pref of preferredPlayers) {
            const p = list.find(pl => matches(pref, pl));
            if (p)
                return p;
        }

        // Anything playing
        const playing = list.find(pl => isPlaying(pl));
        return playing || list[0] || null;
    }

    function refresh(reason) {
        player = pickPlayer();

        if (debug) {
            const ids = players().map(p => (p.identity || "<unknown>").toString());
            console.log("[Mpris]", reason || "refresh", "players:", ids, "picked:", player ? player.identity : null);
        }
    }

    // Players can appear shortly after the bar starts.
    // Poll briefly at startup so it reliably picks up Spotify/etc.
    Component.onCompleted: {
        refresh("startup");
        startupPoll.running = true;
    }

    Timer {
        id: startupPoll
        interval: 200
        repeat: true
        running: false
        property int attempts: 0
        onTriggered: {
            attempts++;
            refresh("startup#" + attempts);
            if (player || attempts >= 10)
                running = false;
        }
    }

    // Refresh when Quickshell tells us the player list/model changed.
    Connections {
        target: Mpris
        ignoreUnknownSignals: true
        function onPlayersChanged() {
            refresh("playersChanged");
        }
    }

    Connections {
        target: Mpris.players
        ignoreUnknownSignals: true
        function onValuesChanged() {
            refresh("model.valuesChanged");
        }
        function onCountChanged() {
            refresh("model.countChanged");
        }
        function onModelReset() {
            refresh("model.reset");
        }
    }

    // Basic controls.
    function playPause() {
        if (!player)
            return;
        if (player.isPlaying === true)
            player.pause();
        else
            player.play();
    }

    // Volume control via mouse wheel.
    // Note: not every player supports setting volume; this is best-effort.
    function wheelVolume(deltaY) {
        if (!player)
            return;

        // Prefer the direct MPRIS volume property if it exists.
        if (player.volume !== undefined && player.volume !== null) {
            const dir = deltaY > 0 ? 1 : -1;
            const next = Math.max(0, Math.min(1, (player.volume + dir * volumeStep)));
            try {
                player.volume = next;
                return;
            } catch (e) {
                if (debug)
                    console.log("[Mpris] direct volume set failed:", e);
            }
        }

        // Fallback: call playerctl.
        if (!playerctlName)
            return;
        const sign = deltaY > 0 ? "+" : "-";
        playerctlProc.command = ["playerctl", "-p", playerctlName, "volume", volumeStep.toString() + sign];
        playerctlProc.running = true;
    }

    Process {
        id: playerctlProc
        command: ["true"]
        onExited: {
            if (debug && exitCode !== 0)
                console.log("[Mpris] playerctl failed:", exitCode);
        }
    }

    function next() {
        if (!player)
            return;
        player.next();
    }

    function previous() {
        if (!player)
            return;
        player.previous();
    }
}
