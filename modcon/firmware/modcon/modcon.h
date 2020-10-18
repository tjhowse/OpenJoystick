

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

#define INPUT_PIN_COUNT 9

bool is_host = false;
volatile uint8_t mode = MODE_NORMAL;
Settings settings;

// For now, only use analogue inputs. If this changes be sure to also change INPUT_PIN_COUNT
uint8_t input_pins[] = {A0, A1, A2, A3, A6, A7, A8, A9, A10};
uint8_t i, j;
// The ADCs on the atmel32u4 are 10-bit, so allocate 16 bits per input.
// If this ever gets bigger than 32B we can't put it through I2C in one message.
uint16_t local_input_values[INPUT_PIN_COUNT];

uint32_t last_blink_ms = 0;
bool blink_prev;