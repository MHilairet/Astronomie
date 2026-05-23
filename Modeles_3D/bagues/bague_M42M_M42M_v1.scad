include <BOLTS/BOLTS.scad>
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

use <threads.scad>
use <my_function.scad>

$fn=360;
epsilon=0.01;

// M42
diameter_M42 = 42;
diameter_int_M42 = 36;

pas=0.75;

epaisseur_piece=2;
profondeur_file_M42M = 3;


module baguue_M42M_M42M()
{
  difference()
  {
    union()
    {
      // M42M
      metric_thread(diameter_M42-0.05,pas,profondeur_file_M42M);
  
      // Ajout d'un cylindre de diamètre 43mm
      translate([0,0,profondeur_file_M42M-epsilon]) cylinder(epaisseur_piece,(diameter_M42+2.5)/2,(diameter_M42+2.5)/2);
      
      // Ajout grip
      for (nb =[0:9])
      rotate([0,0,360*nb/10])
      {
        translate([0,0,profondeur_file_M42M-epsilon]) hollowcylindersector(epaisseur_piece, (diameter_M42+8)/2, angle=10,0, center=false);
      }  
      
      // M42M
      translate([0,0,profondeur_file_M42M+epaisseur_piece-epsilon]) metric_thread(diameter_M42-0.05,pas,profondeur_file_M42M);      
    
    }
    
    // trou central
    translate([0,0,-1]) cylinder(10,d=diameter_int_M42);
  }
}
   
baguue_M42M_M42M();
