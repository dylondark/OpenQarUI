import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: controlBarBase
    color: "white"
    opacity: 0.8
    border.color: "black"
    border.width: 1

    RowLayout {
        id: baseLayout
        anchors.fill: parent
        spacing: 10

        Image {
            id: homeButton
            Layout.fillHeight: true
            Layout.preferredWidth: height
            source: "qrc:/images/home.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            Layout.margins: 10

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Home button clicked")
                    // Implement home button functionality here
                }
            }
        }

        ToolSeparator { }

        Item {
            id: musicBase
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ToolSeparator { }

        Item {
            id: volumeBase
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
