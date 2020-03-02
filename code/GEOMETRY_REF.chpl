/*
File : GEOMETRY_REF.chpl
Author : Amin Ouled-Mohamed
Date : 22/02/2020 22:21
Last revised : 21/02/2020 01:35
Desc : Function refines the geometry of the airfoil by adding a mid point to every panel.
       This file is a sub-module of GEOMETRY_PREP (used only in that module)
Usage : input --> nb_ref : how many times the airfoil will be refined 
                           for example, if nb_ref=1, every panel will be subdivided once in 2 equal panels
                           if nb_ref=2, every panel will be subdivied twice with a result of 4 equal panels
                           in the initial one
        output --> the new refined geometry
*/

proc refine_geometry(nb_ref:int, x_coord, y_coord) {


    var new_x_coord : [1..(2**nb_ref)*(x_coord.size)] real;
    var new_y_coord :  [1..(2**nb_ref)*(y_coord.size)] real;

    var coeff : real ;
    
    for i in 1..x_coord.size do {

        
        new_x_coord[(i-1)*(2**nb_ref)+1] = x_coord[i];
        new_y_coord[(i-1)*(2**nb_ref)+1] = y_coord[i];
        coeff = 1;

        if i == x_coord.size then{        
                
            for j in (i-1)*(2**nb_ref)+2..(i)*(2**nb_ref) do {

                

                new_x_coord[j] = x_coord[i] + (x_coord[1]-x_coord[i])*(coeff/(2**nb_ref));
                new_y_coord[j] = y_coord[i] + (y_coord[1]-y_coord[i])*(coeff/(2**nb_ref));
                coeff += 1;

            }
        }
        else {

            for j in (i-1)*(2**nb_ref)+2..(i)*(2**nb_ref) do {
            new_x_coord[j] = x_coord[i] + (x_coord[i+1]-x_coord[i])*(coeff/(2**nb_ref));
            new_y_coord[j] = y_coord[i] + (y_coord[i+1]-y_coord[i])*(coeff/(2**nb_ref));
            coeff += 1;

            }
        }
    }
    var all_coord = [new_x_coord,new_y_coord];

    return all_coord;
}

