import QtQuick
import QtMultimedia
import QtQuick.Controls
import QtCore

Rectangle {
    id: backupCameraBase

    visible: backupCameraActive
    color: Qt.gray

    Settings {
        id: cameraSettings
        category: "BackupCamera"
    }

    Camera {
        // should automatically grab the camera but can add manually specifying through settings in the future
        id: camera
        active: backupCameraActive
    }

    CaptureSession {
        id: captureSession
        camera: camera
        videoOutput: videoOut
    }

    VideoOutput {
        id: videoOut
        anchors.fill: parent
        z: 9999

        Button {
            id: closeButton
            text: "Close"
            anchors.top: parent.top
            anchors.right: parent.right

            onClicked: { backupCameraActive = false }
        }
    }
}
