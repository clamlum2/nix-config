import Quickshell
import Quickshell.Io
import QtQuick

Item {
	id: workspaces

	implicitHeight: childrenRect.height
	implicitWidth: childrenRect.width

	// Match styling/behavior of `Workspaces.qml`
	property color primaryColor: "#4ea1ff"
	property color secondaryColor: "#6c8aff"
	property color inactiveColor: "#595959"
	property real fontSize: 14.5
	property int spacing: 0

	property int itemWidth: 20
	property int itemHeight: 24
	property int underlineHeight: 3

	property int hitboxHeight: 32
	readonly property real effectiveHeight: (workspaces.parent && workspaces.parent.height > 0)
		? workspaces.parent.height
		: workspaces.hitboxHeight

	height: effectiveHeight

	property color underlineActiveColor: primaryColor
	property color underlineInactiveColor: "transparent"

	property real textYOffset: -1
	property real visualYOffset: 0

	// Raw IPC snapshots
	property var niriWorkspaces: []
	property var occupiedWorkspaceIds: ({}) // workspace_id -> true

	// Render model (array of { idx, isFocused, occupied })
	property var displayWorkspaces: []

	function _uniqueSortedInts(values) {
		const seen = {}
		const out = []
		for (let i = 0; i < values.length; i++) {
			const v = parseInt(values[i])
			if (!isFinite(v)) continue
			if (seen[v]) continue
			seen[v] = true
			out.push(v)
		}
		out.sort((a, b) => a - b)
		return out
	}

	function _focusedWorkspace(all) {
		if (!all || all.length === 0) return null
		let ws = all.find(w => w && w.is_focused)
		if (ws) return ws
		ws = all.find(w => w && w.is_active)
		return ws || all[0]
	}

	function recomputeDisplay() {
		const all = workspaces.niriWorkspaces || []
		const focused = _focusedWorkspace(all)
		if (!focused || focused.output === null || focused.output === undefined) {
			workspaces.displayWorkspaces = []
			return
		}

		const outputName = focused.output
		const onOutput = all.filter(w => w && w.output === outputName)

		const occupiedIdxs = []
		let maxIdx = 0

		for (let i = 0; i < onOutput.length; i++) {
			const w = onOutput[i]
			const idx = parseInt(w.idx)
			if (!isFinite(idx)) continue
			if (idx > maxIdx) maxIdx = idx

			const occupied = (workspaces.occupiedWorkspaceIds && workspaces.occupiedWorkspaceIds[w.id] === true)
				|| (w.active_window_id !== null && w.active_window_id !== undefined)
				|| (w.is_active === true)
				|| (w.is_focused === true)
				|| (w.is_urgent === true)

			if (occupied) occupiedIdxs.push(idx)
		}

		const baseIdxs = _uniqueSortedInts(occupiedIdxs.concat([focused.idx]))
		const baseMax = baseIdxs.length > 0 ? baseIdxs[baseIdxs.length - 1] : Math.max(1, maxIdx)
		const nextIdx = baseMax + 1

		const idxsToShow = _uniqueSortedInts(baseIdxs.concat([nextIdx]))

		const nextModel = idxsToShow.map(idx => {
			const w = onOutput.find(x => x && parseInt(x.idx) === idx) || null
			const occupied = !!(w && (
				(workspaces.occupiedWorkspaceIds && workspaces.occupiedWorkspaceIds[w.id] === true)
				|| (w.active_window_id !== null && w.active_window_id !== undefined)
				|| (w.is_active === true)
				|| (w.is_focused === true)
				|| (w.is_urgent === true)
			))
			return {
				idx,
				isFocused: !!(w && w.is_focused === true),
				occupied,
			}
		})

		workspaces.displayWorkspaces = nextModel
	}

	function refresh() {
		windowsProc.running = true
		workspacesProc.running = true
	}

	Component.onCompleted: {
		// Try event-stream for instant updates; polling is enabled if it exits.
		eventStreamProc.running = true
		refresh()
	}

	// Use jq to force single-line JSON so SplitParser is safe.
	Process {
		id: workspacesProc
		command: ["sh", "-c", "niri msg -j workspaces | jq -c ."]
		stdout: SplitParser {
			onRead: data => {
				try {
					const parsed = JSON.parse(data.trim())
					if (Array.isArray(parsed)) {
						workspaces.niriWorkspaces = parsed
						workspaces.recomputeDisplay()
					}
				} catch (e) {
					// Keep last good snapshot
				}
			}
		}
	}

	Process {
		id: windowsProc
		command: ["sh", "-c", "niri msg -j windows | jq -c ."]
		stdout: SplitParser {
			onRead: data => {
				try {
					const parsed = JSON.parse(data.trim())
					if (Array.isArray(parsed)) {
						const occ = ({})
						for (let i = 0; i < parsed.length; i++) {
							const win = parsed[i]
							if (!win) continue
							const wsid = win.workspace_id
							if (wsid !== null && wsid !== undefined) occ[wsid] = true
						}
						workspaces.occupiedWorkspaceIds = occ
						workspaces.recomputeDisplay()
					}
				} catch (e) {
					// Keep last good snapshot
				}
			}
		}
	}

	Timer {
		id: pollTimer
		interval: 500
		repeat: true
		running: false
		onTriggered: workspaces.refresh()
	}

	Timer {
		id: refreshDebounce
		interval: 50
		repeat: false
		running: false
		onTriggered: workspaces.refresh()
	}

	Process {
		id: eventStreamProc
		command: ["niri", "msg", "-j", "event-stream"]
		stdout: SplitParser {
			onRead: _ => {
				refreshDebounce.stop()
				refreshDebounce.start()
			}
		}
		onExited: {
			// If event-stream isn't available or niri isn't running, fall back to polling.
			pollTimer.running = true
		}
	}

	Process {
		id: focusProc
		command: ["niri", "msg", "action", "focus-workspace", "1"]
	}

	function focusWorkspace(idx) {
		focusProc.command = ["niri", "msg", "action", "focus-workspace", String(idx)]
		focusProc.running = true
	}

	Row {
		id: row
		spacing: workspaces.spacing
		height: workspaces.effectiveHeight

		Repeater {
			model: workspaces.displayWorkspaces

			Item {
				required property var modelData

				width: workspaces.itemWidth
				height: workspaces.effectiveHeight

				property int workspaceIdx: modelData.idx
				property bool isActive: modelData.isFocused
				property bool hasWindows: modelData.occupied

				Rectangle {
					id: visual
					width: parent.width
					height: workspaces.itemHeight
					color: "transparent"
					anchors.top: parent.top
					anchors.topMargin: workspaces.visualYOffset
					anchors.horizontalCenter: parent.horizontalCenter
				}

				Text {
					text: parent.workspaceIdx
					color: parent.isActive
						? workspaces.secondaryColor
						: (parent.hasWindows ? workspaces.secondaryColor : workspaces.inactiveColor)
					font.pixelSize: workspaces.fontSize
					font.bold: true
					anchors.horizontalCenter: visual.horizontalCenter
					anchors.verticalCenter: visual.verticalCenter
					anchors.verticalCenterOffset: workspaces.textYOffset - (workspaces.underlineHeight * 0.5)
				}

				Rectangle {
					width: visual.width
					height: workspaces.underlineHeight
					color: parent.isActive ? workspaces.underlineActiveColor : workspaces.underlineInactiveColor
					anchors.horizontalCenter: visual.horizontalCenter
					anchors.bottom: visual.bottom
				}

				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: workspaces.focusWorkspace(parent.workspaceIdx)
				}
			}
		}
	}
}
