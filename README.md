# Ultrasound Hardware Control

This repository includes scripts that allow the user to conduct ultrasound experiments.  Scripts enable the users to align and calibrate ultrasound transducers and to control the insonation of these transducers on targets in 24 well plate platforms.

### Software Prerequisites

This system requires MATLAB with the Instrument Control Toolbox Support Package that is relevant for the hardware that you will be using.  For example, the code as currently written uses the "Instrument Control Toolbox Support Package for Keysight IO Libraries and VISA Interface"

### Hardware Required

This system is designed to function with the following instruments:

```
BK Precision 4050 Function / Arbitrary Waveform Generator
Keysight InfiniiVision 3000 X-Series Oscilloscope
Velmex VXM-3 Stepping Motor Controller
```

If a different waveform generator, oscilloscope, or motor controller is used, the subroutines used in this code must be modified to the programming syntax of these new pieces of hardware as described in their programming manual.

The ultrasound signal generated needs to be amplified using an RF amplifier that can boost the signal voltage to be sufficient to drive an ultrasound transducer at the target pressure values.  A hydrophone system, such as a fiber optic hydrophone is necessary to detect the ultrasound signal at a test point to allow for alignment and calibration.

## Setup

### Matlab computer

These scripts must all be in the same directory in order to function.  The results of any scans or acquisitions made by these scripts will be in a "results" subdirectory in this directory, so place this directory in a drive with sufficient available space.

### Hardware VISA addresses

Before running the scripts, the VISA address of the signal generator and oscilloscope  must be appended to the list of VISA addresses within the following files:

```
sub_Scope_Initialize.m (for the oscilloscope)
sub_SG_Initialize.m (for the signal generator)
```

Consult the programming manual of the signal generator and oscilloscope to determine how to find the specific instrument's VISA address.  The program should be able to find the connected Velmex motor stage automatically. 

### Hardware USB connections

The signal generator, oscilloscope, and motor controller must be connected to the Matlab computer via USB cables.  Using unpowered USB ports may lead to unstable connections that can cause the programs to crash.  Use powered USB hubs if possible.

### Suggested Hardware Configuration (adjustable in code)

For the BKP signal generator (SG) and Keysight oscillscope (Scope), a suspected cable configuration is as follows:

```
SG Ch 1 <--> Scope Ch 1 (1 Mohm impedance)
SG Ch 1 <--> SG Ext Trg
SG Ch 2 <--> Scope Ch 2  (1 Mohm impedance)
SG Ch 2 <--> Amplifier In
Amplifier out <--> US Tx
Hydrophone <--> Scope Ch 4 (matched impedance with hydrophone)
```

This allows the signal readout from the oscilloscope to be:

```
Scope Ch 1 - ultrasound pulse envelope
Scope Ch 2 - signal generator signal output
Scope Ch 4 - hydrophone signal output
```

## How to Use

Prior to any experiment, update the transducer, amplifier, and safety values within:

```
sub_AllSettings.m
```

### Transducer Alignment

Position both the transducer and hydrophone in a water bath, with the transducer mounted to the motor stage system.  Define a low intensity pulsed ultrasound test signal that can be run safely continuously during alignment using:

```
SetTestingParameter.m
```

Edit the testing parameters within that file first, then execute the file to apply those changes to the signal generator.  That script will throw an error if any value violates the prior defined safety limits.

Manually position the transsducer such that a signal appears on the oscilloscope.  If using a GUI would be useful in this manual course adjustment of the transducer, then run:

```
stage_GUI.m
```


Then review, edit, and use the following search scripts to find the maximum value:

```
Scan_FindMax_v4.m
Scan_Grid.m
```

After a scan file has been completed, a "params" structure will appear in the variable explorer.  This enables the use of the following utility functions:

```
BackToOrigin.m
MoveToMax.m
```

### Transducer Calibration

After aligning the transducer to the hydrophone as described above, use the following script to get the pressure waveforms for various ultrasound waveforms sent through the transducer:

```
Scan_TransducerResponse_Adv.m
```

### 24 well plate insonation

