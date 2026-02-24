import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."

Item {
    id: batteryGauge
    width: 80
    height: 200
    
    property int batteryLevel: 85  // Percentage 0-100

    // Red border frame
    Rectangle {
        id: borderFrame
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.primary
        border.width: 3
        radius: 5
        
        // Inner black background
        Rectangle {
            id: background
            anchors.fill: parent
            anchors.margins: 5
            color: Theme.background
            radius: 3
            
            // Battery fill (cyan gradient)
            Rectangle {
                id: batteryFill
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 3
                height: parent.height * (batteryLevel / 100.0)
                
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Theme.secondary }
                    GradientStop { position: 0.5; color: "#00DDDD" }
                    GradientStop { position: 1.0; color: Theme.secondary }
                }
                
                radius: 2
            }
            
            // Glow effect on the fill
            Glow {
                anchors.fill: batteryFill
                radius: 8
                samples: 17
                color: Theme.secondary
                source: batteryFill
                opacity: 0.6
            }
        }
    }
    
    // "BATTERY" label at top
    Text {
        id: batteryLabel
        text: "BATTERY"
        font.pixelSize: 12
        font.bold: true
        color: Theme.primary
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 5
    }
    
    // "F" (Full) label at top
    Text {
        text: "F"
        font.pixelSize: 14
        font.bold: true
        color: Theme.primary
        anchors.right: parent.left
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 10
    }
    
    // "E" (Empty) label at bottom
    Text {
        text: "E"
        font.pixelSize: 14
        font.bold: true
        color: Theme.primary
        anchors.right: parent.left
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }
    
    // Battery percentage text (optional - can remove if you don't want it)
    Text {
        text: batteryLevel + "%"
        font.pixelSize: 12
        font.bold: true
        color: Theme.secondary
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 5
    }
}
