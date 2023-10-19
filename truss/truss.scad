// Parameters
length = 25;      // Horizontal length of the truss segment
height = 20;       // Vertical height of the truss segment
thickness = 3;     // Thickness of each member
segmentCount = 8;  // How many segments to render

$fn = 100; // Smoothness of the cylinders

// Function to create a single truss member
module truss_member(h, d) {
    cylinder(h=h, r=d/2, center=false);
}


module triangleCylinders(radius, 
    baseLength, 
    height,
    overlap=0.8) {
    sidesHeight = sqrt((baseLength/2)^2 + (height)^2);
    angle = 90-asin((baseLength/2)/sidesHeight);
    rotate([90, 0, 0])
    cylinder(r=radius, h=baseLength+overlap);
    translate([0, -baseLength, 0])
    rotate([90, 0, 180-angle])
    cylinder(r=radius, h=sidesHeight+overlap);
    rotate([90, 0, angle])
    cylinder(r=radius, h=sidesHeight+overlap);
}

// Create the truss segment
module truss_segment() {
    // Horizontal members (bottom square)
    rotate([90, 0, 0]) {
        truss_member(length, thickness);
    }
    rotate([0, 90, 0]) {
        truss_member(length, thickness);
    }
    
    translate([length, 0, 0]) {
    rotate([90, 0, 0]) {
            truss_member(length, thickness);
        }
    }
    
    translate([0,-length,0]) {
    rotate([90, 0, 90]) {
        truss_member(length, thickness);
        }
    }   
    // vertical parts
    
    triangleSidesHeight=sqrt((length/2)^2 + (height)^2);
    angle = 90-asin((length/2)/triangleSidesHeight);
    rotate([0,-angle,0])
    triangleCylinders(thickness/2, length, triangleSidesHeight);
    
    translate([length,0,0])
    rotate([0,180+angle,0])
    triangleCylinders(thickness/2, length, triangleSidesHeight);
}

// Render segments
for( i = [0 : segmentCount-1] ){
    translate([length*i,0,0])
    truss_segment();
    triangleSidesHeight=sqrt((length/2)^2 + (height)^2);
    if(i < segmentCount-1) {
        translate([length*i+length/2,-length/2,height])
        rotate([0,90,0])
        cylinder(h=length, r=thickness/2, center=false);
    }
}
