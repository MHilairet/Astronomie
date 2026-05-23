$fn=360;
epsilon=0.01;

use <threads.scad>


d_ext = 46;
d_int = 20;
d_notch = 41.9;
d_end = 42.3;
d_see_nust = 30;

h = 23;
h1_1 = 2;
h1_2 = 9.05-h1_1;
h2 = 3.1;
h3 = h-h1_1-h1_2-h2;

// 3 holes
d_pos_hole = 40;
d_hole = 3; // M3
angle_hole = 15;
pas = 1.5;
h_hole = 8;

//------------------------------------------------------------------
// cylindre
//------------------------------------------------------------------
module hollowcylindersector(height, radius, angle=360, intradius=0, center=false)
{
  translate ([0, 0, center?(-height/2):0])
    rotate (center?(-angle/2):0, [0, 0, 1])
      rotate_extrude(angle = angle, convexity = 2)
        polygon([[intradius, 0],[intradius, height],[radius, height],[radius, 0]]);
}

//---------------------------------------------------------------
// Polemaster adaptatrr
module adapter()
{
  render(convexity = 2) difference()
  { 
    union() 
    {
      // main body
      cylinder(h3,d_ext/2,d_ext/2);
      
      // Notch
      translate([0,0,-h2+epsilon]) cylinder(h2,d_notch/2,d_notch/2);
      
      // 
      translate([0,0,-h2-h1_2+epsilon]) cylinder(h1_2,d_ext/2,d_end/2);
      translate([0,0,-h2-h1_2-h1_1+epsilon]) cylinder(h1_1,d_ext/2,d_ext/2);
      
    }   
  
    // Interior hole
    //translate([0,0,-20]) cylinder(h+10,d_int/2,d_int/2);
    
    // 3 holes to connect the polemaster
    rotate([0,0,angle_hole]) translate([0,d_pos_hole/2,h3/2-2]) metric_thread (diameter=d_hole, pitch=pas, length=h_hole+1); 
    rotate([0,0,angle_hole+120]) translate([0,d_pos_hole/2,h3/2-2]) metric_thread (diameter=d_hole, pitch=pas, length=h_hole+1);
    rotate([0,0,angle_hole+240]) translate([0,d_pos_hole/2,h3/2-2]) metric_thread (diameter=d_hole, pitch=pas, length=h_hole+1);
    
    //
    hollowcylindersector(height = h3/2, radius = d_ext/2, angle = 360, intradius = d_see_nust/2);
    
  }
}    

adapter();