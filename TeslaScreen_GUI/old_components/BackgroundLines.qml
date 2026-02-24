import QtQuick 2.0
import "."

Canvas {
    id: backgroundLines
    anchors.fill: parent
    
    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        
        ctx.strokeStyle = Theme.primary  // Red lines
        ctx.lineWidth = 2
        
        // Vertical lines (evenly spaced across the display)
        var numVerticalLines = 12
        var spacing = width / (numVerticalLines + 1)
        
        for (var i = 1; i <= numVerticalLines; i++) {
            var x = spacing * i
            ctx.beginPath()
            ctx.moveTo(x, 0)
            ctx.lineTo(x, height)
            if (i > 8)
                ctx.stroke()
        }
        
        // Diagonal lines (left side, going from bottom-left toward top-right)
        // var numDiagonalLines = 8
        // var diagonalSpacing = width * 0.4 / numDiagonalLines
        
        // for (var j = 0; j < numDiagonalLines; j++) {
        //     var startX = diagonalSpacing * j
        //     ctx.beginPath()
        //     ctx.moveTo(startX, height)
        //     ctx.lineTo(startX + width * 0.3, 0)  // Angle upward
        //     ctx.stroke()
        // }
        
        // Horizontal lines (optional, add a few for grid effect)
        // var numHorizontalLines = 3
        // var hSpacing = height / (numHorizontalLines + 1)
        
        // for (var k = 1; k <= numHorizontalLines; k++) {
        //     var y = hSpacing * k
        //     ctx.beginPath()
        //     ctx.moveTo(0, y)
        //     ctx.lineTo(width, y)
        //     ctx.stroke()
        // }
    }
    
    // Redraw if theme changes
    Connections {
        target: Theme
        function onCurrentThemeChanged() {
            backgroundLines.requestPaint()
        }
    }
}
