// shift left 2 = multiplica por 4 (2**2)
module shiftLeft2(
    input wire [31:0] IR15_0toShiftLeft,  // input 32 bits
    output wire [31:0] SLtoPCSourceMYX // output 32 bits
);

    assign SLtoPCSourceMYX = IR15_0toShiftLeft << 2; 

endmodule
