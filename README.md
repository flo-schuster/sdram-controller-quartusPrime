## SDRAM controller
This repository contains a SDRAM controller written in Verilog. It is specified for the SDRAM chip 'winbond W9864G6JT-6' and a Intel Cyclone 10 LP FPGA.

Intended to be used as a replacement for the SRAM of 'Project Oberon' in the future.
http://www.projectoberon.com/
https://people.inf.ethz.ch/wirth/ProjectOberon/index.html

### IDE & Board
- HDL: Verilog
- IDE: Quartus Prime Lite 18.1.0
- Devide Family: Intel Cyclone 10 LP
- Device: 10CL025YU256C8G
- SDRAM chip: winbond W9864G6JT-6
  - Datasheet: https://www.winbond.com/resource-files/w9864g6jt_a03.pdf
- Board: Trenz CYC1000 (TEI0003)
  - Resources + Datasheet: https://wiki.trenz-electronic.de/display/PD/TEI0003+Resources

### How to set up the project
1. Open the file `sdram-controller.qpf` in Quartus Prime
2. Run the script `setup_sdram-controller.tcl` to initialy configure the project