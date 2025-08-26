import QtQuick
import QtQuick.VirtualKeyboard
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import OpenQarUI

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: qsTr("OpenQarUI")

    Component.onCompleted: {
        BluetoothMediaController.connectToDevice("AC_C0_48_68_67_9E"); // temporary hardcoded mac until gui based device select
    }

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

            StatusBar {
                id: statusBar
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                radius: 5
            }

            ContentPane {
                id: contentPane
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            ControlBar {
                id: controlBar
                Layout.preferredHeight: 80
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                radius: 10
            }

            Connections {
                target: controlBar
                function onGoHomeRequested() {
                    contentPane.goHome()
                }
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
