$fn = 90;

// library folder
use <lib/robotis_parts.scad>;
use <lib/misc.scad>;
use <lib/pi.scad>;
use <lib/lidar.scad>;

module standoff(h=30){
    difference()
    {
        offset = 7;
        union(){
            cylinder(d=8,h=h-offset);
            translate([0,0,h-offset]) cylinder(d=6, h=offset);
        }
        /* cylinder() */
        translate([0,0,-2]) cylinder(d=2.5,h=h+4);
    }
}


module piFootPrint(depth=10){
    dx = 58;
    dy = 49;
    translate([-dx/2,-dy/2,0]){
        M2(20);
        translate([dx,0,0]) M2(20);
        translate([0,dy,0]) M2(20);
        translate([dx,dy,0]) M2(20);
    }
}

module M2standoff(x,y,z,h){
    dia = 2.3;
    wide = 3;

    translate([x,y,z]) difference(){
        cylinder(h=h, d=dia+wide);
        cylinder(h=4*h, d=dia, center=true);
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
        difference()
        {
            translate([-49/2,0,0]) cube([49, 4, 30+offset]);

            translate([-49/2+3+2,-1,3+offset+2]) rotate([90,0,0]){
                M3(6);
                translate([0,0,-6]) M3Nut(3);
            }  // bottom left
            translate([-49/2+3+2,-1,3+offset+20+2]) rotate([90,0,0]) {
                M3(6);
                translate([0,0,-6]) M3Nut(3);
            }  // top left
            translate([49/2-7+2,-1,3+offset+2]) rotate([90,0,0]) {
                M3(6);
                translate([0,0,-6]) M3Nut(3);
            } // bottom right
            translate([49/2-7+2,-1,3+offset+20+2]) rotate([90,0,0]) {
                M3(6);
                translate([0,0,-6]) M3Nut(3);
            } // top right

            translate([0,0,20]) rotate([90,0,0]) {
                cylinder(h=10, d=25, center=true); // arch
            }

            translate([-25/2,-1,-1]) cube([25, 10, 20]);  // cable/sd card cutout
        }
        // curved edges
        difference(){
            translate([-49/2,0,4]) cube([49, 8, 5]);
            translate([-49/2-1,5+4,4+5]) rotate([0,90,0]) cylinder(h=55, d=10);
            translate([-25/2,-1,-1]) cube([25, 20, 40]); // screw cutout
        }
    }
}

module rpi_base(){
    difference()
    {
        // main deck
        cylinder(h=4, d=100);

        // cable cutouts
        translate([-12.5,-50,-1]) cube([25,11,20], center=false); // front
        translate([0,-40,0]) cylinder(h=10, d=25, center=true); // front curve
        translate([0,-2.55,0]) cube([70,30,20], center=true); // side cable runs
        translate([0,10,0]) cylinder(h=20, d=40, center=true);

        // alt imu mount point
        y = 5;
        translate([-38, 23+y, 0]) M2(20);
        translate([-38, y, 0]) M2(20);

        // screws to bottom (legs)
        translate([50-5/2-1, 0, 0]) {M3(20);}
        translate([-50+5/2+1, 0, 0]) {M3(20);}
        translate([0, 50-5/2-1, 0]) {M3(20);}
        translate([0, -50+5/2+1, 0]) {M3(20);}

        /* translate([50-5/2-1, 0, 0]) standoff(); */

        // screws to top (lidar)
        /* rotate([0,180,45]) translate([0,0,-4]){
            rotate([0,0,20]) translate([50-5/2-1, 0, 0]) M3(20);
            translate([-50+5/2+1, 0, 0]) M3(20);
            translate([0, 50-5/2-1, 0]) M3(20);
            rotate([0,0,-20]) translate([0, -50+5/2+1, 0]) M3(20);
        } */

        rotate([0,0,90]) translate([-10,0,0]) piFootPrint();
    }

    // new stand offs for self tapping screws
    soh = 34;
    rotate([0,0,45]) rotate([0,0,0]) translate([50-5/2-1, 0, 0]) standoff(soh);
    rotate([0,0,45]) rotate([0,0,-20]) translate([-50+5/2+1, 0, 0]) standoff(soh);
    rotate([0,0,45]) rotate([0,0,20]) translate([0, -50+5/2+1, 0]) standoff(soh);
    rotate([0,0,45]) rotate([0,0,0]) translate([0, 50-5/2-1, 0]) standoff(soh);
    /* rotate([0,0,45]) rotate([0,0,0]) translate([50-5/2-1, 0, 0]) standoff(); */


    // imu standoffs
    height = 3;  // height above plate
    y = 5;
    M2standoff(-38,23+y,4,height);
    M2standoff(-38,y,4,height);

