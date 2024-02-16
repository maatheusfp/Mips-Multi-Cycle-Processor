// Mux 5x1
module irToReg(
    input wire [31:0] reg31,
    input wire [31:0] reg29,
    input wire [15:0] IR15_0toMUXReg,
    input wire [4:0] IR20_16toReg,
    input wire [4:0] IR25_21toMUXReg,
    input wire [2:0] RegDst, // 3-bit input to select between 5 inputs
    output reg [31:0] RegDstMUXtoReg
);

    always @* begin
        case (RegDst)
            3'b000: RegDstMUXtoReg = reg31;
            3'b001: RegDstMUXtoReg = reg29;
            3'b010: RegDstMUXtoReg = IR15_0toMUXReg;
            3'b011: RegDstMUXtoReg = IR20_16toReg;
            3'b100: RegDstMUXtoReg = IR25_21toMUXReg;
            default: RegDstMUXtoReg = 32'b0; // Valor padrão quando RegDst é inválido
        endcase
    end

endmodule
