$fn=360;
epsilon=0.01;

use <threads.scad>
use <my_function.scad>

include <BOLTS/bolts.scad>
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

// main body
d = 180;  // Diameter
h_bottom = 25;   // height, more than z_my_pa

// M10
tread_M10 = 1.5;
d_M10 = 10.0; // fixing screws
h_M10 = 8.4;  // M8 8.6mm

// M8
tread_M8 = 1.25;
d_M8 = 8.0; // fixing screws
h_M8 = 8.4;  // M8 8.6mm

// Link with the upper piece - center + bearing
d_upper = 55; //47;
h_upper = 13; //15.25 + 0.25;

// Big ball bearing (6mm on deph so that the bottom of the bearing is lock)
d_int_bearing = 90-0.1;
d_ext_bearing = 120+0.1;
//h_int_bearing = 22-0.2;  // 0.2mm of space with the middle component
// More space so the the top of the bearing can rotate freely
d_int2_bearing = 90-0.2*2;
d_ext2_bearing = 120+0.2*2;
h_int2_bearing = 22-0.6; //22-0.2-6;  // 0.2mm of space with the middle component

// Link with the upper piece - 3 holes M8
d_upper_M8 = d_M8 + 0.2;  // more than M8
dist_upper_M8 = 79; //75; //70;
angle_upper_M8 = 20;
s = 16.9/cos(30) + 1; // place for the screw

d_lower_part = d_M8 + 2;
h_lower_part = h_M8 + 1.4;
angle_lower_part = 20;

// EQ5/EQ6 support
d_eq6 = 65;
d_eq5 = 60-0.2;  // less than 60mm
h_eq5 = 20;  // less than 20.4mm
h_tread = h_eq5 + h_bottom + 1;

y_pa = 38.30;  // polar alignment adjustment support
d_pa = 8; // M6

x_my_pa = 9+1+1; // My  polar alignment adjustment support
y_my_pa = 11+1;
z_my_pa = 24;

// Avalon T90
h_T90 = h_bottom+1;
d_T90 = d_M8; // M8
y_T90 = 44*sin(30);
x_T90 = 44*cos(30);

// Space between the main body and the gear
d_gear = 140.3;
space = 2;


module engrenage()
{
  difference()
  {
    union()
    {    
      hollowcylindersector(height = space, radius = d_gear/2, angle = 360, intradius = d_gear/2-4);
      translate([0,0,space]) import("gears_104_dents.stl", convexity=4);
      hollowcylindersector(height = 12, radius = (d-20)/2, angle = 360, intradius = (d-20-21)/2);
    }
    
    rotate([0,0,-70]) cube([500,500,20],false);
    rotate([0,0, 70+90]) cube([500,500,20],false);    
    translate([0,250,0]) cube([1000,500,40],true); 
  }
}

module bottom_eq5()
{
  difference()
  {
    union()
    {
      // Main body
      cylinder(h_bottom,d/2,d/2);
      
      // EQ5 adapter
//      translate([0,0,-h_eq5+epsilon]) cylinder(h_eq5,d_eq5/2,d_eq5/2);
      
      // Gear
      translate([0,0,h_bottom-epsilon]) engrenage();   
    }

    // Link with the upper piece + bearing
    translate([0,0,h_bottom-h_upper+epsilon]) cylinder(h_upper,d_upper/2,d_upper/2);
    
    // Link with the upper piece - 3 holes M8
    for (nb =[-50:50])
      rotate([0,0,angle_lower_part*nb/50])
      {
      translate([0,dist_upper_M8,-h_bottom+epsilon]) cylinder(2*h_bottom,d_upper_M8/2,d_upper_M8/2);
      translate([dist_upper_M8*cos(angle_upper_M8),-dist_upper_M8*sin(angle_upper_M8),-h_bottom+epsilon]) cylinder(2*h_bottom,d_upper_M8/2,d_upper_M8/2);
      translate([-dist_upper_M8*cos(angle_upper_M8),-dist_upper_M8*sin(angle_upper_M8),-h_bottom+epsilon]) cylinder(2*h_bottom,d_upper_M8/2,d_upper_M8/2);
      }          
      
    for (nb =[-50:50])
      rotate([0,0,angle_lower_part*nb/50])
      {
        translate([0,dist_upper_M8+5,-epsilon]) cylinder(h_lower_part,s/2+5,s/2+5);
        translate([(dist_upper_M8+5)*cos(angle_upper_M8),-dist_upper_M8*sin(angle_upper_M8),-epsilon]) cylinder(h_lower_part,s/2+5,s/2+5);       
        translate([-(dist_upper_M8+5)*cos(angle_upper_M8),-dist_upper_M8*sin(angle_upper_M8),-epsilon]) cylinder(h_lower_part,s/2+5,s/2+5);   
      }        
      
         
    // M10 fixing screws
    translate([0,0,-5*h_bottom]) cylinder(10*h_bottom,d_M8/2+1,d_M8/2+1);
    translate([0,0,9]) ISO4032("M10");
    translate([0,0,6]) ISO4032("M10");
    translate([0,0,0]) ISO4032("M10");
    translate([0,0,-epsilon-2]) ISO4032("M10");
    
    // EQ5 : remove material for the polar alignment adjustment support
    //translate([0,y_pa,-h_bottom/2]) cylinder(2*h_bottom,d_pa/2,d_pa/2);
    translate([-x_my_pa/2,d_eq6/2-0.5-0.4,0]) cube(size = [x_my_pa,y_my_pa,h_bottom+0.2], center = false);
    translate([0,d_eq6/2+5,0]) trapeze_form2(15,y_my_pa,15,x_my_pa, 10) ;
    
    // Remove material for the needle bearing
    //translate([0,0,h_bottom-h_int_bearing+epsilon]) hollowcylindersector(h_int_bearing, d_ext_bearing/2, angle=360, d_int_bearing/2, center=false);
    translate([0,0,h_bottom-h_int2_bearing+epsilon]) hollowcylindersector(h_int2_bearing, d_ext2_bearing/2, angle=360, d_int2_bearing/2, center=false);
    
    // Add 3 holes to unlock the main bearing
    for (nb =[-1:1])
      rotate([0,0,120*nb])
      {
      translate([0,(d_ext_bearing+d_int_bearing)/4,0]) hollowcylindersector(50, 6/2, angle=360,0, center=false);
      }     

    // Add 3 holes to lock the EQ5 adapter
    for (nb =[-1:1])
      rotate([0,0,120*nb]) translate([0,d_upper/2-5,0])
      {
       hollowcylindersector(50, 5/2, angle=360,0, center=false);
       translate([0,0,h_bottom-h_upper+epsilon-3.6]) cylinder(3.6,5/2,9.6/2);
      }  
      
    // Add 3 holes to unlock the center bearing
    for (nb =[-1:1])
      rotate([0,0,120*nb+60]) translate([0,d_upper/2,9-3])
      {
       hollowcylindersector(50, 8/2, angle=360,0, center=false);
      } 
      
    // EQ5 adapter
    translate([0,0,-epsilon]) cylinder(3,d_eq5/2,d_eq5/2);      
      
  }
}


bottom_eq5();

