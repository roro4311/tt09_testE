import cocotb
from cocotb.triggers import RisingEdge, FallingEdge

@cocotb.test()
async def test_morse_code(dut):
    # Initialize reset
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Function to print `seg` output from `uio_out`
    async def monitor_seg():
        previous_seg = None
        while True:
            await RisingEdge(dut.clk)
            current_seg = dut.uio_out.value & 0x7F  # Extract 7-bit seg value
            if current_seg != previous_seg:
                previous_seg = current_seg
                print(f"Captured seg output: {current_seg:07b}")

    # Start monitoring coroutine in the background
    cocotb.fork(monitor_seg())

    # Send Morse code for "A" (dot-dash sequence)
    # Dot press
    dut.ui_in.value = 1  # Button press for dot
    await cocotb.triggers.Timer(100, units="ns")
    dut.ui_in.value = 0  # Release button
    await cocotb.triggers.Timer(100, units="ns")  # 1-dot gap

    # Dash press
    dut.ui_in.value = 1  # Button press for dash
    await cocotb.triggers.Timer(300, units="ns")
    dut.ui_in.value = 0  # Release button
    await cocotb.triggers.Timer(700, units="ns")  # 7-dot gap to signal end of character

    # Wait for decoding to complete
    await cocotb.triggers.Timer(1000, units="ns")
