$fn=360;
epsilon=0.01;

use <my_function.scad>
use <threads.scad>
include <BOLTS/bolts.scad>
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

h = 5;
l= 36;
L = 60;

h_cercle = 6;
rayon = 230/2;
alpha = 360;

// Trou central
diametre = 5.3;

// Trou en longeur
d1 = 6.35;
l1 = 15.5 - d1;
decalage1 = diametre/2 + 8 + d1/2;

e = 2;
d2 = d1+2*e;
l2 = 19.5-d2;
h2 = 2.7;
decalage2 = decalage1;

h_top = 10;


module C8_mini_Vixen_dessous()
{
  difference()
  {
    union()
    {
      //  Base
      translate([0,-L/2,0]) cube([l,L,h],false);
      
      // Support rond C8
      translate([0,0,-rayon]) rotate([0,90,0]) hollowcylindersector(height = l, radius = rayon+h_cercle, angle = alpha, intradius = rayon);
    }
    
    // Suppression arrondi sur le dessus
    translate([0,-L/2,h]) cube([l,L,h],false);    
  
    // Pour faire l'arrondi
    translate([l/2,0,-50]) hollowcylindersector(height = 100, radius = 10*L/2, angle = 360, intradius = L/2);
    // Pour faire le petit meplat en dessous
    translate([0,-1.5*rayon,-3*rayon-3.5]) cube([l,3*rayon,3*rayon],false);
    
    // Trou central
    translate([l/2,0,-50]) cylinder(100,diametre/2,diametre/2);
    // Biseau
    translate([l/2,0,3]) cylinder(2,2,13/2);    
    
    // Trou en longeur
    for (nb =[0:50])
    {
      translate([l/2,decalage1+l1*nb/50,-10]) cylinder(20,d1/2,d1/2);
      translate([l/2,-(decalage1+l1*nb/50),-10]) cylinder(20,d1/2,d1/2);
    }
    for (nb =[0:50])
    {
      translate([l/2,decalage2+l2*nb/50,h-h2]) cylinder(h2,d2/2,d2/2);
      translate([l/2,-(decalage2+l2*nb/50),h-h2]) cylinder(h2,d2/2,d2/2);
    }      
  }
}


module C8_mini_Vixen_dessus()
{
  difference()
  {
    // dessus
    cylinder(h_top,L/2,L/2); 
  
    // Couper le cercle sur la partie haute et basse
    translate([l/2,-L,-h_top/2]) cube([2*L, 2*L,2*h_top],false);
    translate([-2*L-l/2,-L,-h_top/2]) cube([2*L, 2*L,2*h_top],false);

    // Couper le cercle sur la partie droite
    translate([-L/2,L/2-6,0]) cube([L,L,h_top],false);

    // Couper le cercle sur la partie centrale gauche-droite
    translate([-5,-L,0]) cube([10,2*L,h_top],false);
   
    // Forme mini Vixen
    w = 35/2;
    h = 33;
    translate([-l/2,-w,0]) triangle(l, w, h);
    translate([l/2,w,0]) rotate([0,0,-180]) triangle(l, w, h);
    
    // Trou vis M4
    tread_M4 = 0.4;
    d_M4 = 3.98; // fixing screws
    h_M4 = 20;
    translate([(10+13)/2,30,h_top/2]) rotate([90,0,0])  metric_thread(diameter=d_M4, pitch=tread_M4, length=h_M4);   
    translate([-(10+13)/2,30,h_top/2]) rotate([90,0,0])  metric_thread(diameter=d_M4, pitch=tread_M4, length=h_M4);
    
  }
}


module C8_mini_Vixen()
{
  C8_mini_Vixen_dessous();
  translate([l/2,0,h]) C8_mini_Vixen_dessus();
}

C8_mini_Vixen();  
  
  