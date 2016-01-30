/*
 * Siemens/Bosch dishwasher lower basket clamp
 *
 * All lenghts are in milimeters.
 */

// wire diameter 4.1mm
wireDiameter = 4.1;

// wire radius
wireRadius = wireDiameter/2;

// distance between two top wires
wireDistance = 14.7; 

// clip wall thickness
wallThickness = 2.0;

// corner rounding radius
cornerRadius = 1.0;

// bearing width
clampWidth = 8.1;

// extra 
lowerPadding = 0;

//***************************

clipHeight = wireDiameter + 2*wallThickness + lowerPadding;
clipWidth = wireDiameter + 2*wallThickness;
topClipZ = clampWidth;
botClipZ = wireDistance;

totalWidth = 2*wireDiameter+wireDistance+2*wallThickness;
echo("Total bearing width =", totalWidth );



module cylinder_outer(height,radius,fn){
    fudge = 1/cos(180/fn);
    cylinder(h=height,r=radius*fudge,$fn=fn, center=true);
}


module clip(w, h, r, d){
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
    
    // draw left upper clip
    clip(cw, ch, cr, cz);
    
    // draw right upper clip
    translate([wdst+wd,0,0])
        clip(cw, ch, cr, cz);

    // draw lower clip connecting two upper ones
    translate([(wd+wdst)/2, -wd, 0])
        rotate(a=90,v=[0,1,0])
            clip(cw, ch, cr, wdst);
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

module clicks(wr, wdst, l){
    // bottom clicks
    translate([(2*wr+wdst)/2, -2*wr, 0])
        rotate(a=90,v=[0,1,0]){
            translate([wr*1.1,-wr*1.2,0])
                cylinder(h=wdst,r=wr*0.2,$fn=60, center=true);
            translate([-wr*1.1,-wr*1.2,0])
                cylinder(h=wdst,r=wr*0.2,$fn=60, center=true);
            
        }      
}

//********************************************

difference(){
    // draw body
    bearingBody(clipWidth, clipHeight, cornerRadius, topClipZ,  wireDiameter, wireDistance);

    // create holes for wires
    wires(wireDiameter/2, wireDistance, topClipZ*2);
    
    // create hole in the top of the mid section
    translate([(wireDiameter+wireDistance)/2,0,0])
        cube([(wireDistance - wireDiameter*1.2), wallThickness*4,wireDiameter], center=true);
    
}
// create "clicks" which will secure wires in place
clicks(wireDiameter/2, wireDistance, topClipZ*2);
