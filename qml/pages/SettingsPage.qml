import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: settingsPage
    title: "Settings"

    ColumnLayout {
        id: settingsLayout
        spacing: 24
        anchors.margins: 24
        width: parent.width

        Frame {
            Layout.fillWidth: true
            padding: 16

            ColumnLayout {
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    text: "Bluetooth Device"
                    font.pixelSize: 22
                    Layout.fillWidth: true
                    color: "black"
                }

                RowLayout {
                    Layout.fillWidth: true

                    ComboBox {
                        id: deviceComboBox
                        Layout.fillWidth: true
                        textRole: "name"
                        model: BluetoothMediaController.getPairedDevices()
                        currentIndex: -1 // No selection by default
                    }
                }
            }

            background: Rectangle {
                color: Qt.rgba(0, 0.7, 1, 0.5)
                border.color: "black"
                border.width: 1
                radius: 5
            }
        }
    }
}
