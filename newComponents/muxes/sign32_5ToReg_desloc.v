// shiftctrlMUX
// mux 3x1
module mux3x1 (
    input wire [4:0] se32x5ToShift_ctrlMUX,
    input wire [31:0] reg16;
    input wire [4:0] IR10_6toMUXShiftCtrl;
    input wire [1:0] ShiftCtrl;
    output ShiftCtrlMUXtoRD [15:0]
);
    
      always @(*) begin
     case (ShiftCtrl)
        2'b00: ShiftCtrlMUXtoRD = se32x5ToShift_ctrlMUX;
        2'b01: ShiftCtrlMUXtoRD = reg16;
        2'b10: ShiftCtrlMUXtoRD = IR10_6toMUXShiftCtrl;
        default: ShiftCtrlMUXtoRD = 16'b0; // Default value
     endcase
      end
endmodule