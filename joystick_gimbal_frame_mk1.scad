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

gimbal_frame();

gimbal_frame_bolt_depth = 15;

module gimbal_frame()
{
	difference()
	{
		cube([gimbal_frame_x,gimbal_frame_y,gimbal_frame_z], center=true);
		// Boosted zff right up here, don't know why it's required, but it is.
		translate([0,0,-zff])
			cube([gimbal_frame_x-(2*gimbal_frame_thickness),gimbal_frame_y-(2*gimbal_frame_thickness),gimbal_frame_z + 30*zff], center=true);

		// X rot bearings 
		translate([gimbal_frame_x/2+zff - (gimbal_frame_thickness-bearing_thickness),0,0])
			rotate([0,-90,0])
				bearing();
		translate([-gimbal_frame_x/2-zff + (gimbal_frame_thickness-bearing_thickness),0,0])
			rotate([0,90,0])
				bearing();

		translate([-(gimbal_frame_x/2)-zff,0,0])
			rotate([0,90,0])
				cylinder(h=(gimbal_frame_x+2*zff), r=(bearing_inside_dia/2), $fn=50);
		// Bolt holes 
		translate([-gimbal_frame_x/2 + gimbal_frame_thickness/2, -gimbal_frame_y/2 + gimbal_frame_thickness/2,gimbal_frame_z/2+zff-gimbal_frame_bolt_depth])
			cylinder(r = 1.5, h=gimbal_frame_bolt_depth + zff, $fn=50);
		translate([gimbal_frame_x/2 - gimbal_frame_thickness/2, gimbal_frame_y/2 - gimbal_frame_thickness/2,gimbal_frame_z/2+zff-gimbal_frame_bolt_depth])
			cylinder(r = 1.5, h=gimbal_frame_bolt_depth + zff, $fn=50);
		translate([gimbal_frame_x/2 - gimbal_frame_thickness/2, -gimbal_frame_y/2 + gimbal_frame_thickness/2,gimbal_frame_z/2+zff-gimbal_frame_bolt_depth])
			cylinder(r = 1.5, h=gimbal_frame_bolt_depth + zff, $fn=50);
		translate([-gimbal_frame_x/2 + gimbal_frame_thickness/2, gimbal_frame_y/2 - gimbal_frame_thickness/2,gimbal_frame_z/2+zff-gimbal_frame_bolt_depth])
			cylinder(r = 1.5, h=gimbal_frame_bolt_depth + zff, $fn=50);

	}
}