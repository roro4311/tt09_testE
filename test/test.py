import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.regression import TestFactory

# Clock period in ns
CLOCK_PERIOD = 10

@cocotb.coroutine
async def reset_dut(dut):
    """Reset the DUT."""
    dut.rst_n.value = 0
    await Timer(20, units="ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

@cocotb.coroutine
async def apply_morse_code_A(dut):
    """Apply Morse code for 'A' (.-) and check output."""
    # Reset the design
    await reset_dut(dut)


    # Simulate a dot (short press)
    dut.ui_in[0].value = 1  # Button pressed
    await Timer(100_000, units="ns")  # Dot duration
    dut.ui_in[0].value = 0  # Button released
    await Timer(50_000, units="ns")  # Wait between symbols

  # Simulate a dash (long press)
    dut.ui_in[0].value = 1  # Button pressed
    await Timer(300_000, units="ns")  # Dash duration
    dut.ui_in[0].value = 0  # Button released
    await Timer(500_000, units="ns")  # Wait after character entry

    # Check the output on the seven-segment display
    await RisingEdge(dut.clk)
    seg_val = dut.uio_out.value.integer & 0x7F  # Only 7 bits used for the 7-segment display

    # Mapping of 'A' to 7-segment display value (you need to adjust this based on your display encoding)
    expected_seg = 0b01001111  # Example encoding for 'A'
    assert seg_val == expected_seg, f"Expected {expected_seg:#07b}, got {seg_val:#07b}"

@cocotb.test()
async def test_morse_code_A(dut):
    """Test Morse code for 'A'."""
    # Start clock
    cocotb.start_soon(Clock(dut.clk, CLOCK_PERIOD, units="ns").start())

    # Apply Morse code for the letter "A" and check
    await apply_morse_code_A(dut)
