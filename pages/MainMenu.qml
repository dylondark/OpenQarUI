import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

GridLayout {
    id: baseLayout
    uniformCellHeights: true
    uniformCellWidths: true
    columns: 6
    rows: 3
    columnSpacing: 10
    rowSpacing: 10

    Repeater {
        model: 18

        Rectangle {
            color: "blue"
            opacity: 0.5
            border.color: "black"
            border.width: 1
            Layout.fillWidth: true
            Layout.preferredHeight: width
        }
    }
}
