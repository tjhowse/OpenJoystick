# Modular Control Panel

This is a project to create a modular control panel for controlling flight simulators and
games on a computer.

Each module contains a microcontroller that interfaces to the inputs on that module and can
relay the states of those inputs to an adjacent module. A module can be fitted with a USB
port to interface to a PC via a standard HID joystick interface. The input devices can be
joysticks, buttons, switches, sliders, knobs or anything else that can be connected to an
arduino-style microcontroller.

https://www.youtube.com/watch?v=Ra9WzwZtf44

The goal is to enable non- or semi-technical people to build custom computer peripherals
to suit how they want to interact with their favourite game or simulator. The PC interface
is via standard USB HID joystick device, so should work with a wide range of software and
platforms (Windows, OSX, Linux, consoles...?).

## This sounds great! I want one!

This project aims to produce the CAD files, circuit board designs and firmware to support
people building their own modular control panels. Further down the road there may be a
small-scale store selling kits, but that's a fair way away.

This is definitely a do-it-yourself kind of project. It might seem like this would
be impossible for a beginner to build, but it may be simpler than you imagine. Learning
a few new skills and building something that is unique to you can feel very rewarding.
Don't be intimidated!

The main things you'll need are:

### The boxes/lids

These are 3d printed. If you don't have a 3d printer of your own there are online services
that you use to print and ship components to you. Alternatively ask a friend with a 3d
printer, or visit your local makerspace/hackerspace/library. They're more common than you
might think.

### The PCBs

The Printed Circuit Board (PCB) is designed such that it can be ordered from JLC PCB
inexpensively and arrive in a nearly-ready-to-use form. Any components that JLC can't
populate on the board are easy to solder by hand.

### Input devices

Switches, buttons, joysticks, et cetera. These are readily available from your online
retailer of choice. The bill of materials (BoM) will provide model numbers and links
for where you could buy them.

### Soldering iron and solder

A cheap electrical soldering iron and some flux-core solder is all you will need. Don't
be scared! It's not as hard as you might think.

### Bits and bobs

The bill of materials (BoM) will list some inexpensive wires, plugs and header strips
you'll need to assemble your controller modules.

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
