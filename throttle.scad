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

throttle_right_x = 50;
throttle_right_y = 50;
throttle_right_z = 55;
//throttle_right_z = 70;

wall_thickness = 3;
//wall_thickness = 1;
plate_thickness = 4_way_hat_base_z-1;

screw_support_x = 10;

throttle_stem_x = 25;
throttle_stem_y = 60;
throttle_stem_z = 15;
throttle_stem_thickness = 3;

plate_clearance = 0.3;
plate_z_clearance = 0.3;
plate_clearance = 0.5;

3ts_x = 12.7;
3ts_y = 11.5;
3ts_z = 12.9;
3ts_thread_dia = 6;
3ts_thread_z = 9;
3ts_nut_dia = 9.1;
3ts_stem_dia = 2.9;
3ts_stem_z = 10.3;

// Based on measurements from a boat switch on the TM warthog
boat_switch_x = 20;
boat_switch_y = 10;
boat_switch_z = 10;
step_x = 2.5;
step_z = 0.8;

module throttle_right()
{
	difference()
	{
		union()
		{
			cube([throttle_right_x,throttle_right_y,throttle_right_z]);
			translate([throttle_right_x/2, throttle_right_y,0]) cylinder(r=throttle_right_x/2,h=throttle_right_z);
		}
		union()
		{
			translate([wall_thickness,wall_thickness,wall_thickness]) cube([throttle_right_x-wall_thickness+2*zff,throttle_right_y-wall_thickness,throttle_right_z-wall_thickness+2*zff]);
			translate([throttle_right_x/2, throttle_right_y,wall_thickness]) cylinder(r=(throttle_right_x/2)-wall_thickness,h=throttle_right_z-wall_thickness+2*zff);
		}
		// Hole for wires
		translate([throttle_right_x/2-wall_thickness,0,wall_thickness]) cube([wall_thickness*2,wall_thickness,wall_thickness]);
	}
	
	// Vertical screwholes
	translate([wall_thickness,wall_thickness+5,throttle_right_z-plate_thickness-plate_z_clearance]) screw_support(0);
	translate([wall_thickness,2*wall_thickness+throttle_right_y,throttle_right_z-plate_thickness-plate_z_clearance]) screw_support(0);
	translate([throttle_right_x-(screw_support_x/2)-plate_thickness-plate_z_clearance,wall_thickness,throttle_right_z-plate_thickness-plate_z_clearance]) rotate([0,0,90]) screw_support(0);
	translate([throttle_right_x-wall_thickness,2*wall_thickness+throttle_right_y,throttle_right_z-plate_thickness-plate_z_clearance]) rotate([0,0,180]) screw_support(0);
	
	// Horizontal screwholes
	translate([throttle_right_x-plate_thickness-plate_z_clearance,wall_thickness+screw_support_x/2,wall_thickness]) screw_support(1);
	translate([throttle_right_x-plate_thickness-plate_z_clearance,throttle_right_y-wall_thickness*2,wall_thickness]) screw_support(1);
	
	// Lip
	translate([throttle_right_x-wall_thickness-plate_thickness-plate_z_clearance,wall_thickness,wall_thickness]) cube([wall_thickness,throttle_right_y,wall_thickness]);
	translate([throttle_right_x-wall_thickness-plate_thickness-plate_z_clearance,wall_thickness,wall_thickness]) cube([wall_thickness,wall_thickness,throttle_right_z-plate_thickness-wall_thickness-plate_z_clearance]);
	translate([throttle_right_x-wall_thickness-plate_thickness-plate_z_clearance,throttle_right_y-wall_thickness,wall_thickness]) cube([wall_thickness,wall_thickness*2,throttle_right_z-plate_thickness-wall_thickness-plate_z_clearance]);
	translate([throttle_right_x-wall_thickness-plate_thickness-plate_z_clearance,throttle_right_y,wall_thickness]) 
		cube([plate_thickness+plate_z_clearance,wall_thickness,throttle_right_z-plate_thickness-wall_thickness-plate_z_clearance]);
	
