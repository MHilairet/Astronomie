$fn=360;
epsilon=0.01;

use <my_function.scad>
use <BOSL/nema_steppers.scad>
include <BOLTS/bolts.scad>
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

include <arduino.scad>
unoDimensions = boardDimensions(UNO);


// main body
d = 180;  // Diameter
h = 10; //3;    // height

// M8
tread_M8 = 1.25;
d_M8 = 8.0; // fixing screws
h_M8 = 8.4;  // M8 8.6mm

// M4
d_M4 = 4;

// Link with the upper piece - center + bearing
d_upper = 30; // 47-0.2;
h_upper = 5; //13-0.2; 

// Link with the upper piece - 3 holes M8
d_upper_M8 = d_M8 + 0.2;  // more than M8
dist_upper_M8 = 79; //75; //70;
angle_upper_M8 = 20;

d_lower_part = d_M8 + 2;
h_lower_part = h_M8 + 1.4;
angle_lower_part = 10;

// Support right and left
l_support = 155; //140;
h_support = 80; //70;
e_support = 10; //5; //3;
x_support = 48; //50;

x2_support = 2*x_support-10; // remove material to see the bottom piece
y2_support = 60;

// Motor plate nema 14
x_motor_plate = 2*x_support-e_support-0.2; // a ajuster
y_motor_plate = 35; // a ajuster
//shift_y_motor_plate = 5;
z_motor_plate = 4;

d3_nema14 = 3 + 0.2; // M3
d4_nema14 = 84; // x - Distance between two holes for connextion
d5_nema14 = 10; // y - Distance between two holes for connextion
d6_nema14 = 24; // motor axe lenght

shift_y_motor_plate = 0;
shift_z_motor_plate = 2 + d6_nema14 - z_motor_plate;  // 2mm is the piece just under the gear
shift_y_motor_plate_2 = -60;

d2_nema11 = 22*cos(45);  // Distance between two nema 11 holes 22mm
d3_nema11 = 3 + 0.2; // M3
d4_nema11 = 16; //14.5+0.15*2;  // More than 15 to introduce the small gear

decalage = -10;

radius_lock_EQ = 35;


