use GEOMETRY_PREP only x_edge_pts , y_edge_pts ,x_ctrl_pts ,y_ctrl_pts ,length_panel ,orientation_panels ,normal_to_panels ,beta_panels;
use PANEL_INTEGRALS only compute_integrals;



writeln("|---PANEL_SOLVER---| Number of CPU cores to use for solving the problem ? ", "( There's ", here.numPUs()," cores in this PC)" );
var num_CPU = stdin.read(int);


var I_n : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real ;
var I_t : [1..x_ctrl_pts.size,1..x_ctrl_pts.size] real ;

var integrals = [I_n,I_t];

integrals = compute_integrals(num_CPU:int,length_panel ,orientation_panels ,x_ctrl_pts ,y_ctrl_pts ,x_edge_pts,y_edge_pts);

I_n = integrals[1];
I_t = integrals[2];


