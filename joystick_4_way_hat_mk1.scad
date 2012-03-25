include <joystick_defines.scad>

// See joystick_defines for most of the guts.

//translate([0,0,10])
//	4_way_hat_washer();
//translate([0,0,13])
//	switch_hat_saddle();
//  switch_hat_hanoi();
//pb(1);

module hat_base(numDirs)
{
	difference()
	{
		cylinder(r=(4_way_hat_base_dia/2), h=4_way_hat_base_z, $fn=circle_faces);
		
		translate([0,pb_total_z+(4_way_hat_base_screw_dia/2),4_way_hat_base_z-pb_xy/2+zff])
			rotate([90,0,0])
				pb(1.02,0);
		translate([0,-pb_total_z-(4_way_hat_base_screw_dia/2),4_way_hat_base_z-pb_xy/2+zff])
			rotate([-90,180,0])
				pb(1.02,0);
		if (numDirs==4)
		{
			translate([pb_total_z+(4_way_hat_base_screw_dia/2),0,4_way_hat_base_z-pb_xy/2+zff])
				rotate([90,0,-90])
					pb(1.02,0);
			translate([-pb_total_z-(4_way_hat_base_screw_dia/2),0,4_way_hat_base_z-pb_xy/2+zff])
				rotate([-90,180,-90])
					pb(1.02,0);
//			// Now chop the bit out of the middle
			translate([0,0,4_way_hat_base_base_z+zff])
				//cube([4_way_hat_base_screw_dia+2*pb_btn_z+zff,4_way_hat_base_screw_dia+2*pb_btn_z+zff,10],center=true);
                cylinder(r=sqrt(pow((pb_btn_dia/2),2) + pow((4_way_hat_base_screw_dia/2+pb_btn_z),2)),h=10,$fn=circle_faces);
		} else	{
			// Now chop the bit out of the middle
			translate([0,0,4_way_hat_base_base_z+5])
				cube([4_way_hat_base_screw_dia,4_way_hat_base_screw_dia+2*pb_btn_z+zff,10],center=true);
		}

		// Now chop the bit out of the middle
		/*translate([0,0,4_way_hat_base_base_z+5])
			cube([pb_xy+zff,pb_xy+zff,10],center=true);*/

		// Screw
		translate([0,0,-1])
            union()
            {
                rotate([0,5,0]) cylinder(r=4_way_hat_base_screw_dia/2, h=4_way_hat_base_z*1, $fn=circle_faces);
                rotate([0,-5,0]) cylinder(r=4_way_hat_base_screw_dia/2, h=4_way_hat_base_z*1, $fn=circle_faces);
                rotate([5,0,0]) cylinder(r=4_way_hat_base_screw_dia/2, h=4_way_hat_base_z*1, $fn=circle_faces);
                rotate([-5,0,0]) cylinder(r=4_way_hat_base_screw_dia/2, h=4_way_hat_base_z*1, $fn=circle_faces);
                cylinder(r=4_way_hat_base_screw_dia/2, h=4_way_hat_base_z*1, $fn=circle_faces);
            }
	}		
}

module hat_voids(numDirs)
{
	difference()
	{
		cylinder(r=4_way_hat_base_dia/2, h=4_way_hat_base_z);		
		hat_base(numDirs);
	}
}

// Next up: build the hat that goes on top out of a series of stacking cylinders, tower of hanoi style with a 4_way_hat_base_screw_dia hole in the bottom

module switch_hat_saddle()
{
	step_size = 2; // Won't really work for anything other than 2, sorry.
	num_steps = 4_way_hat_base_dia / step_size;
	switch_hat_saddle_base_depth = 4;


	union()
	{
		translate([0,0,switch_hat_saddle_base_depth])
			intersection()
			{
				cylinder(r = (4_way_hat_base_dia/2), h = 10, $fn=circle_faces);
				for (n = [0:num_steps])
				{
					translate([-(4_way_hat_base_dia/2)+n*step_size+0.25*step_size,0,0])
						cube([step_size, 4_way_hat_base_dia, abs((num_steps/2)-n)*1.5],center=true);
				}
			}
		difference()
		{
			cylinder(r = (4_way_hat_base_dia/2), h = switch_hat_saddle_base_depth, $fn=circle_faces);
			translate([0,0,-zff])
				cylinder(r=(4_way_hat_base_screw_dia/2), h =switch_hat_saddle_base_depth, $fn=circle_faces);
		}
	}
}

module switch_hat_hanoi()
{
	
	difference()
	{
		union()
		{
			cylinder(r = (4_way_hat_base_dia/2), h = 2, $fn=circle_faces);
			translate([0,0,2])
			{
				for (n = [1:8])
				{
					cylinder(r = (4_way_hat_base_dia/2 - (n-1)), h = n*0.7, $fn=circle_faces);
				}
			}
		}
		translate([0,0,-zff])
			cylinder(r=(4_way_hat_base_screw_dia/2), h = 4, $fn=circle_faces);
	}	
}

module 4_way_hat_washer()
{
	difference()
	{
		cylinder(r=(4_way_hat_base_dia/2), h = 1, $fn=circle_faces);
		translate([0,0,-zff])
			cylinder(r=(4_way_hat_base_screw_dia/2), h = 1+2*zff, $fn=circle_faces);
	}
}

module hat_stem()
{
	bolt(8.5/2, 1.5, 4.5/2, 11,0);
}
	
//hat_stem();
//switch_hat_hanoi();
