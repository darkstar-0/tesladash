import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: energyFlow
    
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
    property color fillColor: powerKW >= 0 ? Theme.accent : Theme.secondary
    
    Canvas {
        id: arcCanvas
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            // Arc parameters - creates a flattened rainbow shape
            var startX = 50
            var startY = height - 20  // Bottom left start
            var endX = width - 10
            var endY = height - 175   // Top right end (higher up)
            
            var controlX1 = width * 0.3
            var controlY1 = 20  // First control point (creates the rise)
            var controlX2 = width * 0.3
            var controlY2 = 20  // Second control point (creates the flat top)
            
            // Draw the empty arc outline (red)
            ctx.strokeStyle = "transparent"
            ctx.lineWidth = 4
            ctx.beginPath()
            ctx.moveTo(startX, startY)
            ctx.bezierCurveTo(controlX1, controlY1, controlX2, controlY2, endX, endY)
            ctx.stroke()
            
            // Draw dashed line offset outward from the arc
            ctx.strokeStyle = Theme.primary
            ctx.lineWidth = 6
            ctx.setLineDash([1, 1])
            ctx.beginPath()
            
            var offset = -10  // Distance to offset outward (pixels)
            var numPoints = 50  // Number of points to sample
            
            for (var i = 0; i <= numPoints; i++) {
                var t = i / numPoints
                
                // Point on the curve
                var oneMinusT = 1 - t
                var x = oneMinusT * oneMinusT * oneMinusT * startX +
                       3 * oneMinusT * oneMinusT * t * controlX1 +
                       3 * oneMinusT * t * t * controlX2 +
                       t * t * t * endX
                       
                var y = oneMinusT * oneMinusT * oneMinusT * startY +
                       3 * oneMinusT * oneMinusT * t * controlY1 +
                       3 * oneMinusT * t * t * controlY2 +
                       t * t * t * endY
                
                // Derivative (tangent) of the curve
                var dx = -3 * oneMinusT * oneMinusT * startX +
                         3 * oneMinusT * oneMinusT * controlX1 - 6 * oneMinusT * t * controlX1 +
                         6 * oneMinusT * t * controlX2 - 3 * t * t * controlX2 +
                         3 * t * t * endX
                         
                var dy = -3 * oneMinusT * oneMinusT * startY +
                         3 * oneMinusT * oneMinusT * controlY1 - 6 * oneMinusT * t * controlY1 +
                         6 * oneMinusT * t * controlY2 - 3 * t * t * controlY2 +
                         3 * t * t * endY
                
                // Perpendicular normal (rotated 90 degrees)
                var len = Math.sqrt(dx * dx + dy * dy)
                var nx = -dy / len
                var ny = dx / len
                
                // Offset point
                var offsetX = x + nx * offset
                var offsetY = y + ny * offset
                
                if (i === 0) {
                    ctx.moveTo(offsetX, offsetY)
                } else {
                    ctx.lineTo(offsetX, offsetY)
                }
            }
            
            ctx.stroke()
            ctx.setLineDash([])  // Reset to solid

            // Draw the filled portion
            if (fillPercent > 0) {
                ctx.strokeStyle = fillColor
                ctx.lineWidth = 8
                ctx.shadowBlur = 15
                ctx.shadowColor = fillColor
                
                // Draw partial bezier curve from start to fillPercent
                // We need to subdivide the bezier curve at parameter t = fillPercent
                var t = fillPercent
                
                // Calculate intermediate control points for the partial curve
                // Using De Casteljau's algorithm to split the bezier at t
                var p0x = startX, p0y = startY
                var p1x = controlX1, p1y = controlY1
                var p2x = controlX2, p2y = controlY2
                var p3x = endX, p3y = endY
                
                // First level interpolation
                var p01x = p0x + t * (p1x - p0x)
                var p01y = p0y + t * (p1y - p0y)
                var p12x = p1x + t * (p2x - p1x)
                var p12y = p1y + t * (p2y - p1y)
                var p23x = p2x + t * (p3x - p2x)
                var p23y = p2y + t * (p3y - p2y)
                
                // Second level interpolation
                var p012x = p01x + t * (p12x - p01x)
                var p012y = p01y + t * (p12y - p01y)
                var p123x = p12x + t * (p23x - p12x)
                var p123y = p12y + t * (p23y - p12y)
                
                // Final point on curve
                var p0123x = p012x + t * (p123x - p012x)
                var p0123y = p012y + t * (p123y - p012y)
                
                // Draw the first segment (0 to t)
                ctx.beginPath()
                ctx.moveTo(p0x, p0y)
                ctx.bezierCurveTo(p01x, p01y, p012x, p012y, p0123x, p0123y)
                ctx.stroke()
            }
            
            // Draw tick marks along the arc
            ctx.shadowBlur = 0
            ctx.strokeStyle = Theme.primary
            ctx.lineWidth = 2
            
            // Major ticks at key power values
            var tickValues = [-100, -50, 0, 50, 100, 150, 200, 250, 300]
            // var tickValues = [0, 1, 2, 3, 4, 5, 6, 7, 8]
            
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
                ctx.fillStyle = Theme.primary
                ctx.font = "20px Arial"
                ctx.textAlign = "center"
                ctx.fillText(i.toString(), tickX, tickY - 25)

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
    // Text {
    //     text: (powerKW >= 0 ? "+" : "") + powerKW + " kW"
    //     font.pixelSize: 16
    //     font.bold: true
    //     color: fillColor
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     anchors.bottom: parent.bottom
    //     anchors.bottomMargin: 150
        
    //     Glow {
    //         anchors.fill: parent
    //         radius: 8
    //         samples: 17
    //         color: fillColor
    //         source: parent
    //         opacity: 0.6
    //     }
    // }
}
