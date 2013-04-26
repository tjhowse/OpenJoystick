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
inner_spring_pegs = 20;
spring_z_offset = 3.5;
spring_peg_r = 1.5;

y_cutaway_bite_r = 5;
y_cutaway_bite_stretch = 1.2;

bearing_outside_dia = 22*1.02;

module m8_bolt(length,slotblock)
{
	rotate([0,0,90]) union()
	{
		cylinder(r=m8_bolt_head_max_r,h=m8_bolt_head_z,$fn=6);
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
	total_z = bearing_thickness*2;
	
	total_y = (outer_spring_pegs/2+spring_peg_r+wall_thickness+m8_bolt_head_z+wall_thickness)*2;
	total_x = (m8_bolt_head_min_r+wall_thickness)*2;
	
	edge_chord = 2*sqrt(pow((bearing_outside_dia+wall_thickness*2)/2,2)-pow(total_x/2,2));
	
	
	difference()
	{
		union()
		{
			//translate([0,0,-total_z/2]) cylinder(r=bearing_outside_dia/2+wall_thickness,h=total_z);
			bearing_clamp();
			cube([total_x,total_y,total_z],true);
		}
				
		translate([0,0,-total_z/2])cylinder(r=bearing_outside_dia/2,h=total_z);
				
		translate([0,-total_y/2+wall_thickness+m8_bolt_head_z,0]) rotate([90,0,00]) m8_bolt(10,1);
		rotate([0,0,180]) translate([0,-total_y/2+wall_thickness+m8_bolt_head_z,0]) rotate([90,0,00]) m8_bolt(10,1);
		
		// Spring pegs * 2
		translate([spring_z_offset,-outer_spring_pegs/2,-total_z/2]) #cylinder(r=spring_peg_r,h=total_z);
		rotate([0,0,180]) translate([-spring_z_offset,-outer_spring_pegs/2,-total_z/2]) #cylinder(r=spring_peg_r,h=total_z);
		translate([-spring_z_offset,-outer_spring_pegs/2,-total_z/2]) #cylinder(r=spring_peg_r,h=total_z);
		rotate([0,0,180]) translate([spring_z_offset,-outer_spring_pegs/2,-total_z/2]) #cylinder(r=spring_peg_r,h=total_z);
		
		// Cutaway * 4
		translate([total_x/2,edge_chord/2+(y_cutaway_bite_r*y_cutaway_bite_stretch),-bearing_thickness]) scale([1,y_cutaway_bite_stretch,1]) cylinder(r=y_cutaway_bite_r,h=bearing_thickness*2);
		translate([-total_x/2,edge_chord/2+(y_cutaway_bite_r*y_cutaway_bite_stretch),-bearing_thickness]) scale([1,y_cutaway_bite_stretch,1]) cylinder(r=y_cutaway_bite_r,h=bearing_thickness*2);
		rotate([0,0,180]) translate([total_x/2,edge_chord/2+(y_cutaway_bite_r*y_cutaway_bite_stretch),-bearing_thickness]) scale([1,y_cutaway_bite_stretch,1]) cylinder(r=y_cutaway_bite_r,h=bearing_thickness*2);
		rotate([0,0,180]) translate([-total_x/2,edge_chord/2+(y_cutaway_bite_r*y_cutaway_bite_stretch),-bearing_thickness]) scale([1,y_cutaway_bite_stretch,1]) cylinder(r=y_cutaway_bite_r,h=bearing_thickness*2);
		
		// Clamp cut
		
	}
}

module bearing_clamp()
{
	total_z = bearing_thickness*2;
	gap = 3;
	clamp_bolt_r = spring_peg_r;

	difference()
	{
		union()
		{
			translate([0,0,-total_z/2]) cylinder(r=bearing_outside_dia/2+wall_thickness,h=total_z);
			translate([bearing_outside_dia/2-wall_thickness,0,0]) cube([wall_thickness*2+clamp_bolt_r*2+bearing_outside_dia/2, wall_thickness*2+gap,total_z],true);
		}
		translate([0,0,-total_z/2])cylinder(r=bearing_outside_dia/2,h=total_z);
		translate([bearing_outside_dia/2-wall_thickness,0,0]) cube([wall_thickness*2+clamp_bolt_r*2+bearing_outside_dia/2, gap,total_z],true);
		
		translate([bearing_outside_dia/2+wall_thickness*2,0,bearing_thickness/2]) rotate([90,0,0]) translate([0,0,-(wall_thickness*2+gap)/2]) cylinder(r=clamp_bolt_r,h=wall_thickness*2+gap);
		translate([bearing_outside_dia/2+wall_thickness*2,0,-bearing_thickness/2]) rotate([90,0,0]) translate([0,0,-(wall_thickness*2+gap)/2]) cylinder(r=clamp_bolt_r,h=wall_thickness*2+gap);
	}
}

y_axis();
//bearing_clamp();
//m8_bolt(10,1);