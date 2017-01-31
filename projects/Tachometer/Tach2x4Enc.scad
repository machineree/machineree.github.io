//CNC Tach Case of 2x4 Lumber

//3x7 cm perfboard - adjust to needs
perfx=70;
perfy=30;

//LCD
lcdx=93;
lcdy=49;
lcdcut=3; //quarter of enclosure plus lcd+pcb

wall=6.35; //surround top LCD screen enclosure

encX=lcdx+2*wall;
encY=lcdy+2*wall;
encZ=38.1; //1.5" 

routbit=6.35; //.25" two flute router bit

difference(){
    cube([encX,encY,encZ], center = true);
    //Perfboard w Nano:
    translate([0,0,wall/2]) cube([perfx,perfy,encZ-wall], center=true);
    //Relief for LCD Screen Enclosure:
    translate([0,0,encZ/2-lcdcut/2]) cube([lcdx,lcdy,lcdcut], center=true);
    //Relief for LCD Cable:
    translate([-perfx/6,perfy/2,encZ/2-lcdcut/2-routbit/2]) cube([2*perfx/3,routbit,routbit], center = true);
    //Power In -->Vin:
    translate([0,-encY/4,0]) rotate([90,0,0]) cylinder(d=routbit, h=encY/2, center=true, $fn=60);
    //USB and Sensor cables:
    hull(){ 
        translate([encX/4,perfy/2-routbit,0]) rotate([0,90,0]) cylinder(d=routbit, h=encX/2, center=true, $fn=60);
        translate([encX/4,-(perfy/2-routbit),0]) rotate([0,90,0]) cylinder(d=routbit, h=encX/2, center=true, $fn=60);}
    
}