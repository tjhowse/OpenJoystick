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
bearing_retain_thickness = 1;

inner_gimbal_x = 58;
inner_gimbal_y = 35;
inner_gimbal_z = 25;

inner_gimbal_total_x = inner_gimbal_x+2*bearing_retain_thickness;
inner_gimbal_total_y = inner_gimbal_y+2*bearing_retain_thickness;

joiner_z = 10;
joiner_x = 10;
joiner_peg_height = 56;
support_stem_beef = 1;

temp = joiner_z/2;

springbar_offset = 3.5;
springbar_y = 20;
springbar_z = 5;
springbar_x = 8;
springbar_separation = springbar_y -8;

// Solidified this variable for consistent springiness
//springsupport_separation = inner_gimbal_total_x-5;
springsupport_separation = 47;
//echo(springsupport_separation);

joiner_peg_z = 5;
joiner_peg_xy = bearing_inside_dia / sqrt(2);

base_support_height = 25;
inner_gimbal_clearance = 2;

magnet_d = 10;
magnet_z = 5;

// A little bit of extra clearance on the springbar to allow for clearance of the bolts internally.
// on the inner gimbal.
// Might abandon this if the bolts/spring cause magnetic annoyances.
springbar_extra = 2;

arc_z = 2;
arc_ridge_z = 1.5;
arc_ridge_x = 1;
arc_ridge_spacing_deg = 5;
arc_outer_radius = inner_gimbal_z/2+base_support_height-12-joiner_peg_z+joiner_peg_height;
arc_y = 10;
arc_range = 30;

calibration_slot_x = 4.63;
calibration_slot_y = 4.25;
calibration_wall_thickness = 2.25;
calibration_hat_z = 15;
calibration_hat_lid_z = 2;

calibration_clip_gap = arc_z+0.75;
calibration_clip_x = 4;
calibration_clip_y = 8;
calibration_clip_z = 2;

module joystick_joiner()
{
	total_y = inner_gimbal_y+2*bearing_retain_thickness-2*bearing_thickness;
	bolt_offset = 21.5;
	
	difference()
	{
		union()
		{
			//scale([1,1,joiner_stem_scalar]) joystick_handle_peg(0);
			joystick_gimbal_peg();
			translate([-joiner_x/2,-total_y/2,0]) cube([joiner_x,total_y,joiner_z]);
		}
		//translate([0,total_y/2+zff,joiner_z/2]) rotate([-90,0,0]) %bearing(1);
		//translate([0,-total_y/2-zff-bearing_thickness,joiner_z/2]) rotate([-90,0,0]) %bearing(1);
		
		translate([-joiner_peg_xy/2,total_y/2-joiner_peg_z+zff,joiner_z/2-joiner_peg_xy/2]) cube([joiner_peg_xy,joiner_peg_z,joiner_peg_xy]);
		translate([-joiner_peg_xy/2,-(total_y/2+zff),joiner_z/2-joiner_peg_xy/2]) cube([joiner_peg_xy,joiner_peg_z,joiner_peg_xy]);
		
		//translate([0,-total_y/2-zff-bearing_thickness,joiner_z/2]) rotate([-90,0,0]) #cube([joiner_peg_xy,joiner_peg_z,joiner_peg_xy]);
		
		
		rotate([90,0,0]) translate([0,joiner_z/2,-bolt_offset]) bolt(3,3,1.45,20,0);
		rotate([-90,0,0]) translate([0,-joiner_z/2,-bolt_offset]) bolt(3,3,1.45,20,0);
		
		rotate([-90,0,0]) translate([0,-20,-12]) bolt(3,3,1.45,20,0);
		rotate([-90,0,0]) translate([0,-30,-12]) bolt(3,3,1.45,20,0);
		rotate([-90,0,0]) translate([0,-40,-12]) bolt(3,3,1.45,20,0);
		rotate([-90,0,0]) translate([0,-50,-12]) bolt(3,3,1.45,20,0);
	}
	
}

