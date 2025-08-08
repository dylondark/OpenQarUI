import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: page
    title: "Bluetooth Music"
    anchors.leftMargin: 10
    anchors.rightMargin: 10

    Frame {
        id: bluetoothMusicFrame
        width: parent.width
        height: pageBase.height

        RowLayout {
            id: masterRowLayout
            anchors.fill: parent

            Item {
                id: albumArtContainer
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.horizontalStretchFactor: 3

                Image {
                    id: fullAlbumArt
                    anchors.centerIn: parent
                    source: "https://lastfm.freetls.fastly.net/i/u/300x300/dd45b0438a315aed98b5830aa2fc43c5.jpg"
                    width: parent.width / 1.5
                    height: width
                }
            }

            Item {
                id: textAndControlsContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.horizontalStretchFactor: 2

                ColumnLayout {
                    id: textAndControlsLayout
                    anchors.fill: parent

                    Item {
                        id: trackInfoContainer
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        //Layout.margins: 10

                        Text {
                            id: trackInfo
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            text: "Title\nArtist\nAlbum"
                            font.pointSize: 24
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    Item {
                        id: controlButtonsLayoutContainer
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            id: controlButtonsLayout
                            anchors.fill: parent
                            anchors.margins: 70

                            Image {
                                id: previousButton
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                source: "qrc:/images/previous.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("Play/Pause button clicked")
                                        // Implement play/pause functionality here
                                    }
                                }
                            }

                            Image {
                                id: playPauseButton
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                source: "qrc:/images/play.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true

                                property bool play: true // play or pause?

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (parent.play) {
                                            parent.play = false;
                                            playPauseButton.source = "qrc:/images/pause.png";
                                            console.log("Play button clicked");
                                            // Implement play functionality here
                                        } else {
                                            parent.play = true;
                                            playPauseButton.source = "qrc:/images/play.png";
                                            console.log("Pause button clicked");
                                            // Implement pause functionality here
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

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("Next button clicked")
                                        // Implement next track functionality here
                                    }
                                }
                            }
                        }
                    }
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
