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

    Column {
        id: column

        Pages.MainMenu {
            id: mainMenuPage
            width: parent.width
            anchors.margins: 10
        }
    }
}