module joystick_inner_gimbal()
{
	extra_height_on_screwholes = 1;
	difference()
	{
		union()
		{
			difference()
			{
				translate([-inner_gimbal_total_x/2, -inner_gimbal_total_y/2, -inner_gimbal_z/2])
					cube([inner_gimbal_total_x, inner_gimbal_total_y, inner_gimbal_z]);
				translate([-inner_gimbal_x/2+bearing_thickness, -inner_gimbal_y/2+bearing_thickness, -inner_gimbal_z/2-zff])
					cube([inner_gimbal_x-2*bearing_thickness, inner_gimbal_y-2*bearing_thickness, inner_gimbal_z+2*zff]);

				translate([0,inner_gimbal_total_y/2-bearing_thickness+zff,0]) rotate([-90,0,0]) bearing(0,0.1);
				
				translate([0,-inner_gimbal_total_y/2-zff,0]) rotate([-90,0,0]) bearing(0,0.1);
				rotate([90,0,0]) translate([0,0,-inner_gimbal_y/2]) cylinder(r=(bearing_outside_dia-4)/2,h=inner_gimbal_y);
				
				translate([inner_gimbal_total_x/2+zff,0,0]) rotate([0,-90,0]) bearing(0,0.1);
				translate([-inner_gimbal_total_x/2+bearing_thickness-zff,0,0]) rotate([0,-90,0]) bearing(0,0.1);
				rotate([0,90,0]) translate([0,0,-inner_gimbal_x/2]) cylinder(r=(bearing_outside_dia-4)/2,h=inner_gimbal_x);		 
			}
			//cueb!
			
			// Spring support stems
			translate([0,0,springbar_offset]) union()
			{
				translate([springsupport_separation/2-2.5, -inner_gimbal_total_y/2-5, -2.5]) cube([5,springbar_z,5]);
				translate([-springsupport_separation/2-2.5, -inner_gimbal_total_y/2-5, -2.5]) cube([5,springbar_z,5]);
				translate([springsupport_separation/2-2.5, -inner_gimbal_total_y/2-5, -2.5]) rotate([-45,0,0]) cube([5,springbar_z*sqrt(2),5]);
				translate([-springsupport_separation/2-2.5, -inner_gimbal_total_y/2-5, -2.5]) rotate([-45,0,0]) cube([5,springbar_z*sqrt(2),5]);
			
				translate([inner_gimbal_total_x/2, springsupport_separation/2-2.5, -2.5]) cube([springbar_z,5,5+extra_height_on_screwholes]);	
				translate([inner_gimbal_total_x/2, springsupport_separation/2-2.5, -7.5]) rotate([0,-45,0]) cube([springbar_z*sqrt(2),5,5]);
				
				translate([inner_gimbal_total_x/2, -springsupport_separation/2-2.5, -2.5]) cube([springbar_z,5,5+extra_height_on_screwholes]);				
				translate([inner_gimbal_total_x/2, -springsupport_separation/2-2.5, -7.5]) rotate([0,-45,0]) cube([springbar_z*sqrt(2),5,5]);
			}
			translate([inner_gimbal_total_x/2-(inner_gimbal_total_x-springsupport_separation)/2+2.5, -springsupport_separation/2-2.5, -inner_gimbal_z/2])
				cube([(inner_gimbal_total_x-springsupport_separation)/2-2.5,(springsupport_separation-inner_gimbal_total_y)/2+2.5,springbar_offset+inner_gimbal_z/2+2.5+extra_height_on_screwholes]);

			translate([inner_gimbal_total_x/2-(inner_gimbal_total_x-springsupport_separation)/2+2.5, springsupport_separation/2-5, -inner_gimbal_z/2])
				cube([(inner_gimbal_total_x-springsupport_separation)/2-2.5,(springsupport_separation-inner_gimbal_total_y)/2+2.5,springbar_offset+inner_gimbal_z/2+2.5+extra_height_on_screwholes]);

		}
		translate([0,0,springbar_offset]) union()
		{
			translate([springsupport_separation/2, -inner_gimbal_total_y/2-16.5, 0]) rotate([-90,0,0]) bolt(3,3,1.45,20,0);
			translate([-springsupport_separation/2, -inner_gimbal_total_y/2-16.5, 0]) rotate([-90,0,0]) bolt(3,3,1.45,20,0);

		}
		translate([0,0,springbar_offset]) union()
		{
			translate([inner_gimbal_total_x/2+20,springsupport_separation/2, 0]) rotate([0,-90,0]) bolt(3,3,1.45,20,0);
			translate([inner_gimbal_total_x/2+20,-springsupport_separation/2, 0]) rotate([0,-90,0]) bolt(3,3,1.45,20,0);

		}
		// Y-axis centering pegs
		// Note: using the springbar dimensions to ensure the same springiness between X and Y.
		
	}
	//cube([springsupport_separation,100,100],true);
}

