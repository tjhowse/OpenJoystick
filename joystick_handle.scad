include <joystick_defines.scad>
use <joystick_4_way_hat_mk1.scad>
use <joystick_head.scad>

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
			cylinder(h = grip_rest_thickness, r = (grip_rest_diameter / 2), $fn = circle_faces);		
	
		}
		// Subtract hole through centre.
		translate([0,0,-zff])
			cylinder(h = (grip_height + grip_rest_thickness+ 2 * zff), r = (shaft_dia/2), $fn = circle_faces);
		
		translate([0,grip_cms_offset,grip_cms_height]) // I should be more clever about this.
				rotate([grip_cms_angle,0,0])
					scale([1.05,1.05,0])hull() {cms_stem();}
	}
	
	translate([0,0,grip_height+23.5]) rotate([0,0,90]) joystick_head_with_boltholes(2);
}

module cms_stem()
{
	difference()
	{
		cylinder(h = grip_cms_stub_length, r = (grip_cms_stub_diameter/2), $fn =circle_faces);
		translate([0,0,grip_cms_stub_length-4_way_hat_base_z+zff]) hat_voids(4);
		translate([0,0,-zff]) cylinder(h = grip_cms_stub_length-4_way_hat_base_z+0.5, r = 4_way_hat_base_dia/2, $fn =circle_faces);
	}
}

joystick_handle();
//cms_stem();
