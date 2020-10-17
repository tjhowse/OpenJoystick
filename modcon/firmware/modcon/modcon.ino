
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

// Wait this many MS before determining whether we're a guest or host module.
#define STARTUP_DELAY_MS 1000
#define GUEST_LEARN_MODE_BLINK_INTERVAL_MS 100
#define HOST_LEARN_MODE_BLINK_INTERVAL_MS 1000

#define PIN_BTN_MODE 10
#define PIN_RXLED 17
#define PIN_HOST 9

#define LEARNING_I2C_ADDRESS 0x01

bool is_host = false;
volatile uint8_t mode = MODE_NORMAL;
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
  Serial.println("learn_guest_i2c_callback");
  if (mode != MODE_LEARN) return;
  uint8_t addr = Wire.read();
  if (addr > 0x01) {
    mode = MODE_NORMAL;
    settings.addr = addr;
    settings.save();
    // Wire.end();
    Wire.begin(settings.addr);
    Serial.print("Guest assigned address ");
    Serial.println(settings.addr);
    Wire.onReceive(normal_guest_i2c_callback);
  }
}

void normal_guest_i2c_callback(int byte_count) {
  Serial.println("normal_guest_i2c_callback");
  Wire.write(settings.addr);
  Wire.write(0x5A);
  Serial.print("Guest got a read request ");
  Serial.println(byte_count);
}

void setup_learn_mode() {
  mode = MODE_LEARN;
  if (is_host) {
    settings.guest_count = 0;
    Serial.println("Host in learn mode");
  } else {
    Serial.println("Guest in learn mode");
    settings.addr = LEARNING_I2C_ADDRESS;
    settings.save();
    // Wire.end();
    Wire.begin(settings.addr);
    Wire.onReceive(learn_guest_i2c_callback);
    Serial.println("Guest registered callback");
    TXLED1;
  }
}

void setup_pins() {
  pinMode(PIN_BTN_MODE, INPUT_PULLUP);
  pinMode(PIN_HOST, INPUT_PULLUP);
  pinMode(PIN_RXLED, OUTPUT);
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
}

bool check_if_host() {
  // This function returns true if this module is the host, otherwise false.
  // delay(STARTUP_DELAY_MS)
  // // Note this must be read after a delay, it's not accurate on boot.
  // return UDADDR & _BV(ADDEN);
  // For testing I'm using a GPIO pin to set a module to guest/host rather
  // than auto-detecting based on USB state.
  return digitalRead(PIN_HOST);
}

void setup() {
  setup_pins();
  is_host = check_if_host();
  settings.load();
  Serial.begin(115200);
  delay(1000);
  if (is_host) {
    Serial.println("Hi from host");
    settings.addr = 0x00;
    settings.save();
    Wire.begin();
    // Gamepad.begin();
    // Gamepad1.begin();
    // Gamepad2.begin();
  } else {
    // This is a guest module.
    Serial.println("Hi from guest");
    if (!settings.valid) {
      settings.addr = 0x70;
      settings.save();
    }
    Wire.begin(settings.addr);
  }
}

void loop_normal() {
  update_inputs_local();
  if (is_host) {
    update_inputs_remote();
    // update_HID();
  }
}

void loop_learn() {
  if (is_host) {
    // Attempt to assign 0x01 a unique address.
    Wire.beginTransmission(LEARNING_I2C_ADDRESS);
    Serial.println("Host sent an address");
    int i = Wire.write(assigned_address);
    Serial.print("Writing address: ");
    Serial.print(assigned_address);
    Serial.print(" : ");
    Serial.println(i);
    Wire.endTransmission();
    delay(1000);
    Wire.beginTransmission(assigned_address);
    uint8_t error = Wire.endTransmission();
    if (!error) {
      Serial.println(" Host assigned an address.");
    }
    mode = MODE_NORMAL;
  } else {

  }
}

uint32_t last_blink_ms = 0;
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
  update_mode();
  loop_leds();
  if (mode == MODE_NORMAL) {
    loop_normal();
  } else if (mode == MODE_LEARN) {
    loop_learn();
  }
  delay(10);
}
