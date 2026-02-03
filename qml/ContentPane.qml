import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "pages" as Pages

ScrollView {
    id: pageBase
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    //onWidthChanged: column.width = pageBase.width // for some reason the column cant update its own width...

    function goHome() {
        swipeView.previousIndex = swipeView.currentIndex
        swipeView.setCurrentIndex(0)
        swipeView.animating = true
        animatingTimer.start()
    }

    Column {
        id: column
        width: pageBase.width

        SwipeView {
            id: swipeView
            currentIndex: 0
            implicitWidth: parent.width
            orientation: Qt.Horizontal
            interactive: false

            property bool animating: false
            property int previousIndex: 0

            Timer {
                id: animatingTimer
                interval: 2000
                repeat: false
                onTriggered: { swipeView.animating = false }
            }

            Pages.MainMenu {
                id: mainMenu
            }

            /*Component {
                id: musicMenuComponent

                Pages.MusicMenu {
                    id: musicMenu
                    anchors.left: stackView.left
                    anchors.right: stackView.right
                    anchors.margins: 10
                }
            }*/

            /*Component {
                id: settingsMenuComponent

                Pages.SettingsMenu {
                    id: settingsMenu
                    anchors.left: stackView.left
                    anchors.right: stackView.right
                    anchors.margins: 10
                }
            }*/

            Loader {
                id: bluetoothMusicPageLoader
                active: swipeView.currentIndex === 1 || (swipeView.previousIndex == 1 && animating)

                sourceComponent: Pages.BluetoothMusicPage {
                    id: bluetoothMusicPage
                }
            }

            Loader {
                id: settingsPageLoader
                active: swipeView.currentIndex === 2 || (swipeView.previousIndex == 2 && animating)

                sourceComponent: Pages.SettingsPage {
                    id: settingsPage
                }
            }
        }
    }
}
