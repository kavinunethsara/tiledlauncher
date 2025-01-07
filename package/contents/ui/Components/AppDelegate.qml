import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
Item {
    id: root
    required property variant model
    property real itemWidth: Kirigami.Units.gridUnit * 14
    property bool small: false
    required property variant itemController

    height: content.implicitHeight
    width: root.itemWidth - Kirigami.Units.gridUnit * 2

    RowLayout {
        id: content
        Layout.fillWidth: true
        Kirigami.Icon {
            id: icon
            Layout.margins: Kirigami.Units.largeSpacing
            Layout.preferredWidth: root.small ? Kirigami.Units.gridUnit : Kirigami.Units.gridUnit * 2
            source: root.model.decoration
        }
        PlasmaComponents.Label {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 5 * Kirigami.Units.largeSpacing - icon.implicitWidth
            Layout.margins:  Kirigami.Units.largeSpacing
            text: root.model.display
            elide: Qt.ElideRight
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: root.itemController.showContextMenu(root.model.index)//root.trigger()
    }

    Keys.onPressed: event => {
        if ((event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
            event.accepted = true
            root.trigger()
        }
    }

    function trigger() {
        if ("trigger" in root.list.model) {
            root.list.model.trigger(root.model.index, "", null)
            root.toggle()
        }
    }
}
