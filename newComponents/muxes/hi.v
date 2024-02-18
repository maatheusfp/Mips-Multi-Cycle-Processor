// mux 2x1
// mux div/mult cntrl
module hi(
    input wire [31:0] DivtoDivCtrlMUX,
    input wire [31:0] MulttoDivCtrlMUX,
    input wire divCtrl,
    output reg [31:0] DivCtrlMUXtoHI
);

  always @(*) begin
    case (divCtrl)
      1'b0: DivCtrlMUXtoHI = DivtoDivCtrlMUX;
      1'b1: DivCtrlMUXtoHI = MulttoDivCtrlMUX;
    //   default: DivCtrlMUXtoHI = 1'b0; // Default value
    endcase
  end
endmodule