/*
 SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
 SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
Item {
    id: root
    required property variant model
    property bool small: false
    required property variant itemController
    signal toggle

    height: Kirigami.Units.gridUnit * 2
    anchors.left: parent.left
    anchors.right: parent.right

    RowLayout {
        id: content
        anchors.fill: parent

        Kirigami.Icon {
            id: icon
            Layout.alignment: Qt.AlignVCenter
            Layout.margins:  Kirigami.Units.smallSpacing
            Layout.preferredWidth: root.small ? Kirigami.Units.gridUnit : Kirigami.Units.gridUnit * 2
            source: root.model.decoration
        }
        PlasmaComponents.Label {
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment: Qt.AlignVCenter
            text: root.model.display
            elide: Qt.ElideRight
        }
    }

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.RightButton | Qt.LeftButton
        onClicked: function (mouse) {
            if (mouse.button == Qt.RightButton) {
                root.itemController.showContextMenu(root.model.index)
            } else {
                root.trigger()
            }
        }
    }

    Keys.onPressed: event => {
        if ((event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
            event.accepted = true
            root.trigger()
        }
    }

    function trigger() {
        if ("trigger" in root.itemController.model) {
            root.itemController.model.trigger(root.model.index, "", null)
            root.toggle()
        }
    }
}
