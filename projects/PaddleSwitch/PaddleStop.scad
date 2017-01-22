//Paddle Stop Sign -->inches

module inscr_circle(diameter){
   inscribed = 1/cos(180/8);
   circle(r=(diameter/2)*inscribed,$fn=8);}

scale([25.4,25.4]) 
   difference(){
       //enter width of the stop sign from flat to flat here
       rotate([0,0,360/16]) inscr_circle(8); 
       //holes for 2 #6 screws to mount
       translate([0,2]) circle(d=.13, $fn=100);
       translate([0,-2]) circle(d=.13, $fn=100);
   }


//EXPORT TO DXF OR SVG FOR TEMPLATE/LASER/CNC