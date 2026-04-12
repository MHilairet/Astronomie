$fn=360;
epsilon=0.01;

use <gear_14_teeths_shaft6mm.scad>

use <my_function.scad>
use <BOSL/nema_steppers.scad>


// Nema 11
x_motor_plate_nema11 = 4;
y_motor_plate_nema11 = 70;
z_motor_plate_nema11 = 28;

d2_nema11 = 22*cos(45);  // Distance between two nema 11 holes 22mm
d3_nema11 = 3 + 0.2; // M3
d4_nema11 = 17.2; // > 16.95mm
shaft_diameter_nema11 = 6+0.2;
shaft_len_nema11 = 20;
//shift_shaft_len_nema11 = 5;

d_nema11_shift = 12;
d_nema11 = 8;    

module nema11_stepper_plate()
{
  difference()
  { 
    union()
    {
      // Plate
      color("red") translate([x_motor_plate_nema11/2,0,z_motor_plate_nema11/2])  
      cube([x_motor_plate_nema11,y_motor_plate_nema11,z_motor_plate_nema11],true);   
          
      // Nema 11, 
      translate([x_motor_plate_nema11,0,z_motor_plate_nema11/2]) rotate([0,-90,0]) nema11_stepper(h=40.1+31.5, shaft=shaft_diameter_nema11, shaft_len=shaft_len_nema11);
      
      // 14 teeths gear 
      translate([-21-2,0,z_motor_plate_nema11/2]) rotate([0,90,0]) gear_14_teeths_shaft6mm();    
    }
 
    // Centrale hole
    translate([-epsilon,0,z_motor_plate_nema11/2]) rotate([0,90,0]) cylinder(2*x_motor_plate_nema11,d4_nema11/2,d4_nema11/2); 
        
    // four motor holes
    rotate([0,90,0]) translate([-z_motor_plate_nema11/2,0,0])
    {
      translate([ d2_nema11/2, d2_nema11/2,0]) cylinder(2*x_motor_plate_nema11,d3_nema11/2,d3_nema11/2);   
      translate([-d2_nema11/2, d2_nema11/2,0]) cylinder(2*x_motor_plate_nema11,d3_nema11/2,d3_nema11/2); 
      translate([ d2_nema11/2,-d2_nema11/2,0]) cylinder(2*x_motor_plate_nema11,d3_nema11/2,d3_nema11/2); 
      translate([-d2_nema11/2,-d2_nema11/2,0]) cylinder(2*x_motor_plate_nema11,d3_nema11/2,d3_nema11/2); 
    }

    // four conical head screw
    rotate([0,90,0]) translate([-z_motor_plate_nema11/2,0,0])
    {
      translate([ d2_nema11/2, d2_nema11/2,0]) cylinder(1.4,6/2,d3_nema11/2);    
      translate([-d2_nema11/2, d2_nema11/2,0]) cylinder(1.4,6/2,d3_nema11/2); 
      translate([ d2_nema11/2,-d2_nema11/2,0]) cylinder(1.4,6/2,d3_nema11/2); 
      translate([-d2_nema11/2,-d2_nema11/2,0]) cylinder(1.4,6/2,d3_nema11/2); 
    }    
      
    // four holes to tune the position of the nema17 motor plate
    for (nb =[-10:10])
    {
      rotate([0,90,0]) translate([-z_motor_plate_nema11/2,0,0])
      {
        translate([ d2_nema11/2, d2_nema11/2+d_nema11_shift+d_nema11*nb/20,0]) cylinder(2*x_motor_plate_nema11,d3_nema11/2,d3_nema11/2); 
        translate([-d2_nema11/2, d2_nema11/2+d_nema11_shift+d_nema11*nb/20,0]) cylinder(2*x_motor_plate_nema11,d3_nema11/2,d3_nema11/2);  
        translate([ d2_nema11/2,-d2_nema11/2-d_nema11_shift+d_nema11*nb/20,0]) cylinder(2*x_motor_plate_nema11,d3_nema11/2,d3_nema11/2);  
        translate([-d2_nema11/2,-d2_nema11/2-d_nema11_shift+d_nema11*nb/20,0]) cylinder(2*x_motor_plate_nema11,d3_nema11/2,d3_nema11/2);           
      }
    }
 
  }
}

nema11_stepper_plate();