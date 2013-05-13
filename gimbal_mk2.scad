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
outer_spring_pegs = 50; // Try increasing this.
inner_spring_pegs = 10;

spring_peg_r = 1.5;

bearing_outside_dia = 22*1.02;

y_clearance = 3; // Two washers' worth
anchor_clearance = 3;
z_clearance = 2;
z_extra_bolt_clearance = 1;

y_extra_sleeve_clearance = 2;

y_pegs_offset = bearing_inside_dia/2 + (bearing_inside_dia/2+bearing_inside_dia/2)/2-spring_peg_r;

//spring_z_offset = 2;
spring_z_offset = 2*spring_peg_r;
//spring_z_offset = 0;
spring_peg_sleeve_y = y_pegs_offset-spring_peg_r-(spring_z_offset-2*spring_peg_r);
spring_peg_sleeve_x = y_pegs_offset-spring_peg_r-(spring_z_offset-2*spring_peg_r);

spring_wire_r = 1.5/2;

y_total_z = bearing_thickness*2;	
// y_total_y = outer_spring_pegs+spring_peg_sleeve_y*2+spring_wire_r*2+y_extra_sleeve_clearance;
y_total_y = outer_spring_pegs+spring_peg_sleeve_y*2+y_extra_sleeve_clearance;
y_total_x = (m8_bolt_head_min_r+wall_thickness)*2;

magnet_d = 10*1.1;
magnet_z = 5;

anchor_base_thickness = 2*wall_thickness;
anchor_base_extra_height = 15;
anchor_total_z = bearing_thickness*2;

stem_socket_depth = 10;

