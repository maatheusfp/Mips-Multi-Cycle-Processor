// Ignore mux - mux 2x1
module overflowToControl_unit(
    input wire Overflow,
    input wire ignore,
    output reg IgnoreMUXtoUC
);

    always @* begin
        case (ignore)
            1'b0: IgnoreMUXtoUC = 0;
            1'b1: IgnoreMUXtoUC = Overflow;
            default: IgnoreMUXtoUC = 0; // Valor padrão
        endcase
    end

endmodule
