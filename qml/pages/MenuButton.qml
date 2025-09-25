import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.VectorImage

Rectangle {
    id: baseRect
    color: Qt.rgba(0, 0.7, 1, 0.5)
    border.color: "black"
    border.width: 1
    Layout.fillWidth: true
    Layout.preferredHeight: width
    radius: 6

    property string titleText: "Menu Button"
    property string iconSource: "qrc:/images/placeholder.png"

    ColumnLayout {
        id: baseLayout
        anchors.fill: parent
        anchors.bottomMargin: parent.height / 5

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                id: title
                anchors.centerIn: parent
                text: baseRect.titleText
                font.pixelSize: 20
                font.bold: true
                color: "black"
                opacity: 1.0
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            VectorImage {
                id: icon
                width: parent.width / 2
                height: width
                anchors.centerIn: parent
                source: baseRect.iconSource
                fillMode: Image.PreserveAspectFit
                preferredRendererType: VectorImage.CurveRenderer
            }
        }
    }
}
