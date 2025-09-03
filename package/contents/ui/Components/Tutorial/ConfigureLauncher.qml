import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

Page {
  id: root
  previous: "GetNew"
  next: "JumpIn"

  Kirigami.Heading {
    Layout.fillWidth: true
    Layout.margins: Kirigami.Units.largeSpacing
    horizontalAlignment: Qt.AlignHCenter
    text: "Configure Tiled Launcher"
  }

  PlasmaComponents.Label {
    Layout.margins: Kirigami.Units.largeSpacing
    Layout.fillWidth: true
    Layout.maximumWidth: Kirigami.Units.gridUnit * 28
    Layout.alignment: Qt.AlignHCenter
    horizontalAlignment: Qt.AlignHCenter
    onLinkActivated: function (link) { Qt.openUrlExternally(link) }
    text: "Tiled Launcher isn't just an application launcher. Infact, it doesn't have to be an application launcher at all. Use the extensive configuration options to tune Tiled Launcher into anything you want - be it a simple application launcher, a tile-based dash board or even a quick settings system tray."
    wrapMode: Text.WordWrap
  }

  PlasmaComponents.Label {
    Layout.margins: Kirigami.Units.largeSpacing
    Layout.fillWidth: true
    Layout.maximumWidth: Kirigami.Units.gridUnit * 28
    Layout.alignment: Qt.AlignHCenter
    horizontalAlignment: Qt.AlignHCenter
    onLinkActivated: function (link) { Qt.openUrlExternally(link) }
    text: "<b>Right Click</b> on the Tiled Launcher icon on your desktop and select <b>Configure Tiled Laucher</b> to open the configuration dialog. You can try it out on the icon below."
    wrapMode: Text.WordWrap
  }

  Rectangle {
    Layout.preferredWidth: Kirigami.Units.gridUnit  * 6
    Layout.preferredHeight: Layout.preferredWidth
    Layout.alignment: Qt.AlignHCenter

    color: Kirigami.Theme.backgroundColor
    border.width: 1
    border.color: Kirigami.Theme.backgroundColor.darker(200)
    radius: Kirigami.Units.cornerRadius

    Kirigami.Icon {
      anchors.fill: parent
      anchors.margins: Kirigami.Units.largeSpacing

      source: plasmoid.configuration.icon
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.RightButton
      onClicked: {
        contextMenu.popup()
      }
    }
  }

  PlasmaComponents.Menu {
    id: contextMenu

    PlasmaComponents.MenuItem{
      text: "Configure Tiled Launcher..."
      icon.name: "configure"
      onClicked: plasmoid.internalAction("configure").trigger()
    }

    PlasmaComponents.MenuSeparator {}

    PlasmaComponents.MenuItem{
      text: "Show Alternatives..."
      icon.name: "widget-alternatives-symbolic"
    }
  }
}
