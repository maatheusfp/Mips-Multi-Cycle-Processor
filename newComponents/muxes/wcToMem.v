// mux 2x1
module wcToMem(
    input wire [31:0] WCtoWriteDataCtrlMUX,
    input wire [31:0] BtoWriteDataCtrlMUX,
    input wire WriteDataCtrl,
    output reg [31:0] WriteDataCtrlMUXtoMem
);

  always @(*) begin
    case (WriteDataCtrl)
      1'b0: WriteDataCtrlMUXtoMem = BtoWriteDataCtrlMUX;
      1'b1: WriteDataCtrlMUXtoMem = WCtoWriteDataCtrlMUX;
      default: WriteDataCtrlMUXtoMem = 32'b0; // Default value
    endcase
  end

endmodule
