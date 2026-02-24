"""Simple QA tests for TeslaDash demo mode classes.

Tests verify data ranges, state transitions, and output formatting
without requiring CAN bus hardware or a running vehicle.

Run with: pytest test_dashboard.py -v
"""
import sys
import os
import pytest

# Add the app directory to path so demo classes can be imported
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "TeslaScreen_GUI"))

# Use offscreen platform so tests run without a display
os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

from PyQt5.QtCore import QCoreApplication


@pytest.fixture(scope="session", autouse=True)
def qapp():
    """Provide a QCoreApplication for the test session (required by PyQt5)."""
    app = QCoreApplication.instance() or QCoreApplication(sys.argv)
    yield app


# ---------------------------------------------------------------------------
# Speed
# ---------------------------------------------------------------------------

class TestSpeed:
    @pytest.fixture(autouse=True)
    def setup(self, qapp):
        from main_demo import Speed
        self.speed = Speed()
        self.speed.timer.stop()

    def test_initial_value_is_zero(self):
        assert self.speed.speed == 0

    def test_speed_never_negative(self):
        for _ in range(100):
            self.speed.update_speed()
        assert self.speed.speed >= 0

    def test_speed_within_upper_bound(self):
        for _ in range(200):
            self.speed.update_speed()
        assert self.speed.speed <= 120


# ---------------------------------------------------------------------------
# Gear
# ---------------------------------------------------------------------------

VALID_GEARS = {"DI_GEAR_P", "DI_GEAR_R", "DI_GEAR_N", "DI_GEAR_D"}

class TestGear:
    @pytest.fixture(autouse=True)
    def setup(self, qapp):
        from main_demo import Gear
        self.gear = Gear()
        self.gear.timer.stop()

    def test_initial_gear_is_drive(self):
        assert self.gear.gear == "DI_GEAR_D"

    def test_gear_cycles_through_all_positions(self):
        seen = {self.gear.gear}
        for _ in range(len(VALID_GEARS)):
            self.gear.update_gear()
            seen.add(self.gear.gear)
        assert seen == VALID_GEARS

    def test_gear_is_always_a_valid_value(self):
        for _ in range(20):
            self.gear.update_gear()
            assert self.gear.gear in VALID_GEARS


# ---------------------------------------------------------------------------
# Odometer
# ---------------------------------------------------------------------------

class TestOdometer:
    @pytest.fixture(autouse=True)
    def setup(self, qapp):
        from main_demo import Odo
        self.odo = Odo()
        self.odo.timer.stop()

    def test_initial_format_ends_with_km(self):
        assert self.odo.odometer.endswith(" km")

    def test_initial_format_has_comma_separator(self):
        # Default starts at 12,345 km
        assert "," in self.odo.odometer

    def test_odometer_never_decreases(self):
        prev = self.odo.odo_value
        for _ in range(20):
            self.odo.update_odo()
            assert self.odo.odo_value >= prev
            prev = self.odo.odo_value

    def test_odometer_formats_large_number_with_commas(self):
        self.odo.odo_value = 1000000
        self.odo.update_odo()
        # update_odo adds a random 0-2 increment, so check format not exact value
        assert self.odo.odometer.endswith(" km")
        assert "," in self.odo.odometer
        raw = int(self.odo.odometer.replace(" km", "").replace(",", ""))
        assert raw >= 1_000_000

    def test_odometer_string_is_parseable(self):
        self.odo.update_odo()
        # Strip " km" and commas, should convert to int cleanly
        raw = self.odo.odometer.replace(" km", "").replace(",", "")
        assert int(raw) >= 0


# ---------------------------------------------------------------------------
# Battery
# ---------------------------------------------------------------------------

