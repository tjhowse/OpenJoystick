#import "modcon.h"

// If an analog input reads further than this value from min or max
// then it's deemed to be an analogue input.
#define ANALOG_DETECTION_BOUNDARY 20
#define ANALOG_PIN_MAX 1023
#define ANALOG_PIN_MIN 0

// These numbers are per-gamepad. We have three gamepads:
// Gamepad1, Gamepad2, Gamepad3 and Gamepad4.
#define GAMEPAD_COUNT 4
#define BTN_COUNT 32
#define DPAD_BTN_COUNT 16
// We're only using the four 16-bit axes here.
#define AXIS_COUNT 4

uint8_t next_i2c_address = I2C_ADDRESS_ALLOCATION_START;
uint16_t remote_input_values[INPUT_PIN_COUNT];

// This maps from the memory holding the axis value, usually in
// either local_input_values[] or remote_input_values[], to the
// axes used to drive the HID joysticks.
uint8_t mapped_axis_count = 0;
uint16_t *axis_map[GAMEPAD_COUNT*AXIS_COUNT];

// These are same as the above, but map those fields through to binary buttons.
// One bit per button.
uint8_t mapped_btn_count = 0;
uint32_t *btn_map[GAMEPAD_COUNT];

// One element in this array per local or remote input values array,
// boolean mapping 0 - digital, 1 - analog
uint16_t axis_allocation[module_count???]

void loop_learn_host() {
    // Attempt to assign 0x01 a unique address.
    Wire.beginTransmission(LEARNING_I2C_ADDRESS);
    Serial.println("Host sent an address");
    int i = Wire.write(next_i2c_address);
    Serial.print("Writing address: ");
    Serial.print(next_i2c_address);
    Serial.print(" : ");
    Serial.println(i);
    Wire.endTransmission();
    delay(1000);
    Wire.beginTransmission(next_i2c_address);
    uint8_t error = Wire.endTransmission();
    if (!error) {
        Serial.print("Host assigned an address: ");
        Serial.println(next_i2c_address++);
        mode = MODE_NORMAL;
        // TODO MVP allocate local storage for remote values in RAM.
    }
}

void setup_host() {
    Serial.println("Hi from host");
    settings.addr = 0x00;
    settings.save();
    Wire.begin();
    // Gamepad.begin();
    // Gamepad1.begin();
    // Gamepad2.begin();
}

void setup_learn_mode_host() {
    settings.guest_count = 0;
    Serial.println("Host in learn mode");
}

void update_inputs_remote() {
    // This is called if this module is the host module. It polls all the guest modules
    // for their present input states.
    for (i = I2C_ADDRESS_ALLOCATION_START; i < next_i2c_address; i++) {
        Wire.requestFrom((uint8_t)i, (uint8_t)(INPUT_PIN_COUNT*2));
        j = 0;
        while (Wire.available()) {
            // This shenannigans here is because we're reading bytewise from
            // Wire.read but storing values into two-byte registers.
            ((uint8_t*)remote_input_values)[j++] = Wire.read();
        }
        Serial.print("A0 on remote: ");
        Serial.println(remote_input_values[0]);
        // Serial.println(remote_input_values[0]+remote_input_values[1]<<8);
    }
    // TODO MVP map values through to HID outputs.
}

void update_axis_map() {
    // This looks at the values seen in the local and remote inputs and determines
    // whether these values should be mapped through to axes/buttons.
    // If necessary it will call Gamepad[ 12].begin() to initialise extra gamepads.

}

void update_HID() {
    // This updates the gamepad object with all available local and remote inputs
    Gamepad.releaseAll();

    for (i = 0; i < mapped_axis_count; i++) {
        // Gamepad1
    }

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
    //     dpad1 = GAMEPAD_DPAD_CENTERED;

    // static int8_t dpad2 = GAMEPAD_DPAD_CENTERED;
    // Gamepad.dPad2(dpad2--);
    // if (dpad2 < GAMEPAD_DPAD_CENTERED)
    //     dpad2 = GAMEPAD_DPAD_UP_LEFT;

    // Functions above only set the values.
    // This writes the report to the host.
    Gamepad.write();
}

void loop_host() {
    update_inputs_remote();
    update_axis_map();
    update_HID();
}