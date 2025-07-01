import QtQuick
import QtQuick.Controls
import QtQuick

MenuBase {
    id: mainMenu

    delegate: Rectangle {
        color: "lightblue"
        border.color: "black"
        border.width: 1
        radius: 10

        Text {
            anchors.centerIn: parent
            text: "Menu Item " + (index + 1)
            font.pixelSize: 20
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Clicked on Menu Item " + (index + 1))
                // Here you can add logic to navigate to different pages or perform actions
            }
        }
    }
}
