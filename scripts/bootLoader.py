"""
Converts a HEX file to the binary representation for the DE2-115 TCL Scripts
once the conversion is finished will generate the tcl script to load the binary to the memory
and will execute it.
"""

import os
import binascii
import subprocess
import argparse
import re

try:
    import colorama

    colors = True
    colorama.init()
except ImportError:
    colors = False
    print("If you want to see the output with colors please install the collorama package\n pip install colorama")

TEXT_ADDR = "0x400000"
DATA_ADDR = "0x10010000"
TEST_FOLDER = "../test/"


def generate_bin():
    # Open files
    hex_file = open(hex_name, 'r')
    verbose_print(f"HexFile: {hex_name} open")
    bin_file = open(bin_name, "w+b")
    verbose_print(f"BinFile: {bin_file} created")
    for line in hex_file:
        x = line[6] + line[7] + line[4] + line[5] + line[2] + line[3] + line[0] + line[1]
        bin_file.write(binascii.unhexlify(x))

    if args.halt:
        bin_file.write(binascii.unhexlify("FFFFFFFF"))
    verbose_print(f"BinFile writted")
    # Close files
    hex_file.close()
    bin_file.close()


def generate_load_tcl(file_name):
    # Create tcl file
    tcl_name = file_name + "_load.tcl"
    tcl_file = open(tcl_name, "w+")
    # Write the script
    script = """set master [claim_service "master" [lindex [get_service_paths "master"] 0] ""]; 
    master_write_from_file $master {}/{} {};
    """.format(os.getcwd().replace('\\', '/'), bin_name, TEXT_ADDR)
    tcl_file.write(script)
    tcl_file.close()
    return tcl_name


def generate_tcl_mem_dump(file_name):
    # Create tcl file
    tcl_name = file_name + "_memdump.tcl"
    tcl_file = open(tcl_name, "w+")
    # Write the script
    script = f"""set master [claim_service "master" [lindex [get_service_paths "master"] 0] ""];
    puts [master_read_32 $master {DATA_ADDR} 100]"""
    tcl_file.write(script)
    tcl_file.close()
    return tcl_name


def call_system_console(tcl_name):
    system_console_exe = os.environ["QSYS_ROOTDIR"] + "\\system-console.exe"
    cmd = subprocess.Popen(system_console_exe + f" --project_dir=.. --script={tcl_name}", shell=True,
                           stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, err = cmd.communicate()
    cmd.wait()
    return stdout


def get_gold_results(test_name):
    test_file = open(test_name, "r")
    count = 0
    gold_results = []
    for line in test_file:
        line = line[:-1]
        if line == "00000000":
            count += 1
            if count == 10:
                break
        else:
            count = 0
        gold_results.append("0x" + line)

    if count == 10:
        gold_results = gold_results[:-9]

    return gold_results


def delete_files(files):
    for file in files:
        os.remove(file)


def load_program():
    tcl_load = generate_load_tcl(file_name)
    verbose_print(f"TclScript to load data created")
    created_files.append(tcl_load)
    verbose_print(f"Executing TclScript...")
    call_system_console(tcl_load)
    verbose_print(f"TclScript executed")


def get_program_info(asm_program, i):
    j = 0
    for k, ins in enumerate(asm_program):
        if ins.split()[0] == "sw":
            j += 1
            if j == i:
                return asm_program[k-5:k]


def check_results(asm_program):
    input("Press enter to read and compare the results...")
    read_tcl = generate_tcl_mem_dump(file_name)
    verbose_print(f"TclScript to read the data from SDRAM created")
    created_files.append(read_tcl)
    verbose_print(f"Executing TclScript...")
    out = str(call_system_console(read_tcl))
    verbose_print(f"TclScript executed")
    re_results = re.finditer(r"0[xX][0-9a-fA-F]+", out, re.MULTILINE)
    hex_results = [x.group() for x in re_results]
    hex_gold_results = get_gold_results(TEST_FOLDER + args.test)
    print("  RISC-V  --  User provided")
    for i, result in enumerate(zip(hex_results, hex_gold_results)):
        if colors:
            if result[0] == result[1]:
                print(colorama.Fore.GREEN + result[0] + "--" + result[1])
            else:
                if asm_program is not None:
                    print(*get_program_info(asm_program, i))
                print(colorama.Fore.RED + result[0] + "--" + result[1])
        else:
            print(result[0] + "--" + result[1])
    if colors:
        print(colorama.Style.RESET_ALL)


def parse_asm():
    program = []
    with open(file_name.split('-')[0]+".asm", "r") as file:
        program = [line for line in file]
    return program


def execute_pipeline():
    generate_bin()
    load_program()
    asm_program = None
    if args.debug:
        asm_program = parse_asm()
    if args.test is not None:
        check_results(asm_program)

    # Delete tmp files
    if args.clean:
        verbose_print(f"Cleaning TclScripts and BinFile")
        delete_files(created_files)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Utility to manage the SDRAM of the DE2-115 and perform test")
    parser.add_argument("file", type=str)
    parser.add_argument("-t", "--test", type=str,
                        help="When provided wil check if the first 100 positions of the memory data section are equal "
                             "to this file. In order to reduze the output size if the test file has "
                             "more than 10 repeated lines with 0 will stop."
                        )
    parser.add_argument("--halt", action='store_true', default=False,
                        help="When provided will add the instruction 0xFFFFFFFF at the end of the code to "
                             "halt the processor"
                        )
    parser.add_argument("--no-clean", action='store_false', default=True, dest="clean",
                        help="When provided the temp files will not be removed"
                        )
    parser.add_argument("-v", "--verbose", action='store_true', default=False,
                        help="When provided will add info about the execution of the program through the stdout"
                        )
    parser.add_argument("-d", "--debug", action='store_true', default=False,
                       help="When provided will try to find the ASM file to get some debug info about the "
                            "instructions executing")
    args = parser.parse_args()

    verbose_print = print if args.verbose else lambda *a, **k: None

    file_name = TEST_FOLDER + args.file.split('.')[0]
    hex_name = file_name + ".hex"
    bin_name = file_name + ".bin"
    created_files = [bin_name, ]

    execute_pipeline()