module m8_bolt(length,slothead,slotshaft)
{
	rotate([0,0,90]) union()
	{
		translate([0,0,zff]) cylinder(r=m8_bolt_head_max_r,h=m8_bolt_head_z,$fn=6);
		translate([0,0,m8_bolt_head_z]) cylinder(r=bearing_inside_dia/2,h=length);
		if (slothead == 1)
		{
			translate([0,-m8_bolt_head_min_r,0]) cube([m8_bolt_head_min_r*2,m8_bolt_head_min_r*2,m8_bolt_head_z]);
			// translate([0,-bearing_inside_dia/2,m8_bolt_head_z]) cube([m8_bolt_head_min_r*2,bearing_inside_dia,length]);
		}
		if (slotshaft == 1)
		{
			// translate([0,-m8_bolt_head_min_r,0]) cube([m8_bolt_head_min_r*2,m8_bolt_head_min_r*2,m8_bolt_head_z]);
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

		translate([0,-bearing_outside_dia/2-wall_thickness,0]) rotate([90,0,0]) m8_bolt(100,1,0);
		rotate([0,0,180]) translate([0,-bearing_outside_dia/2-wall_thickness,0]) rotate([90,0,0]) m8_bolt(100,1,0);
		
		// Spring pegs * 2
		translate([y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r,h=y_total_z);
		rotate([0,0,180]) translate([-y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r,h=y_total_z);
		translate([-y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r,h=y_total_z);
		rotate([0,0,180]) translate([y_pegs_offset,-outer_spring_pegs/2,-y_total_z/2]) cylinder(r=spring_peg_r,h=y_total_z);
		
	}
	
	
}

module x_axis()
{	
	//stem_socket_depth = spring_peg_r*2+wall_thickness;
	
	
	x_hole_x = y_total_z+ y_clearance;
	x_hole_y = bearing_outside_dia+wall_thickness*3 +spring_peg_r*2+z_clearance+z_extra_bolt_clearance;
	//x_total_z = 15;
	x_total_z = m8_bolt_head_min_r*2+spring_peg_r*4+wall_thickness/2;
	
	x_total_x = x_hole_x + wall_thickness*3;
	x_total_y = x_hole_y + wall_thickness*3+stem_socket_depth;
		
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
				translate([0,0,x_total_x/2+nut_countersink/2]) cube([x_total_z,(m8_bolt_head_max_r)*2, nut_countersink],center=true);
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
	translate([0,0,bearing_thickness/2]) single_bearing_clamp();
	translate([0,0,-bearing_thickness/2]) single_bearing_clamp();
}

module single_bearing_clamp()
{
	gap = 3;
	clamp_bolt_r = spring_peg_r;

	difference()
	{
		union()
		{
			translate([0,0,-bearing_thickness/2]) cylinder(r=bearing_outside_dia/2+wall_thickness,h=bearing_thickness);
			translate([bearing_outside_dia/2-wall_thickness,0,0]) cube([wall_thickness*2+clamp_bolt_r*2+bearing_outside_dia/2, wall_thickness*3+gap,bearing_thickness],true);
		}
		translate([0,0,-bearing_thickness/2]) cylinder(r=bearing_outside_dia/2,h=bearing_thickness);
		translate([bearing_outside_dia/2-wall_thickness,0,0]) cube([wall_thickness*2+clamp_bolt_r*2+bearing_outside_dia/2, gap,bearing_thickness],true);
		
		translate([bearing_outside_dia/2+wall_thickness*2,wall_thickness/2,0]) rotate([90,0,0]) translate([0,0,-(wall_thickness*2+gap)/2]) cylinder(r=clamp_bolt_r,h=wall_thickness*3+gap);
	}
}

module spring_peg_sleeve()
{
	spring_peg_sleeve_z = m8_bolt_head_z+wall_thickness*1.5+y_clearance/2+spring_wire_r*2;
	difference()
	{
		union()
		{
			cylinder(r=spring_peg_sleeve_y+spring_wire_r,h=spring_peg_sleeve_z-spring_wire_r*2);
			translate([0,0,spring_peg_sleeve_z-spring_wire_r*2]) cylinder(r1=spring_peg_sleeve_y+spring_wire_r,r2=spring_peg_sleeve_y,h=spring_wire_r);
			translate([0,0,spring_peg_sleeve_z-spring_wire_r]) cylinder(r1=spring_peg_sleeve_y,r2=spring_peg_sleeve_y+spring_wire_r,h=spring_wire_r);
			
		}
		cylinder(r=spring_peg_r,h=spring_peg_sleeve_z);
	}		
}

module anchor()
{
	anchor_total_y = outer_spring_pegs+ 6*wall_thickness+6*spring_peg_r;	
	anchor_post_x = bearing_outside_dia/2-spring_z_offset+spring_peg_r+wall_thickness+anchor_base_extra_height;
	
	difference()
	{
		union()
		{
			bearing_clamp();
			translate([-(bearing_outside_dia/2+anchor_base_extra_height)/2,0,0]) cube([bearing_outside_dia/2+anchor_base_extra_height,bearing_outside_dia+2*wall_thickness,anchor_total_z],center=true);
			translate([-(anchor_post_x)/2+spring_peg_r+wall_thickness-spring_z_offset,-outer_spring_pegs/2,0]) difference()
			{
				cube([anchor_post_x,spring_peg_r*2+2*wall_thickness,anchor_total_z],center=true);
				translate([anchor_post_x/2-spring_peg_r-wall_thickness,0,-anchor_total_z/2]) cylinder(r=spring_peg_r,h=anchor_total_z);
			}
			translate([-(anchor_post_x)/2+spring_peg_r+wall_thickness-spring_z_offset,outer_spring_pegs/2,0]) difference()
			{
				cube([anchor_post_x,spring_peg_r*2+2*wall_thickness,anchor_total_z],center=true);
				translate([anchor_post_x/2-spring_peg_r-wall_thickness,0,-anchor_total_z/2]) cylinder(r=spring_peg_r,h=anchor_total_z);
			}
			translate([-bearing_outside_dia/2-anchor_base_thickness/2-anchor_base_extra_height,0,0]) cube([anchor_base_thickness,anchor_total_y,anchor_total_z],center=true);
		}
		translate([0,0,-anchor_total_z/2]) cylinder(r=bearing_outside_dia/2,h=anchor_total_z);
		
		translate([0,outer_spring_pegs/2+2*spring_peg_r+2*wall_thickness,0]) rotate([0,-90,0]) cylinder(r=spring_peg_r,h=100);
		translate([0,-(outer_spring_pegs/2+2*spring_peg_r+2*wall_thickness),0]) rotate([0,-90,0]) cylinder(r=spring_peg_r,h=100);
	}

}

module y_spring_hat()
{
	difference()
	{
		cylinder(r=m8_bolt_head_max_r+wall_thickness/2+2*spring_peg_r,h=(m8_bolt_head_z/m8_bolt_clearance)*2);
		cylinder(r=m8_bolt_head_max_r,h=(m8_bolt_head_z/m8_bolt_clearance)*2,$fn=6);
		for (i = [0:60:300])
		{
			rotate([0,0,i]) translate([0,m8_bolt_head_min_r+spring_peg_r,0]) cylinder(r=spring_peg_r,h=(m8_bolt_head_z/m8_bolt_clearance)*2);
		}
	}
}

module shaft()
{
	shaft_length = 40;
	shaft_dia_scalar = 0.97;
	difference()
	{
		cylinder(r=(shaft_dia*shaft_dia_scalar)/2,h=shaft_length);
		translate([-shaft_dia/3,0,shaft_length/2]) cube([shaft_dia/2,shaft_dia/2,shaft_length],center=true);
		translate([0,0,stem_socket_depth/2]) rotate([90,0,0]) translate([0,0,-50]) #cylinder(r=spring_peg_r,h=100);
	}
}

module base()
{
	// Slapdash for testing.
	base_length = 81.5+(spring_peg_r+wall_thickness)*2;
	difference()
	{
		cube([base_length,10,5]);
		translate([spring_peg_r+wall_thickness,5,0]) peg_bolt();
		translate([base_length-spring_peg_r-wall_thickness,5,0]) peg_bolt();
	}
}
module peg_bolt()
{
	cylinder(r=5.4/2,h=3);
	translate([0,0,3]) cylinder(r=spring_peg_r,h=100);
}


// test_x = abs($t-0.5)*-80+20;
test_x = 0;
// test_y = abs($t-0.5)*-80+20;
test_y = 0;

if (1)
{
	
	rotate([test_x,test_y,0]) rotate([90,0,0]) x_axis();
	rotate([0,test_y,0]) rotate([0,270,0]) y_axis();
	
	rotate([0,test_y,0]) translate([y_total_z/2,+outer_spring_pegs/2,y_pegs_offset]) rotate([0,90,0]) spring_peg_sleeve();
	rotate([0,test_y,0]) translate([y_total_z/2,-outer_spring_pegs/2,y_pegs_offset]) rotate([0,90,0]) spring_peg_sleeve();
	translate([0,y_total_y/2+anchor_clearance/2+anchor_total_z/2,0]) rotate([0,270,90]) anchor();
	translate([0,-(y_total_y/2+anchor_clearance/2+anchor_total_z/2),0]) rotate([0,270,90]) anchor();

} else {
	rotate([180,0,0]) base();
	translate([0,20,0]) rotate([180,0,0]) base();
	//y_spring_hat();
	//y_axis();
	//x_axis();
	//shaft();
	//anchor();
	//single_bearing_clamp();
	//bearing_clamp();
	//spring_peg_sleeve();
	//translate([0,20,0])spring_peg_sleeve();
	//cube([100,50,10],center=true);
	//translate([0,0,15/2]) x_axis();
	//translate([30,0,y_total_z/2]) y_axis();
	//bearing_clamp();
	//m8_bolt(10,1);
}