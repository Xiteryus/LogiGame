# LogiGame - Microcontrôleur en VHDL avec Jeu Interactif

## Description du Projet
Ce projet consiste à concevoir un cœur de microcontrôleur simple en VHDL, puis à le tester sur une carte de développement ARTY intégrant un FPGA Artix-35T de Xilinx. Une fois le cœur de microcontrôleur fonctionnel, il sera utilisé pour exécuter un jeu interactif. Des blocs fonctionnels complémentaires seront créés en VHDL pour permettre au jeu de fonctionner correctement sur le FPGA.

## Architecture du Microcontrôleur

### Coeur de controlleur
1. **Top Level** 
    - Top Level
2. **Unité Arithmétique et Logique (UAL)**
   - UAL 
   - UAL Sel_Out
   - UAL Sel_Route
3. **Buffers**
   - CMD Buffers
   - UAL Buffers
4. **Mémoire d'Instructions**
    - Memory Instruction

## Module de Jeu

1. **Générateur de Séquence Pseudo-Aléatoire**
    - Implémentation d'un LFSR (Linear Feedback Shift Register) de 4 bits pour générer des séquences aléatoires.


## Lancement des simulations
 - UAL 
````bash 
cd .\UAL\
ghdl -a --std=08 .\ual.vhd .\TBual.vhd
ghdl -e --std=08 tb_valcore
ghdl -r --std=08 tb_valcore --wave=TBual.ghw
````
 - Ual_selout
```BASH
cd .\Coeur_Controleur\UAL\
ghdl -a --std=08 .\ual_selout.vhd .\TBual_selout.vhd
ghdl -e --std=08 tb_ual_selout
ghdl -r --std=08 tb_ual_selout --wave=TBual_selout.ghw
```
 - Ual_selroute
```BASH
cd .\Coeur_Controleur\UAL\
ghdl -a --std=08 .\ual_selroute.vhd .\TBual_selroute.vhd
ghdl -e --std=08 tb_ual_seroute
ghdl -r --std=08 tb_ual_selroutr --wave=TBual_selroute.ghw
```
 - Memory Instruction 
```BASH 
cd .\Coeur_Controleur\MemoryUnit\
ghdl -a --std=08 .\mem_control.vhd .\TBmem_control.vhd
ghdl -e --std=08 tb_mem_control
ghdl -r --std=08 tb_mem_control --wave=TB_mem_control.ghw
```
 - Top_level
 - Penser d'abord à charger les fichiers suivants dans le répertoire Top_Level :
   -  Ual ```ghdl -a --std=08 C:[chemin vers le repertoire] LogiGame\Coeur_Controleur\UAL\ual.vhd```
   -  Ual_selout  ```ghdl -a --std=08 C:[chemin vers le repertoire] LogiGame\Coeur_Controleur\UAL\ual_selout.vhd```
   -  Ual_selroute  ```ghdl -a --std=08 C:[chemin vers le repertoire] LogiGame\Coeur_Controleur\UAL\ual_selroute.vhd```
   -  Buffer_cmd ```ghdl -a --std=08 C:[chemin vers le repertoire] LogiGame\Coeur_Controleur\Buffers\buffer_cmd.vhd```
   -  Buffer_cmd ```ghdl -a --std=08 C:[chemin vers le repertoire] LogiGame\Coeur_Controleur\Buffers\buffer_ual.vhd```
   -  Mem_control ```ghdl -a --std=08 C:[chemin vers le repertoire] LogiGame\Coeur_Controleur\MemoryUnit\mem_control.vhd```
```BASH
cd .\Coeur_Controleur\Top_Level\
ghdl -a --std=08 .\Top_level.vhd .\tb_top_level.vhd
ghdl -e --std=08 tb_Top_level
ghdl -r --std=08 tb_Top_level --wave=tb_Top_level.ghw
```
---
 - Generateur Aléatoire 
```BASH
cd .\Générateur_Aléatoire\
ghdl -a --std=08 .\lsfr4bits.vhd .\TBlsfr4bits.vhd
ghdl -e --std=08 TBlsfr4bits
ghdl -r --std=08 TBlsfr4bits --wave=TBlsfr4bits.ghw
```

