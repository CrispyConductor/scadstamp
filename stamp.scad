
module Stamp(size, baseThickness=2, featureThickness=0.8, taper=true, taperHeight=0.6) {
    taperWidth = taperHeight * 1.5;
    translate([size[0], 0, baseThickness])
        mirror([1, 0, 0]) {
            translate([0, 0, -baseThickness])
                cube([size[0], size[1], baseThickness]);
            linear_extrude(featureThickness)
                    children();
            if (taper)
                intersection() {
                    translate([0, 0, -featureThickness])
                        difference() {
                            minkowski() {
                                linear_extrude(featureThickness)
                                    children();
                                cylinder(r1=taperWidth, r2=0, h=taperHeight);
                            };
                            cube([size[0], size[1], featureThickness]);
                        };
                    cube([size[0], size[1], featureThickness]);
                };
        };
};

module StampHandle(stampSize, overhang=2, height=12) {
    difference() {
        cube([stampSize[0] + overhang*2, stampSize[1] + overhang*2, height]);
        translate([overhang, overhang, height-0.2])
            linear_extrude(0.2)
                children();
    };
};

module TestStamp(featureThickness=0.8) {
    Stamp([80, 55], featureThickness=featureThickness, taperHeight=featureThickness-0.2) union() {
        translate([5, 45])
            text(text="ABCDEFGHIJKLMNO", size=5);
        translate([3, 35])
            text(text="PQRSTUVWXYZ", size=7);
        multiplier = 0.5; // extrusion width
        spacing = 2;
        for (i = [1:7])
            for (j = [1:10])
                translate([j*(j+1)/2*multiplier+j*spacing, i*(i+1)/2*multiplier+i*spacing])
                    square([j*multiplier, i*multiplier]);
        translate([14 + 46, 17])
            difference() {
                circle(r=10);
                circle(r=5);
            };
    };
};

module TestStamp2(featureThickness=0.8) {
    Stamp([20, 20], featureThickness=featureThickness, taperHeight=featureThickness-0.2) union() {
        translate([10, 8])
            circle(r=6);
        translate([3, 17])
            square([14, 0.5]);
    };
};

module TestStampSet() {
    for (i = [1:5]) {
        translate([0, (i - 1) * 60, 0])
            TestStamp(featureThickness = 0.2 + i * 0.4);
    }
};

//TestStamp2();
//StampHandle([20, 20]);

