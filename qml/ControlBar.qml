import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import OpenQarUI
import QtQuick.VectorImage

Rectangle {
    id: controlBarBase
    color: "white"
    opacity: 0.8
    border.color: "black"
    border.width: 1

    signal goHomeRequested()

    RowLayout {
        id: baseLayout
        anchors.fill: parent
        spacing: 10

        VectorImage {
            id: homeButton
            Layout.fillHeight: true
            Layout.preferredWidth: height
            source: "qrc:/images/home/light/home.svg"
            fillMode: Image.PreserveAspectFit
            preferredRendererType: VectorImage.CurveRenderer
            Layout.rightMargin: -10

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    controlBarBase.goHomeRequested()
                }
            }
        }

        ToolSeparator { }

        RowLayout {
            id: musicBase
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 10

            Image {
                id: albumImage
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: BluetoothMediaController.connected ? BluetoothMediaController.coverURL : "qrc:/images/placeholder_image/light/image.svg"
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                smooth: true
                sourceSize.width: 300
                sourceSize.height: 300
            }

            ColumnLayout {
               id: songTextLayout
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 10
                spacing: 0

                Text {
                    id: songTitle
                    Layout.fillWidth: true
                    text: BluetoothMediaController.connected ? BluetoothMediaController.title : "No BT device connected"
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVBottom
                    horizontalAlignment: Text.AlignLeft
                    font.bold: true
                }

                Text {
                    id: artistName
                    Layout.preferredHeight: 28 // i dont know why this positions it correctly but i guess we'll keep it
                    Layout.fillWidth: true
                    text: BluetoothMediaController.artist
                    font.pixelSize: 20
                    verticalAlignment: Text.AlignVTop
                    horizontalAlignment: Text.AlignLeft
                }
            }

            VectorImage {
                id: previousButton
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: "qrc:/images/media/light/previous.svg"
                fillMode: VectorImage.PreserveAspectFit
                preferredRendererType: VectorImage.CurveRenderer

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        BluetoothMediaController.previous();
                    }
                }
            }

            VectorImage {
                id: playPauseButton
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: BluetoothMediaController.playing ? "qrc:/images/media/light/pause.svg" : "qrc:/images/media/light/play.svg"
                fillMode: VectorImage.PreserveAspectFit
                preferredRendererType: VectorImage.CurveRenderer

                property bool play: true // play or pause?

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (!BluetoothMediaController.playing) {
                            BluetoothMediaController.play();
                        } else {
                            BluetoothMediaController.pause();
                        }
                    }
                }
            }

            VectorImage {
                id: nextButton
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: "qrc:/images/media/light/next.svg"
                fillMode: VectorImage.PreserveAspectFit
                preferredRendererType: VectorImage.CurveRenderer

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        BluetoothMediaController.next();
                    }
                }
            }
        }

        ToolSeparator { }

        RowLayout {
            id: volumeBase
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 10

            Image {
                id: volumeIcon
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: "qrc:/images/volume.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
                Layout.margins: 10

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Implement volume control functionality here
                    }
                }
            }

            Slider {
                id: volumeSlider
                Layout.fillWidth: true
                Layout.fillHeight: true
                from: 0
                to: 100
                stepSize: 1
                value: 50 // Default volume level
                Layout.rightMargin: 10

                onValueChanged: {
                    // Implement volume change functionality here
                }
            }
        }
    }
}
