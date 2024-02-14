// reduce ctrl mux
// mux 2x1
module mdaToSign32_5(
    input wire MDRtoRdcCtrlMUX [31:0],
    input wire BtoRdcCtrlMUX [31:0],
    input wire RdcCtrl,
    output reg [31:0] RdcCtrlMUXtoSign32_5
);
    
      always @(*) begin
     case (RdcCtrl)
        2'b0: RdcCtrlMUXtoSign32_5 = MDRtoRdcCtrlMUX;
        2'b1: RdcCtrlMUXtoSign32_5 = BtoRdcCtrlMUX;
        // default: RdcCtrlMUXtoSign32_5 = 32'b0; // Default value
     endcase
    end
endmodule