/*
 SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
 SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

import './Components'
import './Components/Tile' as Tile
import './Components/Tutorial' as Tutorial

pragma ComponentBehavior: Bound

Item {
    id: root

    Layout.minimumHeight: Kirigami.Units.gridUnit * 20
    Layout.preferredWidth: Kirigami.Units.gridUnit * 34 + toolbar.implicitWidth

    property bool dummyProp: displayApps && expanded

    onDummyPropChanged: {
        if (!appsLoader.active) return;
        appsLoader.item.sfield.text = ""
        appsLoader.item.allapps.listview.currentIndex = 0
        appsLoader.forceActiveFocus()
    }

    Keys.onPressed: function (button) {
        if (button.text != "") {
            const prevDisp = displayApps
            displayApps = true
            if (appsLoader.active && !prevDisp)
                appsLoader.item.sfield.text += button.text
        }
    }

    Keys.forwardTo: [appsLoader.active ? appsLoader.item.sfield : tileView]

    Item {
        id: expandedView
        anchors.fill: parent

        property Item currentView: null
        visible: currentView
    }

    Loader {
        visible: plasmoid.configuration.firstRun
        anchors.fill: parent
        active: plasmoid.configuration.firstRun
        sourceComponent:Tutorial.Guide {}
    }

    Rectangle {
        visible: plasmoid.configuration.displayAppsView && displayApps && !expandedView.visible && !plasmoid.configuration.firstRun

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

        visible: !expandedView.visible && !plasmoid.configuration.firstRun

        property var appsModel: rootModel.count ? rootModel.modelForRow(0) : []
        property var searchModel: runnerModel.count ? runnerModel.modelForRow(0) : null
        property string searchString : ""
        property var model: (searchString) ? searchModel : appsModel

        ToolBar {
            id:toolbar
            z: 1
            visible: plasmoid.configuration.displayToolBar

            Keys.onPressed: function (button) {
                if (button.text != "")
                    displayApps = true
            }
        }

        // Editor Sidebar
        Tile.Editor {
            id: editor_sidebar

            Layout.preferredWidth: Kirigami.Units.gridUnit * plasmoid.configuration.appsViewSize + Kirigami.Units.largeSpacing * 2
            Layout.fillHeight: true

            property bool prevAppState: false
            onVisibleChanged: {
                if (visible) {
                    prevAppState = displayApps
                    displayApps = false
                } else {
                    displayApps = prevAppState
                }
            }

            onCloseClicked: tileView.closeEditor()
        }

        Loader {
            id: appsLoader
            z: 1
            active: plasmoid.configuration.displayAppsView

            visible: plasmoid.configuration.displayAppsView && displayApps

            Layout.preferredWidth: item? item.Layout.preferredWidth : 0
            Layout.fillHeight: true

            sourceComponent: ColumnLayout {
                Layout.preferredWidth: appsView.preferredWidth + Kirigami.Units.largeSpacing
                Layout.fillHeight: true

                property alias sfield: searchField
                property alias allapps: appsview

                AppView {
                    id: appsview
                    model: container.model
                    small: true
                    sections: plasmoid.configuration.displayCategories ? "group" : ""

                    onToggle: {
                        expanded = !expanded
                    }

                    onAddTile: function (metadata) {
                        tileView.addTile("icon", metadata)
                    }
                }

                PlasmaComponents.TextField {
                    id: searchField

                    Layout.preferredWidth: Kirigami.Units.gridUnit * plasmoid.configuration.appsViewSize
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                    Layout.margins: Kirigami.Units.largeSpacing
                    Layout.topMargin: 0
                    Layout.bottomMargin: Kirigami.Units.mediumSpacing

                    focus: true

                    padding: Kirigami.Units.largeSpacing
                    leftPadding: Kirigami.Units.largeSpacing
                    rightPadding: Kirigami.Units.largeSpacing

                    background: Rectangle {
                        anchors.fill: parent
                        color: Kirigami.Theme.View
                        radius: Kirigami.Units.cornerRadius
                        opacity: 0.25
                    }

                    Keys.onReleased: function (event) {
                        if (text == " " && event.text == " ") {
                            event.accepted = true
                            text=""
                        }
                    }

                    Keys.onDownPressed: {
                        if (appsview.listview.currentIndex < appsview.listview.count - 1)
                            appsview.listview.currentIndex += 1
                    }

                    Keys.onUpPressed: {
                        if (appsview.listview.currentIndex > 0)
                            appsview.listview.currentIndex -= 1
                    }

                    Keys.onReturnPressed: {
                        appsview.listview.currentItem.trigger()
                    }

                    Keys.onEnterPressed: {
                        appsview.listview.currentItem.trigger()
                    }

                    placeholderText: "Search ..."

                    onTextChanged: {
                        if (text != "")
                            displayApps = true
                        runnerModel.query = text
                        container.searchString = text
                        appsview.listview.currentIndex = 0
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

                invisibleScrollbars: true
                sidebar: editor_sidebar

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

                property bool appState: false

                onExpanded: function (view, data) {
                    if (expandedView.currentView)
                        expandedView.currentView.destroy()
                    expandedView.currentView = view.createObject(expandedView, data)
                }

                Keys.onPressed: function (button) {
                    if (button.text != "") {
                        const prevDisp = displayApps
                        displayApps = true
                        if (appsLoader.active && !prevDisp)
                            appsLoader.item.sfield.text += button.text
                    }
                }
            }
        }
    }
}
