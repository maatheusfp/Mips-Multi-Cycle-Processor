module epcToPc(
    input wire [31:0] SLtoPCSourceMYX,
    input wire [31:0] EPCtoPCSourceMUX,
    input wire [31:0] ALUOuttoPCSourceMUX,
    input wire [31:0] SE8_32toPCSource,
    input wire [1:0] PCSource,
    output reg [31:0] PCSourceMUXtoPC
);
    
    always @* begin
        case (PCSource)
            2'b00: PCSourceMUXtoPC = SLtoPCSourceMYX;
            2'b01: PCSourceMUXtoPC = EPCtoPCSourceMUX;
            2'b10: PCSourceMUXtoPC = ALUOuttoPCSourceMUX;
            2'b11: PCSourceMUXtoPC = SE8_32toPCSource;
            default: PCSourceMUXtoPC = 32'b0; // Valor padrão
        endcase
    end

endmodule
