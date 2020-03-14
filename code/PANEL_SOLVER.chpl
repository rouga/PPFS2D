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
use PANEL_INTEGRALS only compute_integrals;
use Math only pi, cos;
use LinearAlgebra;
use Time ;

var beta_pp = beta_panels;
var aoa_pp = aoa ;
var v_inf_pp = v_inf ;
var length_panel_pp = length_panel;

writeln("|---PANEL_SOLVER---| Number of CPU cores to use for solving the problem ? ", "( There's ", here.numPUs()," cores in this PC)" );
var num_CPU = stdin.read(int);

var watch: Timer;
watch.start();

var I_n : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real ;
var I_t : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real ;
var B : [1..x_ctrl_pts.size] real ;

var integrals = [I_n,I_t];


integrals = compute_integrals(num_CPU:int,length_panel ,orientation_panels ,x_ctrl_pts ,y_ctrl_pts ,x_edge_pts,y_edge_pts);

I_n = integrals[1];
I_t = integrals[2];


for i in 1..x_ctrl_pts.size do {
    B[i] = -v_inf*2*pi*cos(beta_panels[i]);

}


var lambdas : [1..x_ctrl_pts.size] real ;
lambdas = solve(I_n,B);
var sum_lambdas = +reduce lambdas;

writeln("Sum lambdas : " , sum_lambdas);

watch.stop();
writeln("Time for whole process: " , watch.elapsed());

