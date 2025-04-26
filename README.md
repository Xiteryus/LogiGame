# LogiGame

# Projet Microcontrôleur Simple en VHDL
Ce projet consiste à concevoir un cœur de microcontrôleur simple en VHDL, puis à le tester sur une carte de développement ARTY intégrant un FPGA Artix-35T de Xilinx. Une fois le cœur de microcontrôleur fonctionnel, il sera utilisé pour exécuter un jeu interactif. De plus, des blocs fonctionnels complémentaires seront créés en VHDL pour permettre au jeu de fonctionner correctement sur le FPGA.

---

## Installation et Lancement

### 1. UAL 
```
ghdl -a -g -fsynopsys --std=08 .\VALCORE_ARCH.vhd
ghdl -e -fexplicit --ieee=synopsys --std=08 VALCORE
ghdl -r -fexplicit --ieee=synopsys --std=08 VALCORE
```

### 2. Memory Unit
```
ghdl -a -g -fsynopsys --std=08 .\MEM_CONTROL.vhd
ghdl -e -fexplicit --ieee=synopsys --std=08 MEM_CONTROL
ghdl -r -fexplicit --ieee=synopsys --std=08 MEM_CONTROL
```
