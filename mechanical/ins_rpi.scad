$fn = 90;

// library folder
use <lib/misc.scad>;
use <lib/pi.scad>;
use <lib/lidar.scad>;


module piFootPrint(depth=10){
    hole = 2.8; // mm
    dx = 58;
    dy = 49;
    translate([-dx/2,-dy/2,0]){
        /* cylinder(h=depth, d=hole, center=true);
        translate([dx,0,0]) cylinder(h=depth, d=hole, center=true);
        translate([0,dy,0]) cylinder(h=depth, d=hole, center=true);
        translate([dx,dy,0]) cylinder(h=depth, d=hole, center=true); */
        M2(20);
        translate([dx,0,0]) M2(20);
        translate([0,dy,0]) M2(20);
        translate([dx,dy,0]) M2(20);
    }
}

module cameramount(thick){
    offset = 15;
    translate([0,-3,0]){  // move to avoid screw holes
    // connects to base plate
    difference(){
        translate([-49/2,0,0]) cube([49, 15, thick]);
        translate([-25/2,-1,-1]) cube([25, 20, 2*thick]); // screw cutout
    }
    // camera mount back
    difference(){
        translate([-49/2,0,0])cube([49, 3, 30+offset]);
        translate([-49/2+3,-1,3+offset]) cube([4, 10, 4]);
        translate([-49/2+3,-1,3+offset+20]) cube([4, 10, 4]);
        translate([49/2-7,-1,3+offset]) cube([4, 10, 4]);
        translate([49/2-7,-1,3+offset+20]) cube([4, 10, 4]);
        translate([-25/2,-1,-1])cube([25, 10, 25]);  // cable/sd card cutout
    }
    // curved edges
    difference(){
        translate([-49/2,0,4]) cube([49, 8, 5]);
        translate([-49/2-1,5+3,4+5]) rotate([0,90,0]) cylinder(h=55, d=10);
        translate([-25/2,-1,-1]) cube([25, 20, 40]); // screw cutout
    }
}
}

module rpi_base(){
    difference(){
        // main deck
        cylinder(h=4, d=100);

        // cable cutouts
        cube([70,20,20], center=true);
        translate([0,-10,0]) cylinder(h=10, d=50, center=true);
        translate([0,10,0]) cylinder(h=20, d=40, center=true);

        // alt imu mount point
        rotate([0,180,0]) translate([0,0,-4]){
            y = 5;
            translate([38, 23+y, 0]) M2(20);
            translate([38, y, 0]) M2(20);
        }

        // screws to bottom (legs)
        translate([50-5/2-1, 0, 0]) M3(20);
        translate([-50+5/2+1, 0, 0]) M3(20);
        translate([0, 50-5/2-1, 0]) M3(20);
        translate([0, -50+5/2+1, 0]) M3(20);

        // screws to top (lidar)
        rotate([0,180,45]) translate([0,0,-4]){
            rotate([0,0,20]) translate([50-5/2-1, 0, 0]) M3(20);
            translate([-50+5/2+1, 0, 0]) M3(20);
            translate([0, 50-5/2-1, 0]) M3(20);
            rotate([0,0,-20]) translate([0, -50+5/2+1, 0]) M3(20);
        }

        rotate([0,180,90]) translate([10,0,-4]) piFootPrint();
    }

    // imu standoffs
    height = 4;  // height above plate
    y = 5;
    M2standoff(-38,23+y,4,height);
    M2standoff(-38,y,4,height);

    // pi standoffs
    dx = 58;
    dy = 49;
    height = 4;  // height above plate
    rotate([0,0,90]) translate([-dx/2,-dy/2,0]) {
        M2standoff(dx-10,0,4,height);
        M2standoff(-10,0,4,height);
        M2standoff(dx-10,dy,4,height);
        M2standoff(-10,dy,4,height);
    }

    translate([0,-55,0]) cameramount(4);
}

module lidar_base(){
    dia = 100;
    difference(){
        cylinder(h=4, d=100);
        cylinder(h=10, d=40, center=true);

        // screws to rpi deck
        m3d = 6;
        translate([50-5/2-1, 0, 0]) M3Nut(20); //cylinder(h=19,d=m3d, center=true);
        rotate([0,0,-20]) translate([-50+5/2+1, 0, 0]) M3Nut(20);
        translate([0, 50-5/2-1, 0]) M3Nut(20);
        rotate([0,0,20]) translate([0, -50+5/2+1, 0]) M3Nut(20);
//}{
        // ydlidar/lds-01 lidar mount
        rotate([0,180,45]) translate([3,0,-4]){
            translate([22,31,0]) M3(20);
            translate([22,-31,0]) M3(20);
            translate([-35,25,0]) M3(20);
            translate([-35,-25,0]) M3(20);
        }

        // rpylidar - tbd

        // hokuyo urg mount
        rotate([0,180,45]) translate([0,0,-4]){
            translate([20,20,0]) M3(20);
            translate([20,-20,0]) M3(20);
            translate([-20,20,0]) M3(20);
            translate([-20,-20,0]) M3(20);
        }

        // skeletonizing
        translate([dia/3+4, dia/3+4, -2]) rotate([0,0,-45]) scale([1.2,.85,1]) cylinder(h=10, d=50); // back
        translate([-dia/4-5, dia/2.5, -2]) rotate([0,0,35]) scale([.90,.75,1]) cylinder(h=10, d=50); // right
        //translate([dia/3, -dia/3, -2]) rotate([0,0,45]) scale([1,.5,1]) cylinder(h=10, d=50);
        translate([dia/2.5, -dia/4-5, -2]) rotate([0,0,35]) scale([.90,.75,1]) cylinder(h=10, d=50); // left
        translate([-dia/3, -dia/3, -2]) rotate([0,0,-45]) scale([1.75,.70,1]) cylinder(h=10, d=50); // front
    }
}






//COLOR1 = "lime";
COLOR1 = "skyblue";

rotate([0,0,90]) translate([2,0,6]) rpi3();
translate([0,0,0]) color(COLOR1) rpi_base();
translate([0,0,30]) rotate([0,0,45]) color(COLOR1) lidar_base();
translate([0,-3,34]) rotate([0,0,-90]) ydlidar();
translate([0,-60,20]) rotate([90,0,0]) picamera();
//top2(125, 100);
//upper();
//rpi_base();
//lidar_base();
