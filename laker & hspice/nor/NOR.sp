* SPICE NETLIST
***************************************

.SUBCKT L POS NEG
.ENDS
***************************************
.SUBCKT NOR C VDD D GND out_3
** N=6 EP=5 IP=0 FDC=4
M0 out_3 C GND GND N_18 L=1.8e-07 W=5e-07 AD=1.3e-13 AS=2.45e-13 PD=5.2e-07 PS=1.48e-06 $X=4610 $Y=-3400 $D=0
M1 GND D out_3 GND N_18 L=1.8e-07 W=5e-07 AD=2.45e-13 AS=1.3e-13 PD=1.48e-06 PS=5.2e-07 $X=5310 $Y=-3400 $D=0
M2 3 C VDD VDD P_18 L=1.8e-07 W=1e-06 AD=2.6e-13 AS=7.4e-13 PD=5.2e-07 PS=2.48e-06 $X=4610 $Y=-295 $D=1
M3 out_3 D 3 VDD P_18 L=1.8e-07 W=1e-06 AD=8.5e-13 AS=2.6e-13 PD=2.7e-06 PS=5.2e-07 $X=5310 $Y=-295 $D=1
.ENDS
***************************************
