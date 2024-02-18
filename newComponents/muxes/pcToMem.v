module pcToMem(
    input wire [31:0] PCSource,
    input wire [31:0] RDtoIorDMUX,
    input wire [31:0] ALUOut,
    input wire [2:0] IorD,
    output reg [31:0] IorDMUXtoMem
);

always @* begin
    case (IorD)
        3'b000: IorDMUXtoMem = PCSource;
        3'b001: IorDMUXtoMem = 32'b11111101; // 253
        3'b010: IorDMUXtoMem = 32'b11111110; // 254
        3'b011: IorDMUXtoMem = 32'b11111111; // 255
        3'b100: IorDMUXtoMem = RDtoIorDMUX;
        3'b101: IorDMUXtoMem = ALUOut;
        default: IorDMUXtoMem = 32'b0; // Default case for invalid IorD values
    endcase
end

endmodule
