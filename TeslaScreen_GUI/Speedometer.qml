import QtQuick 2.4
import QtGraphicalEffects 1.0


Rectangle {
    color: "transparent"
    signal speedoNeedleValueChanged(int value)
    border.color: Theme.primary
    border.width: 2
    radius: 5
    anchors.fill: parent
    anchors.margins: 5
    clip: true

    EnergyFlow {
        id: energyFlow
        powerKW: 0  // Will animate with demo data
        width: parent.width
        // height: parent.height - bottomBox.height //+ (parent.height * 0.1)  // Fill from top to just above bottom box
        height: parent.height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottomBox.height
        anchors.left: parent.left 
        // anchors.leftMargin: batteryGauge.width + 100
        anchors.leftMargin: 0
    }

    BottomBox {
        id: bottomBox
        width: parent.width
        height: parent.height * 0.15
        anchors.bottom: parent.bottom
    }
    
    BatteryGauge {
        id: batteryGauge
        batteryLevel: 45  // Will connect to real data later
        width: 120
        height: 175 
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottomBox.height + (parent.height * 0.1)
    }

    SpeedometerDisplay {
        id: speedDisplay
        speed: 0
        anchors.right: parent.right
        anchors.rightMargin: 235
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottomBox.height + (parent.height * 0.1)
        z: 10  // Put speed on top of the arc
    }

    GearGauge {
        id: gearGauge
        width: 120
        height: 175
        anchors.right: parent.right
        anchors.rightMargin: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottomBox.height + (parent.height * 0.1)
    }

    // TopBox {
    //     id: topBox
    //     width: parent.width
    //     height: parent.height * 0.15
    //     anchors.top: parent.top
    // }
    // Turn Signal - Left
    Image {
        id: turnLeftOffOn
        source: ""
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        width: 40
        height: 40
    }

    // Turn Signal - Right
    Image {
        id: turnRightOffOn
        source: ""
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        width: 40
        height: 40
    }

    function park() {
        gearGauge.setGear("DI_GEAR_P")
    }

    function reverse() {
        gearGauge.setGear("DI_GEAR_R")
    }

    function neutral() {
        gearGauge.setGear("DI_GEAR_N")
    }

    function drive() {
        gearGauge.setGear("DI_GEAR_D")
    }
    
    function updateSpeedoNeedleValue(value) {
        speedDisplay.speed = value
        speedoNeedleValueChanged(value)
    }

    function leftSignalChange(leftSignal) {
        if (leftSignal === "LIGHT_ON") {
            turnLeftOffOn.source = "pics/turnLeftOn.png"
        } else if (leftSignal === "LIGHT_OFF") {
            turnLeftOffOn.source = ""
        }
    }

    function rightSignalChange(rightSignal) {
        if (rightSignal === "LIGHT_ON") {
            turnRightOffOn.source = "pics/turnRightOn.png"
        } else if (rightSignal === "LIGHT_OFF") {
            turnRightOffOn.source = ""
        }
    }

    function updatePowerValue(value) {
        energyFlow.powerKW = value
    }
}