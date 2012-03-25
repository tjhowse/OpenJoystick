include <joystick_defines.scad>
use <joystick_4_way_hat_mk1.scad>

module joystick_head()
{
	shaft_offset = -3;
	
	mode_button_z = 44.5;
	
	difference()
	{
		
		//scale([0.7,1,0.6]) sphere(r=37);
		union()
		{
			scale([0.7,1,0.6]) sphere(r=37);
			translate([0,mode_button_z-10,0]) rotate([-90,0,0]) cylinder(r=6,h=6);
			
		}

		//translate([20,0,10])rotate([45,0,0]) joystick_head_faceclip();
		translate([0,0,10]) rotate([45,0,0]) translate([0,-7,0]) joystick_head_faceplate_negative_removal();
		translate([0,0,-42.5]) cube([50,70,50],true);		
		translate([0,shaft_offset,-38]) cylinder(r=(shaft_dia/2), h=26);
		
		// Trigger cutaway
		translate([-(joystick_head_trigger_thickness/2),28, 5]) rotate([0,-90,180]) joystick_head_trigger_cutaway();
		
		translate([0,mode_button_z,0]) rotate([-90,0,0]) rotate([0,0,90]) union()
		{
			difference()
			{
				joystick_big_button_cutout(0);
				translate([-5,-15.5,-11]) cube([10,10,10]);
			}
			translate([-3,-6.3,-11]) cube([6,6,1]);
		}
		
		// Channel for mode button wires
		translate([6,0,0]) rotate([-90,0,0]) cylinder(r=1.5,h=34);
		
		//translate([0,-50,-50]) cube([100,100,100]);
		joystick_head_sidecuts();
	}
	
	//translate([0,shaft_offset,-43]) cylinder(r=(grip_diameter/2), h=26);	
}

module joystick_head_sidecuts()
{
	side_cut_y = -17;	
	union()
	{
		translate([-20,side_cut_y,-50]) rotate([-45,0,0]) scale([0.6,1,1]) translate([0,0,-50]) cylinder(r=20,h=200);
		translate([-32,side_cut_y,-50]) rotate([-45,0,0]) translate([0,0,50]) scale([0.6,1,1]) cube([40,40,200],true);
	}
	union()
	{
		translate([20,side_cut_y,-50]) rotate([-45,0,0]) scale([0.6,1,1]) translate([0,0,-50]) cylinder(r=20,h=200);
		translate([32,side_cut_y,-50]) rotate([-45,0,0]) translate([0,0,50]) scale([0.6,1,1]) cube([40,40,200],true);
	}
}

module joystick_faceplate()
{
	shaft_offset = -3;
	difference()
	{
		scale([0.7,1,0.6]) sphere(r=37);

		//translate([20,0,10])rotate([45,0,0]) joystick_head_faceclip();
		translate([20,0,10])rotate([45,0,0]) joystick_head_faceplate_cutout();
		translate([0,0,-42.5]) cube([50,70,50],true);		
		translate([0,shaft_offset,-38]) cylinder(r=(shaft_dia/2), h=26);
		
	}
	
	//translate([0,shaft_offset,-43]) cylinder(r=(grip_diameter/2), h=26);	
}

module joystick_head_faceclip()
{
	offset_x = -10.2;
	offset_y = 0;
	union()
	{
		translate([-50,-50,0]) cube([100,100,60]);
		translate([-20+offset_x,-20+offset_y,zff]) hat_cutout(1.05);
		translate([0+offset_x,-20+offset_y,zff]) hat_cutout(1.05);
		translate([0+offset_x,0+offset_y,zff]) hat_cutout(1.05);
		translate([-30,0,0]) rotate([0,0,90]) joystick_big_button_cutout();
	}
	// Wiring channels
	union()
	{
		translate([0+offset_x,-10,-1-4_way_hat_cutout_z+zff]) cube([5,25,2],true);
		translate([-10+offset_x,-20,-1-4_way_hat_cutout_z+zff]) cube([25,5,2],true);
		translate([-28,-3.0,-19]) cube([3,pb_xy,3]);
		translate([-28,-3.0,-19.2]) rotate([0,-18,0]) cube([22,3,3]);
		
	}	
}

module joystick_head_trigger(hole)
{
	//translate([-17,-8.5,0])
	translate([-13,-16,0])
	union()
	{
		difference()
		{
			union()
			{
				scale([0.7,1.0,1])
					difference()
					{
						scale([1,0.5,1]) cylinder(r=40, h=joystick_head_trigger_thickness);
						translate([-5,-5,-zff]) scale([1.2,0.5,1]) cylinder(r=33, h=7+2*zff);
						translate([0,-50,-zff]) cube([100,100,joystick_head_trigger_thickness+2*zff]);		
					}
				translate([0,11.4,-zff]) cube([17,8.5,joystick_head_trigger_thickness+2*zff]);
			}
			translate([16.5,2,-(2*zff)]) rotate([0,0,45]) cube([10,10,joystick_head_trigger_thickness+4*zff]);
			translate([17.5,15,-(2*zff)]) rotate([0,0,45]) cube([10,10,joystick_head_trigger_thickness+4*zff]);
			translate([15.5,12,-(2*zff)]) rotate([0,0,0]) cube([10,10,joystick_head_trigger_thickness+4*zff]);
			if (hole == 1)
			{
				translate([13,16,-10]) cylinder(r=1.5, h=20);
			}
			// Hole for spring
			 translate([-10,23,joystick_head_trigger_thickness/2]) rotate([90,0,-5]) cylinder(r=2.1,h=10);
		}
		// Bump for pressing button
		translate([-8,17,0]) cube([3.5,6,joystick_head_trigger_thickness]);
	}
}

