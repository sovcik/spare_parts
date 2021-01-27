
// quality
q=200;

ShaftLength=17;
ShaftDiameter=12;
ShaftOffset=8;

TopCylHeight=6;
TopCylDia=35;

difference(){
	union(){
		// shaft
        translate([0,0,-ShaftLength/2]){
            difference(){
                cylinder(h=ShaftLength, d=ShaftDiameter, center=true, $fn=q);
                translate([-ShaftDiameter/2,(ShaftDiameter-ShaftOffset)/2,-ShaftLength/2-1])
                    cube([ShaftLength,ShaftDiameter,ShaftLength+2]);
                    
            }
            translate([-2,(ShaftDiameter-ShaftOffset)/2,-ShaftLength/2])
                cube([4,1.5,ShaftLength]);
        }
        translate([0,0,TopCylHeight/2])
            difference(){
                cylinder(h=TopCylHeight, d=TopCylDia, center=true, $fn=q);
                translate([-TopCylDia/2,-4,-1])
                    cube([TopCylDia+2,8,TopCylHeight]);
                translate([-4,-TopCylDia/2,-1])
                    cube([8,TopCylDia+2,TopCylHeight]);
            }
    }
}
	
