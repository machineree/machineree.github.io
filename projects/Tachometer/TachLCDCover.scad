//parameters
wall=6; //thickness around modules
res=30; //circle resolution

//LCD Module 1602
lcdx=72;
lcdy=25;
lcdz=7.3;

lcdpcbx=81;
lcdpcby=37;
lcdpcbz=12; //total height lcd+pcb

lcdlightx=(lcdpcbx-lcdx)/2;
lcdlighty=19;
lcdlightz=3.55;

lcdbolt=3.5; //bolt diameter for mount holes
lcdboltx=75; //distance from center of bolt in x direction
lcdbolty=31; //distance from center of bolt in y direction



module lcd(){
        cube([lcdpcbx,lcdpcby,lcdpcbz-lcdz]);
        translate([(lcdpcbx-lcdx)/2, (lcdpcby-lcdy)/2, lcdpcbz-lcdz]) cube ([lcdx,lcdy,lcdz]);
        translate([0, (lcdpcby-lcdlighty)/2, lcdpcbz-lcdz]) cube ([lcdlightx, lcdlighty, lcdlightz]);
}

module case1(){
    difference(){
        cube([lcdpcbx+2*wall,lcdpcby+2*wall, lcdpcbz]);
        translate ([(lcdpcbx-lcdboltx)/2+wall,(lcdpcby-lcdbolty)/2+wall,0]) cylinder(h=lcdpcbz, d=lcdbolt, $fn=res);
        translate ([(lcdpcbx-lcdboltx)/2+wall+lcdboltx,(lcdpcby-lcdbolty)/2+wall,0]) cylinder(h=lcdpcbz, d=lcdbolt, $fn=res);
        translate ([(lcdpcbx-lcdboltx)/2+wall+lcdboltx,(lcdpcby-lcdbolty)/2+wall+lcdbolty,0]) cylinder(h=lcdpcbz, d=lcdbolt, $fn=res);
        translate ([(lcdpcbx-lcdboltx)/2+wall,(lcdpcby-lcdbolty)/2+wall+lcdbolty,0]) cylinder(h=lcdpcbz, d=lcdbolt, $fn=res);
    
    }
}

module top(){
    difference(){
        case1();
        translate([wall,wall,0]) lcd();
    }
}

top();