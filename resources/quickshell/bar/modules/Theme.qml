// Theme.qml
pragma Singleton
import QtQuick

QtObject {
    // Colors
    readonly property color background: "#0C0F1B"
    readonly property color text: "#c8c8e6"
    readonly property color primary: "#4ea1ff"
    readonly property color secondary: "#6c8aff"
    readonly property color inactive: "#595959"
    readonly property color muted: "#44475a"

    // Typography
    readonly property string font: "DejaVuSansM Nerd Font Mono"
    readonly property int fontSize: 14

    // Layout
    readonly property int barHeight: 32
}
