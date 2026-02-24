import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: energyFlow
    width: 400
    height: 200
    
    property int powerKW: 0  // Current power: negative = regen, positive = discharge
    property int minPower: -100  // -100 kW (max regen)
    property int maxPower: 300   // 300 kW (max discharge)
    
    // Calculate needle angle based on power
    // Arc spans 180 degrees: -90° (left) to +90° (right)
    property real needleAngle: {
        var range = maxPower - minPower  // 400 total range
        var normalized = (powerKW - minPower) / range  // 0 to 1
        return (normalized * 180) - 90  // -90 to +90 degrees
    }
    
    // Needle color: cyan/green for regen, yellow for discharge
    property color needleColor: powerKW < 0 ? "#00FFFF" : "#FFD700"
    
    // Canvas for drawing the arc
    Canvas {
        id: arcCanvas
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            var centerX = width / 2
            var centerY = height - 20  // Bottom center
            var radius = height - 40
            var lineWidth = 3
            
            // Draw the main arc (red)
            ctx.strokeStyle = "#FF0000"
            ctx.lineWidth = lineWidth
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, Math.PI, 0, false)  // 180° arc
            ctx.stroke()
            
            // Draw tick marks
            ctx.strokeStyle = "#FF0000"
            ctx.lineWidth = 2
            
            // Major ticks every 50 kW
            for (var kw = minPower; kw <= maxPower; kw += 50) {
                var angle = ((kw - minPower) / (maxPower - minPower)) * Math.PI
                var startRadius = radius - 10
                var endRadius = radius + 5
                
                var x1 = centerX + startRadius * Math.cos(Math.PI - angle)
                var y1 = centerY - startRadius * Math.sin(Math.PI - angle)
                var x2 = centerX + endRadius * Math.cos(Math.PI - angle)
                var y2 = centerY - endRadius * Math.sin(Math.PI - angle)
                
                ctx.beginPath()
                ctx.moveTo(x1, y1)
                ctx.lineTo(x2, y2)
                ctx.stroke()
                
                // Draw tick labels
                var labelRadius = radius + 20
                var labelX = centerX + labelRadius * Math.cos(Math.PI - angle)
                var labelY = centerY - labelRadius * Math.sin(Math.PI - angle)
                
                ctx.fillStyle = "#FF0000"
                ctx.font = "10px Arial"
                ctx.textAlign = "center"
                ctx.fillText(kw.toString(), labelX, labelY + 5)
            }
        }
    }
    
    // Needle
    Rectangle {
        id: needle
        width: 4
        height: energyFlow.height - 60
        color: needleColor
        antialiasing: true
        
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        
        transformOrigin: Item.Bottom
        rotation: needleAngle
        
        // Needle tip (triangle)
        Canvas {
            width: 12
            height: 12
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: -6
            
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.fillStyle = needleColor
                ctx.beginPath()
                ctx.moveTo(6, 0)      // Top center
                ctx.lineTo(0, 12)     // Bottom left
                ctx.lineTo(12, 12)    // Bottom right
                ctx.closePath()
                ctx.fill()
            }
        }
        
        // Glow effect on needle
        Glow {
            anchors.fill: parent
            radius: 8
            samples: 17
            color: needleColor
            source: parent
            opacity: 0.6
        }
        
        // Smooth animation
        Behavior on rotation {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }
    }
    
    // Center pivot point
    Rectangle {
        width: 16
        height: 16
        radius: 8
        color: needleColor
        border.color: "#000000"
        border.width: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        
        Glow {
            anchors.fill: parent
            radius: 6
            samples: 17
            color: needleColor
            source: parent
            opacity: 0.8
        }
    }
    
    // "kW" label
    Text {
        text: "kW"
        font.pixelSize: 14
        font.bold: true
        color: "#FF0000"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
    }
    
    // Current power value display
    Text {
        text: (powerKW >= 0 ? "+" : "") + powerKW
        font.pixelSize: 18
        font.bold: true
        color: needleColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
    }
}
