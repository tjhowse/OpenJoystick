#import "modcon.h"

void normal_guest_i2c_receive(int byte_count) {
    if (mode != MODE_NORMAL) return;
    Serial.println("normal_guest_i2c_receive");
    Serial.println(byte_count);
}

void normal_guest_i2c_request() {
    if (mode != MODE_NORMAL) return;
    Serial.println("normal_guest_i2c_request");
    Wire.write((const uint8_t*)local_input_values, INPUT_PIN_COUNT*2);
}

void learn_guest_i2c_receive_callback(int byte_count) {
    Serial.println("learn_guest_i2c_receive_callback");
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