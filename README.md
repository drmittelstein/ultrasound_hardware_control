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
| Script name                       | Description          |
|-----------------------------------|----------------------|
| BackToOrigin.m                    | Move stage to origin |
| Cavitation_Rpt.m                  |                      |
| Cavitation_Seg_Rpt.m              |                      |
| CustomWaveformGenerator.m         |                      |
| MakeMovieFromGridWaveform.m       |                      |
| MoveSpecial.m                     |                      |
| MoveSpecialMM.m                   |                      |
| MoveToHome.m                      |                      |
| MoveToMax.m                       |                      |
| Release_Stage.m                   |                      |
| Scan_Acquire.m                    |                      |
| Scan_Acquire_Cont.m               |                      |
| Scan_FindMax_v4.m                 |                      |
| Scan_Grid.m                       |                      |
| Scan_Space.m                      |                      |
| Scan_TransducerResponse_Adv.m     |                      |
| SetTestingParameters.m            |                      |
| stage_GUI.m                       |                      |
| sub_AllSettings.m                 |                      |
| sub_Close_All_Connections.m       |                      |
| sub_Data_CompressWaveform.m       |                      |
| sub_Data_Countdown.m              |                      |
| sub_Data_DecompressWaveform.m     |                      |
| sub_Data_Hydrophone_Curve.m       |                      |
| sub_SG_ApplySettings.m            |                      |
| sub_SG_ApplySettingsForTrigger.m  |                      |
| sub_SG_Initialize.m               |                      |
| sub_SG_Start.m                    |                      |
| sub_SG_Stop.m                     |                      |
| sub_SG_Trigger.m                  |                      |
| sub_SG_Wait_Until_Ready.m         |                      |
| sub_Scope_ApplySettings.m         |                      |
| sub_Scope_Initialize.m            |                      |
| sub_Scope_Readout_All.m           |                      |
| sub_Scope_Readout_All_NoRefresh.m |                      |
| sub_Scope_Readout_HQ.m            |                      |
| sub_Scope_Readout_HQ_simple.m     |                      |
| sub_Scope_Run.m                   |                      |
| sub_Stage_Cancel.m                |                      |
| sub_Stage_Initialize.m            |                      |
| sub_Stage_Move.m                  |                      |
| sub_Stage_Move_To.m               |                      |
| sub_Stage_Move_Vec.m              |                      |
| sub_Stage_Update_Positions.m      |                      |
| sub_Stage_Wait_Until_Ready.m      |                      |
| sub_wellplate_UpdateGUI.m         |                      |
| subdir.m                          |                      |
| wellplate_GUI.m                   |                      |
| wellplate_v4_zigzag43.m           |                      |

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
