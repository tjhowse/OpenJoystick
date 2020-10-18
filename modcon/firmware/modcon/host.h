#import "modcon.h"

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
            ((uint8_t*)remote_input_values)[j++] = Wire.read();
        }
        Serial.print("A0 on remote: ");
        Serial.println(remote_input_values[0]);
        // Serial.println(remote_input_values[0]+remote_input_values[1]<<8);
    }
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
    //     dpad1 = GAMEPAD_DPAD_CENTERED;

    // static int8_t dpad2 = GAMEPAD_DPAD_CENTERED;
    // Gamepad.dPad2(dpad2--);
    // if (dpad2 < GAMEPAD_DPAD_CENTERED)
    //     dpad2 = GAMEPAD_DPAD_UP_LEFT;

    // Functions above only set the values.
    // This writes the report to the host.
    Gamepad.write();
}
