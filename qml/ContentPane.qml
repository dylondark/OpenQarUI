import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "pages" as Pages

ScrollView {
    id: pageBase
    Layout.fillWidth: true
    Layout.fillHeight: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    onWidthChanged: column.width = pageBase.width // for some reason the column cant update its own width...

    function goHome() {
        stackView.pop(stackView.depth - 1) // pop all items except the first one (main menu)
    }

    Column {
        id: column
        height: 1

        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: mainMenuComponent

            pushEnter: Transition {
                NumberAnimation { property: "x"; from: pageBase.width; to: 0; duration: 250; easing.type: Easing.InOutQuad }
            }

            popExit: Transition {
                NumberAnimation { property: "x"; from: 0; to: pageBase.width; duration: 250; easing.type: Easing.InOutQuad }
            }

            // Home/Main page component
            Component {
                id: mainMenuComponent

                Pages.MainMenu {
                    id: mainMenu
                    anchors.left: stackView.left
                    anchors.right: stackView.right
                    anchors.margins: 10
                }
            }

            Component {
                id: musicMenuComponent

                Pages.MusicMenu {
                    id: musicMenu
                    anchors.left: stackView.left
                    anchors.right: stackView.right
                    anchors.margins: 10
                }
            }

            Component {
                id: settingsMenuComponent

                Pages.SettingsMenu {
                    id: settingsMenu
                    anchors.left: stackView.left
                    anchors.right: stackView.right
                    anchors.margins: 10
                }
            }

            // Settings page component
            Component {
                id: settingsPageComponent

                Pages.SettingsPage {
                    id: settingsPage
                    anchors.fill: parent
                    //width: pageBase.width
                    anchors.margins: 10
                }
            }

            Component {
                id: bluetoothMusicPageComponent

                Pages.BluetoothMusicPage {
                    id: bluetoothMusicPage
                    anchors.fill: parent
                    //anchors.margins: 10
                }
            }
        }
    }
}
