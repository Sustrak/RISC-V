#ifndef LIB_RISCV_DEF
#define LIB_RISCV_DEF

/** Constants to make code easier to read */
#undef ERR
#define ERR -1

#undef OK
#define OK 0

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

/** Address of IO mapped devices */
#define LEDG_BASE_ADDR  0x08000000
#define LEDR_BASE_ADDR  0x08000010
#define HEX03_BASE_ADDR 0x08000020
#define HEX47_BASE_ADDR 0x08000030
#define SW_BASE_ADDR    0x08000040
#define KEY_BASE_ADDR   0x08000050

/** 7-Segments mapping */
/**
           0x01
          -----
    0x20 |     | 0x02
         |     |
          -----
    0x10 |0x40 | 0x04
         |     |
          -----
           0x08
*/
#define HEX_T  0x01
#define HEX_TR 0x02
#define HEX_BR 0x04
#define HEX_B  0x08
#define HEX_BL 0x10
#define HEX_TL 0x20
#define HEX_M  0x40

/** Map with the number representation for the HEX */
static unsigned char hex_codes [10] = {
    HEX_T + HEX_TR + HEX_BR + HEX_B + HEX_BL + HEX_TL,
    HEX_TR + HEX_BL, 
    HEX_T + HEX_TR + HEX_M + HEX_BL + HEX_B,
    HEX_T + HEX_TR + HEX_M + HEX_BR + HEX_B,
    HEX_TL + HEX_TR + HEX_M + HEX_BR,
    HEX_T + HEX_TL + HEX_M + HEX_BR + HEX_B,
    HEX_TR + HEX_M + HEX_BR + HEX_B + HEX_BL,
    HEX_T + HEX_TR + HEX_BR,
    HEX_T + HEX_TR + HEX_M + HEX_BR + HEX_B + HEX_BL + HEX_TL,
    HEX_T + HEX_TR + HEX_M + HEX_BR + HEX_TL
};


int write_hex(unsigned int hex, unsigned int value);
int write_ledr(unsigned int led, unsigned int value);
int write_ledr_bulk(unsigned int value);
int write_ledg(unsigned int led, unsigned int value);
int write_ledg_bulk(unsigned int value);
int read_key();
int read_switch();

#endif
