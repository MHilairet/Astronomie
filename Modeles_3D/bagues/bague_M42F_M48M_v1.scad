include <BOLTS/BOLTS.scad>
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

use <threads.scad>
use <my_function.scad>

$fn=360;
epsilon=0.01;

// M48
diameter_M48 = 48;

// M42
diameter_M42 = 42;
diameter_int_M42 = 36;

profondeur_file_M48M=4;
epaisseur_gorge=0;
pas=0.75;

epaisseur_piece=16.5;
profondeur_file_M42F = 6;


module baguue_M42F_M48M()
{
  difference()
  {
    union()
    {
      translate([0,0,epaisseur_piece-epsilon]) metric_thread(diameter_M48-0.05,pas,profondeur_file_M48M);
      // gorge
    //  translate([0,0,-epaisseur_gorge]) cylinder(epaisseur_gorge,d=40.7); 
      // Ajout d'un cylindre de diamètre 43mm
      cylinder(epaisseur_piece,(diameter_M42+2.5)/2,(diameter_M48+2.5)/2);
      
          //
    for (nb =[0:9])
    rotate([0,0,360*nb/10])
    {
      hollowcylindersector(epaisseur_piece, (diameter_M48+4)/2, angle=10,0, center=false);
    }  
    
    }
    
    // trou central
    translate([0,0,-epaisseur_piece/2]) cylinder(2*epaisseur_piece,d=diameter_int_M42); 
    
        // Filetage M42F
    translate([0,0,-epsilon]) metric_thread(diameter_M42+0.35,pas,profondeur_file_M42F,internal=true);
  }
}
   
baguue_M42F_M48M();
