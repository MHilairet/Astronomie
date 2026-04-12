$fn=360;
epsilon=0.01;


use <my_function.scad>
use <threads.scad>

// main body
d = 180;  // Diameter

l_support = 140;
h_support = 70;

// gear_top module
d_gear_top = 97.8;  // Diameter of the gear (fond encoche) - use to remove material
e_gear_top = 10;
d1_gear_top = 20;   // Distance between the M8 hole and the top plate
d2_gear_top = 10;   // Shift of the triangle near the gear

// Position of the two gears
d_top  = 95;   // Space between the two vertical plate of the middle piece
d1_top = 1 ;   // Space bewteen the top and middle pieces (near ball bearing)
d2_top = d_top - 2*e_gear_top - 2*d1_top;


// Top plate
h_top = 10;

y_pa = 38.30;  // polar alignment adjustment support

// EQ5/EQ6 support
d_eq6 = 65;
h_eq6 = 5+0.2;
d_eq6_hole = 12.5;
d_eq5 = 60+0.2;  // 60mm
h_eq5 = 20+1;  //  20.4mm
e_eq5_eq6_support_z = 5;
e_eq5_eq6_support_xy = 7;


// M8
tread_M8 = 1.25;
d_M8 = 8.0; // fixing screws
h_M8 = 8.4;  // M8 8.6mm

// M6 (for the support of the polar alignment)
tread_M6 = 1.0;
d_M6 = 10+0.2; // fixing screws
h_M6 = 10.2;     //

// Ball bearing hole
d_M24 = 24;

radius_lock_EQ = 35;


// One gear + triangle
module gear_top()
{     
   difference()
   {   
    union()
    {   
      // 110 teeths gear
      //rotate([0,90,0]) import("gears_110_dents.stl");
      rotate([0,90,0]) import("gears_126_dents.stl");
          
      // Prism near the gear
      l_prism_top = e_gear_top;
      w_prism_top = 40;
      h_prism_top = 110; //100;       
      //rotate([90,0,0]) translate([0,-w_prism_top+d1_gear_top,d2_gear_top]) triangle(l=l_prism_top, w=w_prism_top, h=h_prism_top);    
      rotate([90,0,0]) translate([0,-w_prism_top+d1_gear_top,d2_gear_top])  cube([l_prism_top,w_prism_top,h_prism_top],false);
    }
    
    // Remove material at the top
    translate([0,-1.2*d_gear_top/2,d1_gear_top]) cube([e_gear_top, 1.2*d_gear_top,1.2*d_gear_top],false);
    // Remove material on the back
    translate([0,d1_gear_top,-1.3*d_gear_top/2]) cube([e_gear_top, 1.2*d_gear_top,1.4*d_gear_top],false);
    
    // Ball bearing hole
    rotate([0,90,0]) cylinder(e_gear_top-2,d_M24/2,d_M24/2);    
    rotate([0,90,0]) cylinder(2*e_gear_top+10,(d_M24-2*2)/2,(d_M24-2*2)/2);  
    
    // Hole to lock the top plate
    for (nb =[-50:50])
      rotate([7*nb/50,0,0])
      {
        #translate([-5,-98,0]) rotate([0,90,0]) cylinder(20,d_M8/2,d_M8/2);
      }    
    // Hole to lock the top plate in EQ mode
    for (nb =[-50:50])
      rotate([30*nb/50+47,0,0])
      {
        #translate([-5,-radius_lock_EQ,0]) rotate([0,90,0]) cylinder(20,d_M8/2,d_M8/2);
      }     
  }
}


