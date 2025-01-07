/*
 SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
 SPDX-License-Identifier: LGPL-2.1-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.kicker as Kicker

Item {
    id: root

    signal reset

    Kirigami.Icon {
        id: buttonIcon

        anchors.fill: parent
        source: plasmoid.configuration.icon
        active: mouseArea.containsMouse
        smooth: true
    }

    FullRepresentation {
        id: dashWindow
    }

    MouseArea
    {
        id: mouseArea

        anchors.fill: parent
        property bool wasExpanded: false;

        activeFocusOnTab: true
        hoverEnabled: !dashWindow.visible

        onClicked: {
            dashWindow.toggleMode();
        }
    }

    Connections {
        target: Plasmoid
        enabled: dashWindow !== null

        function onActivated(): void {
            dashWindow.toggleMode();
            //justOpenedTimer.start();
        }
    }
}
