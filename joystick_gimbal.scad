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
joiner_stem_scalar = 4;
support_stem_beef = 1;

temp = joiner_z/2;

springbar_offset = 2;
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

module joystick_joiner()
{
	total_y = inner_gimbal_y+2*bearing_retain_thickness-2*bearing_thickness;
	bolt_offset = 21.5;
	
	difference()
	{
		union()
		{
			scale([1,1,joiner_stem_scalar]) joystick_handle_peg(0);
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
					cube([spar_width,spar_width+support_stem_beef, base_support_height+support_stem_beef]);
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
					cube([spar_width,spar_width+support_stem_beef, base_support_height+support_stem_beef]);
					translate([spar_width/2+zff,spar_width/2-joiner_peg_xy/2+support_stem_beef/2,base_support_height-joiner_peg_xy-(spar_width-joiner_peg_xy)/2]) 
					union()
					{
						cube([joiner_peg_z,joiner_peg_xy, joiner_peg_xy]);
						translate([spar_width,joiner_peg_xy/2,joiner_peg_xy/2]) rotate([0,-90,0]) bolt(3,3,1.45,20,0);
					}
					
				}
		}
		
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
	
	difference()
	{
		union()
		{
			translate([0,0,lip_size]) cylinder(r=bearing_inside_dia/2-0.05,h=bearing_thickness);
			cylinder(r=bearing_inside_dia/2+1,h=lip_size);
			rotate([0,0,90]) translate([-(joiner_peg_xy)/2,-(joiner_peg_xy)/2, bearing_thickness+lip_size]) cube([(joiner_peg_xy),(joiner_peg_xy),joiner_peg_z+extrapeg]);
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
			translate([springbar_offset_old,0,springbar_z/2]) cube([springbar_x,springbar_y,springbar_z],true);	
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

//translate([0,inner_gimbal_y/2+4+bearing_retain_thickness,0]) rotate([90,0,0]) rotate([0,0,90]) joystick_stem_plug(4,0);
//rotate([0,0,180]) translate([0,inner_gimbal_y/2+springbar_z+bearing_retain_thickness,0]) rotate([90,0,0]) rotate([0,0,-90]) joystick_stem_plug_springbar(inner_gimbal_clearance);
//translate([30,0,0]) joystick_stem_plug_springbar(inner_gimbal_clearance);
//translate([13,0,0]) joystick_stem_plug(2,inner_gimbal_clearance);

//temp_stem_extender();

//joystick_y_padding_washer();

/*test_x = 0;
test_y = 0;
translate([0,0,inner_gimbal_z/2+base_support_height-12]) rotate([test_x,0,0]) rotate([0,test_y,0]) translate([0,0,-5]) joystick_joiner();
translate([springbar_z+inner_gimbal_total_x/2,0,inner_gimbal_z/2+base_support_height-12.5]) rotate([0,-90,0]) union()
{
	joystick_stem_plug_springbar(inner_gimbal_clearance);
	translate([0,0,joiner_peg_z+bearing_thickness]) #joystick_y_padding_washer();
}
translate([0,0,inner_gimbal_z/2+base_support_height-12]) rotate([test_x,0,0]) joystick_inner_gimbal();
joystick_base();*/
rotate([180,0,0]) gimbal_alignment_jig();

//translate([0,50,0]) joystick_base();
//translate([0,0,inner_gimbal_z/2]) joystick_inner_gimbal();
