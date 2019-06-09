import os
import binascii
import subprocess
import re

class RiscvAvalon():
    USER_TEXT_ADDR = "0x4000000"
    USER_DATA_ADDR = "0x5000000"
    SYS_TEXT_ADDR = "0x0"
    SYS_DATA_ADDR = "0x1000000"
    RSI_ADDR = "0xFE0000"
    
    TEST_FOLDER = "../test/"

    def generate_bin(file_name, **kwargs):
        hex_file = open(file_name + ".hex", "r")
        bin_file = open(file_name + ".bin", "w+b")

        if kwargs.enable_int:
            # Enable switch interrupts
            bin_file.write(binascii.unhexlify("b7020400"))
            bin_file.write(binascii.unhexlify("9382e2ff"))
            bin_file.write(binascii.unhexlify("37030008"))
            bin_file.write(binascii.unhexlify("13038300"))
            bin_file.write(binascii.unhexlify("23205300"))
            # Enable key interrupts
            bin_file.write(binascii.unhexlify("37050008"))
            bin_file.write(binascii.unhexlify("13058502"))
            bin_file.write(binascii.unhexlify("9302f000"))
            bin_file.write(binascii.unhexlify("23205500"))

        for line in hex_file:
            x = line[6] + line[7] + line[4] + line[5] + line[2] + line[3] + line[0] + line[1]
            bin_file.write(binascii.unhexlify(x))

        if kwargs.halt:
            bin_file.write(binascii.unhexlify("FFFFFFFF"))

        hex_file.close()
        bin_file.close()
