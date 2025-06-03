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

        RowLayout {
            id: phoneBase
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            Item {
                id: phoneTextBase
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: phoneText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    text: "No phone connected"
                    font.pixelSize: 20
                    font.bold: false
                }
            }

            Image {
                id: signalBarsIcon
                Layout.fillHeight: true
                Layout.preferredWidth: height
                Layout.margins: height / 6
                source: "qrc:/images/signalbars-placeholder.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Image {
                id: batteryIcon
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: "qrc:/images/battery-placeholder.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Item {
                id: batteryPercentageBase
                Layout.fillHeight: true
                Layout.preferredWidth: batteryPercentageText.width

                Text {
                    id: batteryPercentageText
                    anchors.centerIn: parent
                    text: "100%"
                    font.pixelSize: 20
                    font.bold: false
                }
            }
        }
    }
}
