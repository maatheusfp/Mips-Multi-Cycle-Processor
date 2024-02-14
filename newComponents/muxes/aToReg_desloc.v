// entry ctrl mux
// mux 3x1
module aToReg_desloc(
    input wire [15:0] AtoEntryCtrl,
    input wire [15:0] BtoEntryCtrl,
    input wire [15:0] IR15_0toMUXShiftCtrl,
    input wire [1:0] EntryCtrl,
);
     
        always @(*) begin
      case (EntryCtrl)
          2'b00: EntryCtrlMUXtoRD = IR15_0toMUXShiftCtrl;
          2'b01: EntryCtrlMUXtoRD = BtoEntryCtrl;
          2'b10: EntryCtrlMUXtoRD = AtoEntryCtrl; 
          default: EntryCtrlMUXtoRD = 16'b0; // Default value
      endcase
    end
endmodule