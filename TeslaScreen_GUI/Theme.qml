// Theme.qml - Singleton for dashboard colors
pragma Singleton
import QtQuick 2.0

QtObject {
    id: root
    
    // Current theme: "cyberpunk", "stealth", or "arctic"
    property string currentTheme: "cyberpunk"
    
    // Active theme colors (these update automatically when currentTheme changes)
    property color background: {
        if (currentTheme === "cyberpunk") return "#000000"
        if (currentTheme === "stealth") return "#6a6d70"
        if (currentTheme === "arctic") return "#050708"
        if (currentTheme === "user1") return "#6a6d70"
        return "#000000"
    }
    
    property color backgroundAlt: {
        if (currentTheme === "cyberpunk") return "#1a1a1a"
        if (currentTheme === "stealth") return "#7a7d80"
        if (currentTheme === "arctic") return "#0d141a"
        if (currentTheme === "user1") return "#7a7d80"
        return "#1a1a1a"
    }
    
    property color primary: {
        if (currentTheme === "cyberpunk") return "#FF0000"
        if (currentTheme === "stealth") return "#2a2a2a"
        if (currentTheme === "arctic") return "#2a3a4a"
        if (currentTheme === "user1") return "#2a2a2a"
        return "#FF0000"
    }
    
    property color secondary: {
        if (currentTheme === "cyberpunk") return "#00FFFF"
        if (currentTheme === "stealth") return "#00ff41"
        if (currentTheme === "arctic") return "#00d4ff"
        if (currentTheme === "user1") return "#00d4ff"
        return "#00FFFF"
    }
    
    property color accent: {
        if (currentTheme === "cyberpunk") return "#FFD700"
        if (currentTheme === "stealth") return "#00d4aa"
        if (currentTheme === "arctic") return "#0099ff"
        if (currentTheme === "user1") return "#0099ff"
        return "#FFD700"
    }
    
    property color textActive: {
        if (currentTheme === "cyberpunk") return "#00FFFF"
        if (currentTheme === "stealth") return "#00ff41"
        if (currentTheme === "arctic") return "#00d4ff"
        if (currentTheme === "user1") return "#00d4ff"
        return "#00FFFF"
    }
    
    property color textInactive: {
        if (currentTheme === "cyberpunk") return "#404040"
        if (currentTheme === "stealth") return "#2a2a2a"
        if (currentTheme === "arctic") return "#2a3a4a"
        if (currentTheme === "user1") return "#2a3a4a"
        return "#404040"
    }
    
    property color border: {
        if (currentTheme === "cyberpunk") return "#404040"
        if (currentTheme === "stealth") return "#2a2a2a"
        if (currentTheme === "arctic") return "#2a3a4a"
        if (currentTheme === "user1") return "#2a3a4a"
        return "#404040"
    }
    
    property color glowColor: {
        if (currentTheme === "cyberpunk") return "#00FFFF"
        if (currentTheme === "stealth") return "#00ff41"
        if (currentTheme === "arctic") return "#00d4ff"
        if (currentTheme === "user1") return "#00d4ff"
        return "#00FFFF"
    }
}