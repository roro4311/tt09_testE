## How it works

The Reaction Timer project measures the reaction time of a user by detecting the time interval between when an LED lights up and when a button is pressed. The reaction time is then displayed on four 7-segment displays. The project consists of several Verilog modules that handle the timer logic, SPI communication, and display control.

1. **Reaction Timer Logic**: The core module starts counting when the LED is lit and stops counting when the button is pressed. The measured reaction time is stored in a register and displayed on the 7-segment displays.
2. **SPI Driver**: This module handles the communication between the main controller and the 7-segment displays via the SPI protocol.
3. **Top Module**: The top module integrates the reaction timer logic and SPI driver, managing the inputs and outputs to ensure correct operation.

## How to test

To test the Reaction Timer project, follow these steps:

1. **Setup**:
   - Ensure you have a compatible FPGA board with the necessary I/O pins connected to the button and LED.
   - Connect the 7-segment displays to the FPGA board using the SPI interface.

2. **Simulation**:
   - Use the provided testbenches to simulate the reaction timer logic.
   - Run the simulation using a tool like Icarus Verilog to verify the timing and output correctness.

3. **Synthesis and Implementation**:
   - Synthesize the design using your preferred FPGA toolchain.
   - Implement the design on your FPGA board.

4. **Operation**:
   - Press the reset button to initialize the system.
   - Wait for the LED to light up.
   - Press the button as quickly as possible when the LED lights up.
   - Observe the reaction time displayed on the 7-segment displays.

## External hardware

The Reaction Timer project uses the following external hardware:

1. **Button**: A simple push-button switch used to measure the reaction time.
2. **LED**: An LED indicator that lights up to signal the user to press the button.
3. **7-Segment Displays**: Four 7-segment displays connected via the SPI interface to show the measured reaction time.

