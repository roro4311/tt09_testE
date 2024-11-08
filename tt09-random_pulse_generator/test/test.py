# test.py - Cocotb test script for tt_um (Random Pulse Generator)
import cocotb
from cocotb.regression import TestFactory
from cocotb.regulators import RisingEdge
from random import randint

@cocotb.coroutine
def test_tt_um_random_pulse_generator(dut):
    """ Test the tt_um module with random pulse generation """

    # Apply reset
    dut.rst_n <= 0
    yield RisingEdge(dut.clk)
    dut.rst_n <= 1

    # Enable pulse generation
    dut.ena <= 1

    # Wait for a few clock cycles to observe pulse behavior
    yield RisingEdge(dut.clk)
    yield RisingEdge(dut.clk)
    yield RisingEdge(dut.clk)

    # Check that a pulse has been generated (uio_out[0] should be high at some point)
    pulse_generated = False
    for _ in range(100):
        if dut.uio_out.value == 1:
            pulse_generated = True
            break
        yield RisingEdge(dut.clk)

    assert pulse_generated, "Pulse was not generated as expected"

    # Disable pulse generation and wait
    dut.ena <= 0
    yield RisingEdge(dut.clk)
    yield RisingEdge(dut.clk)

    # Check that pulse has stopped (uio_out[0] should be low)
    assert dut.uio_out.value == 0, f"Pulse was still active when it should have stopped, uio_out = {dut.uio_out.value}"

    # Re-enable pulse generation and wait again
    dut.ena <= 1
    yield RisingEdge(dut.clk)
    yield RisingEdge(dut.clk)

    # Check again that pulse is generated
    pulse_generated = False
    for _ in range(100):
        if dut.uio_out.value == 1:
            pulse_generated = True
            break
        yield RisingEdge(dut.clk)

    assert pulse_generated, "Pulse was not generated as expected after re-enabling"

# Create the test factory for the testbench
factory = TestFactory(test_tt_um_random_pulse_generator)
factory.generate_tests()
