// PCSource mux
// mux 4x1
module epcToPc(
    input wire SLtoPCSourceMYX [31:0],
    input wire EPCtoPCSourceMUX [31:0],
    input wire ALUOuttoPCSourceMUX [31:0],
    input wire SE8_32toPCSource [31:0],
    input wire PCSource [1:0],
    output reg [31:0] PCSourceMUXtoPC
);
    
      always @(*) begin
     case (PCSource)
        2'b00: PCSourceMUXtoPC = SLtoPCSourceMYX;
        2'b01: PCSourceMUXtoPC = EPCtoPCSourceMUX;
        2'b10: PCSourceMUXtoPC = ALUOuttoPCSourceMUX;
        2'b11: PCSourceMUXtoPC = SE8_32toPCSource;
        default: PCSourceMUXtoPC = 32'b0; // Default value
     endcase
    end
endmodule