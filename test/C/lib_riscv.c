#include "lib_riscv.h"

int write_hex(unsigned int hex, unsigned int value) {
    int volatile *hex_addr;
    if (hex >= 0 || hex < 4)
        hex_addr = (int *) HEX03_BASE_ADDR;
    else if (hex >= 4 || hex < 8)
        hex_addr = (int *) HEX47_BASE_ADDR;
    else
        return ERR;

    int hex_value = *hex_addr;
    int shift = (hex&0x3)<<3;
    int mask = -1 & ~(0xFF << shift);
    hex_value = hex_value & mask;

    int new_value = (int) hex_codes[value] << shift;
    hex_value = hex_value & new_value;
    *hex_addr = hex_value;

    return hex_value;
}


int write_ledr(unsigned int led, unsigned int value) {
    if (led < 0 || led > 18) 
        return ERR;

    int volatile *led_addr = (int *) LEDR_BASE_ADDR;
    int led_value = *led_addr;
    
    led_value = led_value & ~(1 << led);
    led_value = led_value | ((value&1)<<led);

    *led_addr = led_value;

    return led_value;

}

int write_ledr_bulk(unsigned int value) {
    int volatile *led_addr = (int *) LEDR_BASE_ADDR;
    *led_addr = value;
    
    return OK;
}

int write_ledg(unsigned int led, unsigned int value) {
    if (led < 0 || led > 7) 
        return ERR;

    int volatile *led_addr = (int *) LEDG_BASE_ADDR;
    int led_value = *led_addr;
    
    led_value = led_value & ~(1 << led);
    led_value = led_value | ((value&1)<<led);

    *led_addr = led_value;

    return led_value;
}

int write_ledg_bulk(unsigned int value) {
    int volatile *led_addr = (int *) LEDG_BASE_ADDR;
    *led_addr = value;

    return OK;
}

int read_key() {
    int volatile *key = (int *) KEY_BASE_ADDR;

    return *key;
}

int read_switch() {
    int volatile *sw = (int *) SW_BASE_ADDR;

    return *sw;
}
