// entry ctrl mux
// mux 3x1
module aToReg_desloc(
    input wire [31:0] AtoEntryCtrl,
    input wire [31:0] BtoEntryCtrl,
    input wire [15:0] IR15_0toMUXShiftCtrl,
    input wire [1:0] EntryCtrl, // ok
    output reg [31:0] EntryCtrlMUXtoRD
);
     
    always @(*) begin
        case (EntryCtrl)
            2'b00: EntryCtrlMUXtoRD = {16'b0000000000000000,  IR15_0toMUXShiftCtrl}; //
            2'b01: EntryCtrlMUXtoRD = BtoEntryCtrl; // se IR15_0toMUXShiftCtrl for 16'b1010101010101010, após a atribuição, EntryCtrlMUXtoRD será 32'b00000000101010101010101010101010. O bit mais significativo (bit de sinal) é duplicado para preencher os bits adicionais
            2'b10: EntryCtrlMUXtoRD = AtoEntryCtrl;  // ok
            default: EntryCtrlMUXtoRD = 16'b0; // Default value
        endcase
    end
endmodule