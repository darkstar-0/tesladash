import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."

Item {
    id: batteryGauge
    
    property int batteryLevel: 45  // Percentage 0-100
    
    // Red outer border frame (primary color)
    Rectangle {
        id: outerBorder
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.primary  // Red border
        border.width: 3
        radius: 2

        Rectangle {
            id: background
            anchors.fill: parent
            anchors.margins: 2
            color: Theme.backgroundAlt
            radius: 3

            // Inner black background
            Rectangle {
                id: batteryBackground
                anchors.fill: parent
                anchors.rightMargin: 35
                anchors.leftMargin: 35
                anchors.topMargin: 45
                anchors.bottomMargin: 15
                color: Theme.backgroundAlt
                radius: 3
                
                // Cyan battery border (inner)
                Rectangle {
                    id: batteryBorder
                    anchors.fill: parent
                    anchors.margins: 3
                    color: "transparent"
                    border.color: Theme.secondary  // Cyan border
                    border.width: 2
                    radius: 2
                    
                    // Battery fill (cyan gradient)
                    Rectangle {
                        id: batteryFill
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 4
                        height: (parent.height - 8) * (batteryLevel / 100.0)
                        
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Theme.secondary }
                            GradientStop { position: 0.5; color: Qt.darker(Theme.secondary, 1.1) }
                            GradientStop { position: 1.0; color: Theme.secondary }
                        }
                        
                        radius: 2
                    }
                    
                    // Glow effect on the fill
                    Glow {
                        anchors.fill: batteryFill
                        radius: 8
                        samples: 17
                        color: Theme.glowColor
                        source: batteryFill
                        opacity: 0.6
                    }
                }
                
                // Mid-point arrow (at 50%)
                Text {
                    text: "▶"
                    font.pixelSize: 10
                    color: Theme.secondary
                    anchors.right: batteryBorder.left
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    rotation: 0
                }
                // "F" (Full) label - cyan color
                Text {
                    text: "F"
                    font.pixelSize: 18
                    font.bold: true
                    color: Theme.secondary  // Cyan
                    anchors.right: batteryBorder.left
                    anchors.rightMargin: 5
                    anchors.top: batteryBorder.top
                    anchors.topMargin: -3
                }
                
                // "E" (Empty) label - cyan color
                Text {
                    text: "E"
                    font.pixelSize: 18
                    font.bold: true
                    color: Theme.secondary  // Cyan
                    anchors.right: batteryBorder.left
                    anchors.rightMargin: 5
                    anchors.bottom: batteryBorder.bottom
                    anchors.bottomMargin: -3
                }
                
                // Battery percentage text
                Text {
                    text: batteryLevel + "%"
                    font.pixelSize: 18
                    font.bold: true
                    color: Theme.secondary
                    // anchors.left: batteryBorder.right
                    anchors.horizontalCenter: batteryBorder.horizontalCenter
                    anchors.bottom: batteryBorder.top
                    anchors.bottomMargin: 10
                }
            }
        }
    }

    Rectangle {
        id: textBackground
        color: Theme.backgroundAlt
        width: 90
        height: 25
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: outerBorder.top
        anchors.bottomMargin: -15
    }
    
    // "BATTERY" label at top - outside and above the border
    Text {
        id: batteryLabel
        text: "BATTERY"
        font.pixelSize: 18
        font.bold: true
        color: Theme.primary
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: outerBorder.top
        anchors.bottomMargin: -12
    }
}
