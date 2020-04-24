/*
File : GEOMETRY_PREP.chpl
Author : Amin Ouled-Mohamed
Date : 22/02/2020 22:21
Last revised : 21/02/2020 01:35
Desc : Program prepares the geometry by computing important parameters (control points, panel surface, panel orientation ....) .
Usage : input --> x,y airfoil in an array, in the correct orientation
        output --> x_ctrl_pts,y_ctrl_pts : 2 1D arrays containing coordinates of control points
                   length_panel :  1D array with panels surfaces
                   orientation_panels :  1D array with panels orientation (phi)
                   normal_to_panels : 1D array with angle of the vector normal to the panel (del)
                   beta_panels : 1D array with angles between angle of attack and vector normal to panel

TO-DO : # add a descretization file if necessary (changes precision of the solution)
        # Angle of attack  : Include a range to read from
*/

use AIRFOIL_PARSER only x_airfoil_coordinates, y_airfoil_coordinates;
use Math only atan2, pi;
use GEOMETRY_REF only refine_geometry;


var old_x_edge_pts = x_airfoil_coordinates;
var old_y_edge_pts = y_airfoil_coordinates;



writeln("|---GEOMETRY_PREP---| How much do you want to refine the geometry ? (enter 0 to keep the original)");

var nb_ref = stdin.read(int);

var x_edge_pts : [1..(2**nb_ref)*(old_x_edge_pts.size)] real;
var y_edge_pts : [1..(2**nb_ref)*(old_x_edge_pts.size)] real;

var edge_points = [x_edge_pts,y_edge_pts] ;

edge_points = refine_geometry(nb_ref,old_x_edge_pts,old_y_edge_pts);
x_edge_pts = edge_points[1];
y_edge_pts = edge_points[2];



writeln("|---GEOMETRY_PREP---| ", x_edge_pts.size- old_x_edge_pts.size, " nodes added to the geometry !");
writeln("Previous total number of nodes : " ,old_x_edge_pts.size, "\nNew total number of nodes : ",x_edge_pts.size);


var nb_of_panel = x_edge_pts.size;

//Asking for value of angle of attack (begin with a single value but can include a range)
var aoa_d : real;
writeln("|---GEOMETRY_PREP---| Value of angle of attack of freestream velocity (in degrees) ?");
aoa_d = stdin.read(real);
var aoa = aoa_d*(pi/180);

// computing control points for each panel
var x_ctrl_pts, y_ctrl_pts : [1..nb_of_panel] real ;

for i in 1..nb_of_panel do {

    if i == 1 then {

    x_ctrl_pts[i] = 0.5*(x_edge_pts[nb_of_panel]+x_edge_pts[i]);
    y_ctrl_pts[i] = 0.5*(y_edge_pts[nb_of_panel]+y_edge_pts[i]);

    }
    else {
        x_ctrl_pts[i] = 0.5*(x_edge_pts[i]+x_edge_pts[i-1]);
        y_ctrl_pts[i] = 0.5*(y_edge_pts[i]+y_edge_pts[i-1]);

    }

}

// computing length of each panel
var length_panel : [1..nb_of_panel] real;

for i in 1..nb_of_panel do {

    if i==1 then {

        length_panel[i] = ((x_edge_pts[i]-x_edge_pts[nb_of_panel])**2 + (y_edge_pts[i]-y_edge_pts[nb_of_panel])**(2))**0.5;

    }

    else{

        length_panel[i] = ((x_edge_pts[i]-x_edge_pts[i-1])**2 + (y_edge_pts[i]-y_edge_pts[i-1])**2)**0.5;

    }

}


// Computing orientation angle of panels

var orientation_panels : [1..nb_of_panel] real ;

for i in 1..nb_of_panel do {

    if i == 1 then {

        orientation_panels[i] = atan2(y_edge_pts[i]-y_edge_pts[nb_of_panel],x_edge_pts[i]-x_edge_pts[nb_of_panel]);

        if orientation_panels[i] < 0 then {

            orientation_panels[i] = orientation_panels[i] + 2*pi;

        }

    }

    else {

        orientation_panels[i] = atan2(y_edge_pts[i]-y_edge_pts[i-1],x_edge_pts[i]-x_edge_pts[i-1]);

        if orientation_panels[i] < 0 then {

            orientation_panels[i] = orientation_panels[i] + 2*pi;

        }

    }

}



// computing normal vector panel

var normal_to_panels : [1..nb_of_panel] real ;

normal_to_panels = orientation_panels + pi/2;

// computing beta angle 

var beta_panels : [1..nb_of_panel] real ;

beta_panels = normal_to_panels - aoa ;

writeln("|---GEOMETRY_PREP---| Value of freestream velocity ? " );
var v_inf = stdin.read(real);