module MemtoRegMUX( 
    input wire [31:0] ALUOuttoMemtoRegMUX,
    input wire [31:0] LoadSizetoMemtoRegMUX ,
    input wire [31:0] MemDatatoMemtoRegMUX,
    input wire [31:0] RDtoMemtoRegMUX,
    input wire [31:0] SE1_32toMemtoRegMUX ,
    input wire [31:0] reg227,
    input wire [31:0] RegB,
    input wire [31:0] HItoMemtoRegMUX,
    input wire [31:0] LOtoMemtoRegMUX,
    input wire [3:0] MemtoReg,
    output reg [31:0] RegDstMUXtoReg
);

    always @* begin
        case (MemtoReg)
            4'b0000: RegDstMUXtoReg = ALUOuttoMemtoRegMUX;
            4'b0001: RegDstMUXtoReg = LoadSizetoMemtoRegMUX;
            4'b0010: RegDstMUXtoReg = MemDatatoMemtoRegMUX;
            4'b0011: RegDstMUXtoReg = RDtoMemtoRegMUX;
            4'b0100: RegDstMUXtoReg = SE1_32toMemtoRegMUX ;
            4'b0101: RegDstMUXtoReg = reg227; // mudar para 227 em bits
            4'b0110: RegDstMUXtoReg = RegB;
            4'b0111: RegDstMUXtoReg = HItoMemtoRegMUX;
            4'b1000: RegDstMUXtoReg = LOtoMemtoRegMUX;
            default: RegDstMUXtoReg = 32'b0; // Caso padrão
        endcase
    end

endmodule
