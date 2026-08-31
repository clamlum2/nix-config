pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string barPosition: "bottom"

    function toggle() {
        root.barPosition = root.barPosition === "top" ? "bottom" : "top"
    }

    IpcHandler {
        target: "bar"
        function toggle(): void { root.toggle() }
        function get(): string { return root.barPosition }
    }
}
