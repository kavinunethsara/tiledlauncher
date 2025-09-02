/*
 SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
 SPDX-License-Identifier: LGPL-2.1-or-later
 */

/*
 SPDX-FileCopyrightText: 2024 Kavinu Nethsara <kavinunethsarakoswattage@gmail.com>
 SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick
import QtCore
import QtQuick.Dialogs as Dialogs
import org.kde.kcmutils as KCM
import org.kde.kirigamiaddons.formcard as FormCard

KCM.SimpleKCM {
    id: root

    property alias cfg_displayAppsView: showAppsView.checked
    property alias cfg_appsViewSize: appsViewSize.value
    property alias cfg_displayCategories: separateAlph.checked
    property alias cfg_displayToolBar: showToolBar.checked
    property alias cfg_displayUserInfo: showUser.checked
    property alias cfg_showLogoutButton: showLogout.checked
    property alias cfg_showLockButton: showLock.checked

    FormCard.FormCardPage {
        FormCard.FormHeader {
            title: i18n("Apps View")
        }
        FormCard.FormCard {
            FormCard.FormSwitchDelegate {
                id: showAppsView
                text: i18n("Show Applications")
            }
            FormCard.FormSpinBoxDelegate {
                id: appsViewSize
                label: "App View width"
                from: 1
                to: 50
                stepSize: 1
            }
            FormCard.FormSwitchDelegate {
                id: separateAlph
                enabled: showAppsView.checked
                text: i18n("Separate Application Alphabetically")
            }
        }

        FormCard.FormHeader {
            title: i18n("Toolbar")
        }
        FormCard.FormCard {
            FormCard.FormSwitchDelegate {
                id: showToolBar
                text: i18n("Show Tool Bar")
            }
            FormCard.FormDelegateSeparator {}
            FormCard.FormSwitchDelegate {
                id: showUser
                enabled: showToolBar.checked
                text: i18n("Show User Information")
            }
            FormCard.FormSwitchDelegate {
                id: showLock
                enabled: showToolBar.checked
                text: i18n("Show lock button")
            }
            FormCard.FormSwitchDelegate {
                id: showLogout
                enabled: showToolBar.checked
                text: i18n("Show power button")
            }

        }
    }
}
