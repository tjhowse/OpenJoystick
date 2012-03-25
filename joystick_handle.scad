include <joystick_defines.scad>
use <joystick_4_way_hat_mk1.scad>
use <joystick_head.scad>

peg_height = 14;
peg_offset_x = 0;


module joystick_handle()
{
	trigger_cutout_z = 20;
	trigger_cutout_x = 6.7;
	peg_offset_z = 5;
	
	difference()
	{
		union()
		{
			translate([0,0,grip_rest_thickness])
				difference()
				{
					scale([1,0.7,1]) cylinder(h = grip_height, r = (grip_diameter/2));
					//translate([-15,0,90]) rotate([0,-45,0]) translate([0,0,-50]) scale([1,0.7,1]) cylinder(h = grip_height, r = (grip_diameter/2));
					//translate([0,0,grip_height/2])cube([grip_diameter,grip_clip,grip_height],true); 
					translate([-4.5,0,grip_height]) rotate([0,-20,0]) translate([0,0,-50]) difference()
					{
						translate([0,-50,0]) cube([100,100,100]);
						scale([1,0.7,1]) cylinder(h = grip_height, r = (grip_diameter/2));
					}
				}
			translate([10,10,0]) scale([1.2,1,1]) cylinder(h = grip_rest_thickness, r = (grip_rest_diameter / 2));
			//translate([peg_offset_x,0,grip_height-peg_offset_z]) cylinder(h = peg_height, r = (shaft_dia/2));
			
			
			}
		// Subtract hole through centre.
		translate([0,0,-zff])
			cylinder(h = (grip_height + grip_rest_thickness+ 2 * zff), r = (shaft_dia/2));
		
		translate([0,grip_cms_offset,grip_height-grip_cms_height_offset]) // I should be more clever about this.
				rotate([grip_cms_angle,0,0])
				union()
				{
					scale([1.05,1.05,0]) cms_stem(1);
					//%cms_stem(0);
				}			
				
		//translate([0,0,grip_height+23.5]) rotate([0,0,90]) joystick_head_sidecuts();
		//translate([0,0,grip_height]) rotate([0,0,90]) #joystick_handle_sidecuts();
		translate([0,0,grip_height+23.5]) rotate([0,0,90]) joystick_handle_sidecuts();
		
		
		//Holes for peg - might remove
		/*translate([peg_offset_x,0,grip_height-peg_offset_z]) 
		union()
		{
			translate([(shaft_dia/2)-2,0,peg_height/2]) cube([5,5,peg_height*2],true);
			translate([(-shaft_dia/2)+2,0,peg_height/2]) cube([5,5,peg_height*2],true);
			translate([0,0,-0.5]) cylinder(r=0.5,h=peg_height);
			
		}*/
		
		// Trigger cutout
		/*translate([-(grip_diameter/2),0,grip_height-trigger_cutout_z+10]) union()
		{
			cylinder(r=trigger_cutout_x/2+1,h=trigger_cutout_z);
			translate([1,0,trigger_cutout_z/2]) cube([trigger_cutout_x,trigger_cutout_x,trigger_cutout_z],true);
		}*/		
	}
	translate([peg_offset_x,0,grip_height-peg_offset_z]) joystick_handle_peg();
	
	//translate([0,0,grip_height+23.5]) rotate([0,0,90]) joystick_head_with_boltholes(0);
	//translate([-3,0,grip_height+22.6]) rotate([0,0,90]) import("joystick_head.stl");
}

module joystick_handle_parts(half)
{
	// half = 0 - All
	// half = 1 - Bottom
	// half = 2 - Top
	
	split_z = 40;
	extra_bolt = 15;
	thread_len = 10;
	peg_offset_z = 5;
	
	difference()
	{
		joystick_handle();
		if (half == 1)
		{
			translate([-100,-100,split_z]) cube([200,200,100]);
		} else if (half == 2)
		{
			translate([-100,-100,split_z-100]) cube([200,200,100]);
		}
		
		// Perfectly functional, but you can't reach the bolt heads easily.
		//translate([20,0,split_z-12]) rotate([0,-30,0]) translate([0,0,-extra_bolt+2]) #bolt(3,3+extra_bolt,1.5,20,thread_len);
		//rotate([0,0,180]) translate([20,0,split_z-12]) rotate([0,-30,0]) translate([0,0,-extra_bolt+2]) #bolt(3,3+extra_bolt,1.5,20,thread_len);
		
		translate([20,0,split_z-12]) rotate([0,-30,0]) translate([0,0,-extra_bolt+2]) #bolt(3,3+extra_bolt,1.5,20,thread_len);
		rotate([0,0,180]) translate([20,0,split_z-12]) rotate([0,-30,0]) translate([0,0,-extra_bolt+2]) #bolt(3,3+extra_bolt,1.5,20,thread_len);
	}
	
	if (half == 1)
	{
		translate([peg_offset_x,0,split_z-peg_offset_z-2]) joystick_handle_peg();
	}
}

