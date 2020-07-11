
// Simple primatives for generating holes


// https://www.engineersedge.com/hardware/standard_metric_hex_nuts_13728.htm
// m2: d=4    D=4.62
// m3: d=5.5  D=6.35
module hex(D,t){
    x = D/2;
    y = sqrt(3)/2*x;
    pts = [
        [x/2,y],
        [x,0],
        [x/2,-y],
        [-x/2,-y],
        [-x,0],
        [-x/2,y]
    ];
    linear_extrude(height=t){
        polygon(pts);
    }
}

M2_shaft = 2.3;

module M3Nut(t){
    hex(6.4, t);
    cylinder(1*t, d=3.3, center=true);
}

module M2Nut(t){
    hex(4.68, t);
    cylinder(1*t, d=M2_shaft, center=true);
}

module M2(t){
    cylinder(3*t, d=M2_shaft, center=true);
    translate([0,0,-1]) M2Nut(3); // nut
}

module M3(t){
    cylinder(h=3*t, d=3.3, center=true);
    translate([0,0,2]) cylinder(h=3*t, d=7, center=false); // head
}