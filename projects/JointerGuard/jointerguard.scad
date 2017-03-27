pivot=5/8; //diameter of the pivoting pin
kerf=.008; //laser kerf

pivotdia=pivot-2*kerf; // to account for laser cutter

res=360; //resolution of circles

rnd=1; //radius of corners
rad=5.5; //radius of semicircle

plythick=.2; //thickness of material

module semicircle(rad, reso){
    difference(){
        circle(r=rad, $fn=reso);
        translate([-rad,0]) square([2*rad,2*rad],center=true);
    }
}

module outline(){
    hull(){
        translate([-rad/2+rnd,-rad+rnd]) circle(r=rnd,$fn=res);
        translate([-rad/2+rnd,rad-rnd]) circle(r=rnd,$fn=res);
        translate([1.6*((rad/2-rnd/2)/2),1.6*(sqrt(3)*(rad-rnd)/2)]) circle(r=rnd,$fn=res); //uncomment for more cutterhead coverage
        semicircle(rad,res);
    }
}

//PRINT 2

module springcut(wall){
    hull(){
        translate([0,rnd]) circle(d=pivotdia+wall,$fn=res);
        translate([0,-rad]) circle(d=pivotdia+wall,$fn=res);
    }
}

//PRINT 1

module springcut2(wall){
    hull(){
        translate([0,rnd]) circle(d=pivotdia+wall,$fn=res);
        translate([0,-rad+4*pivotdia]) circle(d=pivotdia+wall,$fn=res);
    }
}

eyehook=.16; // 5/32 eye bolt for spring

scale([25.4,25.4])
difference(){
    outline();
    //springcut(2*plythick-2*kerf); //comment for bottom two layers
    //springcut2(plythick-2*kerf); //comment for middle layer
    translate([0,-rad+rnd])circle(d=pivotdia, $fn=res); //pivot pin hole
    translate([0,rnd]) circle(d=eyehook,$fn=res); //eye hook hole
}
