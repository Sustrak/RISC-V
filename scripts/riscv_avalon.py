import os
import binascii
import subprocess

class RiscvAvalon():
    USER_TEXT_ADDR = "0x4000000"
    USER_DATA_ADDR = "0x5000000"
    SYS_TEXT_ADDR = "0x0"
    SYS_DATA_ADDR = "0x1000000"
    RSI_ADDR = "0xFE0000"
    
    TEST_FOLDER = "../test/"
    SYSTEM_CONSOLE_PATH = os.environ["QSYS_ROOTDIR"]
    PROJECT_DIR = os.path.join(os.getcwd(), "..")

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
            # Enable PS2 interrupts
            bin_file.write(binascii.unhexlify("37052008"))
            bin_file.write(binascii.unhexlify("13050506"))
            bin_file.write(binascii.unhexlify("93021000"))
            bin_file.write(binascii.unhexlify("23205500"))

        for line in hex_file:
            x = line[6] + line[7] + line[4] + line[5] + line[2] + line[3] + line[0] + line[1]
            bin_file.write(binascii.unhexlify(x))

        if kwargs.halt:
            bin_file.write(binascii.unhexlify("FFFFFFFF"))

        hex_file.close()
        bin_file.close()


    def generate_tcl_load(tcl_name, sys_bin, usr_bin=None, rsi_bin=None):
        tcl_file = open(tcl_name, "w")
        script = """set master [claim_service "master" [lindex [get_service_paths "master"] 0] ""];
            master_write_from_file $master {} {};
            """.format(sys_bin, SYS_TEXT_ADDR)

        if usr_bin is not None:
            script = script + f"master_write_from_file $master {usr_bin} {USR_TEXT_ADDR};"

        if rsi_bin is not None:
            script = script + f"master_write_from_file $master {rsi_bin} {RSI_ADDR};"

        tcl_file.close()
        return tcl_name;


    def generate_tcl_memdump(tcl_name, addr, span):
        tcl_file = open(tcl_name, "w")
        script = """set master [claim_service "master" [lindex [get_service_paths "master"] 0] ""];
            puts [master_read_32 $master {} {}]""".format(addr, span)
        tcl_file.write(script)
        tcl_file.close()
        return tcl_name

    
    def call_system_console(tcl_name):
        system_console = os.path.join(SYSTEM_CONSOLE_PATH, "system-console.exe")
        cmd = subprocess.Popen(system_console + f" --project_dir={PROJECT_DIR} --script={tcl_name}", shell=True,
                               stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, err = cmd.communicate()
        cmd.wait()

        return stdout
		