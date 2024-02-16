// Ignore mux - mux 2x1
module overflowToControl_unit(
    input wire [31:0] Overflow,
    input wire ignore,
    output reg [31:0] IgnoreMUXtoUC
);

    always @* begin
        case (ignore)
            1'b0: IgnoreMUXtoUC = 32'b0;
            1'b1: IgnoreMUXtoUC = Overflow;
            default: IgnoreMUXtoUC = 32'b0; // Valor padrão
        endcase
    end

endmodule
