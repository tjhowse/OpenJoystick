#include "HID-Project.h"

#DEFINE BTN_COUNT 32
// Also think about the two dpads. They're essentially another 16 buttons in total.
// I'm not sure if there's any way of detecting a dpad-style sequence of inputs from
// a connected input device. I think we might just have to treat them as digital
// inputs.
#DEFINE DPAD_BTN_COUNT 16
#DEFINE AXIS_COUNT 6

const int pinLed = LED_BUILTIN;
const int pinButton = 2;
bool is_host = false; // This is true if USB is connected to this module, making it the host.

void setup() {
  // Detect whether USB is connected to this module.
  is_host = UDADDR & _BV(ADDEN);
  if (is_host) {
    Gamepad.begin();
  }
}
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
  for
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

void loop() {
  if (is_host) {
    update_HID();
  }
  if (!digitalRead(pinButton)) {
    digitalWrite(pinLed, HIGH);

    // Press button 1-32
    static uint8_t count = 0;
    count++;
    if (count == 33) {


    // Simple debounce
    delay(300);
    digitalWrite(pinLed, LOW);
  }
}