	translate([throttle_right_x/2-throttle_stem_x/2,0.5,0]) throttle_stem();
}

module throttle_stem()
{	
	hinge_sleve_z = throttle_stem_z+10;

	translate([0,-throttle_stem_y,0])
	union()
	{
		difference()
		{
			cube([throttle_stem_x-zff, throttle_stem_y-zff, throttle_stem_z-zff]);
			translate([throttle_stem_thickness,0,throttle_stem_thickness]) cube([throttle_stem_x-2*throttle_stem_thickness, throttle_stem_y, throttle_stem_z-throttle_stem_thickness]);
			translate([throttle_stem_x/2,10,0]) cylinder(r=4,h=hinge_sleve_z);
		}
		translate([throttle_stem_x/2,10,0]) difference()
		{
			union()
			{
				cylinder(r=6,h=hinge_sleve_z);
				translate([-throttle_stem_x/2,-1.5,0]) cube([throttle_stem_x,3,throttle_stem_z]);
			}
			cylinder(r=4,h=hinge_sleve_z);
		}
	}
}

module throttle_endplate()
{
	switch_spacing = 13;
	difference()
	{
		union()
		{
			translate([0,0,zff])
				cube([throttle_right_x-wall_thickness-plate_clearance,throttle_right_y-wall_thickness-plate_clearance,plate_thickness-2*zff]);
			translate([0,0,zff]) translate([(throttle_right_x-2*wall_thickness)/2-plate_clearance/2,throttle_right_y-wall_thickness-plate_clearance,0])
				//cylinder(r=(throttle_right_x-2*wall_thickness)/2,h=plate_thickness-2*zff);
				cylinder(r=(throttle_right_x-2*wall_thickness-plate_clearance)/2,h=plate_thickness-2*zff);
			translate([throttle_right_x/2-wall_thickness,throttle_right_y/6+switch_spacing,plate_thickness]) 3_throw_switch_adds();
			translate([throttle_right_x/2-wall_thickness,throttle_right_y/6+2*switch_spacing,plate_thickness]) 3_throw_1_no_adds();
		}
		
		translate([screw_support_x/2-plate_clearance/2,screw_support_x/2-plate_clearance/2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		translate([throttle_right_x-(screw_support_x/2)-plate_thickness-wall_thickness-plate_clearance/2-plate_z_clearance,screw_support_x/2-plate_clearance/2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		translate([screw_support_x/2-plate_clearance/2,2*wall_thickness+throttle_right_y-wall_thickness-plate_clearance/2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		translate([throttle_right_x-2*wall_thickness-screw_support_x/2-plate_clearance/2,2*wall_thickness+throttle_right_y-wall_thickness-plate_clearance/2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		
		translate([throttle_right_x/2-wall_thickness,throttle_right_y+switch_spacing/2,-1]) hat_voids(4);
		translate([throttle_right_x/2-wall_thickness,throttle_right_y/6,-1]) rotate([0,0,90]) hat_voids(2);
		//translate([throttle_right_x/2-wall_thickness,throttle_right_y/6+switch_spacing,-1]) rotate([0,0,90]) hat_voids(2);
		translate([throttle_right_x/2-wall_thickness,throttle_right_y/6+switch_spacing,-1+zff]) 3_throw_switch_voids();
		//translate([throttle_right_x/2-wall_thickness,throttle_right_y/6+2*switch_spacing,-1]) rotate([0,0,90]) hat_voids(2);
		//translate([throttle_right_x/2-wall_thickness,throttle_right_y/6+2*switch_spacing,-1]) 3_throw_switch_voids();
		translate([throttle_right_x/2-wall_thickness,throttle_right_y/6+2*switch_spacing,-1+zff]) #3_throw_1_no_voids(position)
		
		translate([throttle_right_x-wall_thickness-plate_thickness/2-plate_clearance/2,(throttle_right_y-wall_thickness)/2-3,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		
	}
}

module throttle_backplate()
{
	switch_spacing = 21;
	top_dist = 2*throttle_right_y/3;
	
	//wall_thickness+screw_support_x/2
	
	difference()
	{
		translate([0,0,-zff]) cube([throttle_right_z-wall_thickness-plate_thickness-plate_clearance,throttle_right_y-wall_thickness-plate_clearance,plate_thickness]);
	
		translate([throttle_right_z-wall_thickness-plate_thickness-screw_support_x/2-plate_clearance/2,screw_support_x/2-plate_clearance/2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		translate([throttle_right_z-wall_thickness-plate_thickness-screw_support_x/2-plate_clearance/2,throttle_right_y-3*wall_thickness-plate_clearance/2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
	
		translate([(throttle_right_z-wall_thickness-plate_thickness)/2-switch_spacing/2,top_dist,-1]) hat_voids(4);
		translate([(throttle_right_z-wall_thickness-plate_thickness)/2+switch_spacing/2,top_dist,-1]) hat_voids(4);
		
		translate([-6,(throttle_right_y-wall_thickness)/2-3,plate_thickness/2]) rotate([0,90,0]) bolt(3,3,1.45,20,0);
	}
}

module screw_support(orient)
{
	// orient 0 - vertical, 1 - horizontal.
	
	height = 20;
	
	if (orient == 0)
	{
		translate([5,0,-height]) difference()
		{
			union()
			{
				cylinder(r=screw_support_x/2,h=height);
				translate([-(screw_support_x/2),-(screw_support_x/2),0]) cube([screw_support_x/2,screw_support_x,height]);
			}
			translate([0,0,height+3.1]) rotate([180,0,0]) bolt(3,3,1.45,20,0);
			translate([-(screw_support_x/2),-(screw_support_x/2),0]) rotate([0,45,0]) cube([100,100,100]);
		}
	} else {
		translate([-height,0,5]) rotate([0,-90,180]) difference()
			{
				union()
				{
					cylinder(r=screw_support_x/2,h=height);
					translate([-(screw_support_x/2),-(screw_support_x/2),0]) cube([screw_support_x/2,screw_support_x,height]);
				}
				translate([0,0,height+3.1]) rotate([180,0,0]) bolt(3,3,1.45,20,0);
			}
	}
}

module 3_throw_switch(position)
{
	// I've currently got a DPDT switch which is bigger than it needs to be
	// What I'm using:
	// http://www.jaycar.com.au/productView.asp?ID=ST0356&form=CAT2&SUBCATID=978#1
	// What I should be using.
	// http://www.jaycar.com.au/productView.asp?ID=ST0336&form=CAT2&SUBCATID=978#1
	// Hopefully it's only a single dimension that needs to change.
	

	angle = position;	
	
	translate([-3ts_x/2,-3ts_y/2,-3ts_z]) cube([3ts_x,3ts_y,3ts_z]);
	translate([0,0,-zff]) cylinder(r=3ts_thread_dia/2,h=3ts_thread_z);
	translate([0,0,3ts_thread_z-2*zff]) rotate([0,angle,0]) cylinder(r=3ts_stem_dia/2,h=3ts_stem_z);	
}

module 3_throw_1_no(position)
{
	spring_length = 15;
	spring_angle = 30;
	spring_dia = 4.5;
	spring_offset = 1;
	
	switch_slot_wide_factor = 1.1;
	switch_slot_z = 4.1;
	switch_slot_x = 4;
	
	3_throw_switch(position);
	
	translate([-(switch_slot_x/2),0,3ts_thread_z+switch_slot_z/2-2*zff]) cube([switch_slot_x,3ts_stem_dia*switch_slot_wide_factor,switch_slot_z],true);
	translate([-3ts_stem_dia/2,0,3ts_thread_z+spring_dia/2]) rotate([0,-90-spring_angle,0]) cylinder(r=spring_dia/2,h=spring_length);
	
}

module 3_throw_switch_voids()
{
	translate([0,0,-1.5]) 3_throw_switch(0);
	//translate([0,0,20.8-7]) boat_switch();
}

module 3_throw_1_no_voids()
{
	translate([0,0,-1.5]) 3_throw_1_no(0);
}

module 3_throw_switch_adds()
{
	translate([-boat_switch_x/2,boat_switch_y/2,0]) cube([boat_switch_x,2,9]);
	translate([-boat_switch_x/2,-boat_switch_y/2-2,0]) cube([boat_switch_x,2,9]);
}

module 3_throw_1_no_adds()
{
	guide_z = 4;
	translate([-boat_switch_x/2,boat_switch_y/2,0]) cube([boat_switch_x,2,9]);
	translate([-boat_switch_x/2,-boat_switch_y/2-2,0]) cube([boat_switch_x,2,9]);
	difference()
	{
		translate([-boat_switch_x/4,0,guide_z/2]) cube([boat_switch_x/2,boat_switch_y,guide_z],true);
		translate([-boat_switch_x/4,0,guide_z]) rotate([0,-20,0]) cube([boat_switch_x,boat_switch_y,guide_z],true);
	}
	
}

module boat_switch()
{

	
	hinge_clearance = 0.5;
	
	difference()
	{
		translate([-boat_switch_x/2,-boat_switch_y/2,0]) difference()
		{
			cube([boat_switch_x,boat_switch_y,boat_switch_z]);
			translate([step_x,0,boat_switch_z-step_z]) cube([boat_switch_x-2*step_x,boat_switch_y,step_z+zff]);
			translate([2*step_x,0,boat_switch_z-2*step_z]) cube([boat_switch_x-4*step_x,boat_switch_y,step_z+zff]);
			translate([3*step_x,0,boat_switch_z-3*step_z]) cube([boat_switch_x-6*step_x,boat_switch_y,step_z+zff]);
		}		
		#cylinder(r=1.5,h=7);
	}
}

module china_switch()
{
	// Based on measurements from a boat switch on the TM warthog
	china_switch_x = 20;
	china_switch_y = 10;
	china_switch_z = 10;
	plateau = 4;
	
	difference()
	{
		translate([-china_switch_x/2,-china_switch_y/2,0]) difference()
		{
			cube([china_switch_x,china_switch_y,china_switch_z]);
			scale([1,1,0.5]) translate([-plateau/2,0,china_switch_z*2]) rotate([90,0,0]) translate([0,0,-china_switch_y-zff]) cylinder(r=10,h=china_switch_y+2*zff);
			scale([1,1,0.5]) translate([china_switch_x+plateau/2,0,china_switch_z*2]) rotate([90,0,0]) translate([0,0,-china_switch_y-zff]) cylinder(r=10,h=china_switch_y+2*zff);
			
		}
		// This one doesn't go onto a switch, rather it's a 2-way hat.
		cylinder(r=4.5/2,h=7);
	}
}

explodedist = 0;
throttle_endplate();

//throttle_backplate();

//screw_support(1);

//translate([0,0,20 - ($t*20)]) translate([wall_thickness,wall_thickness,throttle_right_z-plate_thickness]) color("cyan") throttle_endplate();
//translate([20-($t*20),0,0]) translate([throttle_right_x-plate_thickness,wall_thickness,throttle_right_z-plate_thickness]) rotate([0,90,0]) color("cyan") throttle_backplate();

//3_throw_1_no(0);

//throttle_stem();

//throttle_right();

//switch_hinge();
//china_switch();
//scale([1,0.85,1]) boat_switch();

//3_throw_switch_voids();
//hat_voids(2);

//3_throw_1_no_adds();

if (0)
{
	union()
	{
		throttle_right();
		translate([wall_thickness+plate_clearance/2,wall_thickness+plate_clearance/2,throttle_right_z-plate_thickness+explodedist]) #throttle_endplate();
		translate([throttle_right_x-plate_thickness+explodedist,wall_thickness+plate_clearance/2,throttle_right_z-plate_thickness-plate_clearance/2]) rotate([0,90,0]) throttle_backplate();
	}
}