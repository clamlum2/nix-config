pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property alias barPosition: adapter.barPosition

    FileView {
        path: Quickshell.env("HOME") + "/.config/quickshell/bar-state.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        // qmllint disable unresolved-type
        JsonAdapter {
            id: adapter
            property string barPosition: "top"
        }
        // qmllint enable unresolved-type
    }
}
