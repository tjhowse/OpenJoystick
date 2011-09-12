include <joystick_defines.scad>

x_rot_pin_depth = 10;

gimbal_core();

module gimbal_core()
{
	translate([0,0,(gimbal_core_z/2) * printable_mode])
	difference()
	{
		cube([gimbal_core_x, gimbal_core_y, gimbal_core_z], center=true);
		// Y rot bearings
		translate([0,gimbal_core_y/2+z_fight_fudge,0])
			rotate([90,0,0])
				bearing();
		translate([0,-gimbal_core_y/2-z_fight_fudge,0])
			rotate([-90,0,0])
				bearing();
		// X rot pin holes
		translate([-(gimbal_core_x/2)-z_fight_fudge,0,0])
			rotate([0,90,0])
				cylinder(h=x_rot_pin_depth, r = (bearing_inside_dia/2), $fn=circle_faces);
		translate([(gimbal_core_x/2)+z_fight_fudge,0,0])
			rotate([0,-90,0])
				cylinder(h=x_rot_pin_depth, r = (bearing_inside_dia/2), $fn=circle_faces);
		// Shaft slot
		for (n = [-9:9])
		{
			rotate([0,(n/3)*10,0])
					cube([shaft_dia, shaft_dia,100],center=true);
					//cylinder(h=100, r = (shaft_dia/2),  $fn=circle_faces);
					
		}
		// Shaft pin
		translate([0,gimbal_core_y/2+z_fight_fudge,0])
			rotate([90,0,0])
				cylinder(h=(gimbal_core_y+2*z_fight_fudge), r= (bearing_inside_dia/2)*1.1, $fn = circle_faces);

		// Chamfers
		//translate([-(gimbal_core_x/2),-(gimbal_core_y/2),-(gimbal_core_z/2)])
			//chamfer_block();
		
	}
}