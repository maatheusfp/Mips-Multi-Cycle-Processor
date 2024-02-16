// mux 2x1
module MemControl(
    input wire IorDMUXOut[31:0],
    input wire WriteDataCtrlMUXOut[31:0];
    input wire MemWrite_Read,
    output wire OUT [31:0]
);

  always @(*) begin
    case (MemWrite_Read)
      2'b0: OUT = IorDMUXOut;
      2'b1: OUT = WriteDataCtrlMUXOut;
      default: OUT = 32'b0; // Default value
    endcase
  end
endmodule