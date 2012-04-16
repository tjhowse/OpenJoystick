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

// Standard skate bearing
bearing_inside_dia = 8;
bearing_outside_dia = 22;
bearing_thickness = 7;

// Arbitrary value
shaft_dia = 16;

zff = 0.005;

extrusion_width = 0.8; // Used for single-wall support.

// Set this to 1 to translate everything to printable mode
printable_mode = 0;

// Gimbal core block sizes 
gimbal_core_x = 50;
gimbal_core_y = 30;
gimbal_core_z = gimbal_core_y;

// Gimbal frame sizes 
gimbal_frame_thickness = 10; 

circle_faces = 20;
$fn=circle_faces;

// The 1.8 is 2sin(45)ish, the maximum y on the xy plane the core can occupy
gimbal_frame_x = gimbal_core_x+2*gimbal_frame_thickness+2; // 2mm for washers
gimbal_frame_y = (gimbal_core_y * 1.8)+gimbal_frame_thickness;

// Frame is big enough to stop the core colliding at 45 degree rotation.
gimbal_frame_z = sqrt(pow(gimbal_core_z,2)/2) * 2 + 2; // 2 fudge to allow for clearance at tips.

max_angle = 45; // Not much comes off this, should probably build it in more places.

module bearing(hole,outer_puff)
{
	difference()
	{
		cylinder(h=bearing_thickness, r = (bearing_outside_dia/2)+outer_puff);

		if (hole)
		{
			translate([0,0,-zff])
				cylinder(h=9, r = (bearing_inside_dia/2));
		}
	}
}

// Hat sizes
// Note that many other settings for the hats are in their own .scad, only stuff relevant to the rest of the stick is here.
pb_xy = 6;
pb_z = 4; // Height minus pushbutton
pb_btn_z = 1;
pb_total_z = pb_z+pb_btn_z;
pb_btn_dia = 3.5;
pb_leg_x = 4;
pb_leg_y = 5;
pb_leg_z = 0.7;

lever_switch_x = 12.85;
lever_switch_y = 6.5;
lever_switch_z = 5.8;

4_way_hat_base_dia = 18;
4_way_hat_base_base_z = 1.5; // Base thickness
4_way_hat_base_z = pb_xy + 4_way_hat_base_base_z;
4_way_hat_base_screw_dia = 5;
4_way_hat_base_screw_head_dia = 8.25;
4_way_hat_base_screw_head_thk = 3;
4_way_hat_wire_gap = 3;
4_way_hat_cutout_z = 4_way_hat_base_z + 4_way_hat_base_screw_head_thk;

// Grip sizes
grip_height = 100;
grip_diameter = 44;
grip_clip = 33;
grip_rest_thickness = 5;
grip_rest_diameter = 80;
grip_cms_height_offset = 50;
grip_cms_offset = -5;
grip_cms_angle = 30;
grip_cms_stub_length = 40;
grip_cms_stub_diameter = 4_way_hat_base_dia;
grip_cms_twist = 15;

grip_head_offset_x = -10;
grip_head_box_x = 4_way_hat_base_dia * 2.5;
grip_head_box_y = 4_way_hat_base_dia * 2.2;
grip_head_box_z = 4_way_hat_base_dia * 2;

joystick_head_trigger_thickness = pb_xy;

my_layer_thickness = 0.35;

joystick_big_btn_height = 8;
joystick_big_btn_diameter = 8.0;
joystick_big_btn_clippyness = 3;

headbolt_x = 10.8;
headbolt_y = -9;
headbolt_z = -11;
headbolt_extra = 8;

module hat_cutout(bloat)
{
	// Very similar to a hat, but it has a cross on the bottom and a peg to indicate where the cables will be run.
	translate([0,0,-4_way_hat_wire_gap-4_way_hat_base_z])
	union()
	{
		translate([0,0,4_way_hat_wire_gap])cylinder(r=(4_way_hat_base_dia/2)*bloat,h=4_way_hat_base_z);
		
		intersection()
		{
			cylinder(r=(4_way_hat_base_dia/2)*bloat,h=4_way_hat_base_z);
			union()
			{
				cube([100, pb_xy, 10],true);
				cube([pb_xy, 100, 10],true);
			}
		}
		translate([0,0,-4_way_hat_base_screw_head_thk+4_way_hat_wire_gap]) cylinder(r=(4_way_hat_base_screw_head_dia/2),h=4_way_hat_base_screw_head_thk,$fn=circle_faces);
	}
}

module pb(puff, legdir)
{
	translate([0,0,pb_z/2])
	{
		// Puff set to 1 if you want a realistic model of a button.
		// Puff variable used for making holes in things bigger than the button size
		cube([pb_xy*puff,pb_xy*puff,pb_z*puff],center=true);
	
		// Button knob itself
		translate([0,0,pb_z/2-zff])
			cylinder(r=(pb_btn_dia/2),h=pb_btn_z,$fn=circle_faces);
	
		// Button legs
		if (legdir == 0)
		{
			translate([0,-pb_xy/2-pb_leg_y/2+zff,-pb_z/2+pb_leg_z/2+0.8])
				cube([pb_xy,pb_leg_y,pb_leg_z],center=true);
		} else {
			translate([0,-pb_xy/2+pb_leg_z/2+zff-pb_leg_z,-pb_z/2-pb_leg_y/2+0.8])
				cube([pb_xy,pb_leg_z,pb_leg_y],center=true);
		}
	}

}

module bolt(cap_r, cap_z, shaft_r, shaft_z,slot_len)
{
	// Hex head bolt for holding head together
	cylinder(r=cap_r,h=cap_z);
	translate([0,0,cap_z]) cylinder(r=shaft_r+0.15, h=slot_len);
	translate([0,0,cap_z+slot_len]) cylinder(r=shaft_r, h=shaft_z-slot_len);
}

module fillet(radius, length)
{
	difference()
	{
		cube([radius,length,radius]);
		translate([radius,length+zff,radius]) rotate([90,0,0]) cylinder(r=radius,h=length+2*zff);
	}
}



