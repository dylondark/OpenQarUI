cmake_minimum_required(VERSION 3.16)

project(OpenQarUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Core)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

set(CMAKE_AUTORCC ON)

# Include directory for headers
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

# Collect all source and header files
file(GLOB_RECURSE SOURCES src/*.cpp)
file(GLOB_RECURSE HEADERS include/*.h)

# Add executable
qt_add_executable(appOpenQarUI
    ${SOURCES}
    ${HEADERS}
    resources.qrc
)

# QML module
qt_add_qml_module(appOpenQarUI
    URI OpenQarUI
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/StatusBar.qml
        qml/ControlBar.qml
        qml/ContentPane.qml
        qml/pages/MainMenu.qml
        qml/pages/MenuButton.qml
        qml/pages/SettingsPage.qml
        qml/pages/MusicMenu.qml
        qml/pages/BluetoothMusicPage.qml
    RESOURCES
        resources.qrc
)

# Set target properties for macOS bundle and Windows executable
set_target_properties(appOpenQarUI PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Link Qt libraries
target_link_libraries(appOpenQarUI
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE Qt6::DBus
)
target_link_libraries(appOpenQarUI PRIVATE Qt6::Core)

# Install rules
include(GNUInstallDirs)
install(TARGETS appOpenQarUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
