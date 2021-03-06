#include <EEPROM.h>

#define MODE_NORMAL 0
#define MODE_LEARN 1

// Wait this many MS before determining whether we're a guest or host module.
#define STARTUP_DELAY_MS 1000
#define GUEST_LEARN_MODE_BLINK_INTERVAL_MS 100
#define HOST_LEARN_MODE_BLINK_INTERVAL_MS 1000

#define PIN_BTN_MODE 16
#define PIN_RXLED 17
#define PIN_HOST 7

#define LEARNING_I2C_ADDRESS 0x08
#define DEFAULT_I2C_ADDRESS 0x70

#define I2C_ADDRESS_ALLOCATION_START 0x10

#define INPUT_PIN_COUNT 8

#define MODE_DEBOUNCE_MS 500

// If an analog input reads further than this value from min or max
// then it's deemed to be an analogue input.
#define ANALOG_DETECTION_BOUNDARY 100
#define ANALOG_PIN_MAX 1023
#define ANALOG_PIN_MIN 0

bool is_host = false;
volatile uint8_t mode = MODE_NORMAL;

// For now, only use analogue inputs. If this changes be sure to also change INPUT_PIN_COUNT
// Leaving out A10 due to weird internal pull-up problems
uint8_t input_pins[] = {A0, A1, A2, A3, A6, A7, A8, A9};
uint8_t i, j;
// The ADCs on the atmel32u4 are 10-bit, so allocate 16 bits per input.
// If this ever gets bigger than 32B we can't put it through I2C in one message.
uint16_t local_analog_values[INPUT_PIN_COUNT];
uint16_t local_digital_values;

uint32_t last_blink_ms = 0;
bool blink_prev;
bool mode_btn_prev;

void update_inputs_local();
void handle_analog_value(uint16_t);
void handle_digital_value(bool);

// These are the addresses in EEPROM for each setting.
// The SETTINGS_SCHEMA is used to avoid
#define SETTINGS_SETTINGS_SCHEMA_A 0
#define SETTINGS_SCHEMA 0x5A
#define SETTINGS_ADDR_A 1
#define SETTINGS_GUEST_COUNT_A 2
#define SETTINGS_ANALOG_INPUT_MASK_A 3 // and 4.
#define SETTINGS_DIGITAL_INPUT_MASK_A 5 // and 6.

class Settings {
    public:
        // A guest module's I2C address. 0x00 on a host module.
        uint8_t addr;
        // How many guest modules do we know about?
        uint8_t guest_count;
        // A bitmask that stores whether a pin is analogue (0) or digital (1)
        uint16_t analog_input_mask;
        uint16_t digital_input_mask;
        uint8_t local_a_input_count;
        uint8_t local_d_input_count;

    void defaults() {
        addr = DEFAULT_I2C_ADDRESS;
        guest_count = 0;
        analog_input_mask = 0;
        digital_input_mask = 0;
    }

    bool load() {
        // Load the settings from EEPROM into this class.
        if (SETTINGS_SCHEMA != EEPROM.read(SETTINGS_SETTINGS_SCHEMA_A)) {
            // We don't recognise this EEPROM SETTINGS_SCHEMA. Load defaults and save them.
            defaults();
            save();
            return false;
        }
        addr = EEPROM.read(SETTINGS_ADDR_A);
        guest_count = EEPROM.read(SETTINGS_GUEST_COUNT_A);
        analog_input_mask = EEPROM.read(SETTINGS_ANALOG_INPUT_MASK_A);
        analog_input_mask |= EEPROM.read(SETTINGS_ANALOG_INPUT_MASK_A+1)<<8;
        digital_input_mask = EEPROM.read(SETTINGS_DIGITAL_INPUT_MASK_A);
        digital_input_mask |= EEPROM.read(SETTINGS_DIGITAL_INPUT_MASK_A+1)<<8;
        local_a_input_count = 0;
        local_d_input_count = 0;
        for (int i = 0; i < INPUT_PIN_COUNT; i++) {
            if (bitRead(analog_input_mask, i)) {
                local_a_input_count++;
            }
            if (bitRead(digital_input_mask, i)) {
                local_d_input_count++;
            }
        }
        return true;
    }
    void save() {
        // Save the settings from this class into EEPROM.
        EEPROM.write(SETTINGS_ADDR_A, addr);
        EEPROM.write(SETTINGS_GUEST_COUNT_A, guest_count);
        EEPROM.write(SETTINGS_ANALOG_INPUT_MASK_A, lowByte(analog_input_mask));
        EEPROM.write(SETTINGS_ANALOG_INPUT_MASK_A+1, highByte(analog_input_mask));
        EEPROM.write(SETTINGS_DIGITAL_INPUT_MASK_A, lowByte(digital_input_mask));
        EEPROM.write(SETTINGS_DIGITAL_INPUT_MASK_A+1, highByte(digital_input_mask));
        EEPROM.write(SETTINGS_SETTINGS_SCHEMA_A, SETTINGS_SCHEMA);
    }
};

Settings settings;