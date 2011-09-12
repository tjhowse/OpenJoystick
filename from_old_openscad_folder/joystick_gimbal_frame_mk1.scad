include <joystick_defines.scad>

gimbal_frame();


module gimbal_frame()
{
	difference()
	{
		cube([gimbal_frame_x,gimbal_frame_y,gimbal_frame_z], center=true);
		// Boosted z_fight_fudge right up here, don't know why it's required, but it is.
		translate([0,0,-z_fight_fudge])
			cube([gimbal_frame_x-(2*gimbal_frame_thickness),gimbal_frame_y-(2*gimbal_frame_thickness),gimbal_frame_z + 30*z_fight_fudge], center=true);

		// X rot bearings 
		translate([gimbal_frame_x/2+z_fight_fudge,0,0])
			rotate([0,-90,0])
				bearing();
		translate([-gimbal_frame_x/2-z_fight_fudge,0,0])
			rotate([0,90,0])
				bearing();

		translate([-(gimbal_frame_x/2),0,0])
			rotate([0,90,0])
				cylinder(h=(gimbal_frame_x), r=(bearing_inside_dia/2)*1.1, $fn=circle_faces);
	}
}