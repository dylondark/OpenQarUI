import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import OpenQarUI

GridLayout {
    id: baseLayout
    uniformCellHeights: true
    uniformCellWidths: true
    columns: 6
    columnSpacing: 10
    rowSpacing: 10

    MenuButton {
        id: musicButton
        titleText: "Bluetooth Music"
        iconSource: "qrc:/images/menu_icons/" + AppearanceData.darkModeStr + "/bluetooth_music.svg"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                swipeView.setCurrentIndex(1)
            }
        }
    }

    MenuButton {
        id: settingsButton
        titleText: "Settings"
        iconSource: "qrc:/images/menu_icons/" + AppearanceData.darkModeStr + "/settings.svg"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                swipeView.setCurrentIndex(2)
            }
        }
    }

    // if there are less items than it takes to fill a full row, use this to fill the whole row
    Repeater {
        id: blanks
        model: 4

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: width
        }
    }
}
