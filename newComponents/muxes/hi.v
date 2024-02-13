// mux 2x1
// mux div/mult cntrl
module mux2x1(
    input wire [31:0] DivtoDivCtrlMUX,
    input wire [31:0] MulttoDivCtrlMUX,
    input wire DivMultCtrlMUX,
    output reg [1:0] DivCtrlMUXtoHI
);

  always @(*) begin
    case (DivMultCtrlMUX)
      1'b0: DivCtrlMUXtoHI = DivtoDivCtrlMUX;
      1'b1: DivCtrlMUXtoHI = MulttoDivCtrlMUX;
    //   default: DivCtrlMUXtoHI = 1'b0; // Default value
    endcase
  end
endmodule