import QtQuick
import QtQuick.VirtualKeyboard
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: qsTr("OpenQarUI")

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/images/default-background.png"
        fillMode: Image.PreserveAspectCrop

        ColumnLayout {
            id: masterLayout
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Rectangle{
                id: statusBarBase
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                color: "white"
                opacity: 0.8
                border.color: "black"
                border.width: 1
                radius: 5
            }

            Rectangle{
                id: pageBase
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"
                opacity: 0.3
                border.color: "black"
                border.width: 1
                radius: 5
            }

            Rectangle{
                id: controlBarBase
                Layout.preferredHeight: 80
                Layout.fillWidth: true
                color: "white"
                opacity: 0.8
                border.color: "black"
                border.width: 1
                radius: 10
                Layout.leftMargin: 20
                Layout.rightMargin: 20
            }
        }

        InputPanel {
            id: inputPanel
            z: 99
            x: 0
            y: window.height
            width: window.width

            states: State {
                name: "visible"
                when: inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    y: window.height - inputPanel.height
                }
            }
            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
}
