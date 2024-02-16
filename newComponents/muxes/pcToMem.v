module pcToMem(
    input wire [31:0] PCSource,
    input wire [31:0] reg253,
    input wire [31:0] reg254,
    input wire [31:0] reg255,
    input wire [31:0] RDtoIorDMUX,
    input wire [2:0] IorD,
    output reg [31:0] IorDMUXtoMem
);

always @* begin
    case (IorD)
        3'b000: IorDMUXtoMem = PCSource;
        3'b001: IorDMUXtoMem = reg253;
        3'b010: IorDMUXtoMem = reg254;
        3'b011: IorDMUXtoMem = reg255;
        3'b100: IorDMUXtoMem = RDtoIorDMUX;
        default: IorDMUXtoMem = 32'b0; // Default case for invalid IorD values
    endcase
end

endmodule