module joystick_handle_peg()
{
	support_width = shaft_dia;
	
	difference()
	{
		union()
		{
			cylinder(h = peg_height, r = (shaft_dia/2));
			translate([-extrusion_width/2-(shaft_dia/2)+4.9,-support_width/2,-3]) cube([extrusion_width,support_width,3]);
			translate([-extrusion_width/2+(shaft_dia/2)-4.9,-support_width/2,-3]) cube([extrusion_width,support_width,3]);
		}
		union()
		{
			translate([(shaft_dia/2)-2,0,peg_height/2]) cube([5,5,peg_height*2],true);
			translate([(-shaft_dia/2)+2,0,peg_height/2]) cube([5,5,peg_height*2],true);
			translate([0,0,-0.5]) cylinder(r=0.5,h=peg_height);
		}
	}
}

module joystick_handle_sidecuts()
{
	// Mostly copied from joystick_head_sidecuts()
/*	side_cut_y = -17;	
	side_cut_z = 30;
	side_cut_z_scale = 1.5;
	union()
	{
		translate([-20,side_cut_y,-50]) rotate([-45,0,0]) scale([0.6,1,side_cut_z_scale]) translate([0,0,side_cut_z]) sphere(r=20);
	}
	union()
	{
		translate([20,side_cut_y,-50]) rotate([-45,0,0]) scale([0.6,1,side_cut_z_scale]) translate([0,0,side_cut_z]) sphere(r=20);
	}*/
	
	side_cut_x = 18.7;
	side_cut_y = 18.5;
	//side_cut_z = 20;
	side_cut_z = 33;
	side_cut_x_scale = 0.54;
	side_cut_y_scale = 1.38;
	//side_cut_z_scale = 1.5;
	side_cut_z_scale = 1;
	union()
	{
		translate([-side_cut_x,side_cut_y,-50]) scale([side_cut_x_scale,side_cut_y_scale,side_cut_z_scale]) translate([0,0,side_cut_z]) sphere(r=20);
	}
	union()
	{
		translate([side_cut_x,side_cut_y,-50]) scale([side_cut_x_scale,side_cut_y_scale,side_cut_z_scale]) translate([0,0,side_cut_z]) sphere(r=20);
	}
	
	
}
module cms_stem(bolt)
{
	bolt_x = -22;
	bolt_y = grip_cms_stub_diameter/4+1.3;
	bolt_z = 18;

	if (bolt)
	{
		cylinder(h = grip_cms_stub_length, r = (grip_cms_stub_diameter/2));
		translate([bolt_x,bolt_y,bolt_z]) rotate([0,90,0]) bolt(3,3+10,1.5,20,17);
	} else
	{
		difference()
		{
			union()
			{
				difference()
				{
					cylinder(h = grip_cms_stub_length, r = (grip_cms_stub_diameter/2));
					translate([0,0,grip_cms_stub_length-4_way_hat_base_z+zff]) hat_voids(4);
					translate([0,0,-zff]) cylinder(h = grip_cms_stub_length-4_way_hat_base_z+3*zff, r = grip_cms_stub_diameter/2-1.6);
				}
				// Support material experiement
				cms_stem_support(0.7);
				rotate([0,0,90]) cms_stem_support(0.6);
			}
			translate([bolt_x,bolt_y,bolt_z]) rotate([0,90,0]) bolt(3,3+10,1.5,20,17);
		}
	}
}

module cms_stem_support(support_start_z)
{
	support_x = 3.2;
	support_thickness = extrusion_width; // My extrusion width.
	//support_start_z = 0.6;

	//translate([support_x,0,(grip_cms_stub_length*support_start_z-4_way_hat_base_z)]) cube([support_thickness,4_way_hat_base_dia*0.8,(grip_cms_stub_length*support_start_z-4_way_hat_base_z)],true);
	//translate([-support_x,0,(grip_cms_stub_length*support_start_z-4_way_hat_base_z)]) cube([support_thickness,4_way_hat_base_dia*0.8,(grip_cms_stub_length*support_start_z-4_way_hat_base_z)],true);
	translate([-support_x-support_thickness/2,-(4_way_hat_base_dia*0.8/2),grip_cms_stub_length*support_start_z])
		cube([support_thickness,4_way_hat_base_dia*0.8,(1-support_start_z)*grip_cms_stub_length-4_way_hat_base_z]);
	translate([support_x-support_thickness/2,-(4_way_hat_base_dia*0.8/2),grip_cms_stub_length*support_start_z])
		cube([support_thickness,4_way_hat_base_dia*0.8,(1-support_start_z)*grip_cms_stub_length-4_way_hat_base_z]);
	
}
//%cube([100,100,220],true);
joystick_handle();
//joystick_handle_parts(2);
//joystick_handle_parts(1);
//joystick_handle_peg();

//joystick_handle_sidecuts();
//%joystick_head_sidecuts();
translate([50,50,0]) cms_stem(0);

