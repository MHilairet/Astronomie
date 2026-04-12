$fn=360;
epsilon=0.01;

use <my_function.scad>

d_eq5 = 60-0.2;  // less than 60mm
h_eq5 = 20;  // less than 20.4mm
d_upper = 55;

d_hole = 10;

module link_bottom_eq5()
{
  difference()
  {
    cylinder(h_eq5 + 3,d_eq5/2,d_eq5/2); 
    
    // Hole at the center
    cylinder(40,d_hole/2,d_hole/2);
  
    // Add 3 holes to unlock the center bearing
    for (nb =[-1:1])
      rotate([0,0,120*nb])
      {
        translate([0,d_upper/2-5.0,0]) hollowcylindersector(50, 5/2, angle=360,0, center=false);
      }  
  }  
}

link_bottom_eq5();