// One gear + triangle
module gear_top_ypositif()
{     
   difference()
   {   
    union()
    {   
      // Prism near the gear
      l_prism_top = e_gear_top;
      w_prism_top = 40;
      h_prism_top = 110;         
      
      //#translate([0,-10,-20]) cube([e_gear_top,w_prism_top,40],false);
      #translate([0,-10,-35]) cube([e_gear_top,w_prism_top,55],false);
      
      //rotate([90,0,0]) translate([0,-w_prism_top+d1_gear_top,d2_gear_top]) triangle(l=l_prism_top, w=w_prism_top, h=h_prism_top);
    rotate([90,0,0]) translate([0,-w_prism_top+d1_gear_top,d2_gear_top]) cube([l_prism_top,w_prism_top,h_prism_top],false); 

    rotate([-70,0,0]) rotate([0,90,0]) hollowcylindersector(e_gear_top, radius_lock_EQ + 10, angle=100, intradius=0, center=false);

    
    }
    
    // Remove material at the top
    translate([0,-1.2*d_gear_top/2,d1_gear_top]) cube([e_gear_top, 1.2*d_gear_top,1.2*d_gear_top],false);
    // Remove material on the back
    translate([0,d1_gear_top,-1.2*d_gear_top/2]) cube([e_gear_top, 1.2*d_gear_top,1.2*d_gear_top],false);

    // Ball bearing hole    
    rotate([0,90,0]) translate([0,0,2]) cylinder(e_gear_top-2,d_M24/2,d_M24/2);  
    rotate([0,90,0]) cylinder(2*e_gear_top+10,(d_M24-2*2)/2,(d_M24-2*2)/2); 

    // Hole to lock the top plate in alt-az mode
    for (nb =[-50:50])
      rotate([7*nb/50,0,0])
      {
        #translate([-5,-98,0]) rotate([0,90,0]) cylinder(20,d_M8/2,d_M8/2);
      }     
    // Hole to lock the top plate in EQ mode
    for (nb =[-50:50])
      rotate([30*nb/50+47,0,0])
      {
        #translate([-5,-radius_lock_EQ,0]) rotate([0,90,0]) cylinder(20,d_M8/2,d_M8/2);
      }  
    
  }
}


// Two gears 
module two_gear_top()
{
   difference()
   {   
    union()
    {
      // gear
      //translate([d2_top/2,l_support/2-2*d_M8,h_support-d_M8]) gear_top();
      translate([d2_top/2,0,0]) gear_top_ypositif();
      //translate([-d2_top/2-e_gear_top,l_support/2-2*d_M8,h_support-d_M8]) gear_top();
      translate([-d2_top/2-e_gear_top,0,0]) gear_top();
    }
  
    // Remove material on the left (outside the cylinder)
    translate([0,-l_support/2+2*d_M8,-5*h_support]) hollowcylindersector(height = 10*h_support, radius = 150, angle = 360, intradius = d/2); 
  
  }  
}


// Top part to design the EQ5/EQ6 support
module top_plate()
{
   difference()
   {   
    union()
    {
      // top plate
      cylinder(h_top,d/2,d/2); 
      
      // EQ5-EQ6 material support to design the EQ5/EQ6 hole
      translate([0,0,-(h_eq5+e_eq5_eq6_support_z)+h_top]) 
      cylinder(h_eq5+e_eq5_eq6_support_z,d_eq5/2+e_eq5_eq6_support_xy,d_eq5/2+e_eq5_eq6_support_xy);
    }
  
    // EQ5 support
    //translate([0,0,h+h_support+2+h_top-h_eq5+epsilon])
    translate([0,0,-h_eq5+h_top+epsilon]) cylinder(h_eq5,d_eq5/2,d_eq5/2);  
    // EQ5 : remove material for the polar alignment adjustment support
    translate([0,-y_pa,h_top-h_M6+epsilon]) metric_thread(diameter=d_M6, pitch=tread_M6, length=h_M6); 
    
    // EQ6 support
    translate([0,0,-h_eq6+h_top+epsilon]) cylinder(h_eq6,d_eq6/2,d_eq6/2);      
    // EQ6 central hole
    translate([0,0,-h_eq5+1]) cylinder(20,d_eq6_hole/2,d_eq6_hole/2);  
  } 
}

module top()
{
  two_gear_top();
  translate([0,(-l_support/2+2*d_M8)+10,d1_gear_top]) top_plate();
}

top();
