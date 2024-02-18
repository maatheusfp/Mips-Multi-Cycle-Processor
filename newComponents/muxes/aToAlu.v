// mux 2x1
module aToAlu(
    input wire [31:0] AtoALUSrcA,
    input wire [31:0] PCtoMUX,
    input wire ALUSrcA,
    output reg [31:0] ALUSrcAMUXtoALU
);

  always @(*) begin
    case (ALUSrcA)
      2'b0: ALUSrcAMUXtoALU = AtoALUSrcA;
      2'b1: ALUSrcAMUXtoALU = PCtoMUX;
      default: ALUSrcAMUXtoALU = 32'b0; // Default value
    endcase
  end
endmodule
