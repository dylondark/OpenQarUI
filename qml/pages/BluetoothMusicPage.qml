import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import OpenQarUI

Page {
    id: page
    title: "Bluetooth Music"
    anchors.leftMargin: 10
    anchors.rightMargin: 10

    Frame {
        id: bluetoothMusicFrame
        width: parent.width
        height: pageBase.height

        ColumnLayout {
            id: titleAndContentLayout
            anchors.fill: parent

            Item {
                id: titleContainer
                Layout.preferredHeight: titleText.height
                Layout.fillWidth: true

                Text {
                    id: titleText
                    text: page.title
                    anchors.left: parent.left
                    font.pointSize: 24
                    font.bold: true
                    font.underline: true
                }
            }

            RowLayout {
                id: contentLayout
                Layout.fillHeight: true
                Layout.fillWidth: true

                Item {
                    id: albumArtContainer
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.horizontalStretchFactor: 3

                    Image {
                        id: fullAlbumArt
                        anchors.centerIn: parent
                        source: BluetoothMediaController.coverURL
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
                            Layout.rightMargin: 65

                            Text {
                                id: trackTitle
                                anchors.bottom: trackArtist.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                text: BluetoothMediaController.title
                                font.pointSize: 24
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Text {
                                id: trackArtist
                                anchors.bottom: trackAlbum.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                text: BluetoothMediaController.artist
                                font.pointSize: 24
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Text {
                                id: trackAlbum
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                text: BluetoothMediaController.album
                                font.pointSize: 24
                                font.italic: true
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

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            BluetoothMediaController.next();
                                        }
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
