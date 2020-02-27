

proc refine_geometry(nb_ref:int, x_coord, y_coord) {


    var new_x_coord : [1..(2**nb_ref)*(x_coord.size-1)] real;
    var new_y_coord :  [1..(2**nb_ref)*(y_coord.size-1)] real;

    var coeff : int ;
    for i in 1..x_coord.size-1 do {

        
        new_x_coord[(i-1)*(2**nb_ref)+1] = x_coord[i];
        new_y_coord[(i-1)*(2**nb_ref)+1] = y_coord[i];
        coeff = 1;

        if i == x_coord.size-1 then{        
                
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
    writeln(new_x_coord.size,new_y_coord.size);
    var all_coord = [new_x_coord,new_y_coord];

    return all_coord;
}

