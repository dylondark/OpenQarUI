import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import OpenQarUI

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
                source: BluetoothMediaController.coverURL
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                smooth: true
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
                    text: BluetoothMediaController.title
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

            Image {
                id: previousButton
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: "qrc:/images/previous.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
                Layout.margins: 10

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        BluetoothMediaController.previous();
                    }
                }
            }

            Image {
                id: playPauseButton
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: BluetoothMediaController.playing ? "qrc:/images/pause.png" : "qrc:/images/play.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
                Layout.topMargin: 10
                Layout.bottomMargin: 10

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

            Image {
                id: nextButton
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: "qrc:/images/skip.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
                Layout.margins: 10

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
