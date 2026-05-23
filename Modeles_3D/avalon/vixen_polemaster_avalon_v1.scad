$fn=360;
epsilon=0.01;

use <threads.scad>
use <my_function.scad>

// Vixen
B_Vixen = 43.5;
b_Vixen = 36;
l_Vixen = 200;
h_Vixen = 15;

// Transition
h = 5;

// Avalon
B_Avalon = 31.95;
b_Avalon = 40;
l_Avalon = l_Vixen;
h_Avalon = 8.7;


//---------------------------------------------------------------
// 
module vixen_polemaster_avalon()
{
  union() 
  {
    // vixen
    trapeze_form(B_Vixen, b_Vixen, l_Vixen, h_Vixen);
    
    // Transition
    #translate([0,0,h_Vixen-epsilon]) trapeze_form(b_Vixen, B_Avalon, l_Vixen, h); 
    
    // Avalon
    translate([0,0,h_Vixen+h-epsilon]) trapeze_form(B_Avalon, b_Avalon, l_Avalon, h_Avalon);

      
  }   
  

}    

vixen_polemaster_avalon();