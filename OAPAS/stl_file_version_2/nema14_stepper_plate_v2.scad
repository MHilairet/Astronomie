$fn=360;
epsilon=0.01;

use <gear_14_teeths_shaft5mm.scad>

use <my_function.scad>
use <BOSL/nema_steppers.scad>

dessus = 1;
cote = 1;

// main body
d = 160;  // Diameter
e_support = 5; //3;
x_support = 50;


//// Motor plate nema 14
x_motor_plate = 2*x_support-e_support-0.2; // a ajuster
y_motor_plate = 35; // a ajuster
//shift_y_motor_plate = 5;
z_motor_plate = 4;
z2_motor_plate = 16-4;


d1_nema14 = 22 + 2;  // hole for the motor
d2_nema14 = 26;  // Distance between two nema 14 holes
d3_nema14 = 3 + 0.2; // M3

d4_nema14 = 84; // x - Distance between two holes for connextion
d5_nema14 = 10; // y - Distance between two holes for connextion
d7_nema14 = 10; // Possible movment of the motor plate

d6_nema14 = 24; // motor axe lenght

// M4
d_M4 = 4;

          
module nema14_stepper_plate()
{
  difference()
  {
    // Plate
    translate([0,0,z2_motor_plate+z_motor_plate/2-epsilon])  cube([x_motor_plate,y_motor_plate,z_motor_plate],true);   
      
    // Centrale hole
    translate([0,0,z2_motor_plate-z_motor_plate/2]) cylinder(2*z_motor_plate,d1_nema14/2,d1_nema14/2);     
      
    // four motor holes
    translate([ d2_nema14/2, d2_nema14/2,z2_motor_plate-z_motor_plate/2]) cylinder(2*z_motor_plate,d3_nema14/2,d3_nema14/2);    
    translate([-d2_nema14/2, d2_nema14/2,z2_motor_plate-z_motor_plate/2]) cylinder(2*z_motor_plate,d3_nema14/2,d3_nema14/2); 
    translate([ d2_nema14/2,-d2_nema14/2,z2_motor_plate-z_motor_plate/2]) cylinder(2*z_motor_plate,d3_nema14/2,d3_nema14/2); 
    translate([-d2_nema14/2,-d2_nema14/2,z2_motor_plate-z_motor_plate/2]) cylinder(2*z_motor_plate,d3_nema14/2,d3_nema14/2);  
 
    // Lateral holes
    for (nb =[-20:20])
    {  
      translate([30,8*nb/20,10]) cylinder(10,d_M4/2,d_M4/2); 
      translate([-30,8*nb/20,10]) cylinder(10,d_M4/2,d_M4/2); 
    }        
  }
}

module nema14_stepper_plate_support()
{
  difference()
  {
    union()
    {
      // Plate
      translate([0,0,z2_motor_plate+z_motor_plate/2-epsilon])  cube([x_motor_plate,y_motor_plate,z_motor_plate],true);   
        
      // Right
      translate([x_motor_plate/2-z_motor_plate/2,0,z2_motor_plate/2])  cube([z_motor_plate,y_motor_plate,z2_motor_plate],true);
    translate([-x_motor_plate/2+z_motor_plate-epsilon,-y_motor_plate/2,z2_motor_plate-5+epsilon]) rotate([90,0,90]) triangle(y_motor_plate, 5, 5);
      
      // Left
      translate([-(x_motor_plate/2-z_motor_plate/2),0,z2_motor_plate/2])  cube([z_motor_plate,y_motor_plate,z2_motor_plate],true);
      translate([x_motor_plate/2-z_motor_plate+epsilon,y_motor_plate/2,z2_motor_plate-5+epsilon]) rotate([90,0,-90]) triangle(y_motor_plate, 5, 5);       
    }    
   
    // Supress material at the center to split the support intro 2 pieces
    translate([0,0,z2_motor_plate+z_motor_plate/2-epsilon])  cube([40,y_motor_plate,z_motor_plate],true);  
   
    // Lateral holes
    decalage = 5;
    decalage2 = 7;
    for (nb =[-20:20])
    {  
      translate([ 40,y_motor_plate/4+decalage,(z_motor_plate+z2_motor_plate)/2+4*nb/20-1]) rotate([0,90,0]) cylinder(10,d_M4/2,d_M4/2); 
      translate([ 40,-y_motor_plate/4+decalage2,(z_motor_plate+z2_motor_plate)/2+4*nb/20-1]) rotate([0,90,0]) cylinder(10,d_M4/2,d_M4/2);  
      translate([-50,y_motor_plate/4+decalage,(z_motor_plate+z2_motor_plate)/2+4*nb/20-1]) rotate([0,90,0]) cylinder(10,d_M4/2,d_M4/2); 
      translate([-50,-y_motor_plate/4+decalage2,(z_motor_plate+z2_motor_plate)/2+4*nb/20-1]) rotate([0,90,0]) cylinder(10,d_M4/2,d_M4/2);       
    }    
    for (nb =[0:10])
    { 
      translate([ 38.4,y_motor_plate/4+decalage,(z_motor_plate+z2_motor_plate)/2+4-1-5*nb/10]) rotate([0,90,0]) cylinder(5,8/2,8/2);
      translate([ 38.4,-y_motor_plate/4+decalage2,(z_motor_plate+z2_motor_plate)/2+4-1-5*nb/10]) rotate([0,90,0]) cylinder(5,8/2,8/2);    
      translate([-43.4,y_motor_plate/4+decalage,(z_motor_plate+z2_motor_plate)/2+4-1-5*nb/10]) rotate([0,90,0]) cylinder(5,8/2,8/2);
      translate([-43.4,-y_motor_plate/4+decalage2,(z_motor_plate+z2_motor_plate)/2+4-1-5*nb/10]) rotate([0,90,0]) cylinder(5,8/2,8/2);     
    }  

    // Two holes
      translate([30,0,10]) cylinder(10,d_M4/2,d_M4/2); 
      translate([-30,0,10]) cylinder(10,d_M4/2,d_M4/2);        
        
    
 }
}  
    

module nema14_stepper_plate_v2()
{    
  translate([0,0,z_motor_plate]) color("blue") nema14_stepper_plate();
  nema14_stepper_plate_support();
}

nema14_stepper_plate_v2();