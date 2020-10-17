
// I2C library
#include <Wire.h>
// USB HID library
#include "HID-Project.h"
// Settings library
#include "settings.h"


#define BTN_COUNT 32
// Also think about the two dpads. They're essentially another 16 buttons in total.
// I'm not sure if there's any way of detecting a dpad-style sequence of inputs from
// a connected input device. I think we might just have to treat them as digital
// inputs.
#define DPAD_BTN_COUNT 16
#define AXIS_COUNT 6

#define MODE_NORMAL 0
#define MODE_LEARN 1

#define GUEST_LEARN_MODE_BLINK_INTERVAL_MS 100
#define HOST_LEARN_MODE_BLINK_INTERVAL_MS 100

#define PIN_BTN_MODE 10
#define PIN_RXLED 16

bool is_host = false; // This is true if USB is connected to this module, making it the host.
uint8_t mode = MODE_NORMAL;
Settings settings;
uint8_t assigned_address = 2;

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
  // Gamepad.press(count);

  // Move x/y Axis to a new position (16bit)
  Gamepad.xAxis(analogRead(A0));
  Gamepad.yAxis(analogRead(A1));
  // Gamepad.yAxis(random(0xFFFF));

  // Go through all dPad positions
  // values: 0-8 (0==centered)
  // static uint8_t dpad1 = GAMEPAD_DPAD_CENTERED;
  // Gamepad.dPad1(dpad1++);
  // if (dpad1 > GAMEPAD_DPAD_UP_LEFT)
  //   dpad1 = GAMEPAD_DPAD_CENTERED;

  // static int8_t dpad2 = GAMEPAD_DPAD_CENTERED;
  // Gamepad.dPad2(dpad2--);
  // if (dpad2 < GAMEPAD_DPAD_CENTERED)
  //   dpad2 = GAMEPAD_DPAD_UP_LEFT;

  // Functions above only set the values.
  // This writes the report to the host.
  Gamepad.write();
}

void update_mode() {
  if (!digitalRead(PIN_BTN_MODE)) {
    if (mode != MODE_LEARN) {
      setup_learn_mode();
    }
  }
}

void learn_guest_i2c_callback(int byte_count) {
  if (mode != MODE_LEARN) return;
  uint8_t addr = Wire.read();
  if (addr > 0x01) {
    settings.addr = addr;
    settings.save();
    Wire.end();
    Wire.begin(settings.addr);
    Wire.write(0x01);
    mode = MODE_NORMAL;
  }
}

void setup_learn_mode() {
  mode = MODE_LEARN;
  if (is_host) {
    settings.guest_count = 0;
  } else {
    settings.addr = 0x01;
    settings.save();
    Wire.end();
    Wire.onRequest(learn_guest_i2c_callback);
    Wire.begin(settings.addr);
  }
}

void setup_pins() {
  pinMode(PIN_BTN_MODE, INPUT_PULLUP);
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
}

void setup() {
  setup_pins();
  settings.load();
  // Note this isn't accurate right at startup. It take a while
  is_host = UDADDR & _BV(ADDEN);
  if (is_host) {
    settings.addr = 0x00;
    settings.save();
    Wire.begin();
    Gamepad.begin();
    // Gamepad1.begin();
    // Gamepad2.begin();
    Serial.begin(115200);
    Serial.println("HI!");
  } else {
    // This is a guest module.
    if (!settings.valid) {
      settings.addr = 0xFF;
      settings.save();
      Wire.begin(settings.addr);
    }
  }
}

void loop_normal() {
  update_inputs_local();
  if (is_host) {
    update_inputs_remote();
    update_HID();
  }
}

void loop_learn() {
  if (is_host) {
    // Attempt to assign 0x01 a unique address.
    Wire.beginTransmission(0x01);
    Wire.write(assigned_address);
    Serial.print("Writing address: ");
    Serial.println(assigned_address);
    Wire.endTransmission();

    // Wire.requestFrom(assigned_address, (uint8_t)1);
    // while (Wire.available()) {
    //   Serial.print(Wire.read());
    // }
    Serial.println("Address assigned!");
  } else {

  }
}

uint16_t last_blink_ms = 0;
bool blink_prev;

void loop_leds() {
  if (mode == MODE_NORMAL) {
  // if (is_host) {
    digitalWrite(PIN_RXLED, LOW);
  } else {
    if ((millis() - last_blink_ms) > (is_host ? HOST_LEARN_MODE_BLINK_INTERVAL_MS : GUEST_LEARN_MODE_BLINK_INTERVAL_MS)) {
      blink_prev = !blink_prev;
      last_blink_ms = millis();
      if (blink_prev) {
        digitalWrite(PIN_RXLED, LOW);
      } else {
        digitalWrite(PIN_RXLED, HIGH);
      }
    }
  }
}

void loop() {
  is_host = UDADDR & _BV(ADDEN);
  update_mode();
  loop_leds();
  if (mode == MODE_NORMAL) {
    loop_normal();
  } else if (mode == MODE_LEARN) {
    loop_learn();
  }
  delay(10);
}
