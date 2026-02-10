import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import OpenQarUI

Pane {
    id: settingsPage

    background: Rectangle {
        color: Qt.rgba(0, 0, 0, 0)
    }

    ColumnLayout {
        id: settingsLayout
        spacing: 24
        //anchors.margins: 24
        implicitWidth: parent.width

        Frame {
            Layout.fillWidth: true
            padding: 16

            ColumnLayout {
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    text: "Bluetooth Device"
                    font.pixelSize: 20
                    font.bold: true
                    Layout.fillWidth: true
                    color: AppearanceData.text
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Connected Devices: "
                        font.pixelSize: 16
                        Layout.fillWidth: false
                        color: AppearanceData.text
                    }

                    Connections {
                        target: BluetoothMediaController
                        function onErrorOccurred(message) {
                            deviceComboBox.currentIndex = -1; // Reset selection on error
                            errorLabel.text = message;
                        }
                    }

                    ComboBox {
                        id: deviceComboBox
                        Layout.fillWidth: true
                        textRole: "name"
                        model: BluetoothMediaController.getConnectedDevices()
                        currentIndex: -1 // No selection by default

                        onActivated: {
                            if (currentIndex >= 0) {
                                let selectedDevice = model[currentIndex];
                                let mac = selectedDevice.address; // <-- the MAC address
                                console.log("Selected:", selectedDevice.name, mac);

                                errorLabel.text = ""; // Clear previous error

                                // Call into C++ to connect
                                BluetoothMediaController.connectToDevice(mac);
                            }
                        }

                        Component.onCompleted: {
                            // set the current device if already connected
                            if (BluetoothMediaController.connected) {
                                for (let i = 0; i < model.length; i++) {
                                    if (model[i].name === BluetoothMediaController.deviceName) {
                                        currentIndex = i;
                                        break;
                                    }
                                }
                            }
                        }
                    }

                    Label {
                        id: errorLabel
                        text: ""
                        font.pixelSize: 16
                        color: "red"
                        Layout.fillWidth: false
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

        Frame {
            Layout.fillWidth: true
            padding: 16

            ColumnLayout {
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    text: "Audio Device"
                    font.pixelSize: 20
                    font.bold: true
                    Layout.fillWidth: true
                    color: AppearanceData.text
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Devices: "
                        font.pixelSize: 16
                        Layout.fillWidth: false
                        color: AppearanceData.text
                    }

                    Connections {
                        target: PulseAudioController
                        function onErrorOccurred(message) {
                            audioComboBox.currentIndex = -1; // Reset selection on error
                            audioErrorLabel.text = message;
                        }
                    }

                    ComboBox {
                        id: audioComboBox
                        Layout.fillWidth: true
                        textRole: "name"
                        model: PulseAudioController.sinks
                        currentIndex: -1 // No selection by default

                        onActivated: {
                            if (currentIndex >= 0) {
                                let selectedDevice = model[currentIndex];
                                let index = selectedDevice.index;
                                console.log("Selected:", selectedDevice.name, index);

                                audioErrorLabel.text = ""; // Clear previous error

                                // call into c++ to switch default sink
                                PulseAudioController.setDefaultSink(index);
                            }
                        }

                        Component.onCompleted: {
                            // set the current device if already connected
                            if (PulseAudioController.ready) {
                                for (let i = 0; i < model.length; i++) {
                                    if (model[i].name === PulseAudioController.defaultSink().name) {
                                        currentIndex = i;
                                        break;
                                    }
                                }
                            }
                        }
                    }

                    Label {
                        id: audioErrorLabel
                        text: ""
                        font.pixelSize: 16
                        color: "red"
                        Layout.fillWidth: false
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

        Frame {
            Layout.fillWidth: true
            padding: 16

            ColumnLayout {
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    text: "Appearance"
                    font.pixelSize: 20
                    font.bold: true
                    Layout.fillWidth: true
                    color: AppearanceData.text
                }

                Settings {
                    id: appearanceSettings
                    category: "Appearance"
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Dark Mode: "
                        font.pixelSize: 16
                        Layout.fillWidth: false
                        color: AppearanceData.text
                    }

                    Switch {
                        id: darkModeSwitch
                        Layout.fillWidth: true
                        checked: appearanceSettings.value("DarkMode", "false") === "false" ? false : true

                        onCheckedChanged: {
                            appearanceSettings.setValue("DarkMode", checked ? "true" : "false");
                            AppearanceData.darkMode = checked;
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Accent Color: "
                        font.pixelSize: 16
                        Layout.fillWidth: false
                        color: AppearanceData.text
                    }

                    Rectangle {
                        id: accentBlue
                        Layout.fillHeight: true
                        width: height
                        color: Qt.rgba(0, 0, 1, 1)
                        border.color: AppearanceData.border
                        radius: width / 2
                    }

                    Rectangle {
                        id: accentRed
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: Qt.rgba(1, 0, 0, 1)
                        border.color: AppearanceData.border
                        radius: width / 2
                    }

                    Rectangle {
                        id: accentGreen
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: Qt.rgba(0, 1, 0, 1)
                        border.color: AppearanceData.border
                        radius: width / 2
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

        Frame {
            Layout.fillWidth: true
            padding: 16

            ColumnLayout {
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                Settings {
                    id: cameraSettings
                    category: "BackupCamera"
                }

                Label {
                    text: "Backup Camera"
                    font.pixelSize: 20
                    font.bold: true
                    Layout.fillWidth: true
                    color: AppearanceData.text
                }

                RowLayout {
                    Layout.fillWidth: true

                    Button {
                        text: "Show"

                        onClicked: { backupCameraActive = true }
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

        Frame {
            Layout.fillWidth: true
            padding: 16

            ColumnLayout {
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                Settings {
                    id: apiSettings
                    category: "API"
                }

                Label {
                    text: "Album Art"
                    font.pixelSize: 20
                    font.bold: true
                    Layout.fillWidth: true
                    color: AppearanceData.text
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Last.FM API Key: "
                        font.pixelSize: 16
                        Layout.fillWidth: false
                        color: AppearanceData.text
                    }

                    TextField {
                        id: lfmKeyField
                        text: apiSettings.value("LastFMKey", "")
                        onAccepted: {
                            apiSettings.setValue("LastFMKey", lfmKeyField.text.trim());
                            apiSettings.sync();
                        }
                    }

                    Button {
                        id: lfmKeySetButton
                        text: "Set"
                        onClicked: {
                            apiSettings.setValue("LastFMKey", lfmKeyField.text.trim());
                            apiSettings.sync();
                        }
                    }
                }

                Label {
                    text: "Setting API key may require a program restart to apply."
                    font.pixelSize: 16
                    Layout.fillWidth: false
                    color: AppearanceData.grayedText
                    Layout.topMargin: -10
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
}
