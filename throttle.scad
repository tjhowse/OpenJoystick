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
throttle_right_z = 70;

wall_thickness = 3;
plate_thickness = 4_way_hat_base_z-1;

screw_support_x = 10;

throttle_stem_x = 25;
throttle_stem_y = 60;
throttle_stem_z = 15;
throttle_stem_thickness = 3;

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
	translate([wall_thickness,wall_thickness+5,throttle_right_z-plate_thickness]) screw_support(0);
	translate([wall_thickness,2*wall_thickness+throttle_right_y,throttle_right_z-plate_thickness]) screw_support(0);
	translate([throttle_right_x-(screw_support_x/2)-plate_thickness,wall_thickness,throttle_right_z-plate_thickness]) rotate([0,0,90]) screw_support(0);
	translate([throttle_right_x-wall_thickness,2*wall_thickness+throttle_right_y,throttle_right_z-plate_thickness]) rotate([0,0,180]) screw_support(0);
	
	// Horizontal screwholes
	translate([throttle_right_x-plate_thickness,wall_thickness*3,wall_thickness]) screw_support(1);
	translate([throttle_right_x-plate_thickness,throttle_right_y-wall_thickness*2,wall_thickness]) screw_support(1);
	
	// Lip
	translate([throttle_right_x-wall_thickness-plate_thickness,wall_thickness,wall_thickness]) cube([wall_thickness,throttle_right_y,wall_thickness]);
	translate([throttle_right_x-wall_thickness-plate_thickness,wall_thickness,wall_thickness]) cube([wall_thickness,wall_thickness,throttle_right_z-plate_thickness-wall_thickness]);
	translate([throttle_right_x-wall_thickness-plate_thickness,throttle_right_y-wall_thickness,wall_thickness]) cube([wall_thickness,wall_thickness*2,throttle_right_z-plate_thickness-wall_thickness]);
	translate([throttle_right_x-wall_thickness-plate_thickness,throttle_right_y,wall_thickness]) 
		cube([plate_thickness,wall_thickness,throttle_right_z-plate_thickness-wall_thickness]);
	
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
			translate([0,0,zff]) cube([throttle_right_x-wall_thickness,throttle_right_y-wall_thickness,plate_thickness-2*zff]);
			translate([0,0,zff]) translate([(throttle_right_x-2*wall_thickness)/2,throttle_right_y-wall_thickness,0]) cylinder(r=(throttle_right_x-2*wall_thickness)/2,h=plate_thickness-2*zff);
		}
		
		translate([screw_support_x/2,screw_support_x/2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		translate([throttle_right_x-(screw_support_x/2)-plate_thickness-wall_thickness,screw_support_x/2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		translate([screw_support_x/2,2*wall_thickness+throttle_right_y-wall_thickness,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		translate([throttle_right_x-2*wall_thickness-screw_support_x/2,2*wall_thickness+throttle_right_y-wall_thickness,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		
		translate([throttle_right_x/2-wall_thickness,throttle_right_y,-1]) hat_voids(4);
		translate([throttle_right_x/2-wall_thickness,throttle_right_y/6,-1]) rotate([0,0,90]) hat_voids(2);
		translate([throttle_right_x/2-wall_thickness,throttle_right_y/6+switch_spacing,-1]) rotate([0,0,90]) hat_voids(2);
		translate([throttle_right_x/2-wall_thickness,throttle_right_y/6+2*switch_spacing,-1]) rotate([0,0,90]) hat_voids(2);
		
		translate([throttle_right_x-wall_thickness-plate_thickness/2,(throttle_right_y-wall_thickness)/2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		
	}
}

module throttle_backplate()
{
	switch_spacing = 23;
	top_dist = 2*throttle_right_y/3;
	difference()
	{
		translate([0,0,-zff]) cube([throttle_right_z-wall_thickness-plate_thickness,throttle_right_y-wall_thickness,plate_thickness]);
	
		translate([throttle_right_z-wall_thickness-plate_thickness-screw_support_x/2,wall_thickness*2,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
		translate([throttle_right_z-wall_thickness-plate_thickness-screw_support_x/2,throttle_right_y-3*wall_thickness,plate_thickness+zff]) rotate([0,180,0]) bolt(3,3,1.45,20,20);
	
		translate([(throttle_right_z-wall_thickness-plate_thickness)/2-switch_spacing/2,top_dist,-1]) hat_voids(4);
		translate([(throttle_right_z-wall_thickness-plate_thickness)/2+switch_spacing/2,top_dist,-1]) hat_voids(4);
		translate([-6,(throttle_right_y-wall_thickness)/2,plate_thickness/2]) rotate([0,90,0]) bolt(3,3,1.45,20,0);
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
	
	3ts_x = 12.7;
	3ts_y = 11.5;
	3ts_z = 12.9;
	3ts_thread_dia = 6;
	3ts_thread_z = 9;
	3ts_stem_dia = 2.9;
	3ts_stem_z = 10.3;
	angle = position;	
	
	translate([-3ts_x/2,-3ts_y/2,-3ts_z]) cube([3ts_x,3ts_y,3ts_z]);
	cylinder(r=3ts_thread_dia/2,h=3ts_thread_z);
	translate([0,0,3ts_thread_z]) rotate([0,angle,0]) cylinder(r=3ts_stem_dia/2,h=3ts_stem_z);	
}



explodedist = 0;
//throttle_endplate();

//throttle_backplate();

//screw_support(1);

//translate([0,0,20 - ($t*20)]) translate([wall_thickness,wall_thickness,throttle_right_z-plate_thickness]) color("cyan") throttle_endplate();
//translate([20-($t*20),0,0]) translate([throttle_right_x-plate_thickness,wall_thickness,throttle_right_z-plate_thickness]) rotate([0,90,0]) color("cyan") throttle_backplate();

//3_throw_switch(0);

//throttle_stem();

throttle_right();

if (0)
{
	union()
	{
		throttle_right();
		translate([wall_thickness,wall_thickness,throttle_right_z-plate_thickness+explodedist]) throttle_endplate();
		translate([throttle_right_x-plate_thickness+explodedist,wall_thickness,throttle_right_z-plate_thickness]) rotate([0,90,0]) throttle_backplate();
	}
}