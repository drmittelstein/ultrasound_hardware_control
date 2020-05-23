# Ultrasound Hardware Control

This repository includes scripts that allow the user to conduct ultrasound experiments.  Scripts enable the users to align and calibrate ultrasound transducers and to control the insonation of these transducers on targets in 24 well plate platforms.

### Software Prerequisites

This system requires MATLAB with the Instrument Control Toolbox Support Package that is relevant for the hardware that you will be using.  For example, the code as currently written uses the "Instrument Control Toolbox Support Package for Keysight IO Libraries and VISA Interface"

### Hardware Required

This system is designed to function with the following instruments:

```
BK Precision 4050 Function / Arbitrary Waveform Generator
Keysight InfiniiVision 3000 X-Series Oscilloscope
Velmex VMX-3 Stepping Motor Controller
```

If a different waveform generator, oscilloscope, or motor controller is used, the subroutines used in this code must be modified to the programming syntax of these new pieces of hardware as described in their programming manual.

The ultrasound signal generated needs to be amplified using an RF amplifier that can boost the signal voltage to be sufficient to drive an ultrasound transducer at the target pressure values.  A hydrophone system, such as a fiber optic hydrophone is necessary to detect the ultrasound signal at a test point to allow for alignment and calibration.

## Setup

### Matlab computer

These scripts must all be in the same directory in order to function.  The results of any scans or acquisitions made by these scripts will be in a "results" subdirectory in this directory, so place this directory in a drive with sufficient available space.

### Hardware VISA addresses

Before running the scripts, the VISA address of the signal generator and oscilloscope  must be appended to the following files as appropriate:

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


The review, edit, and use the following search scripts to find the maximum value:

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


## Contributing

Currently contributing is not suppported, please see future versions at htts://github.com/drmittelstein/oncotripsy to determine whether this changes.

## Versioning
Please see available versions at htts://github.com/drmittelstein/oncotripsy

## Authors

* **David Reza Mittelstein** - *Caltech Doctorate Thesis Work* - 

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Acknowledgements to my colleagues in Gharib, Shapiro, and Colonius lab at Caltech who helped answer questions involved in thed development of these scripts.
