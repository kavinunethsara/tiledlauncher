/*
 * SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigamiaddons.components 1.0 as KirigamiComponents
import org.kde.plasma.private.sessions as Sessions
import org.kde.coreaddons 1.0 as KCoreAddons
import './Components'

ColumnLayout {
    id: root
    signal toggle

    Layout.fillHeight: true
    width: shutdownIcon.width + Kirigami.Units.smallSpacing * 2
    Layout.alignment: Qt.AlignBottom

    Sessions.SessionManagement {
        id: sm
    }

    Sessions.SessionsModel {
        id: sessionsModel
    }

    KCoreAddons.KUser {
        id: userInfo
    }

    Rectangle {
        anchors.fill: root
        color: Kirigami.Theme.backgroundColor

        border.width: 1
        border.color: Kirigami.Theme.View

        opacity: 0.25
    }

    ToolbarButton {
        Layout.margins: Kirigami.Units.smallSpacing

        visible: plasmoid.configuration.displayAppsView
        toggled: !displayApps

        source: "show-menu"
        hint: i18n("Hide Applications")
        onActivated: {
            displayApps = !displayApps
        }
    }

    Item {
        Layout.fillHeight: true
    }

    Rectangle {
        visible:plasmoid.configuration.displayUserInfo

        activeFocusOnTab: true
        Layout.alignment: Qt.AlignTop

        Layout.margins: Kirigami.Units.smallSpacing

        color: mouseArea.containsMouse || activeFocus? Kirigami.Theme.highlightColor :Kirigami.Theme.backgroundColor
        width: userIcon.width + Kirigami.Units.smallSpacing * 2
        height: userIcon.height + Kirigami.Units.smallSpacing * 2
        radius: height

        KirigamiComponents.Avatar {
            id: userIcon

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Kirigami.Units.smallSpacing
            height: Kirigami.Units.gridUnit * 1.5
            width: height

            name: plasmoid.configuration.userInfoStyle == 0 ? userInfo.fullName : userInfo.loginName
            source: userInfo.faceIconUrl.toString()
        }

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
            onClicked: sessionsModel.startNewSession(sessionsModel.shouldLock)
        }

        Keys.onReturnPressed: sessionsModel.startNewSession(sessionsModel.shouldLock)
    }
    ToolbarButton {
        id: lockIcon
        visible:plasmoid.configuration.showLockButton

        Layout.margins: Kirigami.Units.smallSpacing

        source: "lock"
        hint: "Lock Screen"
        onActivated: {
            sm.lock();
            root.toggle();
        }
    }
    ToolbarButton {
        id: shutdownIcon
        visible:plasmoid.configuration.showLogoutButton

        Layout.margins: Kirigami.Units.smallSpacing

        hint: "Power off"
        source: "system-shutdown"
        onActivated: {
            sm.requestLogoutPrompt();
            root.toggle();
        }
    }
}