module joystick_base()
{
	mounting_extra_y = 20;
	spar_width = joiner_x;
	
	base_x = inner_gimbal_total_x - bearing_thickness*2 - bearing_retain_thickness*2-inner_gimbal_clearance;
	base_y = inner_gimbal_total_y + mounting_extra_y;
	base_z = 5;
	
	fillet_radius = 5;
	
	ttx = spar_width/2-2;

	difference()
	{
		union()
		{
			translate([base_x/2-spar_width,-base_y/2,0]) cube([spar_width,base_y,base_z]);
			translate([-base_x/2,-base_y/2,0]) cube([spar_width,base_y,base_z]);
			
			translate([-(base_x+2*spar_width)/2,-spar_width/2,0]) cube([base_x+2*spar_width,spar_width,base_z]);
			
			translate([-base_x/2,-spar_width/2-support_stem_beef/2,base_z]) 
				difference()
				{
					union()
					{
						cube([spar_width,spar_width+support_stem_beef, base_support_height+support_stem_beef]);
						rotate([0,0,-90]) fillet(fillet_radius,spar_width);
						translate([spar_width,spar_width+support_stem_beef,0]) rotate([0,0,90]) fillet(fillet_radius,spar_width);
						translate([0,spar_width+support_stem_beef/2,0]) rotate([0,0,180]) fillet(fillet_radius,spar_width);
					}
					translate([-zff,spar_width/2-joiner_peg_xy/2+support_stem_beef/2,base_support_height-joiner_peg_xy-(spar_width-joiner_peg_xy)/2]) 
					union()
					{
						cube([joiner_peg_z,joiner_peg_xy, joiner_peg_xy]);
						translate([-spar_width,joiner_peg_xy/2,joiner_peg_xy/2]) rotate([0,90,0]) bolt(3,3,1.45,20,0);
					}
				}
			
			translate([base_x/2-spar_width,-spar_width/2-support_stem_beef/2,base_z])
				difference()
				{
					union()
					{
						cube([spar_width,spar_width+support_stem_beef, base_support_height+support_stem_beef]);
						rotate([0,0,-90]) fillet(fillet_radius,spar_width);
						translate([spar_width,spar_width+support_stem_beef,0]) rotate([0,0,90]) fillet(fillet_radius,spar_width);
						translate([spar_width,support_stem_beef/2,0]) rotate([0,0,0]) fillet(fillet_radius,spar_width);
					}
					translate([spar_width/2+zff,spar_width/2-joiner_peg_xy/2+support_stem_beef/2,base_support_height-joiner_peg_xy-(spar_width-joiner_peg_xy)/2]) 
					union()
					{
						cube([joiner_peg_z,joiner_peg_xy, joiner_peg_xy]);
						translate([spar_width,joiner_peg_xy/2,joiner_peg_xy/2]) rotate([0,-90,0]) bolt(3,3,1.45,20,0);
					}
					
				}
		}
		
		// Mounting bolts
		translate([base_x/2-spar_width/2,-base_y/2+5,10]) rotate([180,0,0]) bolt(3,3,1.45,20,0);
		translate([base_x/2-spar_width/2,base_y/2-5,10]) rotate([180,0,0]) bolt(3,3,1.45,20,0);
		translate([-base_x/2+spar_width/2,-base_y/2+5,10]) rotate([180,0,0]) bolt(3,3,1.45,20,0);
		translate([-base_x/2+spar_width/2,base_y/2-5,10]) rotate([180,0,0]) bolt(3,3,1.45,20,0);
		translate([(base_x+2*spar_width)/2-3,0,10]) rotate([180,0,0]) bolt(3,3,1.45,20,0);
		translate([-(base_x+2*spar_width)/2+3,0,10]) rotate([180,0,0]) bolt(3,3,1.45,20,0);
		
		
		// One day you'll be able to flag primatives for more infill.
		// Until then, horrible hacks:
		translate([spar_width/2+support_stem_beef/2-base_x/2,0,-1]) cylinder(r=0.1,h = 100);
		translate([spar_width/2+support_stem_beef/2-base_x/2+ttx,ttx,-1]) cylinder(r=0.1,h = 100);
		translate([spar_width/2+support_stem_beef/2-base_x/2+ttx,-ttx,-1]) cylinder(r=0.1,h = 100);
		translate([spar_width/2+support_stem_beef/2-base_x/2-ttx,ttx,-1]) cylinder(r=0.1,h = 100);
		translate([spar_width/2+support_stem_beef/2-base_x/2-ttx,-ttx,-1]) cylinder(r=0.1,h = 100);	
		
		translate([-spar_width/2-support_stem_beef/2+base_x/2,0,-1]) cylinder(r=0.1,h = 100);
		translate([-spar_width/2-support_stem_beef/2+base_x/2+ttx,ttx,-1]) cylinder(r=0.1,h = 100);
		translate([-spar_width/2-support_stem_beef/2+base_x/2+ttx,-ttx,-1]) cylinder(r=0.1,h = 100);
		translate([-spar_width/2-support_stem_beef/2+base_x/2-ttx,ttx,-1]) cylinder(r=0.1,h = 100);
		translate([-spar_width/2-support_stem_beef/2+base_x/2-ttx,-ttx,-1]) cylinder(r=0.1,h = 100);
	}
	
}

