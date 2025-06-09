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

    Repeater {
        model: 2

        Rectangle {
            color: "blue"
            opacity: 0.5
            border.color: "black"
            border.width: 1
            Layout.fillWidth: true
            Layout.preferredHeight: width
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
