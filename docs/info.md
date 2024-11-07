## How it works

The Morse Decoder project takes in signals from button presses to interpret Morse code, decodes each sequence into its corresponding letter, and displays the result on a 7-segment display. The project consists of several Verilog modules that handle input signal processing, Morse code decoding, and display control.

1. **Button Input Logic**: This module reads button press durations to differentiate between dots and dashes and recognizes spacing to interpret letter boundaries.
2. **Morse Decoder**: This module receives the processed button signals, decodes the Morse code into its corresponding letter, and sends the decoded character to the display module.
3. **7-Segment Display Control**: The display module converts the decoded letter into a format suitable for displaying on the 7-segment display.

## How to test

To test the Morse Decoder project, follow these steps:

1. **Setup**:
   - Connect the button and 7-segment display to the appropriate I/O pins on a compatible FPGA board.
   
2. **Simulation**:
   - Use provided testbenches to simulate the button input logic and decoding functionality.
   - Verify that the Morse code sequences are accurately interpreted and displayed.

3. **Synthesis and Implementation**:
   - Synthesize the design using your preferred FPGA toolchain.
   - Implement the design on your FPGA board.

4. **Operation**:
   - Press the button in short (dot) or long (dash) durations to enter Morse code for a character.
   - Observe the decoded letter on the 7-segment display.

## External hardware

The Morse Decoder project requires the following external hardware:

1. **Button**: A push-button for entering Morse code by pressing in dot/dash durations.
2. **7-Segment Display**: A display that shows the decoded letter from each Morse code sequence entered by the user.
