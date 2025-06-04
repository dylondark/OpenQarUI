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

        RowLayout {
            id: musicBase
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 10

            Image {
                id: albumImage
                Layout.fillHeight: true
                Layout.preferredWidth: height
                source: "https://lastfm.freetls.fastly.net/i/u/300x300/dd45b0438a315aed98b5830aa2fc43c5.jpg"
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                smooth: true
            }

            ColumnLayout {
               id: songTextLayout
                Layout.fillHeight: true
                Layout.fillWidth: false
                Layout.leftMargin: 10
                spacing: 0

                Text {
                    id: songTitle
                    Layout.fillWidth: true
                    text: "Song Title"
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVBottom
                    horizontalAlignment: Text.AlignLeft
                    font.bold: true
                }

                Text {
                    id: artistName
                    Layout.preferredHeight: 28 // i dont know why this positions it correctly but i guess we'll keep it
                    Layout.fillWidth: true
                    text: "Artist Name"
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
                Layout.topMargin: 10
                Layout.bottomMargin: 10

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
                Layout.margins: 10

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Next button clicked")
                        // Implement next track functionality here
                    }
                }
            }
        }

        ToolSeparator { }

        Item {
            id: volumeBase
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
