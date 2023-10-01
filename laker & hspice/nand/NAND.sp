* SPICE NETLIST
***************************************

.SUBCKT L POS NEG
.ENDS
***************************************
.SUBCKT NAND A out_2 B VDD GND
** N=6 EP=5 IP=0 FDC=4
M0 2 A out_2 GND N_18 L=1.8e-07 W=5e-07 AD=1.3e-13 AS=4.25e-13 PD=5.2e-07 PS=2.2e-06 $X=3270 $Y=-3775 $D=0
M1 GND B 2 GND N_18 L=1.8e-07 W=5e-07 AD=3.7e-13 AS=1.3e-13 PD=1.98e-06 PS=5.2e-07 $X=3970 $Y=-3775 $D=0
M2 out_2 A VDD VDD P_18 L=1.8e-07 W=1e-06 AD=2.6e-13 AS=4.9e-13 PD=5.2e-07 PS=1.98e-06 $X=3270 $Y=-1030 $D=1
M3 VDD B out_2 VDD P_18 L=1.8e-07 W=1e-06 AD=4.9e-13 AS=2.6e-13 PD=1.98e-06 PS=5.2e-07 $X=3970 $Y=-1030 $D=1
.ENDS
***************************************
