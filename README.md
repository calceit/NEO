Parametric, Pipelined Design for an 8-bit NEO operator. It was created with the target platform being the Cyclone IV E FPGA. The pipeline has 4 stages: 
1. Reading Memory & Propagating Data to the Correct Registers.
2. Multiplication
3. Subtraction
4. Handling Overflow & Writing Back to Memory
The txt files contain sine wave data as 4-bit signed values (sign extended to 8 bits by padding the MSB (sign bit) with 4 additional bits). These were generated in MATLAB.
Quartus Synthesis yields the following specs:
Device: Cyclone IV E 5CGXFC7C7F23C8
Power: 363.29 mW @ 100 MHz
Utilisation Specs below:
Logic Utilization in ALMs: 8/56480
Total Pins Used: 20/268
Total DSP Blocks: 1/156
Total Registers: 27
