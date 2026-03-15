- Parametric, Pipelined Design for a Non-Linear Energy Operator.
- NEO is defined as: 𝜓(𝑛) = 𝑥(𝑛)−𝑥(𝑛+1)∙𝑥(𝑛−1)
- The pipeline has 4 stages: 
  1. Reading Memory & Propagating Data to the Correct Registers.
  2. Multiplication
  3. Subtraction
  4. Handling Overflow & Writing Back to Memory
- The txt files contain sine wave data as 4-bit signed values (sign extended to 8 bits by padding the MSB (sign bit) with 4 additional bits). These were generated in MATLAB.
- It was created with the target platform being the Cyclone IV E FPGA. Quartus Synthesis yields the following specs:
  1. Device: Cyclone IV E 5CGXFC7C7F23C8
  2. Power: 363.29 mW @ 100 MHz
  3. Utilisation Specs below:
   - Logic Utilization in ALMs: 8/56480
   - Total Pins Used: 20/268
   - Total DSP Blocks: 1/156
   - Total Registers: 27
