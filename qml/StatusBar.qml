import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.VectorImage

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

        RowLayout {
            id: widgetsBase
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            Layout.leftMargin: 10
            Layout.alignment: Qt.AlignLeft
            visible: false // gonna hide this until i actually start working on it

            Rectangle {
                // this is a placeholder for a widget
                id: widget1
                color: "lightgray"
                opacity: 0.5
                Layout.fillHeight: true
                Layout.preferredWidth: 40
                border.color: black
                border.width: 1
            }

            Rectangle {
                // this is a placeholder for a widget
                id: widget2
                color: "lightgray"
                opacity: 0.5
                Layout.fillHeight: true
                Layout.preferredWidth: 40
                border.color: black
                border.width: 1
            }

            Item {
                id: ellipses
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: ellipsesText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    text: "• • •"
                    font.pixelSize: 20
                    font.bold: true
                }
            }
        }

        Item {
            id: clockBase
            Layout.fillHeight: true
            Layout.preferredWidth: clockText.width
            Layout.alignment: Qt.AlignHCenter
            Layout.leftMargin: 10

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
            Layout.rightMargin: 10
            Layout.alignment: Qt.AlignRight

            Item {
                id: phoneTextBase
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: phoneText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    text: BluetoothMediaController.connected ? BluetoothMediaController.deviceName : "No BT device connected"
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
                visible: false // maybe implement this someday
            }

            VectorImage {
                id: batteryIcon
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: "qrc:/images/battery/light/" + Math.round(BluetoothMediaController.batteryLevel / 12.5) + ".svg"
                fillMode: VectorImage.PreserveAspectFit
                preferredRendererType: VectorImage.CurveRenderer
                visible: (BluetoothMediaController.batteryLevel != -1)
            }

            Item {
                id: batteryPercentageBase
                Layout.fillHeight: true
                Layout.preferredWidth: batteryPercentageText.width

                Text {
                    id: batteryPercentageText
                    anchors.centerIn: parent
                    text: (BluetoothMediaController.batteryLevel == -1) ? "" : BluetoothMediaController.batteryLevel + "%"
                    font.pixelSize: 20
                    font.bold: false
                }
            }
        }
    }
}
