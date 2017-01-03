// BUTTON PARAMETERS
ButtonHeight = 13;
ButtonDiameter = 21.5;
ButtonWall = 2.5;

ShaftDiameter = 8;
ShaftToothHeight = 0.5;
ShaftToothCount = 24;
ShaftHeight = ButtonHeight+1;
ShaftWall = 1;
ShaftHoleDepth = ShaftHeight-1;

GripCount = 12;
GripSize = 1;
GripHeight = 9;
GripAlign = 1;  //1=top,0=center,-1=bottom

RingThickness = 2.5;
RingHeight = 1;

HoleDiameter = 1;
HoleCount = 20;
HoleOffset = RingThickness;

// internal variables
d1=ButtonDiameter;
w1=ButtonWall;
h1=ButtonHeight;

d2=ShaftDiameter;
h2=ShaftHeight-ButtonWall;
w2=ShaftWall;

// quality
q=100;

difference(){
	union(){
		// outer wall
		difference(){
			cylinder(h=h1, d=d1,center=true, $fn=q);
			translate([0,0,-w1])
				cylinder(h=h1, d=d1-2*w1,center=true, $fn=q);
		}

		// shaft
		translate([0,0,-w1+((h1-h2)/2)])
			difference(){
				cylinder(d=d2+2*ShaftWall,h=h2, center=true, $fn=q);
				translate([0,0,-(ShaftHeight-ShaftHoleDepth)])
					star(r2=d2/2,r1=(d2-2*ShaftToothHeight)/2,c=ShaftToothCount,h=h2);
			}

		// ring
		translate([0,0,h1/2])
			ring((d1-2*RingThickness)/2,d1/2,RingHeight);

		// grip
		translate([0,0,(h1-GripHeight)/2*GripAlign])
			grip(d1,d1+GripSize,GripHeight,GripCount);
	}
	// drill holes
	translate([0,0,h1/2])
		holes(1,d1-2*HoleOffset-HoleDiameter,HoleCount);
}

module grip(d1,d2,h1,count){
	intersection(){
		star(r1=d1/2-3,r2=d2/2+3,c=count,h=h1);
		difference(){
			cylinder(d=d2,h=h1,center=true, $fn=q);
			cylinder(d=d1,h=h1,center=true, $fn=q);
		}
	}
}

module holes(d1,d2,c1){
	u=360/c1;
	h1=10;
	for (i=[0:c1-1])
		rotate([0,0,u*i])
			translate([d2/2,0,0])
				cylinder(d=d1,h=h1,center=true,$fn=q);
}


module ring(ri,ro,rh){
	costat_cub = 2*(ri + ro);
	rc=(ro-ri)/2;

	intersection(){
		rotate_extrude(convexity = 10, $fn=60)
			translate([ro-rc, 0, 0])
				resize([2*rc,2*rh])
					circle(r = rc,$fn=60);
		translate([0,0,rc/2]) 
			cube([costat_cub,costat_cub,rc],center=true);
	}

}

// create 2d star
function starv(r1=5,r2=10,fn=5)=
[for(i=[0:(2*fn-1)])
(i%2==0)?
[r1*cos(180*i/fn),r1*sin(180*i/fn)]:
[r2*cos(180*i/fn),r2*sin(180*i/fn)]
];

// display a 2D vector shape in 3D
module dispv(v){
indi=[[for(i=[0:len(v)-1])i]];
polygon(points=v,paths=indi);
}

module star(r1=5,r2=10,c=5,h=5,center=true){
v0=starv(r1,r2,c);
translate([0,0,center?-h/2:0])
	linear_extrude(height=h)	
		dispv(v0);
}
	
