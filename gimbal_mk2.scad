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
use <joystick_handle.scad>

wall_thickness = 2;
m8_bolt_clearance = 1.1;
m8_bolt_head_z = 6.25*m8_bolt_clearance;
m8_bolt_head_min_r = 12.74/2*m8_bolt_clearance;
m8_bolt_head_max_r = 14.55/2*m8_bolt_clearance;

// These come from experimentally-discovered determined values for good springyness
// using 1.5mm spring steel piano wire.
outer_spring_pegs = 47;
inner_spring_pegs = 10;

spring_peg_r = 1.5;

bearing_outside_dia = 22*1.02;

y_total_z = bearing_thickness*2;	
y_total_y = (outer_spring_pegs/2+spring_peg_r+wall_thickness)*2;
y_total_x = (m8_bolt_head_min_r+wall_thickness)*2;

y_pegs_offset = bearing_inside_dia/2 + (bearing_inside_dia/2+bearing_inside_dia/2)/2-spring_peg_r;

spring_z_offset = 3.5;
spring_peg_sleeve_r = y_pegs_offset-3.5;

magnet_d = 10*1.1;
magnet_z = 5;

y_clearance = 3; // Two washers' worth
z_clearance = 2;
z_extra_bolt_clearance = 1;

module m8_bolt(length,slotblock)
{
	rotate([0,0,90]) union()
	{
		translate([0,0,zff]) cylinder(r=m8_bolt_head_max_r,h=m8_bolt_head_z,$fn=6);
		translate([0,0,m8_bolt_head_z]) cylinder(r=bearing_inside_dia/2,h=length);
		if (slotblock == 1)
		{
			translate([0,-m8_bolt_head_min_r,0]) cube([m8_bolt_head_min_r*2,m8_bolt_head_min_r*2,m8_bolt_head_z]);
			translate([0,-bearing_inside_dia/2,m8_bolt_head_z]) cube([m8_bolt_head_min_r*2,bearing_inside_dia,length]);
		}
	}
}

module y_axis()
{	
	edge_chord = 2*sqrt(pow((bearing_outside_dia+wall_thickness*2)/2,2)-pow(y_total_x/2,2));
	
