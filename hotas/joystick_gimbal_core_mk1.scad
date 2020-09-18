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

x_rot_pin_depth = 10;

gimbal_core();

module gimbal_core()
{
	translate([0,0,(gimbal_core_z/2) * printable_mode])
	difference()
	{
		cube([gimbal_core_x, gimbal_core_y, gimbal_core_z], center=true);
		// Y rot bearings
		translate([0,gimbal_core_y/2+zff,0])
			rotate([90,0,0])
				bearing();
		translate([0,-gimbal_core_y/2-zff,0])
			rotate([-90,0,0])
				bearing();
		// X rot pin holes
		translate([-(gimbal_core_x/2)-zff,0,0])
			rotate([0,90,0])
				cylinder(h=x_rot_pin_depth, r = (bearing_inside_dia/2), $fn=50);
		translate([(gimbal_core_x/2)+zff,0,0])
			rotate([0,-90,0])
				cylinder(h=x_rot_pin_depth, r = (bearing_inside_dia/2), $fn=50);
		// Shaft slot
		for (n = [-9:9])
		{
			rotate([0,(n/3)*10,0])
				translate([0,0,-50])
					cylinder(h=100, r = (shaft_dia/2),  $fn=50);
		}
		// Shaft pin
		translate([0,gimbal_core_y/2+zff,0])
			rotate([90,0,0])
				cylinder(h=(gimbal_core_y+2*zff), r= (bearing_inside_dia/2), $fn = 50);

		// Chamfers
		//translate([-(gimbal_core_x/2),-(gimbal_core_y/2),-(gimbal_core_z/2)])
			//chamfer_block();
		
	}
}
