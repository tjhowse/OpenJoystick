
// I2C library
#include <Wire.h>
// USB HID library
#include "HID-Project.h"

// Settings library
#include "settings.h"

#include "host.h"
#include "guest.h"

void update_inputs_local() {
    // This polls the local GPIO for the states of the inputs attached to this module.
    for (i = 0; i < INPUT_PIN_COUNT; i++) {
        local_input_values[i] = analogRead(input_pins[i]);
    }
}

void update_mode() {
    if (!digitalRead(PIN_BTN_MODE)) {
        if (mode != MODE_LEARN) {
            setup_learn_mode();
        }
    }
}

void setup_learn_mode() {
    mode = MODE_LEARN;
    if (is_host) {
        setup_learn_mode_host();
    } else {
        setup_learn_mode_guest();
    }
}

void setup_pins() {
    pinMode(PIN_BTN_MODE, INPUT_PULLUP);
    pinMode(PIN_HOST, INPUT_PULLUP);
    pinMode(PIN_RXLED, OUTPUT);
    for (i = 0; i < INPUT_PIN_COUNT; i++) {
        pinMode(input_pins[i], INPUT_PULLUP);
    }
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
        setup_host();
    } else {
        setup_guest();
    }
}

void loop_normal() {
    update_inputs_local();
    if (is_host) {
        update_inputs_remote();
    }
}

void loop_learn() {
    if (is_host) {
        loop_learn_host();
    } else {
        // All of the guest's learning is done inside the i2c callbacks.
    }
}

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
