include <joystick_defines.scad>
include <joystick_gimbal_core_mk1.scad>
include <joystick_gimbal_frame_mk1.scad>
include <joystick_4_way_hat_mk1.scad>

translate([0,0,0]) rotate([30,0,0]) gimbal_core();

gimbal_frame();

translate([0, 80, 0]) hat_base(2); 
translate([30, 80, 0]) hat_base(4); 
translate([0, 60, 20]) rotate([0,0,90]) switch_hat_saddle();
translate([30, 60, 20]) switch_hat_hanoi();

translate([-30, 80, 0]) 4_way_hat_washer();
