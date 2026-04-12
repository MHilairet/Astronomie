// gear 14 with attach to the nema motor

$fn=360;
epsilon=0.01;

use <my_function.scad>
use <threads.scad>
use <BOSL/nema_steppers.scad>

d_M3 = 7;
tread_M3 = 0.7;

d_M4 = 4.2-0.2;
tread_M4 = 0.7;

shaft_diameter = 6 + 0.2;   // 6 mm

module gear_14_teeths_shaft6mm()
{
  difference()
  {
    union()
    {
      // gear
      // translate([-83,0,0]) import("gears_14_dents.stl");
      translate([-83,0,10]) rotate([180,0,0]) import("gears_14_dents.stl");

      // Link gear to motor
      hollowcylindersector(height = 20, radius = 5.7, angle = 360, intradius = 0);  
    
      //
      #translate([0,8,15.1]) rotate([90,0,0]) hollowcylindersector(height = 5, radius = 4.9, angle = 360, intradius = 0); 
    
    }
  
    // Hole for the shaft of the motor 
    difference()
    {
      hollowcylindersector(height = 20, radius = shaft_diameter/2, angle = 360, intradius = 0);
      translate([-5,2+0.35,0])  cube([10,10,20],false); // nema 11
    }
    
    // M3
    rotate([90,0,180])translate([0,15,2]) metric_thread(diameter=d_M4, pitch=tread_M4, length=20); 
  
  }
  
}

gear_14_teeths_shaft6mm();