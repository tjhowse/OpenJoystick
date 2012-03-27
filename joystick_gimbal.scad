include <joystick_defines.scad>
use <joystick_handle.scad>

inner_gimbal_x = 50;
inner_gimbal_y = 35;
inner_gimbal_z = 25;

joiner_z = 4;
joiner_x = 9;
joiner_stem_scalar = 4;

bearing_retain_thickness = 1;

temp = joiner_z/2;

springbar_offset = 2;
springbar_y = 20;
springbar_z = 5;
springbar_x = 8;

module joystick_joiner()
{
	total_y = inner_gimbal_y+2*bearing_retain_thickness;
	bolt_offset = 21.5;
	
	difference()
	{
		union()
		{
			scale([1,1,joiner_stem_scalar]) joystick_handle_peg(0);
			translate([-joiner_x/2,-total_y/2,0]) cube([joiner_x,total_y,joiner_z]);
		}
		translate([0,total_y/2-bearing_thickness+zff,joiner_z/2]) rotate([-90,0,0]) bearing(1);
		translate([0,-total_y/2-zff,joiner_z/2]) rotate([-90,0,0]) bearing(1);
		
		rotate([90,0,0]) translate([0,joiner_z/2,-bolt_offset]) bolt(3,3,1.45,10,0);
		rotate([-90,0,0]) translate([0,-joiner_z/2,-bolt_offset]) bolt(3,3,1.45,10,0);
		
		rotate([-90,0,0]) translate([0,-20,-12]) bolt(3,3,1.45,20,0);
		rotate([-90,0,0]) translate([0,-30,-12]) bolt(3,3,1.45,20,0);
		rotate([-90,0,0]) translate([0,-40,-12]) bolt(3,3,1.45,20,0);
		rotate([-90,0,0]) translate([0,-50,-12]) bolt(3,3,1.45,20,0);
	}
	
	
}

module joystick_inner_gimbal()
{
	total_x = inner_gimbal_x+2*bearing_retain_thickness;
	total_y = inner_gimbal_y+2*bearing_retain_thickness;

	difference()
	{
		union()
		{
			difference()
			{
				translate([-total_x/2, -total_y/2, -inner_gimbal_z/2])
					cube([total_x, total_y, inner_gimbal_z]);
				translate([-inner_gimbal_x/2+bearing_thickness, -inner_gimbal_y/2+bearing_thickness, -inner_gimbal_z/2])
					cube([inner_gimbal_x-2*bearing_thickness, inner_gimbal_y-2*bearing_thickness, inner_gimbal_z]);

				translate([0,total_y/2-bearing_thickness+zff,0]) rotate([-90,0,0]) bearing(0);
				translate([0,-total_y/2-zff,0]) rotate([-90,0,0]) bearing(0);
				rotate([90,0,0]) translate([0,0,-inner_gimbal_y/2]) cylinder(r=(bearing_outside_dia-4)/2,h=inner_gimbal_y);
				
				translate([total_x/2+zff,0,0]) rotate([0,-90,0]) bearing(0);
				translate([-total_x/2+bearing_thickness-zff,0,0]) rotate([0,-90,0]) bearing(0);
				rotate([0,90,0]) translate([0,0,-inner_gimbal_x/2]) cylinder(r=(bearing_outside_dia-4)/2,h=inner_gimbal_x);		 
			}
			//cueb!
			
			// Spring support stems
			translate([0,0,springbar_offset]) union()
			{
				translate([total_x/2-5, -total_y/2-5, -2.5]) cube([5,springbar_z,5]);
				translate([-total_x/2, -total_y/2-5, -2.5]) cube([5,springbar_z,5]);
				
				translate([total_x/2-5, -total_y/2-5, -2.5]) rotate([-45,0,0]) cube([5,springbar_z*sqrt(2),5]);
				
				translate([-total_x/2, -total_y/2-5, -2.5]) rotate([-45,0,0]) cube([5,springbar_z*sqrt(2),5]);
			}
		}
		translate([0,0,springbar_offset]) union()
		{
			translate([total_x/2-2.5, -total_y/2-16.5, 0]) rotate([-90,0,0]) bolt(3,3,1.45,20,0);
			translate([-total_x/2+2.5, -total_y/2-16.5, 0]) rotate([-90,0,0]) bolt(3,3,1.45,20,0);
		}
	}	
}

module joystick_stem_plug(lip_size)
{	
	difference()
	{
		union()
		{
			translate([0,0,lip_size]) cylinder(r=bearing_inside_dia/2,h=bearing_thickness);
			cylinder(r=bearing_inside_dia/2+1,h=lip_size);
		}
		translate([-joiner_z/2,-15, lip_size]) cube([joiner_z,30,bearing_thickness]);
		translate([0,0,-zff]) bolt(3,3,1.45,20,lip_size-3+2*zff);
	}
	//joiner_z
}

module joystick_stem_plug_springbar()
{
	// Keeping this in place for now.
	springbar_offset_old = 0;
	difference()
	{
		union()
		{
			joystick_stem_plug(springbar_z);
			translate([0,0,springbar_z/2]) cube([springbar_offset_old,springbar_y/2,springbar_z],true);	
			translate([springbar_offset_old,0,springbar_z/2]) cube([springbar_x,springbar_y,springbar_z],true);	
		}
		translate([0,0,-zff]) bolt(3,3,1.45,20,springbar_z-3+2*zff);
		translate([springbar_offset_old,-springbar_y/2+4,-10]) bolt(3,3,1.45,20,0);
		translate([springbar_offset_old,springbar_y/2-4,-10]) bolt(3,3,1.45,20,0);
	}
}

//translate([0,inner_gimbal_y/2+4+bearing_retain_thickness,0]) rotate([90,0,0]) rotate([0,0,90]) joystick_stem_plug(4);
rotate([0,0,180]) translate([0,inner_gimbal_y/2+springbar_z+bearing_retain_thickness,0]) rotate([90,0,0]) rotate([0,0,-90]) joystick_stem_plug_springbar();
//joystick_stem_plug_springbar();
//translate([13,0,0]) joystick_stem_plug(4);
//translate([0,0,-joiner_z/2]) joystick_joiner();
joystick_inner_gimbal();
