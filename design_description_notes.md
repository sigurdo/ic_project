# The circuits and design in general
- Design the readout and control circuit for a four pixel digital camera
- Take\_a\_picture: take picture, high for one clock cycle
- Increase\_time/Decrease\_time: adjust exposure time

## Photodiode
- Represented as a current generator and a pn-diode
- Generates a stronger current in bright light

## C<sub>s</sub>, Expose and Erase
- Current from photodiode is visible as a charge in capacitance C<sub>s</sub>, which depends on current and exp. time
- Long exp. time comb. with small current can result in the same charge as a short exp. time com. with strong current
- Too long exp. in bright light => too large charge => excessive voltage over C<sub>s</sub> => overexposed picture
- Transistor controlled by Erase can remove charge (if any) from C<sub>s</sub>
- Must Erase before Expose, to ensure correct exposure
- Never Expose and Erase at the same time (will send current from photodiode to ground and not charge C<sub>s</sub>) (not destructive, will just not do anything)

## NRE-signal
- Activate the readout of the charge stored on C<sub>s</sub>
- Must be timed correctly to avoid two pixels (one column) connected to the same ADC at the same time
- NRE\_R1 connects to pixels on Row 1, NRE\_R2 on Row 2

## Pixels
- 2x2 pixel array
- Pixel outputs on one column share connection to one ADC (one ADC per column)

## Circuit assignments
- Determine suitable geometries for the transistors in the pixel circuit
- Design the digital control block for controlling the exposure and readout of new image data and erasing of old image data


# Process variations
- Main parameter affected: threshold voltage of the transistors
- Reason: difference in doping concentration on the chip
- Analog circuits are more sensitive to process variations than digital circuits since the current through the device is heavily dependent on the threshold voltage

## Simulating process variations
- Two main ways: Monte-Carlo simulation and simulation of extremes (corners)

### Monte-Carlo simulation
- Same simulation is run many times, but the process parameters are randomly changed each time
- Used when matching two transistors is important

### Corner simulation
- Simulate the circuit only in extreme cases (corners)
- Corners are named after how the transistor parameters are changed
- If the transistor is made faster, the corner is called F, and if the transistor is made slower, the corner is called S
- Variation of NMOS and PMOS does not have to be the same
- Four corners: FF, FS, SF, SS (first letter is for NMOS, second letter is for PMOS)
- Faster than Monte-Carlo simulation since only four simulations are needed

## Process variation assignments
- Look at how process variations impacts the resistance of a switch
- Size the switch with the typical corner in mind
- After choosing size (W/L) of the switch, look at how both on and off resistance of the switch changes when you change the corner

# Circuit description
## Finite state machine
- Photographer chooses exposure time
- Photographer presses trigger
- Trigger activates exposure of the pixel for preset time
- After exposure, the camera must activate readout
- After readout, the camera returns to initial stage and prepares for a new picture

## How it happens
- C<sub>s</sub> is the sampling capacitor and must be discharges before exposure (Erase signal) 
- When exposure is activated, the photodiode is connected to C<sub>s</sub> (Expose signal)
- To control the exposure time, a counter counts to a given amount of cycles
- When the counter is finished, C<sub>s</sub> is disconnected from the photodiode and readout is activated
- Only one readout signal (one pixel row) may be set low at a time (NRE signal)
- When one pixel from each column is selected with NRE set low, ADC is set to high, and two pixel values are converted in parallel
- After the signal has been converted, ADC is set low and the output of the next pixels from each column is connected to the ADC
- After the readout is completed, the camera waits for a new picture to be initiated
- Each column consists of a common active load and ADC, where the buffer transistor M<sub>3</sub> uses the column transistor M<sub>C</sub> as active load

## Assignment
- We ignore everything after the ADCs
- Main task is to design the digital control circuit and design a circuit that does the exposure and readout

# How to solve the problem
- Understand how the pixel circuits work
- Understand how the photocurrent is converted to a voltage
- Understand which transistors are used as switches, amplifiers and active loads
###
- Exposure and readout can be controlled using a state machine
- A programmable counter can control exposure time
- Use the suggested time chart (Fig 6) for the digital camera to help implementing the analog signal inputs

# Suggested solutions
## Suggested digital block diagram
- Possible block diagram solution to the digital part in Fig 8
- Input signals: Init, Exp\_inc, Exp\_dec, Reset, Clk
- Init, Reset and Clk control the readout
- Exp\_inc, Exp\_dec, Reset and Clk control the exposure time
- Clk is the system clock signal
- Init is a one-cycle signal from the camera trigger generated by a pulse shaper
- When Init is high, a sequence of exposure and readout is started
###
- When Exp_inc is 1 the exposure time shall increase by 1ms for each clock period until it reaches the maximum of 30ms
- When Exp_dec is 1 the exposure time shall decrease by 1ms for each clock period until it reaches the minimum of 2ms
- Exp\_inc should override Exp\_dec if they are high at the same time
- Exposure time may be controlled by a state machine or a counter
- Selected exposure time shall be stored in a register
- Exposure time may only be changed in the Idle state (Fig 7)
###
- While the camera waits for a photo to be initiated, Erase is set high to make sure there's no charge on sampling capacitor C<sub>s</sub> (both ends of the C<sub>s</sub> will be grounded, so the value of Expose while Erase is high is unimportant)
- Next time slot is exposure, which varies between 2ms and 30ms depending on light conditions and the preset
- After the picture is captured, the readout starts first on row 1, then on row 2
- After readout, the camera prepares for a new picture by setting Erase high again

## The suggested FSM (Fig 7)
- While camera is in state "Idle", it will stay there until a photo is initiated
- Transition from "Idle" to "Exposure" is activated by the user taking a photo
- Camera will remain in "Exposure" until the for the duration of the exposure time (may be controlled by a counter which overflows when it has counted a number of clock periods corresponding to the
preset exposure time), after the exposure time ofv5 will be set high
- When ovf5 is set high, camera enters "Readout" and readout starts
- Readout may be controlled by another FSM, a shift register or a counter, or including all steps of readout in this FSM
    - If readout is controlled by another counter, that counter must count until the readout is completed and set the ovf4 flag high
    - Better to use onlyone counter that counts from different starting positions; in that case ovf4 and ovf5 may be the same signal ovf
    - Counters may be binary or Gray-code
- The signal Reset will bring the FSM to "Idle" at the next clk posedge in all states (except in "Idle")

# Specifications
- For all transistors, 0.36 µm < L < 1.08 µm and 1.08 µm < W <5.04 µm
- For all sampling capacitances, C<sub>s</sub> ≤ 3 pF
- Column capacitances, CC1 = CC2 = 3 pF
- Supply voltage, VDD = 1.8 V
- Exposure time can vary between 2-30 ms
- The clock frequency is 1 kHz
- The photodiode current is around 50 pA in poor lighting, and around 750 pA with
good light conditions
- Implement your circuit with the typical-typical (TT) corner of a 180 nm transistor
technology

# Some issues on debugging
- A test bench consists of the information needed to extract the simulation results you are interested in (freq. resp., power gain, etc.)
- Use parameter command .param in spice to define W and L, to not manually have to change every W and L every time
- Divide the circuit up into subcircuits instead of collecting the whole circuit in one file
- Write a test bench in Verilog that verifies that the design is working
    - Let the test bench if a module of its own, instantiate the camera circuit inside the module
- The camera circuit shall have one single top module that contains a net list of the modules in the design