    // pi standoffs
    dx = 58;
    dy = 49;
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
        union(){
            cylinder(h=4, d=100);
            /* rotate([0,180,45]) translate([-5,20,-2]){
                w = 26;  ww = w+6;
                l = 29;  ll = l+6;
                d = 10;
                translate([-ww/2,-ll/2-1,-2]) cube([ww+18,8,4]); // back-center
                translate([-w/2-10,l/2-4,-2]) cube([ww+10,7,4]); // front-outside
                translate([w/2,l/2,0]) M2Nut(d);
                translate([w/2,-l/2,0]) color("blue") M2Nut(d);
                translate([-w/2,l/2,0]) M2Nut(d);
                translate([-w/2,-l/2,0]) color("blue") M2Nut(d);
            } */
        }
        cylinder(h=10, d=45, center=true);

        // screws to rpi deck
        m3d = 6;
        translate([50-5/2-1, 0, 0]) M3(20);
        rotate([0,0,-20]) translate([-50+5/2+1, 0, 0]) M3(20);
        translate([0, 50-5/2-1, 0]) M3(20);
        rotate([0,0,20]) translate([0, -50+5/2+1, 0]) M3(20);

        // ydlidar/lds-01 lidar mount
        /* rotate([0,180,45]) translate([3,0,-4]){
            translate([22,31,0]) M3(20);
            translate([22,-31,0]) M3(20);
            translate([-35,25,0]) M3(20);
            translate([-35,-25,0]) M3(20);
        } */

        // rpylidar - tbd

        // hokuyo urg mount
        rotate([0,180,45]) translate([0,0,-4]){
            translate([20,20,2]) M2Nut(20);
            translate([20,-20,2]) M2Nut(20);
            translate([-20,20,2]) M2Nut(20);
            translate([-20,-20,2]) M2Nut(20);
        }

        // skeletonizing
        translate([dia/3+1, dia/3+1, -2]) rotate([0,0,-45]) scale([1.2,.85,1]) cylinder(h=10, d=50); // back
        translate([-dia/4-5, dia/2.5, -2]) rotate([0,0,35+10]) scale([.90,.75,1]) cylinder(h=10, d=50); // right
        translate([dia/2.5, -dia/4-5, -2]) rotate([0,0,35]) scale([.90,.75,1]) cylinder(h=10, d=50); // left
        translate([-dia/3, -dia/3, -2]) rotate([0,0,-45]) scale([1.75,.70,1]) cylinder(h=10, d=50); // front
    }

    // ydlidar standoffs
    rotate([0,0,45+180]) translate([3,0,0]){
        sod = 24;
        translate([22,31,0]) standoff(sod);
        translate([22,-31,0]) standoff(sod);
        translate([-35,25,0]) standoff(sod);
        translate([-35,-25,0]) standoff(sod);
    }

    // USB serial board
    rotate([0,180,45]) translate([-5,24,-4]){
        w = 26;  ww = w+6;
        l = 29;  ll = l+6;
        d = 10;

        // back USB, center lidar plate
        difference(){
            translate([-ww/2-2,-ll/2-1,0]) cube([ww+18,8,4]); // back-center
            translate([w/2,-l/2,1]) M2Nut(d);
            translate([-w/2,-l/2,1]) M2Nut(d);
        }
        M2standoff(w/2,-l/2,-1,1);
        M2standoff(-w/2,-l/2,-1,1);
        // front USB, side of plate with usb connectors
        difference(){
            translate([-w/2-10,l/2-8,0]) cube([ww+10,7+4,4]); // front-outside
            translate([w/2,l/2,1]) M2Nut(d);
            translate([-w/2,l/2,1]) M2Nut(d);
        }
        M2standoff(w/2,l/2,-1,1);
        M2standoff(-w/2,l/2,-1,1);
    }
}

module spacer(h, d){
    off = 2;
    difference()
    {
        cylinder(d=4.5,h=h);
        translate([0,0,-off]) cylinder(d=d,h=h+2*off);
    }
}

module M2standoff2(x,y,z,h){
    dia = 2.3;
    wide = 3;
    base = wide+dia+2;

    translate([x,y,z]) difference(){
        cylinder(h=h, d=base);
        cylinder(h=4*h, d=dia, center=true);
    }
}

module imu_bracket(){
    thick = 4;
    w = 8;
    off = 2;
    M2hole = 2.3;
    M2head = 4.5;

    // NXP
    ooff = 5.8/2;
    oo = 22.86;

    // Qwiic
    noff = 7;
    no = 20.32;

