import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import OpenQarUI
import QtQuick.VectorImage

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
                    color: AppearanceData.text
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
                        source: ((!BluetoothMediaController.connected) || (!BluetoothMediaController.coverURL.includes("http"))) ? "qrc:/images/placeholder_image/" + AppearanceData.darkModeStr + "/image.png" : BluetoothMediaController.coverURL
                        width: parent.width / 1.5
                        height: width
                        sourceSize.width: 300
                        sourceSize.height: 300
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
                                text: BluetoothMediaController.connected ? BluetoothMediaController.title : "No BT device connected"
                                font.pointSize: 24
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                color: BluetoothMediaController.connected ? AppearanceData.text : "gray"
                                elide: Text.ElideRight
                            }

                            Text {
                                id: trackArtist
                                anchors.bottom: trackAlbum.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                text: BluetoothMediaController.artist
                                font.pointSize: 24
                                horizontalAlignment: Text.AlignHCenter
                                color: AppearanceData.text
                                elide: Text.ElideRight
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
                                color: AppearanceData.text
                                elide: Text.ElideRight
                            }
                        }

                        Item {
                            id: controlButtonsLayoutContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            RowLayout {
                                id: controlButtonsLayout
                                anchors.fill: parent
                                anchors.margins: 40

                                VectorImage {
                                    id: previousButton
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: height
                                    source: "qrc:/images/media/" + AppearanceData.darkModeStr + "/previous.svg"
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
                                    source: BluetoothMediaController.playing ? "qrc:/images/media/" + AppearanceData.darkModeStr + "/pause.svg" : "qrc:/images/media/" + AppearanceData.darkModeStr + "/play.svg"
                                    fillMode: VectorImage.PreserveAspectFit
                                    preferredRendererType: VectorImage.CurveRenderer

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
                                    source: "qrc:/images/media/" + AppearanceData.darkModeStr + "/next.svg"
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
                        }
                    }
                }
            }
        }

        background: Rectangle {
            color: AppearanceData.darkMode ? AppearanceData.accentColorDark : AppearanceData.accentColorLight
            border.color: AppearanceData.border
            border.width: 1
            radius: 5
        }
    }
}
