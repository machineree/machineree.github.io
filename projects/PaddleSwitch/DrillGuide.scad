boltdia=.25;
boltdist=4.75; //distance between hinge bolts, center
screwdist=.75; //distance between screw centers on hinge
screwsize=.13; //#6

leverwidth=1.25; //enter custom width to line up with lever board
padding=.25; //max = leverwidth/2+screwsize; default hinges are .25

module drillguide(){
    circle(d=screwsize, center=true, $fn=100);
    translate([screwdist,0]) circle(d=screwsize, center=true, $fn=100);
    translate([boltdist+screwdist/2,0]) circle(d=screwsize, center=true, $fn=100);
    translate([boltdist-screwdist/2,0]) circle(d=screwsize, center=true, $fn=100);
}

difference(){
scale([25.4, 25.4]) translate ([(boltdist+screwdist/2)/2,0])square([boltdist+screwdist+padding, leverwidth],center=true);
    scale([25.4,25.4]) drillguide();
}