module joystick_head_trigger_cutaway()
{
	j = 160;
	/*for (i = [-2:5])
	{
		rotate([0,0,i*-4]) translate([-13,-16,-0.3]) scale([1.1,1.1,1.1]) color("red") joystick_head_trigger(0);
	}*/
	
	/*intersection()
	{	
		difference()
		{
			translate([-35,-87,-0.05*joystick_head_trigger_thickness]) cylinder(r=100,h=joystick_head_trigger_thickness*1.1, $fn=40);
			translate([2,-94,-0.05*joystick_head_trigger_thickness]) cylinder(r=90,h=joystick_head_trigger_thickness*1.1, $fn=40);
		}
		translate([-21,-10,-0.05*joystick_head_trigger_thickness]) cylinder(r=30, h = joystick_head_trigger_thickness*1.1);
	}*/
	
	translate([0,0,-(joystick_head_trigger_thickness*0.1)/2]) union()
	{
		rotate([0,0,-18]) scale([1.1,1.1,1.1]) joystick_head_trigger(1);
		rotate([0,0,-3]) scale([1.1,1.1,1.1]) joystick_head_trigger(1);
		cylinder(r=1.5*1.11, h = joystick_head_trigger_thickness*1.1);
	}
		
	translate([1,11,0]) rotate([0,0,j])
	union()
	{
		translate([0,0,0]) lever_switch(1.01,0);
		//rotate([0,0,j]) translate([lever_switch_x,0,(lever_switch_z-pb_xy)/2]) cube([pb_xy,pb_z,pb_xy]);
		translate([lever_switch_x,0,(lever_switch_z-pb_xy)/2])
			translate([pb_xy/2+0.4,0,pb_xy/2])
				rotate([-90,0,0])
					scale([1.1,1,1])
						pb(1.01,1);
		// Gapfilla
		translate([0,pb_z,-joystick_head_trigger_thickness*0.05]) cube([lever_switch_x+pb_xy+3,10,joystick_head_trigger_thickness*1.1]);
		
		// Wire channels
		translate([0,-7-5+1.5,0]) cube([lever_switch_x+pb_xy+0.74, 8.5,joystick_head_trigger_thickness]);
		//translate([12.99,-4.2,5]) #cube([6*1.476, 6, 2]);
		translate([12.99,-4.2,5]) cube([6*1.1, 6.6, 2]);
	}
	// Breathing room for the top of the trigger
	//translate([0,1,-0.05*joystick_head_trigger_thickness]) scale([1,0.8,1]) cylinder(r=7, h = joystick_head_trigger_thickness*1.1);
	translate([0,0,-50]) cylinder(r=1.5, h = 100);
	
	// Hole for the return spring
	translate([-20,4,joystick_head_trigger_thickness/2]) rotate([-90,0,0]) cylinder(r=2.05,h=18);
	
	//Wire channel to base
	translate([-25,23.7,0]) cube([30,5,joystick_head_trigger_thickness]);
	
}

module lever_switch(puff, open)
{
	cube([lever_switch_x*puff,lever_switch_y*puff, lever_switch_z*puff]);
	translate([0,-3.4,lever_switch_z/2-1]) cube([12.85,3.4,2]);
	translate([1,6.5,1.076]) rotate([0,0,open*20]) cube([17.5,0.31,3.65]);
}

module joystick_big_button()
{
	jbbc = joystick_big_btn_clippyness;
	jbbd = joystick_big_btn_diameter;	
	difference()
	{
		union()
		{
			cylinder(r=jbbd/2, h = joystick_big_btn_height,$fn=circle_faces);
			cylinder(r1=jbbd/2, r2=jbbd/2+0.7, h = 1,$fn=circle_faces);
		}
		union()
		{
			translate([0,0,-zff])difference()
			{
				cylinder(r=(jbbd/2)-1, h=jbbc,$fn=circle_faces);
				cylinder(r=(jbbd/2)-2, h=jbbc,$fn=circle_faces);
			}
		}		
		translate([0,4,(jbbc/2)-zff]) cube([2,3,jbbc],true);
		translate([4,0,(jbbc/2)-zff]) cube([3,2,jbbc],true);
		translate([0,-4,(jbbc/2)-zff]) cube([2,3,jbbc],true);
		translate([-4,0,(jbbc/2)-zff]) cube([3,2,jbbc],true);
	}
}