class TestBattery:
    @pytest.fixture(autouse=True)
    def setup(self, qapp):
        from main_demo import Battery
        self.battery = Battery()
        self.battery.timer.stop()

    def test_initial_value_is_85(self):
        assert self.battery.battery == "85"
        assert self.battery.battery_level == 85

    def test_battery_never_drops_below_20(self):
        self.battery.battery_level = 20.0
        for _ in range(50):
            self.battery.update_battery()
        assert self.battery.battery_level >= 20

    def test_battery_does_not_increase(self):
        initial = self.battery.battery_level
        for _ in range(50):
            self.battery.update_battery()
        assert self.battery.battery_level <= initial

    def test_battery_string_is_integer(self):
        for _ in range(10):
            self.battery.update_battery()
        int(self.battery.battery)  # raises ValueError if not a valid integer


# ---------------------------------------------------------------------------
# Power
# ---------------------------------------------------------------------------

class TestPower:
    @pytest.fixture(autouse=True)
    def setup(self, qapp):
        from main_demo import Power
        self.power = Power()
        self.power.timer.stop()

    def test_initial_value_is_zero(self):
        assert self.power.power == 0

    def test_power_stays_within_bounds(self):
        for _ in range(200):
            self.power.update_power()
        assert -100 <= self.power.power <= 300

    def test_power_reverses_direction_at_max(self):
        self.power.power = 300
        self.power.direction = 1
        self.power.update_power()
        assert self.power.power <= 300
        assert self.power.direction == -1

    def test_power_reverses_direction_at_min(self):
        self.power.power = -100
        self.power.direction = -1
        self.power.update_power()
        assert self.power.power >= -100
        assert self.power.direction == 1


# ---------------------------------------------------------------------------
# Turn Signals
# ---------------------------------------------------------------------------

VALID_SIGNAL_STATES = {"LIGHT_ON", "LIGHT_OFF"}

class TestTurnSignals:
    def test_left_signal_initial_state(self, qapp):
        from main_demo import LeftSignal
        sig = LeftSignal()
        sig.timer.stop()
        assert sig.leftSignal == "LIGHT_OFF"

    def test_right_signal_initial_state(self, qapp):
        from main_demo import RightSignal
        sig = RightSignal()
        sig.timer.stop()
        assert sig.rightSignal == "LIGHT_OFF"

    def test_left_signal_only_emits_valid_states(self, qapp):
        from main_demo import LeftSignal
        sig = LeftSignal()
        sig.timer.stop()
        for _ in range(30):
            sig.update_signal()
            assert sig.leftSignal in VALID_SIGNAL_STATES

    def test_right_signal_only_emits_valid_states(self, qapp):
        from main_demo import RightSignal
        sig = RightSignal()
        sig.timer.stop()
        for _ in range(30):
            sig.update_signal()
            assert sig.rightSignal in VALID_SIGNAL_STATES

    def test_signal_toggles_when_blink_state_is_active(self, qapp):
        from main_demo import LeftSignal
        sig = LeftSignal()
        sig.timer.stop()
        sig.blink_state = True
        sig.leftSignal = "LIGHT_OFF"
        sig.update_signal()
        assert sig.leftSignal == "LIGHT_ON"
        sig.update_signal()
        assert sig.leftSignal == "LIGHT_OFF"

    def test_signal_stays_off_when_not_blinking(self, qapp):
        from main_demo import RightSignal
        sig = RightSignal()
        sig.timer.stop()
        sig.blink_state = False
        for _ in range(10):
            sig.update_signal()
            assert sig.rightSignal == "LIGHT_OFF"


# ---------------------------------------------------------------------------
# Speed Limit
# ---------------------------------------------------------------------------

VALID_LIMITS = {"35", "45", "55", "65", "75"}

class TestSpeedLimit:
    @pytest.fixture(autouse=True)
    def setup(self, qapp):
        from main_demo import SpeedLimit
        self.sl = SpeedLimit()
        self.sl.timer.stop()

    def test_initial_value_is_65(self):
        assert self.sl.speedLimit == "65"

    def test_limit_is_always_a_valid_value(self):
        for _ in range(30):
            self.sl.update_limit()
            assert self.sl.speedLimit in VALID_LIMITS

    def test_all_speed_limits_are_reachable(self):
        seen = set()
        for _ in range(200):
            self.sl.update_limit()
            seen.add(self.sl.speedLimit)
        assert seen == VALID_LIMITS
