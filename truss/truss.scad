// Parameters
length = 25;      // Horizontal length of the truss segment
height = 20;       // Vertical height of the truss segment
thickness = 3;     // Thickness of each member
segmentCount = 8;  // How many segments to render

primitive = "cylinder"; // [cylinder, cube]

$fn = 100; // Smoothness of the cylinders

// Function to create a single truss member
module truss_member(h, d) {
    if(primitive == "cylinder") {
        cylinder(h=h, r=d/2, center=false);
    } else if(primitive == "cube") {
        cube([d, d, h]);
    }
}


module triangleCylinders(radius, 
    baseLength, 
    height,
    overlap=0.5) {
    sidesHeight = sqrt((baseLength/2)^2 + (height)^2);
    angle = 90-asin((baseLength/2)/sidesHeight);
    rotate([90, 0, 0])
    truss_member(baseLength+overlap, radius);
    translate([0, -baseLength, 0])
    rotate([90, 0, 180-angle])
    truss_member(baseLength+overlap, radius);
    rotate([90, 0, angle])
    truss_member(baseLength+overlap, radius);
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
    triangleCylinders(thickness, length, triangleSidesHeight);
    
    translate([length,0,0])
    rotate([0,180+angle,0])
    triangleCylinders(thickness, length, triangleSidesHeight);
}

// Render segments
for( i = [0 : segmentCount-1] ){
    translate([length*i,0,0])
    truss_segment();
    triangleSidesHeight=sqrt((length/2)^2 + (height)^2);
    if(i < segmentCount-1) {
        translate([length*i+length/2,-length/2,height])
        rotate([0,90,0])
        if(primitive == "cylinder") {
            cylinder(h=length, r=thickness/2, center=false);
        } else if(primitive == "cube") {
            cube([thickness, thickness, height]);
        }
    }
    // TODO chamfer/fillet
    // TODO cube doesn't work
}
