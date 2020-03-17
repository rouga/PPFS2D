/*
File : PANEL_INTEGRALS.chpl
Author : Amin Ouled-Mohamed
Date : 01/03/2020 22:02
Last revised : 01/03/2020 01:35
Desc : Function computes postprocessing value for the airfoil (pressure coefficient, tangential velocity
        lift coefficient, drag coefficient)
Usage : input -->  lambdas and geometry info
        output --> C_p : pressure coefficient
                   C_l : lift coefficient
                   C_d : drag coefficient
                   V_t : tangential velocity
*/

use PANEL_SOLVER only aoa_pp,v_inf_pp,beta_pp,lambdas,I_t,length_panel_pp;
use Math only pi,cos,sin;



var V_t : [1..beta_pp.size] real ;
var C_l : real ;
var C_d : real ;
var C_p : [1..beta_pp.size] real ;
var summation : real ;

for i in 1..beta_pp.size do {
    summation = 0;
    for j in 1..beta_pp.size do {
        summation += (lambdas[j]/(2*pi))*(I_t[i,j]);
    }
    V_t[i] = v_inf_pp*sin(beta_pp[i]) + summation;
    C_p[i] = 1 - (V_t[i]/v_inf_pp)**2;

}


var cl1 = -C_p*length_panel_pp*sin(beta_pp)*cos(aoa_pp);
var cl2 = -C_p*length_panel_pp*cos(beta_pp)*sin(aoa_pp);
var cd1 = -C_p*length_panel_pp*sin(beta_pp)*sin(aoa_pp);
var cd2 = -C_p*length_panel_pp*cos(beta_pp)*cos(aoa_pp);
var C_l1 : real ;
var C_l2 : real ;
var C_d1 : real ;
var C_d2 : real ;


C_l1 =  + reduce cl1;
C_l2 =  + reduce cl2;
C_l = C_l1 - C_l2;
C_d1 =  + reduce cd1 ;
C_d2 =  + reduce cd2;
C_d = C_d1 + C_d2;

writeln(lambdas);


