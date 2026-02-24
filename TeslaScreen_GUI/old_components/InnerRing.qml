import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    property int speed: 0

    height: 120 // Fit within 200px window
    width: 200 // Wider for the digital number

    // Load the 7-segment font
    FontLoader {
        id: digitalFont
        source: "fonts/digital-7.ttf"
    }

    Rectangle {
        id: innerRingRect
        height: parent.height
        width: parent.width
//        source: "pics/Tacho_Mitte3_1.png"
	color: "transparent"

        Text {
            id: speeddigit
            text: speed
            //text: '155'
            font.pixelSize: 70
            font.bold: false
            font.family: digitalFont.name
            font.letterSpacing: 8
	    anchors.centerIn: parent // Center it in the InnerRing
            color: "#00FFFF"  // Bright cyan
        }

        // Glow effect for that LED look
        Glow {
            anchors.fill: speeddigit
            radius: 8
            samples: 17
            color: "#00ff00"
            source: speeddigit
            opacity: 0.5
        }

        DropShadow {
            anchors.fill: speeddigit
            horizontalOffset: 0
            verticalOffset: 8
            radius: 4.0
            samples: 16
            color: "black"
            source: speeddigit
        }

        Text {
            text: "mph"
            font.pixelSize: 16
            font.bold: true
            font.family: "Eurostile"
            y: 85
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }

//        Image {
//            id: turnLeftOffOn
//            source: ""
//            x: -250 // move way left
//	    y: -80 // move to top
//         }
//
//        Image {
//            id: turnRightOffOn
//            source: ""
//            x: 220 // move way right
//	    y: -80 // move to top
//         }
//    }

//    function leftSignalOn() {
//        turnLeftOffOn.source = "pics/turnLeftOn.png"
//    }
//
//    function leftSignalOff() {
//        turnLeftOffOn.source = ""
//    }
//
//    function rightSignalOn() {
//        turnRightOffOn.source = "pics/turnRightOn.png"
//    }
//
//    function rightSignalOff() {
//        turnRightOffOn.source = ""
//    }
    }
}
