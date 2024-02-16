// Branch control mux - mux 4x1
module aluToPc(
    input wire zero_in_ALU, // zero na ALU
    input wire GTtoBranchMUX,
    input wire LTorZero_toBranchCtrl,
    input wire GTorLT_toBranchCtrl,
    input wire [1:0] BranchCtrl,
    output reg BranchCtrlMUXtoWriteCondAND
);

    always @* begin
        case (BranchCtrl)
            2'b00: BranchCtrlMUXtoWriteCondAND = 1'b0; // Valor padrão, pode ser ajustado conforme necessário
            2'b01: BranchCtrlMUXtoWriteCondAND = GTtoBranchMUX;
            2'b10: BranchCtrlMUXtoWriteCondAND = LTorZero_toBranchCtrl;
            2'b11: BranchCtrlMUXtoWriteCondAND = GTorLT_toBranchCtrl;
            // default: BranchCtrlMUXtoWriteCondAND = 1'b0; // Pode ser necessário um valor padrão específico
        endcase
    end

endmodule
