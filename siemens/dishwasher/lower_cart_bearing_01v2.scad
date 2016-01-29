/*
 * Siemens/Bosch dishwasher lower basket bearing
 */

// total bearing width
width = 277;

// bearing thickness
thickness = 82;

// bearing wall thickness
wall = 19;

// hole diameter
d1 = 41.1;

// bearing holder width
x1 = 86;

// bearing holder height
y1 = 79;

y2 = 70;

// corner rounding
cr1 = 10;


module h1_2d(w,h,rc,d) {
    // w = width
    // h = height
    // rc = corner rounding
    // d = hole diameter
    p1 = [[0,rc],[0,h-rc],[rc,h],[w-rc,h],[w,h-rc],[w,rc],[w-rc,0],[rc,0]];
    
    hb = (h-d)/3;
    p2 = [[0,0],[0,hb],[d/8,hb+(h-d)/6],[0,hb+(h-d)/3],[0,h/2],[d,h/2],[d,hb+(h-d)/3],[d-d/8,hb+(h-d)/6],[d,hb],[d,0]];
    
    difference(){
        polygon(p1);
        translate([w/2,h/2,0])
            circle(d/2,center=true);
        translate([(w-d)/2,0,0])
            polygon(p2);
    }
}


module h1_3d (zh, w, h, rc, d ) {
    linear_extrude(height = zh, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0)
        h1_2d(w,h,rc,d);
}

 module cylinder_outer(height,radius,fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}



difference(){
    union(){
        // top holder 1
        h1_3d(thickness, x1, y1, cr1, d1);
        // top holder 2
        translate([width,0,0])
            mirror([1,0,0])
                h1_3d(thickness, x1, y1, cr1, d1);
        // bottom holder connecting two top holders
        translate([width/2, wall-y2, x1/2])
            rotate(a=90,v=[0,1,0])
                h1_3d(width-x1-d1, x1, y1, cr1, d1);
    }
    
    // hole through top holders aligned with hole inside bottom holder
    translate([0,-(d1/2-wall+(y1-y2)),0])   
        rotate(a=90,v=[0,1,0])
            cylinder_outer(width, d1/2 ,360);
    
    // hole through bottom holder located between top holders
    translate([width/2,20,0])
        cube([width-x1-d1-3*wall, 50, d1], center=true);
}


