import QtQuick 2.0
import "."

Item {
    id: bottomBox

    FontLoader {
        id: digitalFont
        source: "fonts/digital-7.ttf"
    }
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
            anchors.margins: 2
            color: Theme.backgroundAlt
            radius: 3

            Text {
                id: clockText
                property bool showColon: true
                property color colonColor: showColon ? Theme.primary : Theme.backgroundAlt
                
                anchors.centerIn: parent
                font.family: digitalFont.name
                font.pixelSize: 36
                font.bold: true
                color: Theme.primary
                
                text: Qt.formatTime(new Date(), "hh") + 
                      "<font color='" + colonColor + "'>:</font>" + 
                      Qt.formatTime(new Date(), "mm")
                textFormat: Text.RichText
            }
            
            Timer {
                interval: 1000 // 1 second
                running: true
                repeat: true
                onTriggered: {
                    clockText.showColon = !clockText.showColon
                }
            }
        }
    }
}