use <joystick_head.scad>

translate([0,0,17.5])
{
	/*difference()
	{
		import_stl("joystickheadprecompile_fixed.stl");
		
		//translate([-50,20,-50]) rotate([0,0,0]) #cube([100,100,100]);	
		
		translate([-50,-10,-50]) rotate([-30,0,0]) cube([100,100,100]);	
	}*/


	translate([0,60,-33.8])
	rotate([120,0,0])
	difference()
	{
		import("joystickhead_fixed.stl");
		
		//translate([-50,-80,-50]) cube([100,100,100]);	
		translate([-50,-96.6,0]) rotate([-30,0,0]) cube([100,100,100]);	
	}
}


//translate([35,0,0]) joystick_big_button();

//translate([-100,-100,0.1]) cube([200,200,50]);