After aligning the transducer to Well A1 of the 24 well plate, using a modification of the method described above, develop an excel document as described in the comments of the following script, and follow the comments in order to achieve a unique waveform per well of the 24 well plate

```
wellplate_v4_zigzag43.m
```

### Cavitation Experiments

Co-align both the HIFU transducer and the passive cavitation imaging detector orthogonally to the same point.  Follow the instructions in the comments of the following scripts in order to perform triggered cavitation measurements:

```
Cavitation_Rpt.m
Cavitation_Seg_Rpt.m
```

## Scripts in this repository
Alignment/Measurement Scripts
Script Name | Description
----------- | -----------
Scan_Acquire_Cont.m|Acquire waveform continually, refreshing as fast as possible.  Allows for capturing time varying phenomenon that are not linked to a signal for acquisition
Scan_Aquire.m|Acquire a single waveform at one position
Scan_FindMax_v4.m|Moves motor stage in 3 dimensions to ascend the gradient to a local maximum.  Attention!  Monitor the hydrophone used to measure pressure here, this script may cause the transducer to directly collide with the transducer!
Scan_Grid.m|Uses Velmex stage to move in a predefined pattern to get pressure waveform at all points in a grid
Scan_Space.m|Uses Velmex stage to move in a predefined pattern to get pressure waveform at all points in a 3d space
Scan_TransducerResponse_Adv.m|Cycles through a set of voltages and frequencies to determine the transducer response to signal generator signal using a hydrophone setup.
SetTestingParameters.m|Send command to Signal Generator to define testing parameters.

Utility script to be used during experiments
Script Name | Description
----------- | -----------
BackToOrigin.m|Send command to Velmex stage to move back to the origin.  This command must be run with a valid params file defined.  General use is after another command has been run that moves the stage
Move.m|Move a specific number of mm
MoveOnPlate.m|Move a special distance (integer steps of Plate.welldistance).  Useful during 24 well plate experiments
MoveToHome.m|Moves every motor of the Velmex stage to their home position (defined by Velmex as triggering the negative bumper on the rail) and then zeroes the position internally and in the params file at that location.  This can be useful if you wish to move the Velmex stage to an absolute position.  NOTE: if anything is attached to  the Velmex stage, this motion may cause the attached items to collide with water-bath, etc, so use with caution
MoveToMax.m|Send command to Velmex stage to move to the point with the highest params.Scan.Objective value. This command must be run with a valid params file defined. General use is after another command has been run that moves the stage
Release_Stage.m|Send a command to the Velmex stage to enable manual control of the stage using buttons

Cavitation Scripts
Script Name | Description
----------- | -----------
Cavitation_Rpt.m|Measure scattered signal from cavitating sample. Acquires multiple pulses of signal. Oscilloscope configured for single acquisition per pulse
Cavitation_Seg_Rpt.m|Measure scattered signal from cavitating sample. Acquires multiple pulses of signal. Oscilloscope configured for segmented acquisition per pulse

GUI
Script Name | Description
----------- | -----------
stage_GUI.m|Activates a GUI that allows for control of Velmex stage
Wellplate_v4_zigzag43.m|Wellplate allows you to load an 24 well plate experimental file and run the signal generator and motor stage to expose each well of the 24 well plate to a unique ultrasound signal.

Other Scripts
Script Name | Description
----------- | -----------
CustomWaveformGenerator.m|Generate custom waveform files of frequency  sweeps. These are compatible with BKP signal generators
MakeMovieFromGridWaveform.m|Scan Grid data files collect pressure signal over time for various different data points. Stepping through time points at all positions can allow the generation of videos where pixel intensity correlates to pressure over time, allowing visualization of standing wave or traveling wave patterns

