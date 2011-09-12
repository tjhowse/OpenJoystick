// Standard skate bearing
bearing_inside_dia = 8;
bearing_outside_dia = 22;
bearing_thickness = 7;

// Arbitrary value
shaft_dia = 15;

z_fight_fudge = 0.05;
//z_fight_fudge = 0;

// Set this to 1 to translate everything to printable mode
printable_mode = 0;

// Gimba corel block sizes 
gimbal_core_x = 50;
gimbal_core_y = 30;
gimbal_core_z = gimbal_core_y;

// Gimbal frame sizes 

gimbal_frame_thickness = 10; 

// The 1.8 is 2sin(45)ish, the maximum y on the xy plane the core can occupy
gimbal_frame_x = gimbal_core_x+2*gimbal_frame_thickness+2; 
gimbal_frame_y = (gimbal_core_y * 1.8)+gimbal_frame_thickness;
gimbal_frame_z = gimbal_core_z;

circle_faces = 50;

module bearing()
{
	difference()
	{
		cylinder(h=7+2*z_fight_fudge, r = (bearing_outside_dia/2), $fn=circle_faces);

		/*translate([0,0,-z_fight_fudge])
			%cylinder(h=9, r = (bearing_inside_dia/2), $fn=circle_faces);*/
	}
}
		