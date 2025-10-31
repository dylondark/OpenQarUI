pragma Singleton

import QtQuick
import QtQml
import QtCore

QtObject {
    property bool darkMode: false
    property string darkModeStr: darkMode ? "dark" : "light"

    property color background: darkMode ? Qt.rgba(0, 0, 0, 0.5) : Qt.rgba(1, 1, 1, 0.5)
    property color coloredBackground: darkMode ? Qt.rgba(0, 0.4, 0.8, 0.5) : Qt.rgba(0, 0.7, 1, 0.5)
    property color border: darkMode ? Qt.rgba(0.8, 0.8, 0.8, 1) : Qt.rgba(0, 0, 0, 1)
    property color text: darkMode ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1)
}
