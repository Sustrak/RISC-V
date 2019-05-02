#include "lib_riscv.h"

int main() {
    int ledr = 0x55555555;
    int ledg = 0x33333333;

    write_ledr_bulk(ledr);
    write_ledg_bulk(ledg);

    write_hex(0, 0);
    write_hex(1, 1);
    write_hex(2, 2);
    write_hex(3, 3);
    write_hex(4, 4);
    write_hex(5, 5);
    write_hex(6, 6);
    write_hex(7, 7);
    
}
