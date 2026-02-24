import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: energyFlow
    width: 600
    height: 200
    
    property int powerKW: 0  // Current power: negative = regen, positive = discharge
    property int minPower: -100  // -100 kW (max regen)
    property int maxPower: 300   // 300 kW (max discharge)
    
    // Calculate fill percentage (0 to 1)
    property real fillPercent: {
        if (powerKW >= 0) {
            // Discharge: 0 to 300 kW
            return Math.min(powerKW / maxPower, 1.0)
        } else {
            // Regen: 0 to -100 kW (scaled to 0-0.25 of arc)
            return Math.min(Math.abs(powerKW) / Math.abs(minPower) * 0.25, 0.25)
        }
    }
    
    // Fill color based on power direction
    property color fillColor: powerKW >= 0 ? "#FFD700" : "#00FFFF"
    
    Canvas {
        id: arcCanvas
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            // Arc parameters - creates a flattened rainbow shape
            var startX = 50
            var startY = height - 20  // Bottom left start
            var endX = width - 50
            var endY = height - 100   // Top right end (higher up)
            
            var controlX1 = width * 0.3
            var controlY1 = 20  // First control point (creates the rise)
            var controlX2 = width * 0.6
            var controlY2 = 20  // Second control point (creates the flat top)
            
            // Draw the empty arc outline (red)
            ctx.strokeStyle = "#FF0000"
            ctx.lineWidth = 4
            ctx.beginPath()
            ctx.moveTo(startX, startY)
            ctx.bezierCurveTo(controlX1, controlY1, controlX2, controlY2, endX, endY)
            ctx.stroke()
            
            // Draw the filled portion
            if (fillPercent > 0) {
                ctx.strokeStyle = fillColor
                ctx.lineWidth = 8
                ctx.shadowBlur = 15
                ctx.shadowColor = fillColor
                
                // Calculate the point along the curve based on fillPercent
                var t = fillPercent
                
                // Bezier curve equation: B(t) = (1-t)³P0 + 3(1-t)²tP1 + 3(1-t)t²P2 + t³P3
                var oneMinusT = 1 - t
                var fillX = oneMinusT * oneMinusT * oneMinusT * startX +
                           3 * oneMinusT * oneMinusT * t * controlX1 +
                           3 * oneMinusT * t * t * controlX2 +
                           t * t * t * endX
                           
                var fillY = oneMinusT * oneMinusT * oneMinusT * startY +
                           3 * oneMinusT * oneMinusT * t * controlY1 +
                           3 * oneMinusT * t * t * controlY2 +
                           t * t * t * endY
                
                ctx.beginPath()
                ctx.moveTo(startX, startY)
                ctx.bezierCurveTo(
                    controlX1 * t + startX * (1 - Math.min(t * 3, 1)),
                    controlY1 * t + startY * (1 - Math.min(t * 3, 1)),
                    fillX,
                    fillY,
                    fillX,
                    fillY
                )
                ctx.stroke()
            }
            
            // Draw tick marks along the arc
            ctx.shadowBlur = 0
            ctx.strokeStyle = "#FF0000"
            ctx.lineWidth = 2
            
            // Major ticks at key power values
            var tickValues = [-100, -50, 0, 50, 100, 150, 200, 250, 300]
            
            for (var i = 0; i < tickValues.length; i++) {
                var kw = tickValues[i]
                var t_tick
                
                if (kw >= 0) {
                    t_tick = kw / maxPower
                } else {
                    t_tick = (Math.abs(kw) / Math.abs(minPower)) * 0.25
                }
                
                var oneMinusT_tick = 1 - t_tick
                var tickX = oneMinusT_tick * oneMinusT_tick * oneMinusT_tick * startX +
                           3 * oneMinusT_tick * oneMinusT_tick * t_tick * controlX1 +
                           3 * oneMinusT_tick * t_tick * t_tick * controlX2 +
                           t_tick * t_tick * t_tick * endX
                           
                var tickY = oneMinusT_tick * oneMinusT_tick * oneMinusT_tick * startY +
                           3 * oneMinusT_tick * oneMinusT_tick * t_tick * controlY1 +
                           3 * oneMinusT_tick * t_tick * t_tick * controlY2 +
                           t_tick * t_tick * t_tick * endY
                
                // Draw small tick mark perpendicular to curve
                ctx.beginPath()
                ctx.arc(tickX, tickY, 3, 0, 2 * Math.PI)
                ctx.fill()
                
                // Draw label
                ctx.fillStyle = "#FF0000"
                ctx.font = "10px Arial"
                ctx.textAlign = "center"
                ctx.fillText(kw.toString(), tickX, tickY + 15)
            }
        }
        
        // Redraw when power changes
        Connections {
            target: energyFlow
            function onPowerKWChanged() {
                arcCanvas.requestPaint()
            }
        }
    }
    
    // Current power value display
    Text {
        text: (powerKW >= 0 ? "+" : "") + powerKW + " kW"
        font.pixelSize: 16
        font.bold: true
        color: fillColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        
        Glow {
            anchors.fill: parent
            radius: 8
            samples: 17
            color: fillColor
            source: parent
            opacity: 0.6
        }
    }
}
