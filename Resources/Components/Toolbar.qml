import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import "../Controls"

GridLayout {
    id: toolbar
    columns: 2
    anchors.fill: parent

    Row {
        leftPadding: 15
        spacing: 5

        ToolbarButton {
            id: btnConnect
            text: "Connect"
            MouseArea {
                id: btnConnectMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {

                }
            }
        }

        TransponderButton {
            id: btnModeC
            text: "Mode C"
            MouseArea {
                preventStealing: true
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    isModeC = !isModeC
                    btnModeC.isActive = isModeC
                }
            }
        }

        ToolbarButton {
            id: btnFlightPlan
            text: "Flight Plan"
            MouseArea {
                id: btnFlightPlanMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {

                }
            }
        }

        ToolbarButton {
            id: btnSettings
            text: "Settings"
            MouseArea {
                id: btnSettingsMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {

                }
            }
        }
    }

    Row {
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        rightPadding: 15
        layoutDirection: Qt.RightToLeft
        spacing: -10

        WindowControlButton {
            id: btnClose
            icon.source: "../Icons/CloseIcon.svg"
            icon.color: "transparent"
            icon.width: 20
            icon.height: 20
            onHoveredChanged: hovered ? icon.color = "white" : icon.color = "transparent"

            MouseArea {
                id: btnCloseMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    window.close()
                }
            }
        }

        WindowControlButton {
            id: btnMinimize
            icon.source: "../Icons/MinimizeIcon.svg"
            icon.color: "transparent"
            icon.width: 20
            icon.height: 20
            onHoveredChanged: hovered ? icon.color = "white" : icon.color = "transparent"

            MouseArea {
                id: btnMinimizeMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    window.visibility = "Minimized"
                }
            }
        }
    }
}
