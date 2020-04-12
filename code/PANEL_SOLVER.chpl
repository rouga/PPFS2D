/*
File : PANEL_SOLVER.chpl
Author : Amin Ouled-Mohamed
Date : 14/03/2020 22:02
Last revised : 14/03/2020 01:35
Desc : Program computes lambdas (source strengh of panels) by solving INTEGRALS*Lambda = B linear system
Usage : input -->  Geometry and integral values from PANEL_INTEGRALS.chpl and GEOMETRY_PREP.chpl
        output --> lambdas 
*/


use GEOMETRY_PREP only aoa,x_edge_pts , y_edge_pts ,x_ctrl_pts ,y_ctrl_pts ,length_panel ,orientation_panels ,normal_to_panels ,beta_panels,v_inf;
use SOURCE_INTEGRALS only compute_integrals;
use VORTEX_INTEGRALS only compute_integrals_vortex;
use Math only pi, cos;
use LinearAlgebra;
use Time ;


var beta_pp = beta_panels;
var aoa_pp = aoa ;
var v_inf_pp = v_inf ;
var length_panel_pp = length_panel;

writeln("|---PANEL_SOLVER---| Number of CPU cores used for solving the problem : ", here.numPUs() );
var num_CPU = here.numPUs();

var watch: Timer;
watch.start();

var Is_n : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real ;
var Is_t : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real ;
var Iv_n : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real ;
var Iv_t : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real ;
var B : [1..x_ctrl_pts.size] real ;

var integrals_source = [Is_n,Is_t];
var integrals_vortex = [Iv_n,Iv_t];




integrals_source = compute_integrals(num_CPU:int,length_panel ,orientation_panels ,x_ctrl_pts ,y_ctrl_pts ,x_edge_pts,y_edge_pts);
integrals_vortex = compute_integrals_vortex(num_CPU:int,length_panel ,orientation_panels ,x_ctrl_pts ,y_ctrl_pts ,x_edge_pts,y_edge_pts);

Is_n = integrals_source[1];
Is_t = integrals_source[2];

Iv_n = integrals_vortex[1];
Iv_t = integrals_vortex[2];

// KUtta condition
var kutta_line : [1..x_ctrl_pts.size] real ;
kutta_line[1..x_ctrl_pts.size] = 0 ;
kutta_line[1] = 1 ;
kutta_line[x_ctrl_pts.size] = 1;

Iv_n[x_ctrl_pts.size,1..x_ctrl_pts.size] = kutta_line;


for i in 1..x_ctrl_pts.size do {
    B[i] = -v_inf*2*pi*cos(beta_panels[i]);

}


// Solving linear system for gamma and lambdas
var lambdas : [1..x_ctrl_pts.size] real ;
lambdas = solve(Is_n,B);
var gammas  : [1..x_ctrl_pts.size] real ;
gammas = solve(Iv_n,B);

var sum_lambdas = +reduce (lambdas*length_panel);
var sum_gammas = +reduce gammas;

writeln("Sum lambdas : " , sum_lambdas);
writeln("Sum gammas : ", sum_gammas);


watch.stop();
writeln("Time for whole process: " , watch.elapsed());

