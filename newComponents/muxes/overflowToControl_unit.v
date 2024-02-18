// Ignore mux - mux 2x1
module overflowToControl_unit(
    input wire Overflow,
    input wire ignore,
    output reg IgnoreMUXtoUC
);

    always @* begin
        case (ignore)
            1'b0: IgnoreMUXtoUC = Overflow ;
            1'b1: IgnoreMUXtoUC = 0;
            default: IgnoreMUXtoUC = 0; // Valor padrão
        endcase
    end

endmodule
