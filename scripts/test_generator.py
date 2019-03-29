import random

class CodeGenerator:
    DATA_ADDR = "0x10010000"
    
    registers = [f"x{i}" for i in range(1, 31)]
    instructions = [
            ["li" , "li {}, {}"],
            ["arith", "add {}, {}, {}"],
            ["arith", "sub {}, {}, {}"],
            ["arith", "sll {}, {}, {}"],
            ["arith", "slt {}, {}, {}"],
            ["arith", "sltu {}, {}, {}"],
            ["arith", "xor {}, {}, {}"],
            ["arith", "srl {}, {}, {}"],
            ["arith", "sra {}, {}, {}"],
            ["arith", "or {}, {}, {}"],
            ["arith", "and {}, {}, {}"],
            ["arithi", "addi {}, {}, {}"],
            ["arithi", "slti {}, {}, {}"],
            ["arithi", "sltiu {}, {}, {}"],
            ["arithi", "xori {}, {}, {}"],
            ["arithi", "ori {}, {}, {}"],
            ["arithi", "andi {}, {}, {}"],
            ["si", "slli {}, {}, {}"],
            ["si", "srli {}, {}, {}"],
            ["si", "srai {}, {}, {}"],
            ]
    r_mem = "x31"
    mem_pos = 0
    label = 0

    def __init__(self):
        self.reset_code()


    @staticmethod
    def li_immediate():
        return random.randint(-524288, 524287)


    @staticmethod
    def arithi_immediate():
        return random.randint(-2048, 2047)


    @staticmethod
    def si_immediate():
        return random.randint(0, 15)


    @staticmethod
    def immediate_32():
        return random.randint(-2147483648, 2147483647)


    def get_label(self):
        l = self.label
        self.label += 1
        return f"L{l}"
	
	def branch_jump_ins():
		return [
            # ["b", ["b {}"]],
            ["beqz", ["beqz {}, {}"]],
            ["bgz", ["bgez {}, {}"]],
            ["bgz", ["bgtz {}, {}"]],
            ["blz", ["blez {}, {}"]],
            ["blz", ["bltz {}, {}"]],
            ["bc", ["bnez {}, {}"]],
            ["bc2", ["bgt {}, {}, {}"]],
            ["bc2", ["bgtu {}, {}, {}"]],
            ["bc2", ["ble {}, {}, {}"]],
            ["bc2", ["bleu {}, {}, {}"]]
            # ["jal", ["jal {}, {}"]],
            # ["jarl", ["jarl {}, {}, {}"]],
        ]
        
    def reset_code(self):
        self.code = [".text", f"li {self.r_mem}, {self.DATA_ADDR}"]
        self.code += [f"li {reg}, {self.immediate_32()}" for reg in self.registers]


    # TODO: Do it well and use the negatives and change the x31 register so it dosen't run out of mem positions
    def add_and_check_mem_pos(self):
        self.mem_pos += 4
        if self.mem_pos > 2047:
            print("mem_pos is greater than 2047 will generate errors at compile")


    def generate_instructions(self, n):
        for _ in range(n):
            self.generate_instruction()


    def generate_instruction(self):
        rd = random.choice(self.registers) 
        ra = random.choice(self.registers) 
        rb = random.choice(self.registers) 
        ins = random.choice(self.instructions)

        if ins[0] == "li":
            ins_with_reg = ins[1].format(rd, self.li_immediate())
        elif ins[0] == "arith":
            ins_with_reg = ins[1].format(rd, ra, rb)
        elif ins[0] == "arithi":
            ins_with_reg = ins[1].format(rd, ra, self.arithi_immediate())
        elif ins[0] == "si":
            ins_with_reg = ins[1].format(rd, ra, self.si_immediate())

        ins_wr_res = f"sw {rd}, {self.mem_pos}({self.r_mem})"
        self.code += [ins_with_reg, ins_wr_res]

        self.add_and_check_mem_pos()

    
    def generate_loop(self):
        


    def print_code(self):
        print(*self.code, sep='\n')



if __name__ == "__main__":
    cg = CodeGenerator()
    cg.generate_instructions(10)
    cg.print_code()
