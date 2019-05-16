const std = @import("std");

const Opcodes = enum(u8) {
    NOP,
    PUSH,
    POP,
    ADD,
    SUB,
};

pub fn main() void {
    const program = []u8{
        @enumToInt(Opcodes.PUSH),
        8,
        @enumToInt(Opcodes.PUSH),
        20,
        @enumToInt(Opcodes.ADD),
        @enumToInt(Opcodes.NOP),
    };
    const stack_size = 32;
    var stack = []u8{0} ** stack_size;
    var pc: u8 = 0;
    var sp: u8 = 0;

    while (true) {
        const instr = program[pc] & 0b00011111;
        const meta = (program[pc] & 0b11100000) >> 5;
        pc += 1;

        switch (@intToEnum(Opcodes, instr)) {
            Opcodes.NOP => return,
            Opcodes.PUSH => {
                stack[sp + meta] = program[pc];
                sp += 1;
                pc += 1;
            },
            Opcodes.POP => sp -= meta + 1,
            Opcodes.ADD => {
                sp -= 1;
                stack[sp] = stack[sp - 1] + stack[sp];
            },
            Opcodes.SUB => {
                sp -= 1;
                stack[sp] = stack[sp - 1] - stack[sp];
            },
        }
        var i: u8 = 0;
        while (i < stack_size) {
            std.debug.warn("{}, ", stack[i]);
            i += 1;
        }
        std.debug.warn("\n");
    }
}
