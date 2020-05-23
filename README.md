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

If a different waveform generator, oscilloscope, or motor controller is used, the subroutines used in this code must be modified to the programming syntax of these new pieces of hardware as described in their programming manual

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

## Suggested Hardware Configuration (adjustable in code)

For the BKP signal generator (SG) and Keysight oscillscope (Scope), a suspected cable configuration is as follows:

```
SG Ch 1 <--> Scope Ch 1
SG Ch 1 <--> SG Ext Trg
SG Ch 2 <--> Scope Ch 2
SG Ch 2 <--> Amplifier In
Amplifier out <--> US Tx
Hydrophone <--> Scope Ch 4
```

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

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
