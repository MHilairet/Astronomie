use <my_function.scad>

$fn=360;
epsilon=0.01;


module capuchon()
{
  difference()
  {
    //translate([-d_ext/2,-d_ext/2,-e+e1])
    import("LunetteBouchonAvant.stl", convexity=3);
      
    // Cylindre afin de supprimer la matière - dessous
    //translate([0,0,-2]) cylinder(8,d=56);
    translate([0,0,-2]) cylinder(8,d=63);
  }
}

module bhatinov_fs60()
{
    
  difference()
  {
    translate([-5,-4,0]) import("FS60_Bahtinov.stl", convexity=3);
      
    translate([0,0,-2]) 
    //hollowcylindersector(height=20, radius=200, angle=360, intradius=58/2, center=false);
    hollowcylindersector(height=20, radius=200, angle=360, intradius=64/2, center=false);
  }
}

module bhatinov_diy_60()
{
 union()
 {
   capuchon();
   bhatinov_fs60();
 }
}

bhatinov_diy_60();