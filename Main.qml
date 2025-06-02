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
        fillMode: Image.PreserveAspectCrop

        ColumnLayout {
            id: masterLayout
            anchors.fill: parent
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
