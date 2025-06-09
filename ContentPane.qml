import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "pages" as Pages

ScrollView {
    id: pageBase
    Layout.fillWidth: true
    Layout.fillHeight: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

    Column {
        width: parent.width

        Pages.MainMenu {
            id: mainMenuPage
            width: parent.width
            anchors.margins: 10
        }
    }
}
