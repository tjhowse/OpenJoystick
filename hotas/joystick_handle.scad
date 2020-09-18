/*
	OpenJoystick - A project creating affordable, open source, 3D-printable custom flight-sim joysticks for everyone
	Copyright (C) 2012 Travis John Howse

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

include <joystick_defines.scad>
use <joystick_4_way_hat_mk1.scad>
use <joystick_head.scad>

big_cms_stem_support_z = 2.9;

module joystick_handle()
{
	trigger_cutout_z = 20;
	trigger_cutout_x = 6.7;
	peg_offset_z = 5;
	head_offset_x = -3;
	
	mirror([0,left_handed,0]) union()
	{
		difference()
		{
			union()
			{
				translate([0,0,grip_rest_thickness])
					difference()
					{
						scale([1,0.7,1]) cylinder(h = grip_height, r = (grip_diameter/2));
						//translate([-15,0,90]) rotate([0,-45,0]) translate([0,0,-50]) scale([1,0.7,1]) cylinder(h = grip_height, r = (grip_diameter/2));
						//translate([0,0,grip_height/2])cube([grip_diameter,grip_clip,grip_height],true); 
						translate([head_offset_x-4.5,0,grip_height]) rotate([0,-20,0]) translate([0,0,-50]) difference()
						{
							translate([0,-50,0]) cube([100,100,100]);
							scale([1,0.7,1]) cylinder(h = grip_height, r = (grip_diameter/2));
						}
					}
				translate([10,10,0]) scale([1.2,1,1]) cylinder(h = grip_rest_thickness, r = (grip_rest_diameter / 2));
				//translate([peg_offset_x,0,grip_height-peg_offset_z]) cylinder(h = peg_height, r = (shaft_dia/2));
				}
			// Subtract hole through centre.
			translate([0,0,-zff])
				cylinder(h = (grip_height + grip_rest_thickness+ 2 * zff), r = (shaft_dia/2));
			
			translate([0,grip_cms_offset,grip_height-grip_cms_height_offset]) // I should be more clever about this.
					rotate([grip_cms_angle,0,0])
					union()
					{
						scale([1.05,1.05,0]) cms_stem(1);
						//%cms_stem(0);
					}			
				
			//translate([0,0,grip_height+23.5]) rotate([0,0,90]) joystick_head_sidecuts();
			//translate([0,0,grip_height]) rotate([0,0,90]) #joystick_handle_sidecuts();
			translate([head_offset_x-2,0,grip_height+23.5]) rotate([0,0,90]) joystick_handle_sidecuts();
			
			rotate([0,0,90])translate([headbolt_x,headbolt_y-head_offset_x+3,headbolt_z+headbolt_extra+grip_height+21.5]) rotate([180,0,0]) bolt(3,3+headbolt_extra,1.45,20,0);
			rotate([0,0,90])translate([-headbolt_x,headbolt_y-head_offset_x+3,headbolt_z+headbolt_extra+grip_height+21.5]) rotate([180,0,0]) bolt(3,3+headbolt_extra,1.45,20,0);
					
			// Trigger cutout
			/*translate([-(grip_diameter/2),0,grip_height-trigger_cutout_z+10]) union()
			{
				cylinder(r=trigger_cutout_x/2+1,h=trigger_cutout_z);
				translate([1,0,trigger_cutout_z/2]) cube([trigger_cutout_x,trigger_cutout_x,trigger_cutout_z],true);
			}*/
			translate([22,0,10]) rotate([0,-90,0]) bolt(3,13,1.45,20,0);
		}
		translate([0,0,grip_height-peg_offset_z]) joystick_handle_peg(1);
		
		
		//translate([head_offset_x-3,0,grip_height+22.6]) rotate([0,0,90]) joystick_head_with_boltholes(0);
		translate([0,grip_cms_offset,grip_height-grip_cms_height_offset]) rotate([grip_cms_angle,0,0]) cms_stem(0);
	}
	//translate([head_offset_x-3,0,grip_height+22.6]) rotate([0,0,90]) import("joystick_head.stl");
	//translate([head_offset_x-3,0,grip_height+22.6]) rotate([0,0,90]) import("joystick_head_noface.stl");
}

module joystick_handle_parts(half)
{
	// half = 0 - All
	// half = 1 - Bottom
	// half = 2 - Top
	
	split_z = 40;
	extra_bolt = 15;
	thread_len = 10;
	peg_offset_z = 5;
	
