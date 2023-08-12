# Amstrad CPC 8255 PIO
Simple 8255 PIO board compatible with the Amstrad CPC and MX4 connector.

![readme_pic1](https://github.com/rabs664/Amstrad-CPC-8255-PIO/blob/main/Images/assembled-board.jpg)

## Objective
Prototyping board to Learn about the 8255 PIO, and how to write Z80 assembly using an Amstrad CPC.

## Background
Part of a number of modular cards using Z80 associated peripherals and the Amstrad CPC.

## Backplane
[CPC Amstrad Expansion Backplane by revaldinho](https://github.com/revaldinho/cpc_ram_expansion/wiki/CPC-Expansion-Backplane)

## IO Addressing
The IO Address can be selected using two sets of jumpers (CS_HB and CS_LB), supporting the following base address.

* F8E0 and F8F0
* F9E0 and F9F0
* FAE0 and FAF0
* FBE0 and FBF0

See [CPC Wiki IO Port Summary](https://www.cpcwiki.eu/index.php/I/O_Port_Summary) for a list of known IO ports used on the Amstrad CPC.

## Testing
The 8255 PIO board has been built and has been tested on an Amstrad CPC 6128.

## PCBs
PCBs are available from [Seeed Studio](https://www.seeedstudio.com/Amstrad-CPC-8255-PIO-g-1393845) (V2.0)

## Components
This [Digi-Key List](https://www.digikey.co.uk/en/mylists/list/ZWWIHRPLO7 ) contains all components excluding the 8255 which was purchased from EBay.

Note the right angled header for the port connections was not available at the time of producing this list but all other components were in stock for shipping immediately.

## Assembler
[RASM](https://github.com/EdouardBERGE/rasm)

## Resources
[Zed80 Website](http://zed80.com/Z80-RETRO/index_Home.html)

[CPCWiki](https://www.cpcwiki.eu/index.php/Main_Page)

Z80 Application by James W Coffron ISBN 0-89588-094-6

## Acknowledgements
[@revaldinho](https://github.com/revaldinho)

Don Prefontaine 

Peter Murray

[@EdouardBERGE](https://github.com/EdouardBERGE)

# Release History
## Version 2.0
* First Release
## Version 3.1
* KiCad created version of PCB.
