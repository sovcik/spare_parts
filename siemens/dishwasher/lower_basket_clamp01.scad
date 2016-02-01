/*
 * Clamp for securing plate racks in lower basket
 * of dishwasher machines. Suitable for selected
 * Siemens and Bosch dishwashers.
 *
 * (c) 2016 Jozef Sovcik
 * Siemens & Bosch are trademarks for their respective holders.
 *
 * All lenghts are in milimeters.
 *
 * Tip: Print it up-side-down - it would require less support.
 */

// wire diameter 4.1mm
wireDiameter = 4.1;

// wire radius
wireRadius = wireDiameter/2;

// distance between two top wires
wireDistance = 14.7; 

// element wall thickness
wallThickness = 2.0;

// corner rounding radius
cornerRadius = 1.0;

// clamp width
clampWidth = 8.1;

// extra padding
lowerPadding = 0;

//***************************

elementHeight = wireDiameter + 2*wallThickness + lowerPadding;
elementWidth = wireDiameter + 2*wallThickness;
topElementZ = clampWidth;
botElementZ = wireDistance;

totalWidth = 2*wireDiameter+wireDistance+2*wallThickness;
echo("Total clamp width =", totalWidth );



module cylinder_outer(height,radius,fn){
    fudge = 1/cos(180/fn);
    cylinder(h=height,r=radius*fudge,$fn=fn, center=true);
}


module element(w, h, r, d){
    // element is composed of 2 overlaping cubes
    // and 4 cylinders used to "round" edges.
    // technically, one cube([w,h,d]) would be just fine
    // all those cylinders are just for "beautification"
    cube([w-2*r,h,d], center=true);
    cube([w,h-2*r,d], center=true);
    translate([-w/2+r,h/2-r,0])
        cylinder(h=d,r=r,$fn=60, center=true);
    translate([-w/2+r,-h/2+r,0])
        cylinder(h=d,r=r,$fn=60, center=true);
    translate([w/2-r,h/2-r,0])
        cylinder(h=d,r=r,$fn=60, center=true);
    translate([w/2-r,-h/2+r,0])
        cylinder(h=d,r=r,$fn=60, center=true);
    
} 

module bearingBody(cw, ch, cr, cz, wd, wdst){
    
    // draw left upper element
    element(cw, ch, cr, cz);
    
    // draw right upper element
    translate([wdst+wd,0,0])
        element(cw, ch, cr, cz);

    // draw lower element connecting two upper ones
    translate([(wd+wdst)/2, -wd, 0])
        rotate(a=90,v=[0,1,0])
            element(cw, ch, cr, wdst);
}

module wire(wr, l) {
    cylinder_outer(l, wr, 60);
    translate([0, -2*wr, 0])
        cube([wr*2,4*wr,l], center=true);   
}

module wires(wr, wdst, l){

    // left wire
    wire(wr, l);
    
    // right wire
    translate([wdst+2*wr,0,0])
        wire(wr, l);
    
    // bottom wire
    translate([(2*wr+wdst)/2, -2*wr, 0])
        rotate(a=90,v=[0,1,0])
            wire(wr, wdst*2);
}

// bottom clicks
module clicks(wr, wdst, l){
    
    // click radius
	cr = wr*0.4;
    
    // horizontal offset of click relative to center of wire
    offH = wr*1.1;
    
    // vertical offset of click relative to center of wire
    offV = wr*1.2;
    
    translate([(2*wr+wdst)/2, -2*wr, 0])
        rotate(a=90,v=[0,1,0]){
            translate([offH,-offV,0])
                cylinder(h=wdst,r=cr,$fn=60, center=true);
            translate([-offH,-offV,0])
                cylinder(h=wdst,r=cr,$fn=60, center=true);
            
        }      
}

//********************************************

difference(){
    // draw body
    bearingBody(elementWidth, elementHeight, cornerRadius, topElementZ,  wireDiameter, wireDistance);

    // create holes for wires
    wires(wireDiameter/2, wireDistance, topElementZ*2);
    
    // create hole in the top of the mid section
    translate([(wireDiameter+wireDistance)/2,0,0])
        cube([(wireDistance - wireDiameter*1.2), wallThickness*4,wireDiameter], center=true);
    
}
// create "clicks" which will secure clamp in place, 
// so it won't fall off
clicks(wireDiameter/2, wireDistance, topElementZ*2);
