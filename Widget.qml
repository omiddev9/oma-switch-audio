import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

// Shows the output that currently owns the audio and cycles through the ones
// that are actually connected. The switching itself lives in `omaaudio`, so
// a keybinding or a terminal does exactly the same thing.
// The button does not inherit the host bar object on purpose: third-party
// widgets get a capability-scoped facade, and the shared button would call
// tooltip methods that facade does not expose.
BarWidget {
  id: root
  moduleName: "io.github.omiddev9.oma-switch-audio"

  readonly property string scriptPath: (Quickshell.env("HOME") || "")
    + "/.config/omarchy/plugins/io.github.omiddev9.oma-switch-audio/bin/omaaudio"

  property string target: "speakers"
  property string label: "Built-in speakers"
  property string glyph: "󰓃"
  property string available: "speakers"

  readonly property bool external: available.split(",").length > 1 || target !== "speakers"

  readonly property bool hideWhenIdle: {
    var value = String(root.setting("hideWhenIdle", true)).trim().toLowerCase()
    return value !== "false" && value !== "0" && value !== "no"
  }

  visible: root.hideWhenIdle ? root.external : true
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function applyStatus(text) {
    var lines = String(text).split("\n")
    var seen = {}
    for (var i = 0; i < lines.length; i++) {
      var eq = lines[i].indexOf("=")
      if (eq > 0) seen[lines[i].substring(0, eq)] = lines[i].substring(eq + 1)
    }
    if (!seen.target) return
    root.target = seen.target
    root.label = seen.label || seen.target
    root.glyph = seen.glyph || "󰓃"
    root.available = seen.available || seen.target
  }

  function act(command) {
    Quickshell.execDetached([root.scriptPath, command])
    pollTimer.restart()
  }

  Process {
    id: statusProcess
    running: false
    command: [root.scriptPath, "status"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.applyStatus(text)
    }
  }

  Timer {
    id: pollTimer
    interval: 2000
    repeat: true
    triggeredOnStart: true
    running: true
    onTriggered: if (!statusProcess.running) statusProcess.running = true
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    text: root.glyph
    active: root.target !== "speakers"
    onPressed: function (b) {
      if (b === Qt.LeftButton) root.act("toggle")
      else if (b === Qt.RightButton) root.act("follow")
      else if (b === Qt.MiddleButton && root.bar && typeof root.bar.run === "function")
        root.bar.run("omarchy-shell shell toggle omarchy.audio")
    }

    HoverHandler {
      id: hover
      onHoveredChanged: {
        var b = root.bar
        if (!b || typeof b.showTooltip !== "function" || typeof b.hideTooltip !== "function") return
        if (hover.hovered) b.showTooltip(button, "Audio: " + root.label)
        else b.hideTooltip(button)
      }
    }
  }
}
