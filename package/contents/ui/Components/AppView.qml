/*
 SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
 SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
//import 'scripts/util.js' as Util

Item {
    id: root

    property bool small: false
    clip: true

    activeFocusOnTab: true

    Layout.fillHeight: true
    Layout.preferredWidth: Kirigami.Units.gridUnit * 12
    Layout.margins: Kirigami.Units.largeSpacing
    Layout.bottomMargin: Kirigami.Units.smallSpacing

    signal addTile(metadata: variant)
    signal toggle

    property alias delegate: list.delegate
    property alias model: list.model
    property alias sections: list.section.property
    property alias mouseActive: list.mouseActive
    focus: true

    ListView {
        id: list
        anchors.fill: parent
        anchors.rightMargin: scrollbar.width
        property bool mouseActive: true
        focus: true

        Controls.ScrollBar.vertical: Controls.ScrollBar {
            id: scrollbar
            policy: Controls.ScrollBar.AsNeeded
            interactive: true
            anchors.left: list.right
        }

        highlight: Rectangle {
            color: Kirigami.Theme.highlightColor
            radius: Kirigami.Units.largeSpacing
            opacity: 0.7
        }
        highlightMoveDuration: 0

        delegate: AppDelegate {
            itemController: root
            small: root.small
            onToggle: {
                root.toggle()
            }
        }

        section.property: "group"
        section.delegate: Item {
            required property string section;

            height: label.implicitHeight + Kirigami.Units.mediumSpacing * 2
            anchors.left: parent.left
            anchors.right: parent.right

            PlasmaComponents.Label {
                id: label
                anchors.fill: parent
                anchors.margins: Kirigami.Units.mediumSpacing
                text: parent.section.toUpperCase()
            }
        }
    }

    MouseArea {
        anchors.fill: list
        propagateComposedEvents: true
        hoverEnabled: true
        onPositionChanged: function(mouse) {
            let pos = list.contentItem.mapFromItem(root, mouse.x, mouse.y)
            list.currentIndex = list.indexAt(pos.x, pos.y)
            root.forceActiveFocus()
        }
    }

    PlasmaComponents.Menu {
        id: contextMenu
        property int current: 0

        PlasmaComponents.MenuItem{
            text: "Add to Tiles"
            icon.name: "emblem-favorite-symbolic"
            onClicked: {
                var metadata = {
                    name: list.currentItem.model.display,
                    icon: list.currentItem.model.decoration,
                    useCustomBack: false,
                    useCustomFront: false,
                    backColor: Kirigami.Theme.backgroundColor.toString(),
                    frontColor: Kirigami.Theme.textColor.toString(),
                    actionType: 0,
                    action: list.currentItem.model.favoriteId.replace("applications:", "")
                }
                root.addTile(metadata);
            }
        }

        PlasmaComponents.MenuSeparator {}

        Component {
            id: menuItem

            PlasmaComponents.MenuItem {
                text: model.text
                icon.name: model.icon
                onTriggered: {
                    list.model.trigger(list.itemAtIndex(contextMenu.current).model.index, model.actionId, model.actionArgument);
                    contextMenu.close();
                }
            }
        }

        Component {
            id: separator

            PlasmaComponents.MenuSeparator {}
        }

        Repeater {
            model: list.itemAtIndex(contextMenu.current) && list.itemAtIndex(contextMenu.current).model.hasActionList ?
            list.itemAtIndex(contextMenu.current).model.actionList : null

            delegate: Component {
                Loader {
                    required property variant model
                    sourceComponent: model.type != "separator" ? menuItem : separator
                }
            }
        }
    }


    function showContextMenu(index: int) {
        contextMenu.current = index;
        contextMenu.popup();
    }
}
