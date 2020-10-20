#import "modcon.h"

// If an analog input reads further than this value from min or max
// then it's deemed to be an analogue input.
#define ANALOG_DETECTION_BOUNDARY 50
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

uint8_t mapped_a_count = 0;
uint8_t mapped_d_count = 0;

void loop_learn_host() {
    uint8_t error;
    // Attempt to assign 0x01 a unique address.
    Wire.beginTransmission(LEARNING_I2C_ADDRESS);
    Serial.println("Host sent an addresssssssssssss");
    int i = Wire.write(next_i2c_address);
    Serial.print("Writing address: ");
    Serial.print(next_i2c_address);
    Serial.print(" : ");
    Serial.println(i);
    error = Wire.endTransmission();
    if (!error) {
        // We got a response from a guest in learn mode.
        // Attempt to connect to it at its assigned address.
        delay(500);
        Wire.beginTransmission(next_i2c_address);
        error = Wire.endTransmission();
        if (!error) {
            Serial.print("Host assigned an address: ");
            Serial.println(next_i2c_address++);
        }
    }
}

void setup_host() {
    Serial.println("Hi from host");
    settings.addr = 0x00;
    settings.save();
    Wire.begin();
    Gamepad1.begin();
    Gamepad2.begin();
    Gamepad3.begin();
    Gamepad4.begin();
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
            // ((uint8_t*)remote_input_values)[j++] = Wire.read();
            Wire.read();
        }
        Serial.print("A0 on remote: ");
        Serial.println(remote_input_values[0]);
        Serial.println(remote_input_values[0]+remote_input_values[1]<<8);
    }
}

void handle_analog_value(uint16_t value) {
    // This can be called multiple times during a loop. It manages
    // assigning the provided value to the next available gamepad axis.
    SingleGamepad_* gp;
    if (mapped_a_count < AXIS_COUNT) {
        gp = &Gamepad1;
    } else if ((mapped_a_count >= 1*AXIS_COUNT) && (mapped_a_count < 2*AXIS_COUNT)) {
        gp = &Gamepad2;
    } else if ((mapped_a_count >= 2*AXIS_COUNT) && (mapped_a_count < 3*AXIS_COUNT)) {
        gp = &Gamepad3;
    } else if ((mapped_a_count >= 3*AXIS_COUNT) && (mapped_a_count < 4*AXIS_COUNT)) {
        gp = &Gamepad4;
    } else {
        return;
    }
    switch (mapped_a_count) {
        case 0:
            gp->xAxis(value);
            break;
        case 1:
            gp->yAxis(value);
            break;
        case 2:
            gp->rxAxis(value);
            break;
        case 3:
            gp->ryAxis(value);
            break;
    }
    mapped_a_count++;
}

void handle_digital_value(bool value) {
    SingleGamepad_* gp;
    if (mapped_d_count < BTN_COUNT) {
        gp = &Gamepad1;
    } else if ((mapped_d_count >= 1*BTN_COUNT) && (mapped_d_count < 2*BTN_COUNT)) {
        gp = &Gamepad2;
    } else if ((mapped_d_count >= 2*BTN_COUNT) && (mapped_d_count < 3*BTN_COUNT)) {
        gp = &Gamepad3;
    } else if ((mapped_d_count >= 3*BTN_COUNT) && (mapped_d_count < 4*BTN_COUNT)) {
        gp = &Gamepad4;
    } else {
        return;
    }
    gp->press(mapped_d_count%BTN_COUNT);

    mapped_d_count++;
}

void update_HID() {
    // This updates the gamepad object with all available local and remote inputs
    Gamepad1.releaseAll();

    // for (i = 0; i < mapped_axis_count; i++) {
        // Gamepad1
    // }

    // Gamepad.press(count);

    // Move x/y Axis to a new position (16bit)
    // Gamepad1.xAxis(local_input_values[0]);
    // Gamepad1.yAxis(local_input_values[1]);
    // Gamepad1.rxAxis(remote_input_values[1]);
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
    Gamepad1.write();
}

void loop_host() {
    Gamepad1.releaseAll();
    mapped_a_count = 0;
    mapped_d_count = 0;
    update_inputs_local();
    update_inputs_remote();
    // update_HID();
    Gamepad1.write();
}