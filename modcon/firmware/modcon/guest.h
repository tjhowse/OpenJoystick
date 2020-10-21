#import "modcon.h"

void normal_guest_i2c_receive(int byte_count) {
    if (mode != MODE_NORMAL) return;
    Serial.println("normal_guest_i2c_receive");
    Serial.println(byte_count);
}

void normal_guest_i2c_request() {
    if (mode != MODE_NORMAL) return;
    // Serial.println("normal_guest_i2c_request");
    // This is the new wire protocol to implement:
    // Byte structure:
    // 0 1 2 3 4 5 6 7
    // A C C C C C C C
    // If A is 0 the remainder of this byte and all of the next byte are an analogue value.
    // If A is 1 the remainder of this byte and all of the next byte are binary values.
    // Wire.write((const uint8_t*)local_input_values, INPUT_PIN_COUNT*2);
    // Might need some kind of mutex here.
    // TODO BUG local_a_input_count is inaccurate here
    for (int k = 0; k < settings.local_a_input_count; k++) {
        Wire.write((uint8_t)((local_analog_values[k] & 0xEF00) >> 8));
        Wire.write((uint8_t)(local_analog_values[k] & 0x00FF));
    }
    // TODO write the digital stuff too.
}

void learn_guest_i2c_receive_callback(int byte_count) {
    Serial.println("learn_guest_i2c_receive_callback");
    if (mode != MODE_LEARN) return;
    uint8_t addr = Wire.read();
    if (addr > 0x01) {
        // mode = MODE_NORMAL;
        settings.addr = addr;
        settings.save();
        // Wire.end();
        Wire.begin(settings.addr);
        Serial.print("Guest assigned address ");
        Serial.println(settings.addr);
        Wire.onReceive(normal_guest_i2c_receive);
        Wire.onRequest(normal_guest_i2c_request);
    }
}

void setup_learn_mode_guest() {
    Serial.println("Guest in learn mode");
    settings.addr = LEARNING_I2C_ADDRESS;
    settings.save();
    Wire.begin(settings.addr);
    Wire.onReceive(learn_guest_i2c_receive_callback);
    Serial.println("Guest registered callback");
    TXLED1;
}

void setup_guest() {
    // This is a guest module.
    Serial.println("Hi from guest");
    if (!settings.valid) {
        settings.addr = 0x70;
        settings.save();
    }
    Wire.begin(settings.addr);
}

void loop_learn_guest() {

}

void loop_guest() {
    update_inputs_local();
}
