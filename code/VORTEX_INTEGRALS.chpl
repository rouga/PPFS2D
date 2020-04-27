/*
File : VORTEX_INTEGRALS.chpl
Author : Amin Ouled-Mohamed
Date : 01/03/2020 22:02
Last revised : 01/03/2020 01:35
Desc : Function computes the tangential and normal integrals for each panel to form the A matrix (calculating coefficients)
Usage : input -->  cpu_num : number of cpus to use
                     the rest is defined in GEOMETRY_PREP
        output --> I_t : integrals for the tangential velocity equation
                   I_n : integrals for the normal velocity equation
*/

use Time ;
use Math only cos, pi, sqrt, sin, atan2 , log, isnan;
proc compute_integrals_vortex (cpu_num:int,len_panel ,panel_orient ,x_ctrl_pts ,y_ctrl_pts ,x_edge_pts,y_edge_pts) {


       var watch: Timer;
       watch.start();

       var intervals = x_ctrl_pts.size/cpu_num : int ;
       var rest = x_ctrl_pts.size-intervals*cpu_num : int ;


       var I_n : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real;
       var I_t : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real;

       var lock1 : atomic int;

       var length = x_ctrl_pts.size ; 
       forall task in 0..cpu_num-1 do {

              var A : real;
              var B : real;
              var C_n : real ;
              var D_n : real ; 
              var E : real;
              var C_t : real ;
              var D_t : real ;

              var task_intervall1 = task*intervals + 1 ; int;
              var task_intervall2 = task*intervals + intervals;
              
              
              if task == cpu_num-1 then {

                     if rest != 0 then {

                            task_intervall2 += rest;
                     }
              }

              for i in task_intervall1..task_intervall2 do {

                     for j in 1..length do {

                            if j == 1 then {

                            A = -(x_ctrl_pts[i]-x_edge_pts[length])*cos(panel_orient[j])-(y_ctrl_pts[i]-y_edge_pts[length])*sin(panel_orient[j]);

                            B = (x_ctrl_pts[i]-x_edge_pts[length])**2 + (y_ctrl_pts[i]-y_edge_pts[length])**2 ;

                            // MAYBE SHOULD ADD LENGTH TO PANEL ORIENT

                            C_n = -cos(panel_orient[i]-panel_orient[j]);

                            D_n = (x_ctrl_pts[i]-x_edge_pts[length])*cos(panel_orient[i]) + (y_ctrl_pts[i]-y_edge_pts[length])*sin(panel_orient[i]);

                            C_t = sin(panel_orient[j]-panel_orient[i]);
                            D_t = (x_ctrl_pts[i]-x_edge_pts[length])*sin(panel_orient[i]) - (y_ctrl_pts[i]-y_edge_pts[length])*cos(panel_orient[i]);
                            }

                            else {

                            A = -(x_ctrl_pts[i]-x_edge_pts[j-1])*cos(panel_orient[j])-(y_ctrl_pts[i]-y_edge_pts[j-1])*sin(panel_orient[j]);

                            B = (x_ctrl_pts[i]-x_edge_pts[j-1])**2 + (y_ctrl_pts[i]-y_edge_pts[j-1])**2 ;

                            C_n = -cos(panel_orient[i]-panel_orient[j]);

                            D_n = (x_ctrl_pts[i]-x_edge_pts[j-1])*cos(panel_orient[i]) + (y_ctrl_pts[i]-y_edge_pts[j-1])*sin(panel_orient[i]);

                            C_t = sin(panel_orient[j]-panel_orient[i]);
                            D_t = (x_ctrl_pts[i]-x_edge_pts[j-1])*sin(panel_orient[i]) - (y_ctrl_pts[i]-y_edge_pts[j-1])*cos(panel_orient[i]);


                            }
                            
                            
                            if B-A**2 <= 0 then {

                                   E = 0;
                            }
                            else {
                                   E = sqrt(B-A**2);
                            }
                              
                            

                            if (i == j) then {

                                   I_n[i,j] = 0;

                            }
                            // else if (E == 0) then {
                            //        I_t[i,j] = 0;
                            //        I_n[i,j] = pi;
                            // }

                            else {

                                   I_n[i,j] = -( 0.5*C_n*log((len_panel[j]**2 + 2*A*len_panel[j] + B)/B)
                                                 + ((D_n-A*C_n)/E)*(atan2((len_panel[j]+A),E)-atan2(A,E)) );

                                   I_t[i,j] = ( 0.5*C_t*log((len_panel[j]**2 + 2*A*len_panel[j] + B)/B)
                                   + ((D_t-A*C_t)/E)*(atan2((len_panel[j]+A),E)-atan2(A,E)) );

                                   if isnan(I_n[i,j]) then {
                                          I_n[i,j] = 0;

                                   }

                                   if isnan(I_t[i,j]) then {
                                          I_t[i,j] = 0;

                                   }
                            }
                            

                            }

                     }
              

              lock1.add(1);
              lock1.waitFor(cpu_num);
              
              }
       watch.stop();
       writeln("Duration of Vortex Panel integrals process: " , watch.elapsed());

       return [I_n,I_t];

}