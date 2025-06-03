import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: statusBarBase
    color: "white"
    opacity: 0.8
    border.color: "black"
    border.width: 1

    RowLayout {
        id: baseLayout
        anchors.fill: parent
        spacing: 10

        Item {
            id: widgetsBase
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            id: clockBase
            Layout.fillHeight: true
            Layout.preferredWidth: clockText.width

            property string currentTime: Qt.formatTime(new Date(), "hh:mm AP")

            Timer {
                interval: 30000
                running: true
                repeat: true
                onTriggered: parent.currentTime = Qt.formatTime(new Date(), "hh:mm AP")
            }

            Text {
                id: clockText
                anchors.centerIn: parent
                text: parent.currentTime
                font.pixelSize: 20
                font.bold: true
            }
        }

        Item {
            id: phoneBase
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
