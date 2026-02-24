import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."

Item {
    id: gearGauge
    
    property string currentGear: "P"  // P, R, N, or D
    
    // Red border frame
    Rectangle {
        id: borderFrame
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.primary
        border.width: 3
        radius: 2
        
        // Inner black background
        Rectangle {
            id: background
            anchors.fill: parent
            anchors.margins: 2
            color: Theme.backgroundAlt
            radius: 3
            
            // Gear letters stacked vertically
            Column {
                anchors.centerIn: parent
                spacing: 1
                
                Text {
                    id: letterP
                    text: "P"
                    font.pixelSize: currentGear === "P" ? 36 : 18
                    font.bold: currentGear === "P"
                    color: currentGear === "P" ? Theme.textActive : Theme.textInactive
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    id: letterR
                    text: "R"
                    font.pixelSize: currentGear === "R" ? 36 : 18
                    font.bold: currentGear === "R"
                    color: currentGear === "R" ? Theme.textActive : Theme.textInactive
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    id: letterN
                    text: "N"
                    font.pixelSize: currentGear === "N" ? 36 : 18
                    font.bold: currentGear === "N"
                    color: currentGear === "N" ? Theme.textActive : Theme.textInactive
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    id: letterD
                    text: "D"
                    font.pixelSize: currentGear === "D" ? 36 : 18
                    font.bold: currentGear === "D"
                    color: currentGear === "D" ? Theme.textActive : Theme.textInactive
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
    
    // Glow effect on active gear
    // Glow {
    //     anchors.fill: borderFrame
    //     radius: 8
    //     samples: 17
    //     color: "#00FFFF"
    //     source: borderFrame
    //     opacity: 0.3
    // }
    
    // Function to update gear
    function setGear(gear) {
        // gear will be like "DI_GEAR_P", extract the letter
        if (gear.indexOf("P") !== -1) {
            currentGear = "P"
        } else if (gear.indexOf("R") !== -1) {
            currentGear = "R"
        } else if (gear.indexOf("N") !== -1) {
            currentGear = "N"
        } else if (gear.indexOf("D") !== -1) {
            currentGear = "D"
        }
    }

    Rectangle {
        id: textBackground
        color: Theme.backgroundAlt
        width: 60
        height: 25
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: borderFrame.top
        anchors.bottomMargin: -15
    }
    
    Text {
        id: batteryLabel
        text: "GEAR"
        font.pixelSize: 18
        font.bold: true
        color: Theme.primary
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: borderFrame.top
        anchors.bottomMargin: -12
    }
}
