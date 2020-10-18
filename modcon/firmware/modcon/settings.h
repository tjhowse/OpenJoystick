#include <EEPROM.h>

// These are the addresses in EEPROM for each setting.
// The schema is used to avoid
#define SCHEMA_A 0
#define SCHEMA 0x5A
#define ADDR_A 1
#define GUEST_COUNT_A 2
#define GUEST_ADDRS_A 1024

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

    bool load() {
        // Load the settings from EEPROM into this class.
        // Host module:
        // - Guest I2C module I2C addresses,
        // - Guest.Input to HID axis/button/dpad associations
        // Guest module:
        // - I2C bus addresses
        // - GPIO to Input associations.
        if (SCHEMA != EEPROM.read(SCHEMA_A)) {
            // We don't recognise this EEPROM schema, or it's corrupt. Abandon ship!
            return false;
        }
        addr = EEPROM.read(ADDR_A);
        // guest_count = EEPROM.read(GUEST_COUNT_A);
        // guest_addrs = new uint8_t [guest_count];
        // for (uint8_t i = 0; i < guest_count; i++) {
        //     guest_addrs[i] = EEPROM.read(GUEST_ADDRS_A+i);
        // }
        // valid = true;
        return true;
    }
    void save() {
        // Save the settings from this class into EEPROM.
        // EEPROM.write(ADDR_A, addr);
        // EEPROM.write(SCHEMA_A, SCHEMA);
    }
};