	difference()
	{
		union()
		{
			bearing_clamp();
			cube([y_total_x,y_total_y,y_total_z],true);
			/*translate([y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r+wall_thickness,h=y_total_z);
			rotate([0,0,180]) translate([-y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r+wall_thickness,h=y_total_z);
			translate([-y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r+wall_thickness,h=y_total_z);
			rotate([0,0,180]) translate([y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r+wall_thickness,h=y_total_z);*/
		}
				
		translate([0,0,-y_total_z/2])cylinder(r=bearing_outside_dia/2,h=y_total_z);

		translate([0,-bearing_outside_dia/2-wall_thickness,0]) rotate([90,0,0]) m8_bolt(10,1);
		rotate([0,0,180]) translate([0,-bearing_outside_dia/2-wall_thickness,0]) rotate([90,0,0]) m8_bolt(10,1);
		
		// Spring pegs * 2
		translate([y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) #cylinder(r=spring_peg_r,h=y_total_z);
		rotate([0,0,180]) translate([-y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r,h=y_total_z);
		translate([-y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r,h=y_total_z);
		rotate([0,0,180]) translate([y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r,h=y_total_z);
		
	}
	
	
}

module x_axis()
{	
	//stem_socket_depth = spring_peg_r*2+wall_thickness;
	stem_socket_depth =10;
	
	x_hole_x = y_total_z+ y_clearance;
	x_hole_y = bearing_outside_dia+wall_thickness*3 +spring_peg_r*2+z_clearance+z_extra_bolt_clearance;
	//x_total_z = 15;
	x_total_z = m8_bolt_head_min_r*2+spring_peg_r*4+wall_thickness/2;
	
	x_total_x = x_hole_x + wall_thickness*3;
	x_total_y = x_hole_y + wall_thickness*3+stem_socket_depth;
	
	shaft_length = 20;
		
	nut_countersink = m8_bolt_head_z;
	difference()
	{
		union()
			{
			difference()
			{
				translate([0,(wall_thickness +spring_peg_r*2+z_extra_bolt_clearance)/2+stem_socket_depth/2,0]) difference()
				{
					cube([x_total_x,x_total_y,x_total_z],true);
					translate([0,-stem_socket_depth/2,0]) cube([x_hole_x,x_hole_y,x_total_z],true);
				}
				
				rotate([0,90,0]) translate([0,0,-50]) cylinder(r=(bearing_inside_dia*1.1)/2,h=100);
			}
			
			translate([0,(wall_thickness +spring_peg_r*2+z_extra_bolt_clearance)/2-x_total_y/2+stem_socket_depth/2,0]) rotate([90,0,0]) difference()
			{
				cylinder(r=magnet_d/2+wall_thickness,h=wall_thickness);
				cylinder(r=magnet_d/2,h=wall_thickness);
			}
			//translate([x_total_x/2,-(m8_bolt_head_max_r*2+wall_thickness)/2,-x_total_z/2]) difference ()
			translate([zff,0,0]) rotate([0,90,0]) difference ()
			{
				#translate([0,0,x_total_x/2+nut_countersink/2]) cube([x_total_z,(m8_bolt_head_max_r)*2, nut_countersink],center=true);
				rotate([0,0,30]) cylinder(r=m8_bolt_head_max_r,h=100,$fn=6);
			}
		}
		rotate([0,90,0])
		{
			translate([m8_bolt_head_min_r+spring_peg_r,0,0]) cylinder(r=spring_peg_r,h=100,$fn=10);
			translate([-m8_bolt_head_min_r-spring_peg_r,,0]) cylinder(r=spring_peg_r,h=100,$fn=10);			
		}
		
		translate([0,x_total_y/2+(wall_thickness +spring_peg_r*2+z_extra_bolt_clearance)/2-stem_socket_depth/2,0]) rotate([-90,0,0]) cylinder(r=shaft_dia/2,h=100);
		translate([0,x_total_y/2+(wall_thickness +spring_peg_r*2+z_extra_bolt_clearance)/2,-50]) cylinder(r=spring_peg_r,h=100);
		
	}
}

module bearing_clamp()
{
	y_total_z = bearing_thickness*2;
	gap = 3;
	clamp_bolt_r = spring_peg_r;

	difference()
	{
		union()
		{
			translate([0,0,-y_total_z/2]) cylinder(r=bearing_outside_dia/2+wall_thickness,h=y_total_z);
			translate([bearing_outside_dia/2-wall_thickness,0,0]) cube([wall_thickness*2+clamp_bolt_r*2+bearing_outside_dia/2, wall_thickness*3+gap,y_total_z],true);
		}
		translate([0,0,-y_total_z/2])cylinder(r=bearing_outside_dia/2,h=y_total_z);
		translate([bearing_outside_dia/2-wall_thickness,0,0]) cube([wall_thickness*2+clamp_bolt_r*2+bearing_outside_dia/2, gap,y_total_z],true);
		
		translate([bearing_outside_dia/2+wall_thickness*2,wall_thickness/2,bearing_thickness/2]) rotate([90,0,0]) translate([0,0,-(wall_thickness*2+gap)/2]) cylinder(r=clamp_bolt_r,h=wall_thickness*3+gap);
		translate([bearing_outside_dia/2+wall_thickness*2,wall_thickness/2,-bearing_thickness/2]) rotate([90,0,0]) translate([0,0,-(wall_thickness*2+gap)/2]) cylinder(r=clamp_bolt_r,h=wall_thickness*3+gap);
	}
}
module spring_peg_sleeve()
{
	spring_peg_sleeve_z = m8_bolt_head_z+wall_thickness*3+y_clearance/2;
	difference()
	{
		cylinder(r=spring_peg_sleeve_r,h=10);
		cylinder(r=spring_peg_r,h=10);
	}		
}

//spring_peg_sleeve();

test_x = 0;
test_y = 0;
if (1)
{
	
	rotate([test_x,test_y,0]) rotate([90,0,0]) x_axis();
	rotate([0,test_y,0]) rotate([0,270,0]) y_axis();
}

//cube([100,50,10],center=true);
//translate([0,0,15/2]) x_axis();
//translate([30,0,y_total_z/2]) y_axis();
//bearing_clamp();
//m8_bolt(10,1);