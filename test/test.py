import cocotb
from cocotb.triggers import RisingEdge
from cocotb.regression import TestFactory

@cocotb.test()
async def test_tt_um(dut):
    """ Test the tt_um module. """
    
    # Initialize inputs
    dut.ui_in.value = 0
    dut.rst_n.value = 0
    dut.ena.value = 1
    await RisingEdge(dut.clk)
    
    # Deassert reset
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Trigger the reaction timer
    dut.ui_in.value = 2  # Set button to start reaction timer
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.ui_in.value = 0  # Release button
    
    # Wait for some time
    for _ in range(10):
        await RisingEdge(dut.clk)
    
    # Stop reaction timer
    dut.ui_in.value = 1  # Set button to stop reaction timer
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.ui_in.value = 0  # Release button

    # Wait for some time for the SPI to process the data
    for _ in range(10):
        await RisingEdge(dut.clk)

    # Check the expected value
    expected_reaction_time = 5  # Example expected reaction time
    # Calculate expected value for the display segments
    seg1, seg2, seg3, seg4 = calculate_segments(expected_reaction_time)
    expected_value = (seg4 << 21) | (seg3 << 14) | (seg2 << 7) | seg1
    
    if dut.uio_out.value != expected_value:
        raise cocotb.result.TestFailure(f"Expected uio_out value {expected_value}, but got {dut.uio_out.value}")

def calculate_segments(reaction_time):
    """ Function to calculate segment values based on the reaction time """
    digit1 = reaction_time % 10
    digit2 = (reaction_time // 10) % 10
    digit3 = (reaction_time // 100) % 10
    digit4 = (reaction_time // 1000) % 10
    
    seg1 = digit_to_segment(digit1)
    seg2 = digit_to_segment(digit2)
    seg3 = digit_to_segment(digit3)
    seg4 = digit_to_segment(digit4)
    
    return seg1, seg2, seg3, seg4

def digit_to_segment(digit):
    """ Function to convert a digit to its seven-segment display encoding """
    segment_encoding = {
        0: 0b0111111,
        1: 0b0000110,
        2: 0b1011011,
        3: 0b1001111,
        4: 0b1100110,
        5: 0b1101101,
        6: 0b1111101,
        7: 0b0000111,
        8: 0b1111111,
        9: 0b1101111
    }
    return segment_encoding.get(digit, 0b0000000)

