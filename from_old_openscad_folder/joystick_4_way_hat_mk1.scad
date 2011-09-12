include <joystick_defines.scad>

// variables for little microswitch pushbutton, might move these to joystick_defines
pb_xy = 7.5;
pb_z = 4; // Height minus pushbutton
pb_btn_z = 1.5;
pb_total_z = pb_z+pb_btn_z;
pb_btn_dia = 3;
pb_leg_x = 4;
pb_leg_y = 5;
pb_leg_z = 0.7;

4_way_hat_base_dia = 21;
4_way_hat_base_base_z = 2; // Base thickness
4_way_hat_base_z = pb_xy + 4_way_hat_base_base_z;

4_way_hat_base_screw_dia = 5;

/*hat_base(4);
translate([0,0,10])
	4_way_hat_washer();
translate([0,0,13])
	switch_hat_saddle();*/
	switch_hat_hanoi();
//pb(1);

module hat_base(numDirs)
{
	difference()
	{
		cylinder(r=(4_way_hat_base_dia/2), h=4_way_hat_base_z, $fn=circle_faces);
		
		translate([0,pb_total_z+(4_way_hat_base_screw_dia/2),4_way_hat_base_z-pb_xy/2+z_fight_fudge])
			rotate([90,0,0])
				pb(1);
		translate([0,-pb_total_z-(4_way_hat_base_screw_dia/2),4_way_hat_base_z-pb_xy/2+z_fight_fudge])
			rotate([-90,180,0])
				pb(1);
		if (numDirs==4)
		{
			translate([pb_total_z+(4_way_hat_base_screw_dia/2),0,4_way_hat_base_z-pb_xy/2+z_fight_fudge])
				rotate([90,0,-90])
					pb(1);
			translate([-pb_total_z-(4_way_hat_base_screw_dia/2),0,4_way_hat_base_z-pb_xy/2+z_fight_fudge])
				rotate([-90,180,-90])
					pb(1);
//			// Now chop the bit out of the middle
			translate([0,0,4_way_hat_base_base_z+5+z_fight_fudge])
				cube([4_way_hat_base_screw_dia+2*pb_btn_z+z_fight_fudge,4_way_hat_base_screw_dia+2*pb_btn_z+z_fight_fudge,10],center=true);
		} else	{
			// Now chop the bit out of the middle
			translate([0,0,4_way_hat_base_base_z+5])
				cube([4_way_hat_base_screw_dia,4_way_hat_base_screw_dia+2*pb_btn_z+z_fight_fudge,10],center=true);
		}

		// Now chop the bit out of the middle
		/*translate([0,0,4_way_hat_base_base_z+5])
			cube([pb_xy+z_fight_fudge,pb_xy+z_fight_fudge,10],center=true);*/

		// Screw
		translate([0,0,-1])
			cylinder(r=4_way_hat_base_screw_dia/2, h=4_way_hat_base_z*1, $fn=circle_faces);
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
			translate([0,0,-z_fight_fudge])
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
		translate([0,0,-z_fight_fudge])
			cylinder(r=(4_way_hat_base_screw_dia/2), h = 4, $fn=circle_faces);
	}	
}

module 4_way_hat_washer()
{
	difference()
	{
		cylinder(r=(4_way_hat_base_dia/2), h = 1, $fn=circle_faces);
		translate([0,0,-z_fight_fudge])
			cylinder(r=(4_way_hat_base_screw_dia/2), h = 1+2*z_fight_fudge, $fn=circle_faces);
	}
}
		

module pb(puff)
{
	translate([0,0,pb_z/2])
	{
		// Puff set to 1 if you want a realistic model of a button.
		// Puff variable used for making holes in things bigger than the button size
		cube([pb_xy,pb_xy,puff*pb_z],center=true);
	
		// Button knob itself
		translate([0,0,pb_z/2-z_fight_fudge])
			cylinder(r=(pb_btn_dia/2),h=pb_btn_z,$fn=circle_faces);
	
		// Button legs
		translate([pb_xy/2-pb_leg_x/2,-pb_xy/2-pb_leg_y/2+z_fight_fudge,-pb_z/2+pb_leg_z/2])
			cube([pb_leg_x,pb_leg_y,pb_leg_z],center=true);
		translate([-pb_xy/2+pb_leg_x/2,-pb_xy/2-pb_leg_y/2+z_fight_fudge,-pb_z/2+pb_leg_z/2])
			cube([pb_leg_x,pb_leg_y,pb_leg_z],center=true);
		/* snip
		translate([pb_xy/2-pb_leg_x/2,pb_xy/2+pb_leg_y/2-z_fight_fudge,-pb_z/2+pb_leg_z/2])
			cube([pb_leg_x,pb_leg_y,pb_leg_z],center=true);
		translate([-pb_xy/2+pb_leg_x/2,pb_xy/2+pb_leg_y/2-z_fight_fudge,-pb_z/2+pb_leg_z/2])
			cube([pb_leg_x,pb_leg_y,pb_leg_z],center=true);*/
	}

}