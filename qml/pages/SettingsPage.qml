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
                    font.pixelSize: 22
                    Layout.fillWidth: true
                    color: "black"
                }

                RowLayout {
                    Layout.fillWidth: true

                    ComboBox {
                        id: deviceComboBox
                        Layout.fillWidth: true
                        textRole: "name"
                        model: deviceModel
                        currentIndex: -1 // No selection by default

                        ListModel {
                            id: deviceModel
                        }

                        function populateDevices() {
                            // Call the C++ method
                            let devices = BluetoothMediaController.getPairedDevices();

                            // Convert into JS objects
                            let list = [];
                            for (let i = 0; i < devices.length; i++) {
                                let tuple = devices[i];
                                list.push({
                                              address: tuple[0],
                                              name: tuple[1],
                                              connected: tuple[2]
                                          });
                            }

                            if (list.length === 0) {
                                // If no devices, insert placeholder
                                deviceModel.clear();
                                deviceModel.append({
                                                       address: "none",
                                                       name: "No devices found",
                                                       connected: false
                                                   });
                                return;
                            }

                            // Sort: connected devices first
                            list.sort(function(a, b) {
                                if (a.connected === b.connected) return 0;
                                return a.connected ? -1 : 1;
                            });

                            // Clear and refill the ListModel
                            deviceModel.clear();
                            for (let i = 0; i < list.length; i++) {
                                deviceModel.append(list[i]);
                            }
                        }

                        Component.onCompleted: populateDevices()
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