Subroutine
Script Name | Description
----------- | -----------
sub_AllSettings.m|This subroutine is called in the beginning of each script to generate the params structure.  This includes experiment specific values that should be adjusted before each experiment including: * Safety parameters - that prevent the signal generator from sending a signal that could damage equipment or samples. * Hardware default parameters. * Reference parameters
Sub_Close_All_Connections.m|Opens hardware connection ports by closing all open connections. Runs safe (all commands within try)
sub_Data_CompressWaveform.m|Compresses a waveform
sub_Data_Countdown.m|Outputs a countdown in Matlab command window
sub_Data_DecompressWaveform.m|Decompress waveform
sub_Data_Hydrophone_Curve.m|Convert voltage per time to pressure per time given calibration file
sub_Scope_ApplySettings.m|Apply the settings in the params structure to the oscilloscope
sub_Scope_Initialize.m|Form a connection to the oscilloscope
sub_Scope_Readout_All.m|Readout multiple channels from oscilloscope
sub_Scope_Readout_All_NoRefresh.m|Read out all data currently displayed on oscilloscope, do not re-aquire
sub_Scope_Readout_HQ.m|Readout data at maximum quality (large data files)
sub_Scope_Readout_HQ_simple.m|Read out data from oscilloscope at maximum data quality, making some simplifying assumptions
sub_Scope_Run.m|Press "Run" button on oscilloscope, essential gives real time readout rather than remaining on "Stop" after acquisition
sub_SG_ApplySettings.m|Apply settings from param structure to the connected signal generator
sub_SG_ApplySettingsForTrigger.m|Apply settings to the signal generator, and prime for a receiving a trigger command
sub_SG_Initialize.m|Initialize a connection to the signal generator
sub_SG_Start.m|Turn the output from the signal generator to be ON
sub_SG_Stop.m|Turn the output from the signal generator to be OFF
sub_SG_Trigger.m|Send a trigger command to the signal generator
sub_SG_Wait_Until_Ready.m|Wait until the signal generator has completed operations
sub_Stage_Cancel.m|Cancel the command that was sent to the stage
sub_Stage_Initialize.m|Initialize connection to the Velmex stage
sub_Stage_Move.m|Move a specified motor a specified number of motor steps
sub_Stage_Move_To.m|Move to a certain desired location
sub_Stage_Move_Vec.m|Move by a certain vector offset
sub_Stage_Update_Positions.m|Update the stage positions that is saved in params
sub_Stage_Wait_Until_Ready.m|Wait until the stage is ready



## Basics of interfacing with hardware via Matlab

### VXM stepping motor controller

#### Matlab commands used

| serial Interface command                                                             | serialport Interface command | Example use case           |
|--------------------------------------------------------------------------------------|-----------------------|-----------------------------------|
| seriallist                                                                           | serialportlist        | Discover Serial Port Devices      |
| serial                                                                               | serialport            | Connect to Serial Port Device     |
| fwrite and fread                                                                     | write and read        | Read and Write                    |
| fprintf                                                                              | writeline             | Send a Command                    |
| fscanf, fgetl, and fgets                                                             | readline              | Read a Terminated String          |
| flushinput and flushoutput                                                           | flush                 | Flush Data from Memory            |
| Terminator                                                                           | configureTerminator   | Set Terminator                    |
| BytesAvailableFcnCount, BytesAvailableFcnMode, BytesAvailableFcn, and BytesAvailable | configureCallback     | Set Up a Callback Function        |
| PinStatus                                                                            | getpinstatus          | Read Serial Pin Status            |
| DataTerminalReady and RequestToSend                                                  | setDTR and setRTS     | Set Serial DTR and RTS Pin States |
| serial Properties                                                                    | serialport Properties |                                   |

See here for more information on communicating with serial and serialport objects via Matlab: https://www.mathworks.com/help/matlab/import_export/transition-your-code-to-serialport-interface.html

## Contributing

Currently contributing is not suppported, please see future versions at https://github.com/drmittelstein/ultrasound_hardware_control to determine whether this changes.

## Versioning
Please see available versions at https://github.com/drmittelstein/ultrasound_hardware_control

## Authors

* **David Reza Mittelstein** - "Modifying ultrasound waveform parameters to control, influence, or disrupt cells" *Caltech Doctorate Thesis in Medical Engineering*

## Acknowledgments

* Acknowledgements to my colleagues in Gharib, Shapiro, and Colonius lab at Caltech who helped answer questions involved in the development of these scripts.
