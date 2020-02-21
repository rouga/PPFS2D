/*
File : AIRFOIL_PARSER.chpl
Author : Amin Ouled-Mohamed
Date : 20/02/2020 22:21
Last revised : 21/02/2020 01:35
Desc : Program parses airfoil coordinates (geometry) from file specified by the user.
Usage : input --> airfoil coordinates file in airfoil folder
        output --> 
*/

// Importing module for IO operations
use IO;                                                                                 
use List;


//var file_name = stdin.read(string);

var airfoil_file = open("../airfoil/NACA2412.dat" , iomode.r);

// Adding a channel
var airfoil_channel = airfoil_file.reader();

//Reading all the files information line by line (indexed by line)
var airfoil_data_string = airfoil_channel.lines();

//Closing the channel and the IO operation to free the allocated memory
airfoil_channel.close();
airfoil_file.close();


// Fiding the total number of lines in the file
var file_line_nbr = 0;
for i in airfoil_data_string do {

    file_line_nbr += 1;

}

// Fiding the first appearence of the keyword START
var position = 1;
var starting_line = 1;   
while (airfoil_data_string[position].toLower() != 'start\n' && position <= file_line_nbr) do {
    position += 1;
    starting_line += 1;
}

var airfoil_coordinates_string : list(string);

// Writing the message below and aborting program in case no START statement is found
if (starting_line == file_line_nbr) then {

    writeln("No START statement found in airfoil input file");
    exit(0);
}


//Reading the coordinates of the airfoil and looking for the first appearence of the keyword END


else{

    starting_line += 1;
    

    while (airfoil_data_string[starting_line].toLower() != 'end\n' && starting_line <= file_line_nbr) do {
        
        airfoil_coordinates_string.append(airfoil_data_string[starting_line]);
        starting_line += 1;

    }
}


// Writing the message below and aborting program in case no END statement is found
var ending_line = starting_line;
if ending_line == file_line_nbr then {

    writeln("No END statement found in airfoil input file");
    exit(0);
}

// Initializing the arrays for the x y coordinates of the airfoil
var number_of_points = airfoil_coordinates_string.size ;
var x_airfoil_coordinates : [1..number_of_points ] real  ;
var y_airfoil_coordinates : [1..number_of_points ] real  ;


 
var index_of_end : int ;
var index_of_space : int ;
var index_of_space_2 : int;
for i in 1..number_of_points do{

    // Finding the indexes of important locations in a string line
    // the line format is the following : X.XXXXX    X.XXXXX\n
    // This method finds the index of the first space after the first coordinate
    // and the first space before the second coordinate and the index of the newline
    // carater. By finding these 3 indexes, we can split x y coordinates easily

    //looking for the index of the first space appearence from left to right
    index_of_space = airfoil_coordinates_string[i].find(" "):int;

    //looking for the index of the first space appearence from right to left
    index_of_space_2 = airfoil_coordinates_string[i].rfind(" "):int;

    ////looking for the index of the first newline caracter appearence from left to right
    index_of_end = airfoil_coordinates_string[i].find("\n"):int;

    // Converting the string coordinates from string to real and assigning them to initialized arrays
    x_airfoil_coordinates[i] = airfoil_coordinates_string[i][1..index_of_space-1]:real;
    y_airfoil_coordinates[i] = airfoil_coordinates_string[i][index_of_space_2+1..index_of_end-1]:real;

    
}

writeln(x_airfoil_coordinates);
writeln(y_airfoil_coordinates);