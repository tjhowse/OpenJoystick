#import "modcon.h"

void normal_guest_i2c_receive(int byte_count) {
    if (mode != MODE_NORMAL) return;
    Serial.println("normal_guest_i2c_receive");
    Serial.println(byte_count);
}

void normal_guest_i2c_request() {
    if (mode != MODE_NORMAL) return;
    int k;
    // Serial.println("normal_guest_i2c_request");
    // This is the new wire protocol to implement:
    // 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7
    // A B C C C C C C C C C C C C C C
    // A B S S S S S S C C C C C C C C
    // If A is 0 the remainder of this byte and all of the next byte are an analogue value.
    // If A is 1 the remainder of this byte is the number of the following bytes are
    // digital inputs (Size?)
    // B is always 0.
    // Wire.write((const uint8_t*)local_input_values, INPUT_PIN_COUNT*2);
    // Might need some kind of mutex here.
    for (k = 0; k < settings.local_a_input_count; k++) {
        Wire.write((uint8_t)((local_analog_values[k] & 0x3F00) >> 8));
        Wire.write((uint8_t)(local_analog_values[k] & 0x00FF));
    }
    // TODO Hardcoded max 16 digital inputs.
    Wire.write((settings.local_d_input_count & 0x3F) | 0x80);
    Wire.write(highByte(local_digital_values));
    Wire.write(lowByte(local_digital_values));
}

void setup_normal_mode_i2c() {
    Wire.begin(settings.addr);
    Wire.onReceive(normal_guest_i2c_receive);
    Wire.onRequest(normal_guest_i2c_request);
}

void learn_guest_i2c_receive_callback(int byte_count) {
    Serial.println("learn_guest_i2c_receive_callback");
    if (mode != MODE_LEARN) return;
    uint8_t addr = Wire.read();
    if (addr > 0x01) {
        settings.addr = addr;
        settings.save();
        Serial.print("Guest assigned address ");
        Serial.println(settings.addr);
        setup_normal_mode_i2c();
    }
}

void setup_learn_mode_guest() {
    Serial.println("Guest in learn mode");
    settings.addr = LEARNING_I2C_ADDRESS;
    settings.save();
    Wire.begin(settings.addr);
    Wire.onReceive(learn_guest_i2c_receive_callback);
    TXLED1;
}

void setup_guest() {
    // This is a guest module.
    Serial.println("Hi from guest");
    setup_normal_mode_i2c();
}

void loop_learn_guest() {

}

void loop_guest() {
    update_inputs_local();
}
