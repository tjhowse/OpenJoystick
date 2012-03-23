include <joystick_defines.scad>
use <joystick_4_way_hat_mk1.scad>
use <joystick_head.scad>

module joystick_handle()
{
	peg_height = 16;
	peg_offset_x = 3;
	peg_offset_z = 5;
	trigger_cutout_z = 20;
	trigger_cutout_x = 6.7;
	
	difference()
	{
		union()
		{
			translate([0,0,grip_rest_thickness])
				intersection()
				{
					scale([1,0.7,1]) cylinder(h = grip_height, r = (grip_diameter/2));
					//translate([0,0,grip_height/2])cube([grip_diameter,grip_clip,grip_height],true); 
				}
			cylinder(h = grip_rest_thickness, r = (grip_rest_diameter / 2));
			translate([peg_offset_x,0,grip_height-peg_offset_z]) cylinder(h = peg_height, r = (shaft_dia/2));
	
		}
		// Subtract hole through centre.
		translate([0,0,-zff])
			cylinder(h = (grip_height + grip_rest_thickness+ 2 * zff)-peg_height+peg_offset_z, r = (shaft_dia/2));
		
		translate([0,grip_cms_offset,grip_cms_height]) // I should be more clever about this.
				rotate([grip_cms_angle,0,0])
					scale([1.05,1.05,0])hull() {cms_stem();}
					//cms_stem();
					
					
		translate([0,0,grip_height+23.5]) rotate([0,0,90]) joystick_head_sidecuts();
		
		translate([peg_offset_x,0,grip_height-peg_offset_z]) 
		union()
		{
			translate([(shaft_dia/2)-2,0,peg_height/2]) cube([5,5,peg_height*2],true);
			translate([(-shaft_dia/2)+2,0,peg_height/2]) cube([5,5,peg_height*2],true);
			
		}
		translate([-(grip_diameter/2),0,grip_height-trigger_cutout_z+10]) union()
		{
			cylinder(r=trigger_cutout_x/2+1,h=trigger_cutout_z);
			translate([1,0,trigger_cutout_z/2]) cube([trigger_cutout_x,trigger_cutout_x,trigger_cutout_z],true);
		}
		
	}
	//translate([0,0,grip_height+23.5]) rotate([0,0,90]) joystick_head_with_boltholes(0);
	//translate([0,0,grip_height+23.5]) rotate([0,0,90]) color("red") import("joystick_head_noface.stl");	
	
	
}


module cms_stem()
{
	difference()
	{
		cylinder(h = grip_cms_stub_length, r = (grip_cms_stub_diameter/2));
		translate([0,0,grip_cms_stub_length-4_way_hat_base_z+zff]) hat_voids(4);
		translate([0,0,-zff]) cylinder(h = grip_cms_stub_length-4_way_hat_base_z+0.5, r = 4_way_hat_base_dia/2);
	}
}
//cube([100,100,200],true);
joystick_handle();
//cms_stem();
