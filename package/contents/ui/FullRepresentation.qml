/*
 SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
 SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.kicker as Kicker

import './Components'
import './Components/Tile' as Tile

pragma ComponentBehavior: Bound

Item {
    id: root

    Layout.minimumHeight: Kirigami.Units.gridUnit * 20
    Layout.preferredWidth: Kirigami.Units.gridUnit * 34 + toolbar.implicitWidth

    property bool displayApps: true

    Rectangle {
        visible: plasmoid.configuration.displayAppsView && root.displayApps

        anchors {
            top: container.top
            bottom: container.bottom
            left: container.left
            margins:  -1 * Kirigami.Units.smallSpacing
        }

        property int appsWidth: appsLoader.implicitWidth - Kirigami.Units.smallSpacing
        width: toolbar.implicitWidth + appsWidth + Kirigami.Units.largeSpacing * 2

        color: Kirigami.Theme.backgroundColor
        bottomLeftRadius: Kirigami.Units.cornerRadius
        topLeftRadius: Kirigami.Units.cornerRadius

        opacity: 0.6
        z: 0
    }

    RowLayout {
        id: container
        anchors.fill: parent

        property var appsModel: rootModel.count ? rootModel.modelForRow(0) : []
        property var searchModel: runnerModel.count ? runnerModel.modelForRow(0) : null
        property string searchString : ""
        property var model: (searchString) ? searchModel : appsModel

        ToolBar {
            id:toolbar
            z: 1
            visible: plasmoid.configuration.displayToolBar
        }

        Loader {
            id: appsLoader
            z: 1
            active: plasmoid.configuration.displayAppsView

            visible: plasmoid.configuration.displayAppsView && displayApps

            Layout.preferredWidth: item? item.Layout.preferredWidth : 0
            Layout.fillHeight: true

            sourceComponent: ColumnLayout {
                Layout.preferredWidth: Kirigami.Units.gridUnit * 12 + Kirigami.Units.largeSpacing * 2
                Layout.fillHeight: true

                AppView {
                    id: appsview
                    model: container.model
                    small: true
                    sections: plasmoid.configuration.displayCategories ? "group" : ""
                }

                PlasmaComponents.TextField {
                    id: searchField

                    Layout.preferredWidth: Kirigami.Units.gridUnit * 12
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                    Layout.margins: Kirigami.Units.largeSpacing
                    Layout.topMargin: 0
                    Layout.bottomMargin: Kirigami.Units.mediumSpacing

                    padding: Kirigami.Units.largeSpacing
                    leftPadding: Kirigami.Units.largeSpacing
                    rightPadding: Kirigami.Units.largeSpacing

                    background: Rectangle {
                        anchors.fill: parent
                        color: Kirigami.Theme.View
                        radius: Kirigami.Units.cornerRadius
                        opacity: 0.25
                    }

                    placeholderText: "Search ..."

                    onTextChanged: {
                        runnerModel.query = text
                        container.searchString = text
                    }
                }
            }
        }

        Item {
            id: tileViewContainer

            Layout.fillWidth: true
            Layout.fillHeight: true

            Tile.Grid {
                id: tileView

                property variant appsView: {
                    return ({
                        runApp: (url) => {
                            for (var i = 0; i < container.appsModel.count; i++) {
                                var modelIndex = container.appsModel.index(i, 0)
                                var favoriteId = container.appsModel.data(modelIndex, Qt.UserRole + 3)
                                if (favoriteId == url) {
                                    container.appsModel.trigger(i, "", null)
                                    return
                                }
                            }
                        }
                    })
                }

                onToggled: {
                    kicker.expanded = !kicker.expanded
                }

                onExpanded: function (view, data) {
                    /* if (expandedView.currentView)
                        expandedView.currentView.destroy()
                        expandedView.currentView = view.createObject(expandedView, data) */
                }
            }
        }
    }
}
