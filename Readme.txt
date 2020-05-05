PARALLEL POTENTIAL FLOW SOLVER 2D - PPFS2D

===== DESCRIPTION ======

PPFS2D is a program that calculates Lift coefficient with a given input file .
Input file should contain the airfoil geometry. The vortex panel method is used
to compute the lift. All calculations are automatically parallelized on the number
of cores available in the computer.



===== PROGRAM HIERARCHY =====

PPFS2D
 |
 +-- bin
 |  |  
 |  +-- PPFS2D 					--> Executable to launch the program
 |   
 |    
 +-- results
 |  |  
 |  +-- Output files are generated in this folder 
 |    
 +-- airfoil
 |  |  
 |  +-- naca0012.dat                   		 --> Input file for NACA0012 airfoil (demo file)      
 |  +-- NACA2412.dat				 --> Input file for NACA2412 airfoil (demo file)
 |  +-- cylinder.dat 				 --> Input file for a cylinder (demo file) 
 |  
 |    
 +-- code
    |  
    +-- All source code files are found in this folder 




===== INSTALLATION =====

(Tested on Ubuntu 18.04 LTS)

1) Download zip folder from : https://github.com/rouga/PPFS2D

2) Open linux command line and access directory where the zip folder is downloade

3) Unzip the folder with the command : unzip <folder_name>




===== USAGE =====

The following is a procedure to demonstrate how to run an analysis on NACA2412 airfoil

1) Access the bin folder with command line

2) Execute the program with the following command : ./PPFS2D

3) Once the program is launched, the user is prompted to enter the airfoil file name. Command : NACA2412.dat

IMPORTANT : Make sure the input file is in "airfoil" folder 

4) The user is prompted to refine the geometry. Command : 0

IMPORTANT : Its recommanded to choose always 0 to keep the original geometry. This option is still
in a experimental branch, thus it can return erroneous results.

5) The user is prompted for a value of angle of attack in degrees. Command : 5 (Just for the sake of demonstration. Any value can be given)

6) The user is prompted for a value of freestream velocity. Command : 1 (again for demonstration)

7) The user is prompted to choose the method to compute aerodynamic coefficients . command : vortex

IMPORTANT : choose "vortex" to analyze a lifting surface. Otherwise, enter "source"




====== OUTPUT ====== 

The output is written in "results" folder. The file is named as follows : output_<input_file_name>.dat

For this demonstration, a file named "output_NACA2412.dat" should be generated in "results" folder

The following is a snippet of the output file for this demonstration  : 

Angle of attack : 5.0
x_ctrl_pts          CP
0.999958          -8.84867
0.997927          -3.0723
0.990004          -1.26495
0.974288          -0.858093
0.951043          -0.607143
0.920655          -0.453089
0.883622          -0.355767
0.840553          -0.292135
0.792145          -0.249432
	    .
	    .
	    .
	    .
0.922007          0.483831
0.951998          0.624926
0.974892          0.777883
0.990346          0.911222
0.998131          0.99806

IMPORANT : The subroutine to compute Cp values for lifting surfaces is still in alpha testing. Thus, it's very likely output results are inaccurate. 




Feel free to add options, optimizations or bug fixes by committing to the following repository : https://github.com/rouga/PPFS2D
Thank you !!

 






 

