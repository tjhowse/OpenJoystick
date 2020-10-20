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
#define I2C_ADDRESS_ALLOCATION_START 0x10

#define INPUT_PIN_COUNT 8

#define MODE_DEBOUNCE_MS 500

bool is_host = false;
volatile uint8_t mode = MODE_NORMAL;

// For now, only use analogue inputs. If this changes be sure to also change INPUT_PIN_COUNT
// Leaving out A10 due to weird internal pull-up problems
uint8_t input_pins[] = {A0, A1, A2, A3, A6, A7, A8, A9};
uint8_t i, j;
// The ADCs on the atmel32u4 are 10-bit, so allocate 16 bits per input.
// If this ever gets bigger than 32B we can't put it through I2C in one message.
uint16_t local_analog_values[INPUT_PIN_COUNT];
// TODO OPTIMISATION if we run out of ram this is shockingly inefficient
uint16_t local_digital_values[INPUT_PIN_COUNT];

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
#define SETTINGS_INPUT_PIN_TYPE_A 3 // and 4.
#define SETTINGS_GUEST_ADDRS_A 1024

class Settings {
    public:
        // Whether or not this class contains validly-loaded settings.
        bool valid = false;
        // A guest module's I2C address. 0x00 on a host module.
        uint8_t addr;
        // How many guest modules do we know about?
        uint8_t guest_count;
        // This stores the addresses of the guest modules we know about.
        uint8_t* guest_addrs;
        // A bitmask that stores whether a pin is analogue (0) or digital (1)
        uint16_t input_pin_type;
        uint8_t local_a_input_count;
        uint8_t local_d_input_count;

    bool load() {
        // Load the settings from EEPROM into this class.
        // Host module:
        // - Guest I2C module I2C addresses,
        // - Guest.Input to HID axis/button/dpad associations
        // Guest module:
        // - I2C bus addresses
        // - GPIO to Input associations.
        if (SETTINGS_SCHEMA != EEPROM.read(SETTINGS_SETTINGS_SCHEMA_A)) {
            // We don't recognise this EEPROM SETTINGS_SCHEMA, or it's corrupt. Abandon ship!
            return false;
        }
        addr = EEPROM.read(SETTINGS_ADDR_A);
        // guest_count = EEPROM.read(SETTINGS_GUEST_COUNT_A);
        // guest_addrs = new uint8_t [guest_count];
        // for (uint8_t i = 0; i < guest_count; i++) {
        //     guest_addrs[i] = EEPROM.read(SETTINGS_GUEST_ADDRS_A+i);
        // }
        // valid = true;
        return true;
    }
    void save() {
        // Save the settings from this class into EEPROM.
        // EEPROM.write(SETTINGS_ADDR_A, addr);
        // EEPROM.write(SETTINGS_SETTINGS_SCHEMA_A, SETTINGS_SCHEMA);
    }
};

Settings settings;