module joystick_button()
{
	button_diameter = 10;
	
	lip = 0.5;
	
	cylinder(r=button_diameter/2,h=joystick_big_btn_height);
	cylinder(r=button_diameter/2+lip,h=1);
	
}


module joystick_big_button_cutout(legdir)
{
	// Button should protrude 7mm
	
	//translate([0,0,pb_z+pb_btn_z]) joystick_big_button();
	
	translate([0,0,-joystick_big_btn_height+pb_btn_z])
	union()
	{
		translate([0,0,pb_z]) cylinder(r=4.8,h=joystick_big_btn_height+2,$fn=circle_faces);
		translate([0,0,pb_z]) cylinder(r=5.2,h=1+pb_btn_z,$fn=circle_faces);
		pb(1.01,legdir);
	}
}

module joystick_head_faceplate_cutout()
{
	offset_x = -10.2;
	offset_y = 0;
	union()
	{
		translate([-20+offset_x,-20+offset_y,zff-4_way_hat_base_z]) hat_voids(4);
		translate([0+offset_x,-20+offset_y,zff-4_way_hat_base_z]) hat_voids(4);
		translate([0+offset_x,0+offset_y,zff-4_way_hat_base_z]) hat_voids(4);
		translate([-30,0,4]) rotate([0,0,90]) joystick_big_button_cutout(1);
	}
	
	translate([-50,-50,-40-4_way_hat_base_z+1]) cube([100,100,40]);
	translate([-50,-50,0]) cube([100,100,30]);
	translate([-50,-50,0]) cube([100,100,30]);
}

module joystick_head_faceplate_negative_removal()
{
	cutout_depth = 3;
	
	translate([-50,-50,-zff-4_way_hat_base_z+1]) cube([100,100,60]);
	difference()
	{
		translate([0,0,-zff-4_way_hat_base_z+1-cutout_depth]) scale([1,1.1,1]) cylinder(r=20,h=cutout_depth);
		translate([-13,4,-zff-4_way_hat_base_z+1-cutout_depth]) cube([6,6,cutout_depth-1]);		
	}
	
}

module joystick_head_with_boltholes(headorface)
{
	// headorface:
	// 0 - head
	// 1 - face
	// 2 - both

	trigger_guard_bolts_extra_distance = 6;
	difference()
	{
		union()
		{
			if (headorface !=1) 
			{
				difference()
				{
					joystick_head();
					translate([0,8-trigger_guard_bolts_extra_distance,-5])
					{
						rotate([270,0,0]) translate([6,0,-7.1]) bolt(3,3+trigger_guard_bolts_extra_distance,1.5,20,13);
						rotate([270,0,0]) translate([-6,0,-7.1]) bolt(3,3+trigger_guard_bolts_extra_distance,1.5,20,13);
					}
				}
			}
			if (headorface >= 1) 
			{
				joystick_faceplate();
			}
		}
		//bolt(cap_r, cap_z, shaft_r, shaft_z)
		rotate([225,0,0]) translate([0,-17,-7.1]) bolt(3,3,1.5,10,6.7);
		rotate([225,0,0]) translate([0,7,-7.1]) bolt(3,3,1.5,10,6.7);	
		
	}
}

//translate([-10,10,-50]) rotate([-20,0,0]) scale([0.8,1,1]) cylinder(r=10,h=100);

//lever_switch(1);

//joystick_head_trigger_cutaway();

//joystick_head_trigger_cutaway();
//joystick_head_trigger(1);
//render() joystick_head_with_boltholes(0);

//render() joystick_faceplate();
//joystick_head();
//joystick_head();
//lever_switch(1, 0);


//joystick_head_faceplate_negative_removal();
//joystick_head_trigger(1);
//joystick_big_button();
joystick_button();

//joystick_big_button_cutout();

//joystick_head_faceplate_cutout();
//joystick_head_faceplate_negative_removal();

//hat_cutout(1.05);

//joystick_head_faceclip();

// PRINTABLE EXPORT THINGS HERE *******************
// Just the head
/*render()translate([0,0,17.50])
{
	difference()
	{	
		joystick_head_with_boltholes(0);
		translate([-50,-10,-50]) rotate([-30,0,0]) cube([100,100,100]);	
	}
}*/
	/*translate([0,60,-33.8426])
	rotate([120,0,0])
	difference()
	{
		joystick_head_with_boltholes(0);
		
		//translate([-50,-80,-50]) cube([100,100,100]);	
		translate([-50,-96.6,0]) rotate([-30,0,0]) cube([100,100,100]);	
	}
}*/
//translate([50,0,-0.571]) render() rotate([-45,0,0]) joystick_head_with_boltholes(1);

//translate([-50,-50,0]) #cube([100,100,10]);
// Nope, that doesn't work. You've gotta export this is an STL and chunk it up separately
//render() joystick_head_with_boltholes(0);
// PRINTABLE EXPORT THINGS HERE *******************