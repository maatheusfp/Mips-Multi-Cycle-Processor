// shift left 2 = multiplica por 4 (2**2)
module shiftLeft2up(
    input wire [25:21] IR25_21,
    input wire [20:16] IR20_16,
    input wire [15:0] IR15_0,
    input wire [3:0]  PCOut,// input 32 bits
    output wire [31:0] SLtoPCSourceMYX // output 32 bits
);

    assign SLtoPCSourceMYX = {PCOut, IR25_21, IR20_16, IR15_0, 2'b00}; 

endmodule
