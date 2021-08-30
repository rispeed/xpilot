import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Window 2.15
import QtQuick.Layouts 1.12
import QtWebSockets 1.2
import "../Components"

Window {
    property bool isModeC: false
    property QtObject connectWindow
    property QtObject settingsWindow
    property QtObject flightPlanWindow

    id: mainWindow
    title: "xPilot"
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    width: 800
    height: 250
    minimumHeight: 250
    minimumWidth: 800
    color: "#272C2E"

    Connections {
        target: connectWindow
        function onCloseWindow() {
            connectWindow.destroy()
        }
    }

    Connections {
        target: flightPlanWindow
        function onCloseWindow() {
            flightPlanWindow.destroy()
        }
    }

    Connections {
        target: settingsWindow
        function onCloseWindow() {
            settingsWindow.destroy()
        }
    }

    WebSocket {
        id: socket
        url: "ws://localhost:9000/ws"
        active: true

        onBinaryMessageReceived: {
            console.log(message)
        }

        onTextMessageReceived: {
            console.log(message)
        }

        onStatusChanged: {
            switch(socket.status) {
            case WebSocket.Connecting:
                console.log('connecting...')
                break;
            case WebSocket.Open:
                console.log('open')
                break;
            case WebSocket.Closing:
                console.log('closing')
                break;
            case WebSocket.Closed:
                console.log('closed')
                break;
            case WebSocket.Error:
                console.log('Error: ' + errorString)
                break;
            }
        }
    }

    FontLoader {
        id: ubuntuRegular
        source: "../Fonts/Ubuntu-Regular.ttf"
    }

    FontLoader {
        id: robotoMono
        source: "../Fonts/Roboto-Mono.ttf"
    }

    Rectangle {
        id: windowFrame
        anchors.fill: parent
        color: "transparent"
        border.color: Qt.platform.os === 'osx' ? 'transparent' : '#000000'
        z: 200
    }

    GridLayout {
        anchors.fill: parent
        rowSpacing: 0
        columnSpacing: 0
        rows: 2
        columns: 2
        z: 100

        Rectangle {
            id: radioStack
            Layout.preferredWidth: 250
            Layout.preferredHeight: 75
            Layout.row: 0
            Layout.column: 0
            color: "#0164AD"

            RadioStack {
                anchors.verticalCenter: parent.verticalCenter
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0
            }
        }

        Rectangle {
            id: toolbar
            Layout.row: 0
            Layout.column: 1
            color: "transparent"
            Layout.preferredHeight: 75
            Layout.fillWidth: true

            Toolbar {

            }
        }

        Rectangle {
            id: nearbyAtc
            Layout.row: 1
            Layout.column: 0
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            color: "transparent"

            NearbyAtc {
                anchors.fill: parent
            }
        }

        Rectangle {
            id: messages
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.row: 1
            Layout.column: 1
            color: "#141618"
        }
    }

    MouseArea {
        id: mouseArea
        property real lastMouseX: 0
        property real lastMouseY: 0
        property int activeEdges: 0
        property int gutterSize: 8
        property bool moveable: false
        hoverEnabled: true
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        cursorShape: {
            const p = Qt.point(mouseX, mouseY)
            if (p.x < gutterSize && p.y < gutterSize)
                return Qt.SizeFDiagCursor
            if (p.x >= width - gutterSize && p.y >= height - gutterSize)
                return Qt.SizeFDiagCursor
            if (p.x >= width - gutterSize && p.y < gutterSize)
                return Qt.SizeBDiagCursor
            if (p.x < gutterSize && p.y >= height - gutterSize)
                return Qt.SizeBDiagCursor
            if (p.x < gutterSize || p.x >= width - gutterSize)
                return Qt.SizeHorCursor
            if (p.y < gutterSize || p.y >= height - gutterSize)
                return Qt.SizeVerCursor
        }

        onDoubleClicked: {
            if (mainWindow.visibility == Window.Maximized) {
                mainWindow.showNormal()
            } else {
                mainWindow.showMaximized()
            }
            moveable = false
        }

        onPressed: {
            if (mouse.button !== Qt.LeftButton
                    || mainWindow.visibility === Window.Maximized
                    || mainWindow.visibility === Window.FullScreen) {
                return
            }
            activeEdges = 0
            if (mouseX < gutterSize)
                activeEdges |= Qt.LeftEdge
            if (mouseY < gutterSize)
                activeEdges |= Qt.TopEdge
            if (mouseX > mainWindow.width - gutterSize)
                activeEdges |= Qt.RightEdge
            if (mouseY > mainWindow.height - gutterSize)
                activeEdges |= Qt.BottomEdge

            if (mainWindow.startSystemMove != undefined
                    && Qt.platform.os !== "osx") {
                if (activeEdges == 0) {
                    mainWindow.startSystemMove()
                } else {
                    mainWindow.startSystemResize(activeEdges)
                }
            } else {
                lastMouseX = mouseX
                lastMouseY = mouseY
                moveable = (activeEdges === 0)
            }
        }

        onReleased: {
            activeEdges = 0
            moveable = false
        }

        onMouseXChanged: {
            // Use system native move & resize on Qt >= 5.15
            if (mainWindow.startSystemMove != undefined
                    && Qt.platform.os !== "osx") {
                return
            }

            if (mainWindow.visibility == Window.Maximized
                    || mainWindow.visibility == Window.FullScreen || !pressed) {
                return
            }

            if (activeEdges & Qt.LeftEdge) {
                mainWindow.width -= (mouseX - lastMouseX)
                if (mainWindow.width < window.minimumWidth) {
                    mainWindow.width = window.minimumWidth
                } else {
                    mainWindow.x += (mouseX - lastMouseX)
                }
            } else if (activeEdges & Qt.RightEdge) {
                mainWindow.width += (mouseX - lastMouseX)
                if (mainWindow.width < window.minimumWidth) {
                    mainWindow.width = window.minimumWidth
                }
                lastMouseX = mouseX
            } else if (moveable) {
                mainWindow.x += (mouseX - lastMouseX)
            }
        }

        onMouseYChanged: {
            // Use system native move & resize on Qt >= 5.15
            if (mainWindow.startSystemMove != undefined
                    && Qt.platform.os !== "osx") {
                return
            }

            if (mainWindow.visibility == Window.Maximized
                    || mainWindow.visibility == Window.FullScreen || !pressed) {
                return
            }

            if (activeEdges & Qt.TopEdge) {
                mainWindow.height -= (mouseY - lastMouseY)
                if (mainWindow.height < window.minimumHeight) {
                    mainWindow.height = window.minimumHeight
                } else {
                    mainWindow.y += (mouseY - lastMouseY)
                }
            } else if (activeEdges & Qt.BottomEdge) {
                mainWindow.height += (mouseY - lastMouseY)
                if (mainWindow.height < window.minimumHeight) {
                    mainWindow.height = window.minimumHeight
                }
                lastMouseY = mouseY
            } else if (moveable) {
                mainWindow.y += (mouseY - lastMouseY)
            }
        }
    }
}
