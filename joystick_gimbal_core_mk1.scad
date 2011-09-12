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
		translate([0,gimbal_core_y/2+zff,0])
			rotate([90,0,0])
				bearing();
		translate([0,-gimbal_core_y/2-zff,0])
			rotate([-90,0,0])
				bearing();
		// X rot pin holes
		translate([-(gimbal_core_x/2)-zff,0,0])
			rotate([0,90,0])
				cylinder(h=x_rot_pin_depth, r = (bearing_inside_dia/2), $fn=50);
		translate([(gimbal_core_x/2)+zff,0,0])
			rotate([0,-90,0])
				cylinder(h=x_rot_pin_depth, r = (bearing_inside_dia/2), $fn=50);
		// Shaft slot
		for (n = [-9:9])
		{
			rotate([0,(n/3)*10,0])
				translate([0,0,-50])
					cylinder(h=100, r = (shaft_dia/2),  $fn=50);
		}
		// Shaft pin
		translate([0,gimbal_core_y/2+zff,0])
			rotate([90,0,0])
				cylinder(h=(gimbal_core_y+2*zff), r= (bearing_inside_dia/2), $fn = 50);

		// Chamfers
		//translate([-(gimbal_core_x/2),-(gimbal_core_y/2),-(gimbal_core_z/2)])
			//chamfer_block();
		
	}
}
