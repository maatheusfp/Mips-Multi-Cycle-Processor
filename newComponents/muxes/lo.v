// mux 2x1
// mux div/mult cntrl
module lo(
    input wire [31:0] DivtoMultCtrlMUX,
    input wire [31:0] MulttoMultCtrlMUX,
    input wire multCtrl,
    output reg [31:0] MultCtrlMUXtoLO
);

  always @(*) begin
    case (multCtrl)
      1'b0: MultCtrlMUXtoLO = DivtoMultCtrlMUX;
      1'b1: MultCtrlMUXtoLO = MulttoMultCtrlMUX;
    //   default: MultCtrlMUXtoLO = 1'b0; // Default value
    endcase
  end
endmodule