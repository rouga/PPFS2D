use PANEL_POSTPROCESSING only C_p;
use GEOMETRY_PREP only x_ctrl_pts, y_ctrl_pts, aoa_d;
use AIRFOIL_PARSER only file_name;
use IO;
use Math only pi;


var myFile = open("../results/output_" +  file_name, iomode.cw);

var myWritingChannel = myFile.writer();

myWritingChannel.write("Angle of attack : " , aoa_d,"\n");

myWritingChannel.write("x_ctrl_pts          ", "CP","\n");

for i in 1..C_p.size do {
    myWritingChannel.write(x_ctrl_pts[i],"          ", C_p[i],"\n");


}
