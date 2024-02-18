// mux 4x1 = mux ALUSrcB
module bToAlu(
    input wire [31:0] BtoALUSrcBMUX,
    input wire [31:0] reg4,
    input wire [31:0] SE16_32toALUsrcB,
    input wire [31:0] SLtoAluSrcBMUX,
    input wire [1:0] ALUSrcB,
    output reg [31:0] ALUSrcBMUXtoALU
);

  always @(*) begin
    case (ALUSrcB)
      3'b00: ALUSrcBMUXtoALU = BtoALUSrcBMUX;
      3'b01: ALUSrcBMUXtoALU = 32'd4;
      3'b10: ALUSrcBMUXtoALU = SE16_32toALUsrcB;
      3'b11: ALUSrcBMUXtoALU = SLtoAluSrcBMUX;
      default: ALUSrcBMUXtoALU = 32'b0; // Default value
    endcase
  end
endmodule
