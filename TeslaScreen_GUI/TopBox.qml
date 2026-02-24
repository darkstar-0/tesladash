import QtQuick 2.0
import "."

Item {
    id: topBox

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
                anchors.centerIn: parent
                font.family: digitalFont.name
                font.pixelSize: 24
                font.bold: true
                color: Theme.primary
                text: Qt.formatTime(new Date(), "hh:mm")
            }
            
            Timer {
                interval: 1000 // 1 second
                running: true
                repeat: true
                onTriggered: {
                    clockText.text = Qt.formatTime(new Date(), "hh:mm")
                }
            }
        }
    }
}