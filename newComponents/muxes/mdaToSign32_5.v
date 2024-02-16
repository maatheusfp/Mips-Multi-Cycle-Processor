// reduce ctrl mux
// mux 2x1
module mdaToSign32_5(
    input wire [31:0] MDRtoRdcCtrlMUX,
    input wire [31:0] BtoRdcCtrlMUX,
    input wire RdcCtrl,
    output reg [31:0] RdcCtrlMUXtoSign32_5
);

    always @* begin
        case (RdcCtrl)
            1'b0: RdcCtrlMUXtoSign32_5 = MDRtoRdcCtrlMUX;
            1'b1: RdcCtrlMUXtoSign32_5 = BtoRdcCtrlMUX;
            default: RdcCtrlMUXtoSign32_5 = 32'b0; // Valor padrão
        endcase
    end

endmodule
