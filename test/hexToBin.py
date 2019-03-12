"""
Converts a HEX file to the binary representation for the DE2-115 TCL Scripts
Usage: hexToBin.py <hexfile.hex>
"""

import os
import sys
import binascii

if __name__ == "__main__":
		# Open hex file
		hex_file = open(sys.argv[1], 'r')
		bin_file = open(sys.argv[1][:-4]+".bin", "w+b")
		for line in hex_file:
				x = line[6]+line[7]+line[4]+line[5]+line[2]+line[3]+line[0]+line[1]
				bin_file.write(binascii.unhexlify(x))
