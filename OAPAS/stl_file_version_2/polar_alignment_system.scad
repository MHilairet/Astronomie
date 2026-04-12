$fn=360;
epsilon=0.01;

use <my_function.scad>
use <bottom_eq5.scad>
use <middle.scad>
use <nema11_stepper_plate.scad>
use <nema14_stepper_plate.scad>
use <nema14_stepper_plate_v2.scad>
use <top_eq5.scad>

use <threads.scad>
use <BOSL/nema_steppers.scad>

l_support = 155; //140;
d_M8 = 8.0;

h_support = 80; //70;
h = 3;    // height
d1_gear_top = 20;   // Distance between the M8 hole and the top plate
d3_top = 9;         // space between the top plate and top middle

module polar_alignement_system()
{
  // Bottom
  h_bottom = 25;
  color("red") translate([0,0,-h_bottom]) bottom_eq5();
  
  // Middle
  middle();
  
  // Nema 14
  d6_nema14 = 24; // motor axe lenght
  z_motor_plate = 4;
  shift_y_motor_plate = 0;
  shift_z_motor_plate = 2 + d6_nema14 - z_motor_plate - 7;  // 2mm is the piece just under the gear
  shift_y_motor_plate_2 = -60;
  d = 160;  // Diameter
  difference()
  {  
    translate([0,shift_y_motor_plate_2,shift_z_motor_plate]) nema14_stepper_plate_v2();

    hollowcylindersector(height = 100, radius = 100, angle = 360, intradius = d/2);
  }

  // Nema 11
  h = 10;    // height
  z_motor_plate_nema11 = 28;
  translate([-23.5,10.5-2,h]) rotate([0,0,0]) nema11_stepper_plate();       

  // Top
  color("blue") translate([0,(l_support/2-2*d_M8)-10,(h+h_support+d3_top)-d1_gear_top]) top();
  


}

polar_alignement_system();