	difference()
	{
		joystick_handle();
		if (half == 1)
		{
			translate([-100,-100,split_z]) cube([200,200,100]);
		} else if (half == 2)
		{
			translate([-100,-100,split_z-100]) cube([200,200,100]);
		}
		
		// Perfectly functional, but you can't reach the bolt heads easily.
		//translate([20,0,split_z-12]) rotate([0,-30,0]) translate([0,0,-extra_bolt+2]) #bolt(3,3+extra_bolt,1.45,20,thread_len);
		//rotate([0,0,180]) translate([20,0,split_z-12]) rotate([0,-30,0]) translate([0,0,-extra_bolt+2]) #bolt(3,3+extra_bolt,1.45,20,thread_len);
		
		translate([20,0,split_z+12]) rotate([0,210,0]) translate([0,0,-extra_bolt+2]) bolt(3,3+extra_bolt,1.45,20,thread_len);
		rotate([0,0,180]) translate([20,0,split_z+12]) rotate([0,210,0]) translate([0,0,-extra_bolt+2]) bolt(3,3+extra_bolt,1.45,20,thread_len);
	}
	
	if (half == 1)
	{
		//translate([0,0,split_z-peg_offset_z-2]) joystick_handle_peg(1);
	}
}

module joystick_handle_peg(support)
{
	peg_height = 14;
	support_width = shaft_dia;
	
	difference()
	{
		union()
		{
			cylinder(h = peg_height, r = (shaft_dia/2));
			if (support)
			{	
				translate([-extrusion_width/2-(shaft_dia/2)+4.9,-support_width/2,-3]) cube([extrusion_width,support_width,3]);
				translate([-extrusion_width/2+(shaft_dia/2)-4.9,-support_width/2,-3]) cube([extrusion_width,support_width,3]);
			}
		}
		union()
		{
			translate([(shaft_dia/2)-2,0,peg_height/2]) cube([5,5,peg_height*2],true);
			translate([(-shaft_dia/2)+2,0,peg_height/2]) cube([5,5,peg_height*2],true);
			translate([0,0,-0.5]) cylinder(r=0.5,h=peg_height);
		}
	}
}

module joystick_handle_sidecuts()
{
	// Mostly copied from joystick_head_sidecuts()
/*	side_cut_y = -17;	
	side_cut_z = 30;
	side_cut_z_scale = 1.5;
	union()
	{
		translate([-20,side_cut_y,-50]) rotate([-45,0,0]) scale([0.6,1,side_cut_z_scale]) translate([0,0,side_cut_z]) sphere(r=20);
	}
	union()
	{
		translate([20,side_cut_y,-50]) rotate([-45,0,0]) scale([0.6,1,side_cut_z_scale]) translate([0,0,side_cut_z]) sphere(r=20);
	}*/
	
	side_cut_x = 18.7;
	side_cut_y = 18.5;
	//side_cut_z = 20;
	side_cut_z = 33;
	side_cut_x_scale = 0.54;
	side_cut_y_scale = 1.38;
	//side_cut_z_scale = 1.5;
	side_cut_z_scale = 1;
	union()
	{
		translate([-side_cut_x,side_cut_y,-50]) scale([side_cut_x_scale,side_cut_y_scale,side_cut_z_scale]) translate([0,0,side_cut_z]) sphere(r=20);
	}
	union()
	{
		translate([side_cut_x,side_cut_y,-50]) scale([side_cut_x_scale,side_cut_y_scale,side_cut_z_scale]) translate([0,0,side_cut_z]) sphere(r=20);
	}
	
	
}
module cms_stem(bolt)
{
	bolt_x = -22;
	bolt_y = grip_cms_stub_diameter/4+1.3;
	bolt_z = 18;
	
	baseplug_z = pb_z+1;
	
	pb_puff = 1.05;
	pb_xy_puff = pb_xy*pb_puff;
	pb_z_puff = pb_z*pb_puff;
	

