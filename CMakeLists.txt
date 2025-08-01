cmake_minimum_required(VERSION 3.16)

project(OpenQarUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

set(CMAKE_AUTORCC ON)

qt_add_executable(appOpenQarUI
    main.cpp
    resources.qrc
)

qt_add_qml_module(appOpenQarUI
    URI OpenQarUI
    VERSION 1.0
    QML_FILES
        Main.qml
        StatusBar.qml
        ControlBar.qml
        RESOURCES resources.qrc
        QML_FILES pages/MainMenu.qml
        QML_FILES ContentPane.qml
        QML_FILES pages/MenuButton.qml
        QML_FILES pages/SettingsPage.qml
        QML_FILES pages/MusicMenu.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appOpenQarUI PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appOpenQarUI
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appOpenQarUI
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appOpenQarUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
