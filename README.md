# Amstrad CPC 8255 PIO
Simple 8255 PIO board compatible with the Amstrad CPC and MX4 connector.

![readme_pic1](https://github.com/rabs664/amstrad-cpc-8255-pio/assets/105534000/57d22775-646d-4e72-8b4f-35513a6dd6ac)

## Objective
Support Z80 assembly learning, specifically associated with the 8255 and the Amstrad CPC.

## Background
Part of a number of modular cards using Z80 associated peripherals and the Amstrad CPC.

## IO Address
The IO Address can be selected using two sets of jumpers (CS_HB and CS_LB), supporting the following base address.

* F8E0 and F8F0
* F9E0 and F9F0
* FAE0 and FAF0
* FBE0 and FBF0

See [CPC Wiki IO Port Summary](https://www.cpcwiki.eu/index.php/I/O_Port_Summary) for a list of known IO ports used on the Amstrad CPC.

## Testing
The 8255 PIO board has been built and has been tested on an Amstrad CPC 6128.

## Resources
The project uses the CPC Amstrad Expansion Backplane by [@revaldinho](https://github.com/revaldinho).

# Release History
## Version 1.0
* First Release

