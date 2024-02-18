// mux 2x1
module wcToMem(
    input wire [31:0] WCtoWriteDataCtrlMUX,
    input wire [31:0] BtoWriteDataCtrlMUX,
    input wire WriteDataCtrl,
    output reg [31:0] WriteDataCtrlMUXtoMem
);

  always @(*) begin
    case (WriteDataCtrl)
      1'b0: WriteDataCtrlMUXtoMem = WCtoWriteDataCtrlMUX;
      1'b1: WriteDataCtrlMUXtoMem = BtoWriteDataCtrlMUX;
      default: WriteDataCtrlMUXtoMem = 32'b0; // Default value
    endcase
  end

endmodule
