res=100;
//spindle
spindle=19.05; //.75 in
ringthick=7.5;
//magnet
magdia=5;
magthick=2.5;
//holes for screws
sevendrill=5.1; //.201 in

difference(){
    cylinder(h=magdia+ringthick, d=spindle+ringthick, center=true, $fn=res);
    cylinder(h=magdia+ringthick, d=spindle, center=true, $fn=res);
    translate([0,(spindle+ringthick)/2,0]) rotate([90,0,0]) cylinder(h=magthick*2, d=magdia, center=true, $fn=res);
    //translate([0,-(spindle+ringthick)/2,0]) rotate([90,0,0]) cylinder(h=magthick*2, d=magdia, center=true, $fn=res); uncomment for 2 magnets
    rotate([0,90,0]) cylinder(h=spindle+ringthick, d=sevendrill, center=true, $fn=res); 
}