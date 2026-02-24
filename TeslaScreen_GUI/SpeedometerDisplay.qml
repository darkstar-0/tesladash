import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."

Item {
    id: speedometer
    width: 300
    height: 100
    
    property int speed: 0
    
    // Load the 7-segment digital font
    FontLoader {
        id: digitalFont
        source: "fonts/digital-7.ttf"
    }
    
     Rectangle {
        id: outerBorder
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.primary
        border.width: 3
        radius: 2

        Rectangle {
            id: background
            anchors.fill: parent
            anchors.margins: 2
            color: Theme.backgroundAlt
            radius: 3

            // Speed number
            Text {
                id: speedDigit
                text: speed
                font.pixelSize: 70
                font.bold: false
                font.family: digitalFont.name
                font.letterSpacing: 8
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.bottom: parent. bottom
                anchors.bottomMargin: 10
                color: Theme.secondary
            }
            
            // Glow effect for LED look
            Glow {
                anchors.fill: speedDigit
                radius: 8
                samples: 17
                color: Theme.secondary
                source: speedDigit
                opacity: 0.5
            }
            
            Text {
                text: "mph"
                font.pixelSize: 16
                font.bold: true
                color: Theme.textActive
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.bottom: parent. bottom
                anchors.bottomMargin: 20
            }
        }
     }

     Rectangle {
        id: textBackground
        color: Theme.backgroundAlt
        width: 65
        height: 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: outerBorder.left
        anchors.leftMargin: -30
    }
    
    // "BATTERY" label at top - outside and above the border
    Text {
        id: batteryLabel
        text: "SPEED"
        font.pixelSize: 18
        font.bold: true
        color: Theme.primary
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: outerBorder.left
        anchors.leftMargin: -30
    }
    
}
