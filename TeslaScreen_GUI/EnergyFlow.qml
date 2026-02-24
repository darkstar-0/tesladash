import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."

Item {
    id: energyFlow
    
    property int powerKW: 0  // Current power: negative = regen, positive = discharge
    property int minPower: -100
    property int maxPower: 300
    
    // Calculate fill angle (0 to 1.2 where 0 = start, 1.2 = end)
    property real fillPercent: {
        var totalRange = maxPower - minPower
        var extendedRange = totalRange * 1.2  // 20% extra for tangent

        if (powerKW >= 0) {
            return Math.min((powerKW / maxPower) * 1.2, 1.2)
        } else {
            return Math.min((Math.abs(powerKW) / Math.abs(minPower)) * 0.3, 0.3)
        }
    }
    
    property color fillColor: powerKW >= 0 ? Theme.accent : Theme.secondary
    
    Canvas {
        id: arcCanvas
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            // Center point
            var centerX = parent.width * 0.5
            var centerY = height + 15
            
            // Arc parameters
            var innerRadius = 200  // Inner arc radius
            var gapRadius = 210
            var outerRadius = 220  // Outer arc radius
            var startAngle = -165 * Math.PI / 180  // Start angle (degrees to radians)
            var endAngle = -90 * Math.PI / 180    // End angle
            var tangentLength = 175

            // Draw INNER arc (purple)
            ctx.strokeStyle = Theme.primary
            ctx.lineWidth = 3

             // Calculate tangent direction at endAngle (perpendicular to radius)
            var tangentAngle = endAngle + Math.PI / 2  // Tangent is 90° from radius
            var tangentDx = Math.cos(tangentAngle)
            var tangentDy = Math.sin(tangentAngle)

            // Inner arc tangent extension
            var innerEndX = centerX + innerRadius * Math.cos(endAngle)
            var innerEndY = centerY + innerRadius * Math.sin(endAngle)
            
            // Draw OUTER arc (purple)
            ctx.lineWidth = 6
            ctx.setLineDash([1, 1])
            ctx.beginPath()
            ctx.arc(centerX, centerY, outerRadius, startAngle, endAngle, false)
            ctx.stroke()

            // Outer arc tangent extension
            var outerEndX = centerX + outerRadius * Math.cos(endAngle)
            var outerEndY = centerY + outerRadius * Math.sin(endAngle)
            ctx.beginPath()
            ctx.moveTo(outerEndX, outerEndY)
            ctx.lineTo(outerEndX + tangentLength * tangentDx, outerEndY + tangentLength * tangentDy)
            ctx.stroke()
            
            ctx.setLineDash([])
            // Calculate total path length
            var arcLength = Math.abs(endAngle - startAngle) * innerRadius
            var totalLength = arcLength + tangentLength
            var numTicks = 8
            var segmentLength = totalLength / numTicks

            for (var i = 0; i <= numTicks; i++) {
                var distanceAlongPath = i * segmentLength

                if (distanceAlongPath <= arcLength) {
                    // Still in the arc section - draw radial tick
                    var angleProgress = distanceAlongPath / arcLength
                    var angle = startAngle + (endAngle - startAngle) * angleProgress
                    
                    var x1 = centerX + (innerRadius - 10) * Math.cos(angle)
                    var y1 = centerY + (innerRadius - 10) * Math.sin(angle)
                    var x2 = centerX + (outerRadius + 30) * Math.cos(angle)
                    var y2 = centerY + (outerRadius + 30) * Math.sin(angle)
                    var x3 = centerX + (outerRadius + 50) * Math.cos(angle)
                    var y3 = centerY + (outerRadius + 50) * Math.sin(angle)
                    
                    ctx.strokeStyle = Theme.primary
                    ctx.lineWidth = 2
                    
                    // Inner radial segment
                    ctx.beginPath()
                    ctx.moveTo(centerX, centerY)
                    ctx.lineTo(x1, y1)
                    ctx.stroke()
                    
                    // Outer radial segment
                    ctx.beginPath()
                    ctx.moveTo(x2, y2)
                    ctx.lineTo(x3, y3)
                    ctx.stroke()
                    
                    // Label
                    var labelX = centerX + (outerRadius + 15) * Math.cos(angle)
                    var labelY = centerY + (outerRadius + 15) * Math.sin(angle)
                    ctx.fillStyle = Theme.primary
                    ctx.font = "24px Arial"
                    ctx.textAlign = "center"
                    ctx.textBaseline = "middle"
                    ctx.fillText(i.toString(), labelX, labelY)
                    
                    // Horizontal line from outer tick
                    ctx.beginPath()
                    ctx.moveTo(x3, y3)
                    ctx.lineTo(0, y3)
                    if (angle <= -90 * Math.PI / 180)
                        ctx.stroke()
                    
                } else {
                    // In the tangent section - draw vertical tick
                    var tangentDistance = distanceAlongPath - arcLength
                    
                    // Calculate tangent direction
                    var tangentAngle = endAngle + Math.PI / 2
                    var tangentDx = Math.cos(tangentAngle)
                    var tangentDy = Math.sin(tangentAngle)
                    
                    // Base position on inner tangent line
                    var innerEndX = centerX + innerRadius * Math.cos(endAngle)
                    var innerEndY = centerY + innerRadius * Math.sin(endAngle)
                    var baseX = innerEndX + tangentDistance * tangentDx
                    var baseY = innerEndY + tangentDistance * tangentDy
                    var labelY = centerY + (outerRadius + 15) * Math.sin(endAngle)
                    
                    // Draw vertical tick line
                    ctx.strokeStyle = Theme.primary
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    ctx.moveTo(baseX, baseY + 10)  // Inner tick
                    ctx.lineTo(baseX, baseY + innerRadius)  // Extend inward
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(baseX, baseY - 50)  // Outer tick
                    ctx.lineTo(baseX, -parent.height)  // Extend outward
                    ctx.stroke()
                    
                    // Label
                    ctx.fillStyle = Theme.primary
                    ctx.font = "24px Arial"
                    ctx.textAlign = "center"
                    ctx.textBaseline = "middle"
                    ctx.fillText(i.toString(), baseX, labelY)
                }
            }

            // Draw additional vertical lines to the right of tangent
            // Calculate the spacing from tangent section
            var tangentTickSpacing = segmentLength  // Same spacing as the tick marks
            
            // Get the end point of the tangent line
            var tangentAngle = endAngle + Math.PI / 2
            var tangentDx = Math.cos(tangentAngle)
            var tangentDy = Math.sin(tangentAngle)
            
            var innerEndX = centerX + innerRadius * Math.cos(endAngle)
            var innerEndY = centerY + innerRadius * Math.sin(endAngle)
            var tangentEndX = innerEndX + tangentLength * tangentDx
            var tangentEndY = innerEndY + tangentLength * tangentDy
            
            // Continue vertical lines to the right
            var numExtraLines = 10  // How many extra vertical lines you want
            for (var j = 1; j <= numExtraLines; j++) {
                var extraX = tangentEndX + (j * tangentTickSpacing)
                
                // Draw vertical line
                ctx.strokeStyle = Theme.primary
                ctx.lineWidth = 2
                ctx.beginPath()
                ctx.moveTo(extraX, 0)
                ctx.lineTo(extraX, parent.height)
                ctx.stroke()
            }

            // Draw filled segment (orange/cyan area between arcs)
            if (fillPercent > 0) {
                var fillAngle = startAngle + (endAngle - startAngle) * fillPercent
                
                var arcEndPercent = 1.0
                var tangentExtensionPercent = 0.2
                var totalRange = arcEndPercent + tangentExtensionPercent

                var normalizedFill = fillPercent / totalRange
                
                ctx.fillStyle = fillColor
                ctx.globalAlpha = 0.6
                ctx.beginPath()

                if (fillPercent <= arcEndPercent) {
                    // Fill is still in the arc portion
                    var fillAngle = startAngle + (endAngle - startAngle) * fillPercent
                    
                    ctx.moveTo(centerX, centerY)
                    ctx.arc(centerX, centerY, innerRadius, startAngle, fillAngle, false)
                    
                    var outerX = centerX + gapRadius * Math.cos(fillAngle)
                    var outerY = centerY + gapRadius * Math.sin(fillAngle)
                    ctx.lineTo(outerX, outerY)
                    ctx.arc(centerX, centerY, gapRadius, fillAngle, startAngle, true)
                    ctx.closePath()
                } else {
                    // Fill extends into tangent portion
                    var tangentFillPercent = (fillPercent - arcEndPercent) / tangentExtensionPercent
                    var tangentFillLength = tangentLength * tangentFillPercent
                    
                    var tangentAngle = endAngle + Math.PI / 2
                    var tangentDx = Math.cos(tangentAngle)
                    var tangentDy = Math.sin(tangentAngle)
                    
                    // Inner arc end point
                    var innerEndX = centerX + innerRadius * Math.cos(endAngle)
                    var innerEndY = centerY + innerRadius * Math.sin(endAngle)
                    
                    // Outer arc end point
                    var outerEndX = centerX + gapRadius * Math.cos(endAngle)
                    var outerEndY = centerY + gapRadius * Math.sin(endAngle)
                    
                    // Fill the entire arc
                    ctx.moveTo(centerX, centerY)
                    ctx.arc(centerX, centerY, innerRadius, startAngle, endAngle, false)
                    
                    // Continue along inner tangent
                    ctx.lineTo(innerEndX + tangentFillLength * tangentDx, innerEndY + tangentFillLength * tangentDy)
                    
                    // Line to outer tangent
                    ctx.lineTo(outerEndX + tangentFillLength * tangentDx, outerEndY + tangentFillLength * tangentDy)
                    
                    // Back along outer tangent to arc
                    ctx.lineTo(outerEndX, outerEndY)
                    
                    // Arc back along outer radius
                    ctx.arc(centerX, centerY, gapRadius, endAngle, startAngle, true)
                    ctx.closePath()
                }

                ctx.fill()
                ctx.globalAlpha = 1.0
                
                // Add glow effect
                ctx.shadowBlur = 15
                ctx.shadowColor = fillColor
                ctx.fill()
                ctx.shadowBlur = 0
            }
            
            // Draw center pivot point (blue in your sketch)
            ctx.fillStyle = Theme.secondary
            ctx.beginPath()
            ctx.arc(centerX, centerY, 6, 0, 2 * Math.PI)
            ctx.fill()
        }
        
        // Redraw when power changes
        Connections {
            target: energyFlow
            function onPowerKWChanged() {
                arcCanvas.requestPaint()
            }
        }
    }
}
