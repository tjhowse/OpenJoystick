// Wall thickness
wt = 5;
// Pre-drill hole/groove depth
pd_z = 2;
// Grid spacing for the straight pre-drill grooves
grid_xy = 5;
// A list of radii for the circular pre-drill grooves
circles_r = [10, 30]
// Overall width/height
unit_xy = 100;
unit_z = 70;


module base() {

    difference () {
        cube([unit_xy, unit_xy, unit_z]);
        translate([wt, wt, wt]) cube([unit_xy-2*wt, unit_xy-2*wt, unit_z]);
    }
}