module middle()
{
  difference()
  {
    union()
    {
      // Main body
      cylinder(h,d/2,d/2);
      
      // Support right + reinforcement at the base 
      translate([x_support-0*e_support/2,-l_support/2,h-epsilon]) cube([e_support,l_support,h_support],false);  
      translate([x_support+e_support+5-epsilon,-l_support/2,h-epsilon]) rotate([0,0,90]) triangle(l_support, 5, 5);
      translate([x_support+e_support+10-epsilon,18,h-epsilon]) rotate([0,0,90]) triangle(52, 10, 35);
      
      translate([x_support-e_support+5+epsilon,l_support/2,h-epsilon]) rotate([0,0,-90]) triangle(l_support, 5, 5);
      
      // Support left, near motor and gear
      translate([-x_support-e_support,-l_support/2,h-epsilon]) cube([e_support,l_support,h_support],false);  
      translate([-x_support-e_support-5+epsilon,l_support/2,h-epsilon]) rotate([0,0,-90]) triangle(l_support, 5, 5);
      //translate([-x_support-e_support-10+epsilon,l_support/2-8.5,h-epsilon]) rotate([0,0,-90]) triangle(10, 10, 35);
      translate([-x_support-e_support-20+epsilon,-l_support/2+69,h-epsilon]) rotate([0,0,-90]) triangle(9, 20, 35);
      
      translate([-x_support+2-epsilon,-l_support/2,h-epsilon]) rotate([0,0,90]) triangle(l_support, 2,2);
            
      // Plate for the connexion of the nema 11 plate
      translate([-27.5+1,10.5-2,0])  difference()
      {
        // Nema 11
        x_motor_plate_nema11 = 4+2;
        y_motor_plate_nema11 = 70;
        z_motor_plate_nema11 = 28;

        translate([0,0,h+z_motor_plate_nema11/2])  
        cube([x_motor_plate_nema11,y_motor_plate_nema11,z_motor_plate_nema11],true);   
        
        // Centrale hole to place the shaft of the nema11
        for (nb =[-10:10])
        {  
          translate([-x_motor_plate,5*nb/10,h+z_motor_plate_nema11/2]) rotate([0,90,0]) cylinder(2*x_motor_plate,22/2,22/2);   
        } 
        
        // four holes to tune the position of the nema11 motor plate
        move = 12;
        translate([-z_motor_plate,0,h+z_motor_plate_nema11/2])
        rotate([0,90,0])
        {
            translate([ d2_nema11/2, d2_nema11/2+move,0]) cylinder(2*z_motor_plate,d3_nema11/2,d3_nema11/2);    
            translate([-d2_nema11/2, d2_nema11/2+move,0]) cylinder(2*z_motor_plate,d3_nema11/2,d3_nema11/2); 
            translate([ d2_nema11/2,-d2_nema11/2-move,0]) cylinder(2*z_motor_plate,d3_nema11/2,d3_nema11/2); 
            translate([-d2_nema11/2,-d2_nema11/2-move,0]) cylinder(2*z_motor_plate,d3_nema11/2,d3_nema11/2); 
        }
      }
      
      // Reinforcement of the nema plate
      translate([-32.5+epsilon,45.5-2,h-epsilon]) rotate([0,0,-90]) triangle(70, 3, 3);
      translate([-34.5+epsilon,45.5-2,h-epsilon]) rotate([0,0,-90]) triangle(5, 5, 28);
      translate([-54.5+epsilon,45.5-70-2,h-epsilon]) cube([25,5,28],false);
      
      // Add support for the Arduino UNO board
      #translate([-58+epsilon,62,70]) rotate([180,90,0]) bumper(UNO);
      
      
      
//UNO      translate([47.5,20,h-epsilon]) rotate([0,0,90]) bumper(UNO);
      //Board mockups
//UNO      translate([47.5,20,h+4.2]) rotate([0,0,90]) arduino();
//UNO     #translate([0,79,h]) rotate([0,0,0]) cylinder(4.2,15/2,15/2); 
      
    }

    // Remove material to see the connector of the Arduino UNO
//UNO     translate([47,27.0,h+4]) cube([20,12+5,11+5],false); 
//UNO     translate([47,65.5,h+12]) rotate([0,90,0]) cylinder(20,11/2,11/2); 
        
    // Remove materials of the 2 support outside the cycle 
    translate([0,0,-12]) hollowcylindersector(height = 10*z_motor_plate, radius = 100, angle = 360, intradius = d/2);
    
    // Link with the upper piece - 3 holes M8
    translate([0,dist_upper_M8,-h+epsilon+6]) cylinder(2*h,d_upper_M8/2,d_upper_M8/2);
    translate([dist_upper_M8*cos(angle_upper_M8),-dist_upper_M8*sin(angle_upper_M8),-h+epsilon]) cylinder(2*h,d_upper_M8/2,d_upper_M8/2);
    translate([-dist_upper_M8*cos(angle_upper_M8),-dist_upper_M8*sin(angle_upper_M8),-h+epsilon]) cylinder(2*h,d_upper_M8/2,d_upper_M8/2);   
    
    // Remove material to see the bottom piece
    translate([-x2_support/2,-100,0]) cube([x2_support,y2_support,2*h],false);
    
    // To remove material out side the circle of 180mm
    translate([0,0,-12]) hollowcylindersector(height = 2*h_support, radius = 120, angle = 360, intradius = d/2);
    
    // Two holes to maintain the top piece
    translate([-1.5*x_support,l_support/2-2*d_M8+decalage,h-3+h_support-d_M8]) rotate([0,90,0]) cylinder(3*x_support,d_M8/2,d_M8/2);
    
    // Same holes to lock the top plate in alt-az mode
    translate([-1.5*x_support,-(l_support/2-2*d_M8)+15,h-3+h_support-d_M8]) rotate([0,90,0]) cylinder(3*x_support,d_M8/2,d_M8/2);  
    //translate([x_support+e_support-6.5+epsilon,-(l_support/2-2*d_M8)+15,h-3+h_support-d_M8]) rotate([0,90,0]) ISO4032("M8");
    
    // Same holes to lock the top plate in EQ mode
    translate([-1.5*x_support,l_support/2-2*d_M8+decalage - radius_lock_EQ+15,h-3+h_support-d_M8]) rotate([0,90,0]) cylinder(3*x_support,d_M8/2,d_M8/2);  
    //translate([x_support+e_support-6.5+epsilon,l_support/2-2*d_M8+decalage - radius_lock_EQ+15,h-3+h_support-d_M8]) rotate([0,90,0]) ISO4032("M8");
    
    // Remove material to place the mena motor
    y_nema11_hole = 28+10+3;
    z_nema11_hole = 28+7;    
    #translate([25,-10-3-2,h]) cube([10*e_support,y_nema11_hole,z_nema11_hole],false);  
  
    // Remove materail to place the cylinder to connect with the bottom part
    translate([0,0,-epsilon]) cylinder(h_upper,d_upper/2,d_upper/2);  
    // Add 3 holes M4
    for (nb =[-1:1])
      rotate([0,0,120*nb])
      {
        translate([0,d_upper/4,0]) cylinder(2*h,d_M4/2,d_M4/2);
        translate([0,d_upper/4,h-3.4+epsilon]) cylinder(3.4,4/2,8/2);
      }   
    
    // 4 holes to maintain the nema 14 support plate
    #translate([40,15/2-l_support/2+8.41,h+16]) rotate([0,90,0]) cylinder(20,d_M4/2,d_M4/2);
    translate([40,15/2-l_support/2+8.41+15.5,h+16]) rotate([0,90,0]) cylinder(20,d_M4/2,d_M4/2);
    translate([-60,15/2-l_support/2+8.41,h+16]) rotate([0,90,0]) cylinder(20,d_M4/2,d_M4/2);
    translate([-60,15/2-l_support/2+8.41+15.5,h+16]) rotate([0,90,0]) cylinder(20,d_M4/2,d_M4/2);    
  }
}


middle();