module joystick_stem_plug(lip_size, extrapeg)
{	
	peg_clearance = 0.6;
	
	difference()
	{
		union()
		{
			translate([0,0,lip_size]) cylinder(r=bearing_inside_dia/2-0.05,h=bearing_thickness);
			cylinder(r=bearing_inside_dia/2+1,h=lip_size);
			rotate([0,0,90]) translate([-(joiner_peg_xy-peg_clearance)/2,-(joiner_peg_xy-peg_clearance)/2, bearing_thickness+lip_size]) cube([(joiner_peg_xy-peg_clearance),(joiner_peg_xy-peg_clearance),joiner_peg_z+extrapeg]);
		}
		translate([0,0,-zff]) bolt(3,3,1.45,20,0);
	}
	//joiner_z
}

module joystick_stem_plug_springbar(extrapeg)
{
	// Keeping this in place for now.
	springbar_offset_old = 0;
	difference()
	{
		union()
		{
			joystick_stem_plug(springbar_z,extrapeg);
			translate([0,0,springbar_z/2]) cube([springbar_offset_old,springbar_y/2,springbar_z],true);	
			intersection()
			{
				translate([springbar_offset_old,0,springbar_z/2]) cube([springbar_x,springbar_y,springbar_z],true);	
				translate([0,0,-1]) rotate([45,0,0]) translate([springbar_offset_old,0,0]) cube([springbar_y,springbar_y,springbar_y],true);	
			}
		}
		translate([0,0,-zff]) bolt(3,3,1.45,20,0);
		translate([springbar_offset_old,-springbar_y/2+4,-10]) bolt(3,3,1.45,20,0);
		translate([springbar_offset_old,springbar_y/2-4,-10]) bolt(3,3,1.45,20,0);
	}
}

module joystick_y_padding_washer()
{
	washer_dia = 12;
	
	difference()
	{
		cylinder(r=washer_dia/2, h=bearing_retain_thickness+inner_gimbal_clearance/2);
		cube([joiner_peg_xy+0.5,joiner_peg_xy+0.5,100],true);
	}
}

module temp_stem_extender()
{
	difference()
	{
		scale([1,1,(1/1.4)*0.7]) joystick_handle_peg(0);
		translate([0,0,7-magnet_z+zff]) cylinder(r=magnet_d/2+0.2, h=magnet_z);
	}
}

module joystick_magnet_holder(magnet_d, magnet_z)
{
	// This widget holds the magnet at the bottom of the stem.
	
	holder_z = magnet_z+2;
	peg_z = holder_z+2;
	
	peg_x = 4;
	peg_y = 4.5;
	support_width = 11;
	
	extrusion_width=0.5;

	difference()
	{
		union()
		{
			cylinder(h = holder_z, r2 = (shaft_dia/2), r1=(magnet_d/2)+0.5);
			difference()
			{
				translate([0,0,holder_z+1.5]) cube([shaft_dia,peg_y,3],true);
				cube([joiner_x*1.05,100,100],true);
			}
			//translate([(shaft_dia/2)-peg_x,-peg_y/2,0]) cube([peg_x-0.5,peg_y,peg_z]);
			//translate([(-shaft_dia/2),-peg_y/2,0]) cube([peg_x-0.5,peg_y,peg_z]);
		}
		cylinder(r=magnet_d/2,magnet_z);
		
		translate([-(shaft_dia/2)+1.5,0,0]) cylinder(r=0.1,h = 100);
		translate([(shaft_dia/2)-1.5,0,0]) cylinder(r=0.1,h = 100);
	}
	//rotate([0,0,90]) translate([-extrusion_width/2,-support_width/2,0]) cube([extrusion_width,support_width,magnet_z]);
	cylinder(r=1.2,h=magnet_z);
	//%cube([7.3,7.3,100],true);
}

