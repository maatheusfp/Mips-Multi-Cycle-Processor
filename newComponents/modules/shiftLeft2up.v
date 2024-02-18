// shift left 2 = multiplica por 4 (2**2)
module shiftLeft2up(
    input wire [25:0] IR15_0toShiftLeft,
    input wire [3:0]  PCOut,// input 32 bits
    output wire [31:0] SLtoPCSourceMYX // output 32 bits
);

    assign SLtoPCSourceMYX = {IR15_0toShiftLeft, PCOut, 2'b00}; 

endmodule
