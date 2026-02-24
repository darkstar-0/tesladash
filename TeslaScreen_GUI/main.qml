import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import "."

ApplicationWindow {
    title: qsTr("Tesla Model Y Dashboard")
    width: 900
    height: 310
    visible: true
    visibility: Window.Windowed
    color: Theme.backgroundAlt

    property int needleValue: 0

    QtObject {
        property var locale: Qt.locale()
        property date currentDate: new Date()
        property string dateString
        property string timeString

        Component.onCompleted: {
            dateString = currentDate.toLocaleDateString();
            timeString = currentDate.toLocaleTimeString();
        }
    }

    // Border rectangle wrapper
    Rectangle {
	anchors.fill: parent
        anchors.margins: 0
        color: "transparent"
        border.width: 2
        border.color: Theme.border
        z: 1000  // Keep border on top
    }

    // Keyboard handler for theme switching
    Item {
        focus: true
        anchors.fill: parent
        Component.onCompleted: forceActiveFocus()
        Keys.onPressed: {
            if (event.key === Qt.Key_1) {
                Theme.currentTheme = "cyberpunk"
            } else if (event.key === Qt.Key_2) {
                Theme.currentTheme = "stealth"
            } else if (event.key === Qt.Key_3) {
                Theme.currentTheme = "arctic"
            } else if (event.key === Qt.Key_4) {
                Theme.currentTheme = "user1"
            } else if (event.key === Qt.Key_5) {
                Theme.currentTheme = "chill_2" 
            } else if (event.key === Qt.Key_6) {
                Theme.currentTheme = "chill_3" 
            } else if (event.key === Qt.Key_7) {
                Theme.currentTheme = "chill_4" 
            } else if (event.key === Qt.Key_8) {
                Theme.currentTheme = "chill_5" 
            } else if (event.key === Qt.Key_9) {
                Theme.currentTheme = "chill_6" 
            } else if (event.key === Qt.Key_0) {
                Theme.currentTheme = "chill_7" 
            }
        }
    }

    Speedometer {
        id: speedometer
        anchors.fill: parent
    }

    Connections {
        target: speedValue

        function onSpeedNeedleValue(speed) {
            needleValue = speed
            speedometer.updateSpeedoNeedleValue(needleValue)
        }
    }

    Connections {
        target: gearValue
        
        function onGearChanged(gear) {
            if (gear === "DI_GEAR_P") {
                speedometer.park();
            } else if (gear === "DI_GEAR_D") {
                speedometer.drive();
            } else if (gear === "DI_GEAR_R") {
                speedometer.reverse();
            } else if (gear === "DI_GEAR_N") {
                speedometer.neutral();
            }
        }
    }

    Connections {
        target: leftSignalValue
        
        function onLeftSignalChanged(leftSignal) {
            speedometer.leftSignalChange(leftSignal)
        }
    }

    Connections {
        target: rightSignalValue
        
        function onRightSignalChanged(rightSignal) {
            speedometer.rightSignalChange(rightSignal)
        }
    }

    Connections {
        target: powerValue
        function onPowerChanged(power) {
            speedometer.updatePowerValue(power)
        }
    }

    // Timer {
    //     interval: 1000 // 1 second
    //     repeat: true
    //     running: true

    //     onTriggered: {
    //         photoPopup.visible = !photoPopup.visible; // Toggle visibility
    //     }
    // }
}

