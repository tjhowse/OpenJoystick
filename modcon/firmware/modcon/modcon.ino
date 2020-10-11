
// I2C library
#include <Wire.h>
// USB HID library
#include "HID-Project.h"
// Settings library
#include "settings.h"


#DEFINE BTN_COUNT 32
// Also think about the two dpads. They're essentially another 16 buttons in total.
// I'm not sure if there's any way of detecting a dpad-style sequence of inputs from
// a connected input device. I think we might just have to treat them as digital
// inputs.
#DEFINE DPAD_BTN_COUNT 16
#DEFINE AXIS_COUNT 6

#DEFINE MODE_NORMAL 0
#DEFINE MODE_LEARN 1

#DEFINE PIN_BTN_MODE 2

bool is_host = false; // This is true if USB is connected to this module, making it the host.
uint8_t mode = MODE_NORMAL;
Settings settings;

void update_inputs_local() {
  // This polls the local GPIO for the states of the inputs attached to this module.
}

void update_inputs_remote() {
  // This is called if this module is the host module. It polls all the guest modules
  // for their present input states.
}

void update_HID() {
  // This updates the gamepad object with all available local and remote inputs
  Gamepad.releaseAll();
  Gamepad.press(count);

  // Move x/y Axis to a new position (16bit)
  Gamepad.xAxis(random(0xFFFF));
  Gamepad.yAxis(random(0xFFFF));

  // Go through all dPad positions
  // values: 0-8 (0==centered)
  static uint8_t dpad1 = GAMEPAD_DPAD_CENTERED;
  Gamepad.dPad1(dpad1++);
  if (dpad1 > GAMEPAD_DPAD_UP_LEFT)
    dpad1 = GAMEPAD_DPAD_CENTERED;

  static int8_t dpad2 = GAMEPAD_DPAD_CENTERED;
  Gamepad.dPad2(dpad2--);
  if (dpad2 < GAMEPAD_DPAD_CENTERED)
    dpad2 = GAMEPAD_DPAD_UP_LEFT;

  // Functions above only set the values.
  // This writes the report to the host.
  Gamepad.write();
}

void update_mode() {
  if (!digitalRead(pinButton)) {
    mode = MODE_LEARN;
  }
}


void setup_pins() {
  pinMode(PIN_BTN_MODE, INPUT_PULLUP);
}

void setup() {
  // Detect whether USB is connected to this module.
  setup_pins();
  settings.load();
  is_host = UDADDR & _BV(ADDEN);
  if (is_host) {

    Wire.begin();
    Gamepad.begin();
  } else {
    // This is a guest module.
  }
}

void loop() {
  update_mode();

  if (mode == MODE_NORMAL) {
    update_inputs_local();

    if (is_host) {
      update_inputs_remote();
      update_HID();
    }
  } else if (mode == MODE_LEARN) {

  }
  delay(10);
}
