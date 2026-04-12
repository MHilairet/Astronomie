$fn=360;
epsilon=0.01;

// Link with the upper piece - center + bearing
d_upper = 30-0.2; // 47-0.2;
h_upper = 5+13-0.2; //15.25 - 0.25;

// M4
d_M4 = 4;


module link_middle_buttom()
{
  difference()
  {
    cylinder(h_upper,d_upper/2,d_upper/2);
  
    // Add 3 holes M4
    for (nb =[-1:1])
      rotate([0,0,120*nb])
      {
        translate([0,d_upper/4,1+epsilon]) cylinder(h_upper-1,d_M4/2,d_M4/2);
      }   
  }
}

link_middle_buttom();