    difference()
    {
        union(){
            cube([oo+5,w,thick]);
            translate([ooff,w,0]) cylinder(d=5.8,h=thick);
            translate([ooff+oo,w,0]) cylinder(d=5.8,h=thick);

            M2standoff2(noff,0,0,thick+1);
            M2standoff2(noff+no,0,0,thick+1);
        }

        /* translate([28,-1,-1]) cube([10,5.5,thick+2]); */

        // nxp
        // head
        translate([ooff,w,thick/2]) cylinder(d=M2head, h=thick);
        translate([ooff+oo,w,thick/2]) cylinder(d=M2head, h=thick);
        // shaft
        translate([ooff,w,-off]) cylinder(d=M2hole, h=thick+2*off);
        translate([ooff+oo,w,-off]) cylinder(d=M2hole, h=thick+2*off);

        // qwiic
        translate([noff,0,3]) rotate([180,0,0]) M2Nut(10);
        translate([noff+no,0,3]) rotate([180,0,0]) M2Nut(10);
    }

    /* M2standoff(ooff,3,thick,3); */
    /* M2standoff(ooff+oo,3,thick,3); */
/*
    M2standoff(noff,0,0,thick+1);
    M2standoff(noff+no,0,0,thick+1); */
}

module dual_camera(){
    thick = 4;
    M3_shaft = 3.3;
    M2_shaft = 2.3;
    off = 2;
    ir = 20.32;
    w = 40+10; // x
    h = 21+10+3; // y
    cam_off = 2;
    difference()
    {
        union()
        {
            cube([w,h,thick]);
            translate([w/2-ir/2,cam_off+12.5-5,0]){
                a=6;
                b=8;
                hh=6;
                translate([ir,ir,thick]) cylinder(d2=a, d1=b, h=hh);
                translate([0,ir,thick]) cylinder(d2=a, d1=b, h=hh);
            }
            translate([w/2-21/2,cam_off,0]){
                a=3.3;
                b=4;
                translate([0,0,thick]) cylinder(d2=a,d1=b, h=2.5);
                translate([21,0,thick]) cylinder(d2=a,d1=b, h=2.5);
                translate([21,12.5,thick]) cylinder(d2=a,d1=b, h=2.5);
                translate([0,12.5,thick]) cylinder(d2=a,d1=b, h=2.5);
            }
        }

        //mount
        translate([5,5,0]){
            translate([0,0,0]) M3(thick); //cylinder(d=M3_shaft, h=thick+2*off);
            translate([40,0,0]) M3(thick); //cylinder(d=M3_shaft, h=thick+2*off);
            translate([40,21,0]) M3(thick); //cylinder(d=M3_shaft, h=thick+2*off);
            translate([0,21,0]) M3(thick); //cylinder(d=M3_shaft, h=thick+2*off);
            translate([0,21/2,0]) M3(thick); //cylinder(d=M3_shaft, h=thick+2*off);
            translate([40,21/2,0]) M3(thick); //cylinder(d=M3_shaft, h=thick+2*off);
        }

        // IR
        translate([w/2-ir/2,cam_off+12.5-5,0]){
            //translate([0,0,off]) rotate([180,0,0]) M3Nut(thick+2*off); //cylinder(d=M3_shaft, h=thick+2*off);
            //translate([ir,0,off]) rotate([180,0,0]) M3Nut(thick+2*off); //cylinder(d=M3_shaft, h=thick+2*off);
            translate([ir,ir,off]) rotate([180,0,0]) M3Nut(thick+12*off); //cylinder(d=M3_shaft, h=thick+2*off);
            translate([0,ir,off]) rotate([180,0,0]) M3Nut(thick+12*off); //cylinder(d=M3_shaft, h=thick+2*off);
        }

        // pi
        translate([w/2-21/2,cam_off,0]){
            translate([0,0,off]) rotate([180,0,0]) M2Nut(thick+12*off); //cylinder(d=M2_shaft, h=thick+2*off);
            translate([21,0,off]) rotate([180,0,0]) M2Nut(thick+12*off); //cylinder(d=M2_shaft, h=thick+2*off);
            translate([21,12.5,off]) rotate([180,0,0]) M2Nut(thick+12*off); //cylinder(d=M2_shaft, h=thick+2*off);
            translate([0,12.5,off]) rotate([180,0,0]) M2Nut(thick+12*off); //cylinder(d=M2_shaft, h=thick+2*off);
        }
    }

    /* translate([w/2-21/2,cam_off,0]){
        ww = 2;
        translate([-ww/2,2,0]) cube([ww, 8, thick+2.5]);
        translate([-ww/2+21,2,0]) cube([ww, 8, thick+2.5]);
    } */
}

dual_camera();
/* imu_bracket(); */
/* spacer(5,2.3); */


//COLOR1 = "red";
/* color(COLOR1) rpi_base(); */
//translate([0,-60,20]) rotate([90,0,0]) picamera();
/* rotate([0,0,90]) translate([2,0,6]) rpi3(); */
/* translate([0,0,30]) rotate([0,0,45]) lidar_base(); */
//translate([0,-2.5,34-13+2]) rotate([0,0,-90]) x4lidar();
