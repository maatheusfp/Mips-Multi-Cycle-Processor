// branch ctrl mux
// mux 4x1
module 4x1(
    input wire 0, // zero na ALU
    input wire GTtoBranchMUX,
    input wire LTorZero_toBranchCtrl,
    input wire GTorLT_toBranchCtrl,
    input wire BranchCtrl [1:0],
    output reg BranchCtrlMUXtoWriteCondAND
);

    always @(*) begin
        case (BranchCtrl)
            2'b00: BranchCtrlMUXtoWriteCondAND = 0;
            2'b01: BranchCtrlMUXtoWriteCondAND = GTtoBranchMUX;
            2'b10: BranchCtrlMUXtoWriteCondAND = LTorZero_toBranchCtrl;
            2'b11: BranchCtrlMUXtoWriteCondAND = GTorLT_toBranchCtrl;
        //   default: BranchCtrlMUXtoWriteCondAND = 1'b0; // Default value
        endcase
    end
endmodule

