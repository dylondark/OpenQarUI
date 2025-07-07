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

            RowLayout {
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    text: "Switch"
                    font.pixelSize: 22
                    Layout.fillWidth: true
                }

                Switch {
                    id: darkModeSwitch
                    checked: false
                }
            }

            background: Rectangle {
                color: Qt.rgba(0, 0.7, 1, 0.5)
                border.color: "black"
                border.width: 1
                radius: 5
            }
        }

        Frame {
            Layout.fillWidth: true
            padding: 16

            RowLayout {
                spacing: 12

                Label {
                    text: "Slider"
                    font.pixelSize: 22
                }

                Slider {
                    id: volumeSlider
                    from: 0
                    to: 100
                    value: 50
                    stepSize: 1
                    Layout.fillWidth: true
                }
            }

            background: Rectangle {
                color: Qt.rgba(0, 0.7, 1, 0.5)
                border.color: "black"
                border.width: 1
                radius: 5
            }
        }

        Frame {
            Layout.fillWidth: true
            padding: 16

            RowLayout {
                spacing: 12

                Label {
                    text: "ComboBox"
                    font.pixelSize: 22
                }

                ComboBox {
                    model: ["English", "Spanish", "French", "German"]
                    currentIndex: 0
                    Layout.fillWidth: true
                }
            }

            background: Rectangle {
                color: Qt.rgba(0, 0.7, 1, 0.5)
                border.color: "black"
                border.width: 1
                radius: 5
            }
        }

        Frame {
            Layout.fillWidth: true
            padding: 16

            Button {
                text: "Button"
                font.pixelSize: 20
                Layout.alignment: Qt.AlignHCenter
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
