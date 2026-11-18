import QtQuick
import Quickshell
import Quickshell.Io

// One instance of the cable watcher, for every monitor's bar.
// The widget only reads state; switching happens here so two bar surfaces
// cannot race the same profile change.
Item {
  id: root

  property var shell: null
  property var manifest: null

  readonly property string scriptPath: (Quickshell.env("HOME") || "")
    + "/.local/bin/omaaudio"

  property string lastError: ""

  Process {
    id: autoProcess
    running: false
    command: [root.scriptPath, "auto"]
    stderr: StdioCollector {
      waitForEnd: true
      onStreamFinished: function (text) {
        var msg = String(text).trim()
        if (msg !== "") root.lastError = msg
      }
    }
  }

  Timer {
    interval: 2000
    repeat: true
    triggeredOnStart: true
    running: true
    onTriggered: if (!autoProcess.running) autoProcess.running = true
  }
}
