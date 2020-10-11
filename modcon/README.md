# Modular Control Panel

This is a project to create a modular control panel for controlling different simulators.

Each module contains a microcontroller that interfaces to the inputs on that module and can
relay the states of those inputs to an adjacent module. A module can be fitted with a USB
port to interface to a PC via a standard HID joystick interface.

https://www.youtube.com/watch?v=Ra9WzwZtf44

## Fabrication notes

### Drilling large holes in the lid

If you need to drill a 40mm hole to mount a three-axis joystick module, like [this one](https://www.aliexpress.com/item/32808586573.html)
be very careful not to overshoot and break the part. I used a 45mm holesaw and snapped the lid in half
as I broke through the other side. If possible I suggest printing the lid with the hole already in place,
or being very careful when drilling.

## FAQ

### I would like outputs like displays and lights too!

That would be be neat. However I'm not aware of a standard way of getting that information
out of a simulator. There are plenty of examples of custom integrations with specific software,
but I'm not aware of any equivalent to a USB HID joystick input, but for outputs in terms of
near-universal support.
