// mux 2x1
// mux div/mult cntrl
module mux2x1(
    input wire [31:0] DivtoDivCtrlMUX,
    input wire [31:0] MulttoDivCtrlMUX,
    input wire divCtrl,
    output reg [1:0] MultCtrlMUXtoLO
);

  always @(*) begin
    case (divCtrl)
      1'b0: MultCtrlMUXtoLO = DivtoDivCtrlMUX;
      1'b1: MultCtrlMUXtoLO = MulttoDivCtrlMUX;
    //   default: MultCtrlMUXtoLO = 1'b0; // Default value
    endcase
  end
endmodule