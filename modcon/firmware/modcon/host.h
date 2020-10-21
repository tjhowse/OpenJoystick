#import "modcon.h"

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
    int i = Wire.write(next_i2c_address);
    // Serial.print("Writing address: ");
    // Serial.print(next_i2c_address);
    // Serial.print(" : ");
    // Serial.println(i);
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
    // Gamepad4.begin();
    // Gamepad1.begin();
    // Gamepad2.begin();
}

void setup_learn_mode_host() {
    settings.guest_count = 0;
    Serial.println("Host in learn mode");
}

void drain_bus() {
    while (Wire.available()) {
        Wire.read();
    }
}

void update_inputs_remote() {
    // This is called if this module is the host module. It polls all the guest modules
    // for their present input states.
    uint8_t read;
    uint16_t buffer;
    uint8_t digital_input_count = 0;
    for (i = I2C_ADDRESS_ALLOCATION_START; i < next_i2c_address; i++) {
        Wire.requestFrom((uint8_t)i, (uint8_t)(INPUT_PIN_COUNT*2));
        buffer = 0;

        // Serial.println(Wire.available());
        while (Wire.available()) {
            read = Wire.read();
            buffer = 0;
            if (read == 0xFF) {
                // Message has ended, drain the bus.
                drain_bus();
            }
            if (!bitRead(read, 7)) {
                // This is the first byte of an analogue value.
                buffer |= (read & 0x3F)<<8;
                if (Wire.available() >= 1) {
                    buffer |= Wire.read();
                    handle_analog_value(buffer);
                }
            } else {
                // This is the signal byte of some digital values arriving
                // next.
                digital_input_count = read & 0x3F;
                if (Wire.available() >= 2) {
                    buffer |= Wire.read()<<8;
                    buffer |= Wire.read();
                    for (j = 0; j < digital_input_count; j++) {
                        handle_digital_value(bitRead(buffer, j));
                    }
                } else {
                    // Protocol error. Drain the bus and bail.
                    drain_bus();
                }
            }
        }
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
        // I'm not sure if this actually works. Skip it to avoid weirdness.
        return;
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
    // Serial.print("Axis: ");
    // Serial.print(mapped_a_count);
    // Serial.print("Value: ");
    // Serial.print(value);
    // Serial.println();
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
        // I'm not sure if this actually works. Skip it to avoid weirdness.
        return;
        gp = &Gamepad4;
    } else {
        return;
    }
    if (value) {
        gp->press(mapped_d_count%BTN_COUNT);
    } else {
        gp->release(mapped_d_count%BTN_COUNT);
    }

    mapped_d_count++;
}

void loop_host() {
    // Gamepad1.releaseAll();
    // Gamepad2.releaseAll();
    // Gamepad3.releaseAll();
    mapped_a_count = 0;
    mapped_d_count = 0;
    update_inputs_local();
    update_inputs_remote();
    Gamepad1.write();
    Gamepad2.write();
    Gamepad3.write();
}