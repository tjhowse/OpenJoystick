// Wall thickness
wt = 5;
// Pre-drill hole/groove depth
pd_groove_z = 2;
pd_groove_x = 1;
pd_hole_r = 1.5;
pd_hole_z = pd_groove_z;
// Grid spacing for the straight pre-drill grooves
pd_grid_xy = 10;
// Leave this much room around the edge without pre-drill grooves/holes.
pd_grid_clearance = 10;
// A list of radii for the circular pre-drill grooves
circles_r = [10, 20, 30, 40];
// Overall width/height
unit_xy = 100;
unit_z = 70;

// groove_cone is used to cut the grooves and holes in the
// underside of the lid
module groove_cone() {
    cylinder(r1=0, r2=10, h=10, $fn=10);
}

// pd_cylinder is used to cut the pre-drill holes.
module pd_cylinder() {
    cylinder(r=pd_hole_r, h=10);
}

module base() {
    difference () {
        cube([unit_xy, unit_xy, unit_z-wt/2]);
        translate([wt, wt, wt]) cube([unit_xy-2*wt, unit_xy-2*wt, unit_z]);
    }
}

module lid_whole() {
    union()
    {
        cube([unit_xy, unit_xy, wt/2]);
        translate([wt,wt,wt/2])
            cube([unit_xy-wt*2, unit_xy-wt*2, wt/2]);
    }
}

// lid_lines is half of the straight lines in the underside of the lid
module lid_lines() {
    for (x = [pd_grid_clearance:pd_grid_xy:unit_xy-pd_grid_clearance]) {
        translate([x-pd_groove_x/2, pd_grid_clearance, 0]) cube([pd_groove_x, unit_xy-2*pd_grid_clearance, 10]);
    }
}

// lid_grid is subtracted from the lid to provide the grid
// lines to assist with drilling accurately spaced holes or
// punching out neat sections.
module lid_grid() {
    lid_lines();
    translate([unit_xy, 0, 0]) rotate([0,0,90]) lid_lines();
    for (x = [pd_grid_clearance:pd_grid_xy:unit_xy-pd_grid_clearance]) {
        for (y = [pd_grid_clearance:pd_grid_xy:unit_xy-pd_grid_clearance]) {
            translate([x, y, 0]) pd_cylinder();
        }
    }
}
// lid_grid();

// lid_circles is subtracted from the underside of the lid
// to make it easier to punch out portions of the lid to mount
// stuff.
module lid_circles() {
    // This should be 100, but it makes my laptop cry.
    // Consider doing this with two subtracted cylinders
    // rather than a circle of cones.
    cone_n = 10;

    for (r = circles_r) {
        difference() {
            cylinder(r=r+pd_groove_x/2, h=10);
            cylinder(r=r-pd_groove_x/2, h=10);
        }
    }
}
// lid_circles();

module lid() {
    difference() {
        lid_whole();
        translate([unit_xy/2, unit_xy/2, wt-pd_groove_z]) lid_circles();
        translate([0, 0, wt-pd_hole_z]) lid_grid();
    }
}
render() lid();
module assembled() {
    base();
    translate([0,unit_xy,unit_z])
        rotate([180,0,0])
            #lid();

}
// lid();
// assembled();
// base();