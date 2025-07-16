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
        id: bluetoothButton
        titleText: "Bluetooth"
        iconSource: "qrc:/images/bluetooth.png"
    }

    MenuButton {
        id: localButton
        titleText: "Local Files"
        iconSource: "qrc:/images/file.png"
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
