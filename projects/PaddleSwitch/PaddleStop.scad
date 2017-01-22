//Paddle Stop Sign

width=4.5; //flat to flat measurement inches (inscribed circle dia)

module inscr_circle(diameter){
   inscribed = 1/cos(180/8);
   circle(r=(diameter/2)*inscribed,$fn=8);}

scale([25.4,25.4]) 
difference(){
   rotate([0,0,360/16]) inscr_circle(width); 
       //holes for 2 #6 screws to mount
   translate([0,width/4]) circle(d=.13, $fn=100);
   translate([0,-width/4]) circle(d=.13, $fn=100);
}


//EXPORT TO DXF OR SVG FOR TEMPLATE/LASER/CNC