cmake_minimum_required(VERSION 3.16)

project(OpenQarUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

set(CMAKE_AUTORCC ON)

# Add include directory for headers
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

qt_add_executable(appOpenQarUI
    src/main.cpp
    resources.qrc
)

qt_add_qml_module(appOpenQarUI
    URI OpenQarUI
    VERSION 1.0
    QML_FILES
        Main.qml
        StatusBar.qml
        ControlBar.qml
        ContentPane.qml
        pages/MainMenu.qml
        pages/MenuButton.qml
        pages/SettingsPage.qml
        pages/MusicMenu.qml
        pages/BluetoothMusicPage.qml
    RESOURCES
        resources.qrc
    SOURCES
        src/bluetoothmediacontroller.cpp
        include/bluetoothmediacontroller.h
)

set_target_properties(appOpenQarUI PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appOpenQarUI
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
)

include(GNUInstallDirs)
install(TARGETS appOpenQarUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
