// Mux 5x1
module irToReg(
    input wire [4:0] IR20_16toReg,  // rt 
    input wire [4:0] IR15_11toMUXReg, // 15-11 rd 
    input wire [4:0] IR25_21toMUXReg, // 25-21 rs
    input wire [4:0] RegDst, // 3-bit input to select between 5 inputs
    output reg [4:0] RegDstMUXtoReg
);

    always @* begin
        case (RegDst)
            3'b000: RegDstMUXtoReg = IR20_16toReg;
            3'b001: RegDstMUXtoReg = 5'b11111; // 31  
            3'b010: RegDstMUXtoReg = 5'b11101; // 29 
            3'b011: RegDstMUXtoReg = IR15_11toMUXReg; // rd
            3'b100: RegDstMUXtoReg = IR25_21toMUXReg; // rs
            default: RegDstMUXtoReg = 32'b0; // Valor padrão quando RegDst é inválido
        endcase
    end

endmodule
