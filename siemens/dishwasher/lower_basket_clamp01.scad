/*
 * Siemens/Bosch dishwasher lower basket bearing
 */

// wire diameter
wireDiameter = 41;

// wire radius
wireRadius = wireDiameter/2;

// wire distance
wireDistance = 147; //105

// wall thickness
wallThickness = 20;

// corner radius
cornerRadius = 10;

// bearing width
bearingWidth = 85;

// extra 
lowerPadding = 0;

//***************************

clipHeight = 2*(wireDiameter+wallThickness)+lowerPadding;

totalWidth = 2*wireDiameter+wireDistance+2*wallThickness;
echo("Total bearing width =", totalWidth );



module cylinder_outer(height,radius,fn){
    fudge = 1/cos(180/fn);
    cylinder(h=height,r=radius*fudge,$fn=fn);
}


module clip(wiDia,wallTh,cornRad,width){
    x = 2*wallTh+wiDia;
    y = 2*wallTh+wiDia;
    
    translate([cornRad,0,0])
        cube([x-2*cornRad,y,width], center=false);
    translate([0,cornRad,0])
        cube([cornRad,y-2*cornRad,width], center=false);
    translate([x-cornRad,cornRad,0])
        cube([cornRad,y-2*cornRad,width], center=false);
    translate([cornRad,y-cornRad])
        cylinder(h=width,r=cornRad,$fn=60);
    translate([x-cornRad,y-cornRad])
        cylinder(h=width,r=cornRad,$fn=60);
    translate([x-cornRad,cornRad])
        cylinder(h=width,r=cornRad,$fn=60);
    translate([cornRad,cornRad])
        cylinder(h=width,r=cornRad,$fn=60);
} 

module bearingBody(wiDia, wallTh, cornRad, width, wiDis, loPad){
    // draw left upper clip
    clip(wiDia, wallTh, cornRad, width);
    
    // draw right upper clip
    translate([wiDis+wiDia,0,0])
        clip(wiDia, wallTh, cornRad, width);

    // center of upper wire
    upC = wallTh+wiDia/2;
    // center of lower wire
    loC = upC-wiDia;
    // bottom of lower clip
    loB = loC-wiDia/2-wallTh-loPad;

    // draw lower clip connecting two upper ones
    translate([wallTh+wiDia, loB, width])
    rotate(a=90,v=[0,1,0])
        clip(wiDia, wallTh, cornRad, wiDis);

}

module wires(wireR, wireDst, leftCenter, width){

    // left wire
    translate(leftCenter+[0,0,-width]){
        cylinder_outer(width+width, wireR, 60);
        translate([-wireR, -width, 0])
            cube([wireR*2,width,width*2]);
    }
    
    // right wire
    translate(leftCenter+[wireDst+2*wireR,0,-width]){
        cylinder_outer(width+width, wireR, 60);
        translate([-wireR, -width, 0])
            cube([wireR*2,width,width*2]);
    }
    
    // bottom wire
    translate(leftCenter-[width*0.75,2*wireR,0])
        rotate(a=90,v=[0,1,0]){
            cylinder_outer(wireDst+2*width, wireR ,60);
            translate([-wireR, -width, 0])
                cube([wireR*2,width,wireDst+2*width]);   
        }   
}

difference(){
    // main body
    bearingBody(wireDiameter, wallThickness, cornerRadius, bearingWidth, wireDistance, lowerPadding);

    // cut-out holes for wires
    wires(wireDiameter/2, wireDistance, [wallThickness+wireDiameter/2, lowerPadding+wallThickness+wireDiameter/2, bearingWidth/2], bearingWidth);
    
    // cut-out hole in the mid-section
        // hole through bottom holder located between top holders
    translate([totalWidth/2,-wireDiameter,-wallThickness])
        cube([wireDistance-2*(wallThickness+bearingWidth/10), 50, d1], center=true);

    
}