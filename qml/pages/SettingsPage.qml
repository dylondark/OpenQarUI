import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: settingsPage
    title: "Settings"

    ColumnLayout {
        id: settingsLayout
        spacing: 24
        anchors.margins: 24
        width: parent.width

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
                    color: "black"
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Connected Devices: "
                        font.pixelSize: 16
                        Layout.fillWidth: false
                        color: "black"
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
                color: Qt.rgba(0, 0.7, 1, 0.5)
                border.color: "black"
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
                    color: "black"
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Devices: "
                        font.pixelSize: 16
                        Layout.fillWidth: false
                        color: "black"
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
                color: Qt.rgba(0, 0.7, 1, 0.5)
                border.color: "black"
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
                    color: "black"
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Dark Mode: "
                        font.pixelSize: 16
                        Layout.fillWidth: false
                        color: "black"
                    }

                    Switch {
                        id: darkModeSwitch
                        Layout.fillWidth: true
                        checked: SettingsController.darkMode

                        onCheckedChanged: {
                            SettingsController.setDarkMode(checked);
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
}
