//mux 9x1
module MemtoRegMUX(
        input [31:0] RDtoMemtoRegMUX, // ok
        input [31:0] SE1_32toMemtoRegMUX, // ok
        input [31:0] MemDatatoMemtoRegMUX,// ok
        input [31:0] ALUOuttoMemtoRegMUX, // ok
        input [31:0] LOtoMemtoRegMUX, // ok
        input [31:0] HItoMemtoRegMUX, // ok
        input [31:0] reg227,  // ok
        input [31:0] LoadSizetoMemtoRegMUX, // load size
        input [3:0] MemtoReg, // 4-bit input to select between 9 inputs
        output reg [31:0] RegDstMUXtoReg, // ok
);

    always @(*) begin
        case (MemtoReg)
            4'b0000: RegDstMUXtoReg = RDtoMemtoRegMUX;
            4'b0001: RegDstMUXtoReg = SE1_32toMemtoRegMUX;
            4'b0010: RegDstMUXtoReg = MemDatatoMemtoRegMUX;
            4'b0011: RegDstMUXtoReg = ALUOuttoMemtoRegMUX;
            4'b0100: RegDstMUXtoReg = LOtoMemtoRegMUX;
            4'b0101: RegDstMUXtoReg = HItoMemtoRegMUX;
            4'b0110: RegDstMUXtoReg = reg227;
            4'b0111: RegDstMUXtoReg = LoadSizetoMemtoRegMUX;
            4'b1000: RegDstMUXtoReg = ALUOuttoRDtoIorDMUX;
            default: RegDstMUXtoReg = 32'h0; // Caso padrão
        endcase
    end
endmodule
