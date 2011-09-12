include <joystick_defines.scad>

module joystick_handle()
{
	difference()
	{
		union()
		{
			translate([0,0,grip_rest_thickness])
				intersection()
				{
					cylinder(h = grip_height, r = (grip_diameter/2), $fn = circle_faces);
					translate([0,0,grip_height/2])cube([grip_diameter,grip_clip,grip_height],true); 
				}
			translate([0,grip_cms_offset,grip_cms_height]) // I should be more clever about this.
				rotate([grip_cms_angle,0,0])
					cylinder(h = grip_cms_stub_length, r = (grip_cms_stub_diameter/2), $fn =circle_faces);

			cylinder(h = grip_rest_thickness, r = (grip_rest_diameter / 2), $fn = circle_faces);
			
			// Head
			translate([grip_head_offset_x,0,grip_height + grip_rest_thickness+4_way_hat_base_dia])
				difference()
				{
					cube([grip_head_box_x,grip_head_box_y,grip_head_box_z],center=true);
					
					translate([0.525*4_way_hat_base_dia *2,0,0.525*4_way_hat_base_dia *2])
						rotate([0,45,0,]) // These dimensions are unimportant as long as it cuts the chamfer in the head
							cube([grip_head_box_x*1.5,grip_head_box_y*1.5,50], center = true);
				}
		}
		// Subtract hole through centre.
		translate([0,0,-zff])
			cylinder(h = (grip_height + grip_rest_thickness+ 2 * zff), r = (shaft_dia/2), $fn = circle_faces);
		
		
		
		// Subtract holes for hats
		// CMS
		translate([0,grip_cms_offset,grip_cms_height]) // I should be more clever about this.
			rotate([grip_cms_angle,0,0])
				translate([0,0,grip_cms_stub_length-4_way_hat_base_z+zff])
					//cylinder(h = 4_way_hat_base_z, r = (4_way_hat_base_dia/2), $fn = circle_faces);
					hat_cutout();
							
		

		//TMS 
		translate([grip_head_offset_x,0,grip_height + grip_rest_thickness+4_way_hat_base_dia])
			rotate([0,45,0])
				translate([15,-11.5,-1.8])
					#cylinder(h = 4_way_hat_base_z, r = (4_way_hat_base_dia/2), $fn = circle_faces);
		// DMS
		translate([grip_head_offset_x,0,grip_height + grip_rest_thickness+4_way_hat_base_dia])
			rotate([0,45,0])
				translate([18,11.5,-1.8])
					#cylinder(h = 4_way_hat_base_z, r = (4_way_hat_base_dia/2), $fn = circle_faces);
					
		// TRIM
		translate([grip_head_offset_x,0,grip_height + grip_rest_thickness+4_way_hat_base_dia])
			rotate([0,45,0])
				translate([-10,11.5,-1.8])
					#cylinder(h = 4_way_hat_base_z, r = (4_way_hat_base_dia/2), $fn = circle_faces);

	}
}

joystick_handle();
