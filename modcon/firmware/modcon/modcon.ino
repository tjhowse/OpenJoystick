
// I2C library
#include <Wire.h>
// USB HID library
#include "HID-Project.h"

// Settings library
// #include "settings.h"

#include "host.h"
#include "guest.h"

void update_inputs_local() {
    // This polls the local GPIO for the states of the inputs attached to this module.
    uint8_t a_count = 0;
    uint8_t d_count = 0;
    // local_digital_values = 0x0000;
    for (i = 0; i < INPUT_PIN_COUNT; i++) {
        if (settings.analog_input_mask & (0x0001<<i)) {
            // Read an analogue value
            local_analog_values[a_count++] = analogRead(input_pins[i]);
            if (is_host) {
                handle_analog_value(local_analog_values[a_count-1]);
            }
        } else if (settings.digital_input_mask & (0x0001<<i)) {
            // Read a digital value
            if (digitalRead(input_pins[i])) {
                bitSet(local_digital_values, d_count++);
            } else {
                bitClear(local_digital_values, d_count++);
            }
            if (is_host) {
                handle_digital_value(bitRead(local_digital_values, d_count-1));
            }
        }
    }
}

void update_mode() {
    bool mode_btn_state = digitalRead(PIN_BTN_MODE);
    if (!mode_btn_state && mode_btn_prev) {
        // Falling edge
        if (mode == MODE_LEARN) {
            teardown_learn_mode();
        } else {
            setup_learn_mode();
        }
    }
    mode_btn_prev = mode_btn_state;
}

void learn_inputs() {
    uint16_t temp;
    for (i = 0; i < INPUT_PIN_COUNT; i++) {
        temp = analogRead(input_pins[i]);
        if ((temp > (ANALOG_PIN_MIN + ANALOG_DETECTION_BOUNDARY)) &&
            (temp < (ANALOG_PIN_MAX - ANALOG_DETECTION_BOUNDARY))) {
            // This pin is almost definitely either floating or analogue.
            // Set its bit in settings.analog_input_mask.
            bitSet(settings.analog_input_mask, i);
            bitClear(settings.digital_input_mask, i);
        }
        if (!bitRead(settings.analog_input_mask,i) &&
            (((local_analog_values[i] > (ANALOG_PIN_MAX - ANALOG_DETECTION_BOUNDARY)) &&
             (                  temp < (ANALOG_PIN_MIN + ANALOG_DETECTION_BOUNDARY))) ||
            ((                  temp > (ANALOG_PIN_MAX - ANALOG_DETECTION_BOUNDARY)) &&
             (local_analog_values[i] < (ANALOG_PIN_MIN + ANALOG_DETECTION_BOUNDARY))))) {
            // Oof.
            // This detects whether an input that was previously close to max has gone close to min
            // or it was close to min and has gone to max.
            bitSet(settings.digital_input_mask, i);
        }
        local_analog_values[i] = temp;
    }
}

void setup_learn_mode() {
    mode = MODE_LEARN;
    settings.analog_input_mask = 0x0000;
    settings.digital_input_mask = 0x0000;
    settings.local_a_input_count = 0;
    settings.local_d_input_count = 0;

    for (i = 0; i < INPUT_PIN_COUNT; i++) {
        local_analog_values[i] = analogRead(input_pins[i]);
    }
    if (is_host) {
        setup_learn_mode_host();
    } else {
        setup_learn_mode_guest();
    }
}

void teardown_learn_mode() {
    mode = MODE_NORMAL;
    Serial.println("Leaving learn mode");
    for (i = 0; i < INPUT_PIN_COUNT; i++) {
        if (bitRead(settings.analog_input_mask, i)) {
            settings.local_a_input_count++;
        }
        if (bitRead(settings.digital_input_mask, i)) {
            settings.local_d_input_count++;
        }
    }
    Serial.print("A: ");
    Serial.println(settings.analog_input_mask, BIN);
    Serial.print("D: ");
    Serial.println(settings.digital_input_mask, BIN);
    Serial.println();
    Serial.print("Total analogue axes: ");
    Serial.println(settings.local_a_input_count);
    Serial.print("Total digital axes: ");
    Serial.println(settings.local_d_input_count);
    settings.save();
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
    mode = MODE_NORMAL;
    mode_btn_prev = 1;
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
    if (is_host) {
        loop_host();
    } else {
        loop_guest();
    }
}

void loop_learn() {
    learn_inputs();
    if (is_host) {
        loop_learn_host();
    } else {
        loop_learn_guest();
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