	//grip_cms_twist = 20;
	if (bolt)
	{
		cylinder(h = grip_cms_stub_length, r = (grip_cms_stub_diameter/2));
		translate([bolt_x,bolt_y,bolt_z]) rotate([0,90,0]) bolt(3,3+10,1.45,20,17);
	} else
	{
		difference()
		{
			union()
			{
				difference()
				{
					cylinder(h = grip_cms_stub_length, r = (grip_cms_stub_diameter/2));
					translate([0,0,grip_cms_stub_length-4_way_hat_base_z+zff]) rotate([0,0,grip_cms_twist]) hat_voids(4);
					translate([0,0,-zff+baseplug_z]) cylinder(r = grip_cms_stub_diameter/2-1.6,h = grip_cms_stub_length-4_way_hat_base_z+3*zff-baseplug_z);
					translate([0,0,-zff]) cylinder(r = 2.25, h = baseplug_z+zff);
					
					translate([-pb_xy_puff/2,-pb_xy_puff/2,1]) cube([pb_xy_puff,20,pb_z_puff]);
					
				}
				translate([0,0,1]) rotate([0,0,180]) scale([1,1,1]) pb(1.1, 0);
				// Support material experiment
				rotate([0,0,grip_cms_twist])
				{
					//cms_stem_support(0.74);
					cms_stem_support(big_cms_stem_support_z);
					//rotate([0,0,90]) cms_stem_support(0.77);
					rotate([0,0,90]) cms_stem_support(1.7);
				}
			}
			translate([bolt_x,bolt_y,bolt_z]) rotate([0,90,0]) bolt(3,3+10,1.45,20,17);
			translate([0,(grip_cms_stub_diameter/2)-1.6,baseplug_z]) rotate([0,0,0]) scale([1.1,1.1,1.1]) hull(){cms_hat_stem(0);}
		}
	}
}

module cms_stem_retainer()
{
	guide_z = 2;
	wire_clearance = 1.4;
	wire_gap = 3.5;
	pb_puff = 1.05;
	
	cube([pb_xy,pb_xy*pb_puff-1,pb_z+guide_z-wire_clearance]);
	translate([(pb_xy-wire_gap)/2,0,pb_z+guide_z-wire_clearance]) cube([wire_gap,pb_xy*pb_puff-1,wire_clearance]);
	translate([0,-pb_xy*pb_puff,0]) difference()
	{
		cube([pb_xy,pb_xy*pb_puff,guide_z]);
		translate([pb_xy/2,pb_xy*pb_puff/2,0]) cylinder(r=2,h=10);
	}
}

module cms_stem_support(support_z)
{
	support_x = 3.2;
	support_thickness = extrusion_width; // My extrusion width.
	//support_start_z = 0.75;
	//support_z = (1-support_start_z)*grip_cms_stub_length-4_way_hat_base_z;

	//translate([support_x,0,(grip_cms_stub_length*support_start_z-4_way_hat_base_z)]) cube([support_thickness,4_way_hat_base_dia*0.8,(grip_cms_stub_length*support_start_z-4_way_hat_base_z)],true);
	//translate([-support_x,0,(grip_cms_stub_length*support_start_z-4_way_hat_base_z)]) cube([support_thickness,4_way_hat_base_dia*0.8,(grip_cms_stub_length*support_start_z-4_way_hat_base_z)],true);
	translate([-support_x-support_thickness/2,-(4_way_hat_base_dia*0.8/2),grip_cms_stub_length-4_way_hat_base_z-support_z])
		cube([support_thickness,4_way_hat_base_dia*0.8,support_z]);
	translate([support_x-support_thickness/2,-(4_way_hat_base_dia*0.8/2),grip_cms_stub_length-4_way_hat_base_z-support_z])
		cube([support_thickness,4_way_hat_base_dia*0.8,support_z]);
	
}

module cms_hat_stem(hole)
{
	//height = 15;
	socket_z = 5;
	height = 4_way_hat_base_z+big_cms_stem_support_z+4_way_hat_peg_stem_hole_z;
	//bolt(8.5/2, 1.5, 4.5/2, height,0);
	difference()
	{
		cylinder(r=8.5/2,h=1.5+socket_z);
		if(hole)
		{
			cylinder(r=1.55,h=socket_z);
		}
	}
	translate([0,0,1.5+socket_z-zff]) cylinder(r=4.5/2, h=height);
}

//%cube([100,100,220],true);

//left_handed = 0;
//joystick_handle();
//cms_stem(0);
//rotate([0,180,0]) translate([-pb_xy/2,2.5,-7]) %cms_stem_retainer();

translate([0,20,0]) cms_stem_retainer();
//translate([pb_xy/2,17,7]) rotate([180,0,0]) pb(1.1, 0);
//translate([0,0,23]) cms_hat_stem(1);

//cms_hat_stem(1);

//switch_hat_saddle();
//joystick_handle_parts(2);
//joystick_handle_parts(1);
//joystick_handle_peg();

//joystick_handle_sidecuts();
//%joystick_head_sidecuts();
//translate([50,50,0]) cms_stem(0);

