// mux 2x1
module aToAlu(
    input wire AtoALUSrcA [15:0],
    input wire PCtoMUX [31:0],
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