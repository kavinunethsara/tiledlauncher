/*
    SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
    SPDX-License-Identifier: LGPL-2.1-or-later
    */
pragma ComponentBehavior: Bound

import QtQuick
import QtCore
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.kicker as Kicker

PlasmoidItem {
    id: kicker

    property bool displayApps: plasmoid.configuration.defaultAppsViewState

    compactRepresentation: CompactRepresentation {
            inPanel: kicker.inPanel
            vertical: kicker.vertical
            onToggled: {
                kicker.expanded = !kicker.expanded
            }
        }
    fullRepresentation: FullRepresentation {}

    onExpandedChanged: {
        kicker.displayApps = plasmoid.configuration.defaultAppsViewState
    }

    preferredRepresentation: Plasmoid.compactRepresentation

    signal reset

    Kicker.RootModel {
        id: rootModel

        autoPopulate: false

        flat: true
        // TODO: appletInterface property now can be ported to "applet" and have the real Applet* assigned directly
        appletInterface: kicker

        showAllApps: true
        showAllAppsCategorized: false
        showTopLevelItems: true
        showRecentApps: false
        showRecentDocs: false
        showFavoritesPlaceholder: false

        Component.onCompleted: {
            favoritesModel.initForClient("whjjackwhite.tiledlauncher.favorites.instance-" + Plasmoid.id)

            if (!Plasmoid.configuration.favoritesPortedToKAstats) {
                if (favoritesModel.count < 1) {
                    favoritesModel.portOldFavorites(Plasmoid.configuration.favoriteApps);
                }
                Plasmoid.configuration.favoritesPortedToKAstats = true;
            }

            rootModel.refresh();
        }
    }

    Kicker.RunnerModel {
        id: runnerModel

        appletInterface: kicker
        mergeResults: true

        runners: []
    }

    Connections {
        target: kicker

        function onExpandedChanged(expanded) {
            if (!expanded) {
               kicker.reset();
            }
        }
    }

    Component.onCompleted: {
        if (Plasmoid.hasOwnProperty("activationTogglesExpanded")) {
            Plasmoid.activationTogglesExpanded = false
        }

        rootModel.refreshed.connect(reset);
        if (rootModel.status == Component.Ready) rootModel.refresh();

    }
}
