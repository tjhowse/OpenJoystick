use <joystick_head.scad>

translate([0,0,17.5])union()
{
	difference()
	{
		import_stl("joystickhead_fixed.stl");
		
		translate([-50,20,-50]) cube([100,100,100]);	
	}


	translate([0,60,-37.5])
	rotate([90,0,0])
	difference()
	{
		import_stl("joystickhead_fixed.stl");
		
		translate([-50,-80,-50]) cube([100,100,100]);	
	}
}
translate([35,0,0]) joystick_big_button();

//translate([-100,-100,0,]) cube([200,200,50]);