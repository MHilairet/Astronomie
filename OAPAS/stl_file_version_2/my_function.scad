//------------------------------------------------------------------
// Half cylindee
//------------------------------------------------------------------
module hollowcylindersector(height, radius, angle=360, intradius=0, center=false)
{
  translate ([0, 0, center?(-height/2):0])
    rotate (center?(-angle/2):0, [0, 0, 1])
      rotate_extrude(angle = angle, convexity = 2)
        polygon([[intradius, 0],[intradius, height],[radius, height],[radius, 0]]);
}


//------------------------------------------------------------------
// Triangle
//------------------------------------------------------------------
module triangle(l, w, h)
{
  polyhedron(//pt 0        1        2        3        4        5
         points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
         faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]);
}

//------------------------------------------------------------------
// Triangle
//------------------------------------------------------------------
//module prism(l, w, h)
//{
//  polyhedron(//pt 0        1        2        3        4        5
//         points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
//         faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]);
//}


//------------------------------------------------------------------
// Trapeze form
//------------------------------------------------------------------
module trapeze_form(B, b, l, h) 
{ 
  CubePoints = [
  [ 0, -B/2,  0 ],  //0
  [ l, -B/2,  0 ],  //1
  [ l,  B/2,  0 ],  //2
  [ 0,  B/2,  0 ],  //3
  [ 0, -b/2,  h ],  //4
  [ l, -b/2,  h ],  //5
  [ l,  b/2,  h ],  //6
  [ 0,  b/2,  h ]]; //7
  
  CubeFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
  translate([-l/2,0,0]) polyhedron(CubePoints,CubeFaces);
}


module trapeze_form2(B, b, L, l, h) 
{ 
  CubePoints = [
  [ -L/2, -B/2,  0 ],  //0
  [  L/2, -B/2,  0 ],  //1
  [  L/2,  B/2,  0 ],  //2
  [ -L/2,  B/2,  0 ],  //3
  [ -l/2, -b/2,  h ],  //4
  [  l/2, -b/2,  h ],  //5
  [  l/2,  b/2,  h ],  //6
  [ -l/2,  b/2,  h ]]; //7
  
  CubeFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
  polyhedron(CubePoints,CubeFaces);
}



