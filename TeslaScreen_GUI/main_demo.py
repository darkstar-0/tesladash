import sys
import os
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, QTimer
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
import random

# Demo mode - no CAN bus required!

class Speed(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.speed = 0
        self.max_speed = 240
        # Simulate speed changes with a timer
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_speed)
        self.timer.start(100)  # Update every 100ms
    
    speedNeedleValue = pyqtSignal(int, arguments=['speed'])

    @pyqtSlot()
    def update_speed(self):
        # Simulate varying speed between 0 and 120
        self.speed = (self.speed + random.randint(-5, 10)) % 121
        if self.speed < 0:
            self.speed = 0
        self.speedNeedleValue.emit(self.speed)

class Gear(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.gear = "DI_GEAR_D"
        self.gears = ["DI_GEAR_P", "DI_GEAR_R", "DI_GEAR_N", "DI_GEAR_D"]
        self.gear_index = 3
        # Change gear occasionally
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_gear)
        self.timer.start(5000)  # Change every 5 seconds
    
    gearChanged = pyqtSignal(str, arguments=['gear'])

    @pyqtSlot()
    def update_gear(self):
        self.gear_index = (self.gear_index + 1) % len(self.gears)
        self.gear = self.gears[self.gear_index]
        self.gearChanged.emit(self.gear)

class Odo(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.odometer = "12,345 km"
        # Update odometer slowly
        self.odo_value = 12345
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_odo)
        self.timer.start(1000)  # Update every second
    
    odoChanged = pyqtSignal(str, arguments=['odometer'])

    @pyqtSlot()
    def update_odo(self):
        self.odo_value += random.randint(0, 2)
        self.odometer = str('{0:,}'.format(int(self.odo_value))) + " km"
        self.odoChanged.emit(self.odometer)

class LeftSignal(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.leftSignal = "LIGHT_OFF"
        self.blink_state = False
        # Blink occasionally
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_signal)
        self.timer.start(500)  # Blink every 500ms
    
    leftSignalChanged = pyqtSignal(str, arguments=['leftSignal'])

    @pyqtSlot()
    def update_signal(self):
        # Randomly turn on/off blinking
        if random.random() < 0.1:  # 10% chance to toggle
            self.blink_state = not self.blink_state
        
        if self.blink_state:
            self.leftSignal = "LIGHT_ON" if self.leftSignal == "LIGHT_OFF" else "LIGHT_OFF"
        else:
            self.leftSignal = "LIGHT_OFF"
        self.leftSignalChanged.emit(self.leftSignal)

class RightSignal(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.rightSignal = "LIGHT_OFF"
        self.blink_state = False
        # Blink occasionally
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_signal)
        self.timer.start(500)  # Blink every 500ms
    
    rightSignalChanged = pyqtSignal(str, arguments=['rightSignal'])

    @pyqtSlot()
    def update_signal(self):
        # Randomly turn on/off blinking
        if random.random() < 0.1:  # 10% chance to toggle
            self.blink_state = not self.blink_state
        
        if self.blink_state:
            self.rightSignal = "LIGHT_ON" if self.rightSignal == "LIGHT_OFF" else "LIGHT_OFF"
        else:
            self.rightSignal = "LIGHT_OFF"
        self.rightSignalChanged.emit(self.rightSignal)

class SpeedLimit(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.speedLimit = "65"
        self.limits = ["35", "45", "55", "65", "75"]
        # Change speed limit occasionally
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_limit)
        self.timer.start(10000)  # Change every 10 seconds
    
    speedLimitChanged = pyqtSignal(str, arguments=['speedLimit'])

    @pyqtSlot()
    def update_limit(self):
        self.speedLimit = random.choice(self.limits)
        self.speedLimitChanged.emit(self.speedLimit)

class Battery(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.battery = "85"
        self.battery_level = 85
        # Update battery slowly
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_battery)
        self.timer.start(2000)  # Update every 2 seconds
    
    batteryChanged = pyqtSignal(str, arguments=['battery'])

    @pyqtSlot()
    def update_battery(self):
        # Slowly decrease battery
        self.battery_level = max(20, self.battery_level - random.random() * 0.1)
        self.battery = str(int(self.battery_level))
        self.batteryChanged.emit(self.battery)

class Power(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.power = 0
        self.direction = 1
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_power)
        self.timer.start(200)
    
    powerChanged = pyqtSignal(int, arguments=['power'])

    @pyqtSlot()
    def update_power(self):
        # Simulate power swinging between -100 and +300
        self.power += self.direction * random.randint(5, 15)
        if self.power > 300:
            self.power = 300
            self.direction = -1
        elif self.power < -100:
            self.power = -100
            self.direction = 1
        self.powerChanged.emit(self.power)

def main():
    app = QGuiApplication(sys.argv)
    # Set window size to 9" x 2" (at 96 DPI: 864x192 pixels, or let's use 900x200 for clean numbers)
    import os
    os.environ['QT_QPA_PLATFORM'] = 'cocoa'  # For macOS
    
    engine = QQmlApplicationEngine()
    
    # Create demo objects
    speed = Speed()
    gear = Gear()
    odometer = Odo()
    leftSignal = LeftSignal()
    rightSignal = RightSignal()
    speedLimit = SpeedLimit()
    battery = Battery()
    power = Power()
    
    # Set context properties
    engine.rootContext().setContextProperty('speedValue', speed)
    engine.rootContext().setContextProperty('gearValue', gear)
    engine.rootContext().setContextProperty('odometerValue', odometer)
    engine.rootContext().setContextProperty('leftSignalValue', leftSignal)
    engine.rootContext().setContextProperty('rightSignalValue', rightSignal)
    engine.rootContext().setContextProperty('speedLimitValue', speedLimit)
    engine.rootContext().setContextProperty('batteryValue', battery)
    engine.rootContext().setContextProperty('powerValue', power)
    
    # Load QML file from current directory
    qml_file = os.path.join(os.path.dirname(__file__), 'main.qml')
    engine.load(qml_file)
    
    if not engine.rootObjects():
        print("Error: Failed to load QML file")
        print(f"Tried to load: {qml_file}")
        print(f"Current directory: {os.getcwd()}")
        print(f"Files in directory: {os.listdir('.')}")
        return -1
    
    # Set window size to 900x200 (approximately 9" x 2" at standard DPI)
    window = engine.rootObjects()[0]
    window.setWidth(900)
    window.setHeight(310)
    
    engine.quit.connect(app.quit)

    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
