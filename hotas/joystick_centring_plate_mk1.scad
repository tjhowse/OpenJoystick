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

centring_plate_z = 6;

subtraction_cone_height = 15;

centring_plate_rim_height = 6;
centring_plate_rim_width = 5;

centring_cone_extra_thickness = 4;

//centring_plate();

centring_cone();

module centring_plate()
{
	difference()
	{
		union()
		{
			cube([gimbal_frame_x, gimbal_frame_y, centring_plate_z], center=true);
			translate([0,0,centring_plate_z/2])
				cylinder(r1= (gimbal_frame_y-gimbal_frame_thickness)/2+centring_plate_rim_width, r2= (gimbal_frame_y-gimbal_frame_thickness)/2, h=6);
		}
	// Angled chamfer in the middle
	translate([0,0,-subtraction_cone_height+centring_plate_rim_height + centring_plate_z/2 + z_fight_fudge ])
		cylinder(r1=0, r2= (gimbal_frame_y-gimbal_frame_thickness)/2,h=subtraction_cone_height);

	// Vertical walls in the middle
	translate([0,0,-centring_plate_z - z_fight_fudge])
		cylinder(r= (gimbal_frame_y-gimbal_frame_thickness)/2 - centring_plate_rim_width, h = 20, $fn=50);

	// Bolt holes
	translate([-gimbal_frame_x/2 + gimbal_frame_thickness/2, -gimbal_frame_y/2 + gimbal_frame_thickness/2,-z_fight_fudge-centring_plate_z/2])
		cylinder(r = 1.5, h=centring_plate_z + 2*z_fight_fudge, $fn=50);
	translate([gimbal_frame_x/2 - gimbal_frame_thickness/2, gimbal_frame_y/2 - gimbal_frame_thickness/2,-z_fight_fudge-centring_plate_z/2])
		cylinder(r = 1.5, h=centring_plate_z + 2*z_fight_fudge, $fn=50);
	translate([gimbal_frame_x/2 - gimbal_frame_thickness/2, -gimbal_frame_y/2 + gimbal_frame_thickness/2,-z_fight_fudge-centring_plate_z/2])
		cylinder(r = 1.5, h=centring_plate_z + 2*z_fight_fudge, $fn=50);
	translate([-gimbal_frame_x/2 + gimbal_frame_thickness/2, gimbal_frame_y/2 - gimbal_frame_thickness/2,-z_fight_fudge-centring_plate_z/2])
		cylinder(r = 1.5, h=centring_plate_z + 2*z_fight_fudge, $fn=50);

	}

}

module centring_cone()
{
	difference()
	{

		union()
		{
			translate([0,0,centring_cone_extra_thickness])
				cylinder(r2=0, r1= (gimbal_frame_y-gimbal_frame_thickness)/1.8,h=subtraction_cone_height);
		
			cylinder(r=(gimbal_frame_y-gimbal_frame_thickness)/1.8,h=centring_cone_extra_thickness, $fn=50);
		}
	translate([0,0,-z_fight_fudge])
		cylinder(r=shaft_dia/2, h = 50, $fn=50);
	}
	
}