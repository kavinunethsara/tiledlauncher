/*
 * SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami

Item {
    id: root
    width: Kirigami.Units.gridUnit * 1.5 + Kirigami.Units.smallSpacing * 2
    height: width
    property alias source: icon.source
    property alias hint: tooltip.text
    activeFocusOnTab: true

    signal activated

    Kirigami.Icon {
        id: icon
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        z: 1
    }

    ToolTip {
        id: tooltip
        visible: mouseArea.containsMouse
    }

    Keys.onReturnPressed: {
        root.activated()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.activated()
        }
        z: 2
    }

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: parent.width
        color: Kirigami.Theme.highlightColor
        radius: parent.width
        opacity: mouseArea.containsMouse || root.activeFocus ? 1 : 0
    }
}