module gimbal_alignment_jig()
{
	jig_x = ((inner_gimbal_x-2*bearing_thickness)/2-(bearing_retain_thickness+inner_gimbal_clearance/2)-(joiner_x-support_stem_beef))*2;
	jig_y = 20;
	jig_z = 6;
	//cylinder(r=(inner_gimbal_x-2*bearing_thickness)/2-(bearing_retain_thickness+inner_gimbal_clearance/2)-(joiner_x-support_stem_beef),h=30);
	difference()
	{
		translate([0,0,jig_z/2]) cube([jig_x,jig_y,jig_z],true);
		cylinder(r=shaft_dia/2+0.2,h=jig_z);
		translate([0,0,jig_z/4]) cube([joiner_x+0.2,jig_y,jig_z/2],true);
	}
}

module gimbal_calibration_arc()
{
	difference()
	{
		cylinder(r=arc_outer_radius,h=arc_z);
		cylinder(r=arc_outer_radius-arc_y,h=arc_z);
		translate([-arc_outer_radius,-2*arc_outer_radius,-zff]) cube([2*arc_outer_radius,2*arc_outer_radius,20]);
	}
	intersection()
	{
		union()
		{
			translate([0,inner_gimbal_z/2+base_support_height-12,0]) for (i = [90-arc_range:arc_ridge_spacing_deg:arc_range+90])
			{
				//rotate([0,0,i]) translate([arc_outer_radius-arc_y,-(arc_ridge_x/2),arc_z]) cube([arc_y-1,arc_ridge_x,arc_ridge_z]);
				//rotate([0,0,i]) translate([(arc_outer_radius-arc_y)-(inner_gimbal_z/2+base_support_height-12-joiner_peg_z),-(arc_ridge_x/2),arc_z]) color("red") cube([100,arc_ridge_x,arc_ridge_z]);
				rotate([0,0,i]) translate([0,-(arc_ridge_x/2),arc_z]) cube([100,arc_ridge_x,arc_ridge_z]);
			}
		}
		translate([0,0,arc_z]) union()
		{
			difference()
			{
				cylinder(r=arc_outer_radius,h=arc_z);
				cylinder(r=arc_outer_radius-arc_y,h=arc_z);
				translate([-arc_outer_radius,-2*arc_outer_radius,-zff]) cube([2*arc_outer_radius,2*arc_outer_radius,20]);
			}
		}
	}
	//inner_gimbal_z/2+base_support_height-12-joiner_peg_z
	
}

module gimbal_calibration_hat()
{
	difference()
	{
		//cylinder(r=(shaft_dia/2)+wall_thickness,h=hat_z);
		translate([0,0,calibration_hat_z/2]) cube([shaft_dia+calibration_wall_thickness,shaft_dia+calibration_wall_thickness,calibration_hat_z],true);
		translate([0,0,-zff+calibration_hat_lid_z]) cylinder(r=(shaft_dia/2)+0.15,h=calibration_hat_z-calibration_hat_lid_z+2*zff);
		
		
		//rotate([0,0,90]) translate([(shaft_dia+wall_thickness)/2+clip_gap/2,0,hat_z/2+clip_x]) #cube([clip_gap,shaft_dia+wall_thickness,hat_z],true);
		
		
	}

	gimbal_calibration_hat_clip();
	rotate([0,0,90]) gimbal_calibration_hat_clip();
	
	translate([-(shaft_dia+calibration_wall_thickness)/2,-calibration_slot_y/2,0]) cube([calibration_slot_x,calibration_slot_y,calibration_hat_z]);
	rotate([0,0,180]) translate([-(shaft_dia+calibration_wall_thickness)/2,-calibration_slot_y/2,0]) cube([calibration_slot_x,calibration_slot_y,calibration_hat_z]);
	//translate([0,0,hat_z+hat_lid_z/2]) cube([shaft_dia+wall_thickness,shaft_dia+wall_thickness,hat_lid_z],true);
}

