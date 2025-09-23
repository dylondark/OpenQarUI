import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

GridLayout {
    id: baseLayout
    uniformCellHeights: true
    uniformCellWidths: true
    columns: 6
    columnSpacing: 10
    rowSpacing: 10

    MenuButton {
        id: musicButton
        titleText: "Music"
        iconSource: "qrc:/images/music.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                stackView.push(musicMenuComponent)
            }
        }
    }

    MenuButton {
        id: settingsButton
        titleText: "Settings"
        iconSource: "qrc:/images/settings.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                stackView.push(settingsPageComponent)
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
