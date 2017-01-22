switchx=3.25;
switchy=5;
switchthick=.125;
screwdist=2.375;
recessdepth=1/16;

boltdia=.26;

slotx=.25;
slotz=.375;

slotlength=1.5;

res=60;


module finalplate(){
module plate(){
difference(){
    cube([switchx,switchy,switchthick], center=true);
    cube([.5, 1, switchthick], center=true);
    translate ([0,screwdist/2,recessdepth/2]) cylinder(d1=.125, d2=.375, h=switchthick-recessdepth, center=true, $fn=res);
    translate ([0,-screwdist/2,recessdepth/2]) cylinder(d1=.125, d2=.375, h=switchthick-recessdepth, center=true, $fn=res);
}
}

module recess(){
    cube ([1.5,4,recessdepth], center=true);
}

difference(){
plate();
  translate([0,0,-recessdepth/2])  recess();
}

module slotrails(){
translate ([switchx/2-slotx/2, 0, slotz/2+switchthick/2]) cube([slotx,slotlength+.5,slotz], center=true);
translate ([-(switchx/2-slotx/2), 0, slotz/2+switchthick/2]) cube([slotx,slotlength+.5,slotz], center=true);
}

module pivot(){
    translate ([switchx/2-slotx/2, switchy/2-(boltdia+.5)/2, slotz/2+switchthick/2]) cube([slotx, boltdia+.5, slotz], center=true);
    translate ([-(switchx/2-slotx/2), switchy/2-(boltdia+.5)/2, slotz/2+switchthick/2]) cube([slotx, boltdia+.5, slotz], center=true);
    }
difference(){    
    pivot();
    translate ([0, switchy/2-(boltdia+.5)/2, slotz/2+switchthick/2]) rotate([0,90,0]) cylinder(d=boltdia, h=switchx, $fn=res, center=true);
}

difference(){
    slotrails();
    hull(){
        translate([0,slotlength/2, slotz/2+switchthick/2]) rotate([0,90,0]) cylinder(d=boltdia, h=switchx, $fn=res, center=true);
         translate([0,-slotlength/2, slotz/2+switchthick/2]) rotate([0,90,0]) cylinder(d=boltdia, h=switchx, $fn=res, center=true);
    }
}
}

//scale([25.4,25.4,25.4]) finalplate();

//LINKAGE AND WASHERS -- PRINT 4 @ linklength=.75 AND 2 DETERMINE LONGER LENGTH//

linkagez=.125;
linklength=2.5;

module linkswitch(){
    difference(){
    hull(){
        cylinder(h=linkagez, d=slotz, $fn=res);
        translate([0,linklength,0]) cylinder(h=linkagez, d=slotz, $fn=res);
        
    }
    cylinder(h=linkagez, d=boltdia, $fn=res);
    translate([0,linklength,0]) cylinder(h=linkagez, d=boltdia, $fn=res);
    
}
}

//scale([25.4,25.4,25.4]) linkswitch();

///HINGE -- PRINT 2 OF THESE
hingewidth=1;

module hinge(){
    difference(){
    hull(){
        translate([0,hingewidth/2,0]) cylinder(h=hingewidth, d=slotz, $fn=res, center=true);
        translate([hingewidth/2,hingewidth,0]) cylinder(h=hingewidth, d=slotz, $fn=res, center=true);
        translate([-hingewidth/2,hingewidth,0]) cylinder(h=hingewidth, d=slotz, $fn=res, center=true);
    }
    translate([0,hingewidth/2,0]) cylinder(h=hingewidth, d=boltdia, $fn=res, center=true);
    cube([hingewidth+hingewidth/2,hingewidth+hingewidth/2,hingewidth/2], center=true);
    translate([3*hingewidth/8,0,0]) rotate([90,90,0]) cylinder(d=.13, h=2.5*hingewidth, $fn=res, center=true);
    translate([3*hingewidth/8,0,0]) rotate([90,90,0]) cylinder(d=.375, h=1.75*hingewidth, $fn=res, center=true);
       translate([-3*hingewidth/8,0,0]) rotate([90,90,0]) cylinder(d=.13, h=2.5*hingewidth, $fn=res, center=true);
    translate([-3*hingewidth/8,0,0]) rotate([90,90,0]) cylinder(d=.375, h=1.75*hingewidth, $fn=res, center=true);
}
}


//scale([25.4,25.4,25.4]) hinge();


//spacer for top pivot point -- PRINT 2 OF THESE    
module spacer(){
    difference(){
        cylinder(h=(switchx-2*slotx-hingewidth)/2, d=slotz, center=true, $fn=res);
        cylinder(h=(switchx-2*slotx-hingewidth)/2, d=boltdia, center=true, $fn=res);
    }
}

scale([25.4,25.4,25.4]) spacer();