module gimbal_calibration_hat_clip()
{
	intersection()
	{
		difference()
		{
			translate([(shaft_dia+calibration_wall_thickness)/2+calibration_clip_x/2+calibration_clip_gap,0,calibration_hat_z/2+calibration_clip_z]) cube([calibration_clip_x,calibration_clip_y,calibration_hat_z],true);
			translate([(shaft_dia+calibration_wall_thickness)/2+calibration_clip_x/2+calibration_clip_gap,0,calibration_hat_z/2+calibration_clip_z]) cube([calibration_clip_x,arc_ridge_x,calibration_hat_z],true);
		}
		translate([(shaft_dia+calibration_wall_thickness)/2+calibration_clip_x/2+calibration_clip_gap+3,0,calibration_hat_z/2+calibration_clip_z])
			rotate([0,0,45]) cube([calibration_clip_y,calibration_clip_y,calibration_hat_z],true);
	}
	translate([(shaft_dia+calibration_wall_thickness)/2+(calibration_clip_gap+calibration_clip_x)/2,0,calibration_clip_z/2]) cube([calibration_clip_gap+calibration_clip_x,calibration_clip_y,calibration_clip_z],true);
}

module joystick_gimbal_peg()
{
	
	support_width = shaft_dia;
	
	difference()
	{
		cylinder(h = joiner_peg_height, r = (shaft_dia/2));
		union()
		{
			translate([(shaft_dia/2)-2,0,joiner_peg_height/2]) cube([5,5,joiner_peg_height*2],true);
			translate([(-shaft_dia/2)+2,0,joiner_peg_height/2]) cube([5,5,joiner_peg_height*2],true);
			translate([0,0,-0.5]) cylinder(r=0.5,h=joiner_peg_height);
		}
	}
}


//translate([0,-10,0]) rotate([90,0,0]) gimbal_calibration_arc();
//gimbal_calibration_arc();
//translate([0,0,50]) gimbal_calibration_hat();
//gimbal_calibration_hat();
//gimbal_calibration_hat_clip();
//joystick_joiner();

//translate([0,inner_gimbal_y/2+4+bearing_retain_thickness,0]) rotate([90,0,0]) rotate([0,0,90]) joystick_stem_plug(4,0);
//rotate([0,0,180]) translate([0,inner_gimbal_y/2+springbar_z+bearing_retain_thickness,0]) rotate([90,0,0]) rotate([0,0,-90]) joystick_stem_plug_springbar(inner_gimbal_clearance);
//translate([30,0,0]) joystick_stem_plug_springbar(inner_gimbal_clearance);
//translate([13,0,0]) joystick_stem_plug(2,inner_gimbal_clearance);

//temp_stem_extender();
//joystick_joiner();
//joystick_y_padding_washer();
test_x = 0;
test_y = 0;
if (0)
{
	translate([0,0,inner_gimbal_z/2+base_support_height-12]) rotate([test_x,0,0]) rotate([0,test_y,0]) translate([0,0,-joiner_peg_z])  union()
	{
		joystick_joiner();
		translate([0,0,-9]) joystick_magnet_holder(10.5,7);
	}
	translate([springbar_z+inner_gimbal_total_x/2,0,inner_gimbal_z/2+base_support_height-12.5]) rotate([0,-90,0]) union()
	{
		joystick_stem_plug_springbar(inner_gimbal_clearance);
		translate([0,0,joiner_peg_z+bearing_thickness]) joystick_y_padding_washer();
	}
	translate([0,0,inner_gimbal_z/2+base_support_height-12]) rotate([test_x,0,0]) joystick_inner_gimbal();
	joystick_base();
	translate([0,0,inner_gimbal_z/2+base_support_height-10]) gimbal_alignment_jig();
}
//joystick_y_padding_washer();
//joystick_inner_gimbal();
/*
translate([-15,-15,0]) joystick_stem_plug_springbar(0);
translate([15,-15,0]) joystick_stem_plug_springbar(0);
*/
translate([15,15,0]) joystick_stem_plug_springbar(inner_gimbal_clearance);
translate([-15,15,0]) joystick_stem_plug_springbar(inner_gimbal_clearance);

//joystick_magnet_holder(10.5,7);

//joystick_base();
//fillet(10,10);


//translate([0,0,inner_gimbal_z/2]) joystick_inner_gimbal();
