// mux 5x1
module mux5x1 (
    input wire [31:0] reg31,
    input wire [31:0] reg29,
    input wire [15:0] IR15_0toMUXReg,
    input wire [4:0] IR20_16toReg,
    input wire [4:0] IR25_21toMUXReg,
    input wire [2:0] RegDst, // 2-bit input to select between 5 inputs
    output reg [5:0] RegDstMUXtoReg
);

    always @*
    begin
        case (RegDst)
            5'b000: RegDstMUXtoIR = reg31;
            5'b001: RegDstMUXtoIR = reg29;
            5'b010: RegDstMUXtoIR = IR15_0toMUXReg;
            5'b011: RegDstMUXtoIR = IR20_16toReg;
            5'b100: RegDstMUXtoIR = IR25_21toMUXReg;
            default: RegDstMUXtoIR = 0; // Default output when RegDst is invalid
        endcase
    end

endmodule
