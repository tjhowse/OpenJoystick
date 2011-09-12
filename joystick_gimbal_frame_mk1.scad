include <joystick_defines.scad>

gimbal_frame();

gimbal_frame_bolt_depth = 15;

module gimbal_frame()
{
	difference()
	{
		cube([gimbal_frame_x,gimbal_frame_y,gimbal_frame_z], center=true);
		// Boosted zff right up here, don't know why it's required, but it is.
		translate([0,0,-zff])
			cube([gimbal_frame_x-(2*gimbal_frame_thickness),gimbal_frame_y-(2*gimbal_frame_thickness),gimbal_frame_z + 30*zff], center=true);

		// X rot bearings 
		translate([gimbal_frame_x/2+zff - (gimbal_frame_thickness-bearing_thickness),0,0])
			rotate([0,-90,0])
				bearing();
		translate([-gimbal_frame_x/2-zff + (gimbal_frame_thickness-bearing_thickness),0,0])
			rotate([0,90,0])
				bearing();

		translate([-(gimbal_frame_x/2)-zff,0,0])
			rotate([0,90,0])
				cylinder(h=(gimbal_frame_x+2*zff), r=(bearing_inside_dia/2), $fn=50);
		// Bolt holes 
		translate([-gimbal_frame_x/2 + gimbal_frame_thickness/2, -gimbal_frame_y/2 + gimbal_frame_thickness/2,gimbal_frame_z/2+zff-gimbal_frame_bolt_depth])
			cylinder(r = 1.5, h=gimbal_frame_bolt_depth + zff, $fn=50);
		translate([gimbal_frame_x/2 - gimbal_frame_thickness/2, gimbal_frame_y/2 - gimbal_frame_thickness/2,gimbal_frame_z/2+zff-gimbal_frame_bolt_depth])
			cylinder(r = 1.5, h=gimbal_frame_bolt_depth + zff, $fn=50);
		translate([gimbal_frame_x/2 - gimbal_frame_thickness/2, -gimbal_frame_y/2 + gimbal_frame_thickness/2,gimbal_frame_z/2+zff-gimbal_frame_bolt_depth])
			cylinder(r = 1.5, h=gimbal_frame_bolt_depth + zff, $fn=50);
		translate([-gimbal_frame_x/2 + gimbal_frame_thickness/2, gimbal_frame_y/2 - gimbal_frame_thickness/2,gimbal_frame_z/2+zff-gimbal_frame_bolt_depth])
			cylinder(r = 1.5, h=gimbal_frame_bolt_depth + zff, $fn=50);

	}
}