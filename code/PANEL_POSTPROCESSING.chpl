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

use PANEL_SOLVER only aoa_pp,v_inf_pp,beta_pp,lambdas,gammas,Is_t,Iv_t,length_panel_pp,x_ctrl_pts_pp;
use Math only pi,cos,sin;

var method : string ;

writeln("|---PANEL_POSTPROCESSING---| Method to do the postprocessing (source/vortex) ?");
method = stdin.read(string);

var V_t : [1..beta_pp.size] real ;
var C_l : real ;
var C_d : real ;
var C_p : [1..beta_pp.size] real ;
var summation : real ;
var cl_gamma : real; 
var cm_gamma : real;

if method.toLower() == "vortex" then {


for i in 1..x_ctrl_pts_pp.size do {
    summation = 0;
    for j in 1..x_ctrl_pts_pp.size do {
        summation += (-gammas[j]/(2*pi))*(Iv_t[i,j]);
    }
    V_t[i] = v_inf_pp*sin(beta_pp[i])+ summation;
    C_p[i] = 1 - (V_t[i]/v_inf_pp)**2;

}


cl_gamma  = (+reduce (gammas*length_panel_pp)) / (0.5*v_inf_pp*1) ;
writeln( " Cl : " , cl_gamma);
cm_gamma = (+reduce (gammas*length_panel_pp*x_ctrl_pts_pp)) / (0.5*v_inf_pp*1);
writeln("Cm : " , cm_gamma , "  -testing");
}




else if method.toLower() == "source" then {


    for i in 1..beta_pp.size do {
    summation = 0;
    for j in 1..beta_pp.size do {
        summation += (lambdas[j]/(2*pi))*(Is_t[i,j]);
    }
    V_t[i] = v_inf_pp*sin(beta_pp[i]) + summation;
    C_p[i] = 1 - (V_t[i]/v_inf_pp)**2;

}


writeln(" Cl : 0");

}

