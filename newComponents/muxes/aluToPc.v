// Branch control mux - mux 4x1
module aluToPc(
    input wire GTorLT_toBranchCtrl, 
    input wire LTorZero_toBranchCtrl,
    input wire zero_in_ALU,
    input wire GTtoBranchMUX,
    input wire [1:0] BranchCtrl,
    output reg BranchCtrlMUXtoWriteCondAND
);

    always @* begin
        case (BranchCtrl)
            2'b00: BranchCtrlMUXtoWriteCondAND = GTorLT_toBranchCtrl; // Valor padrão, pode ser ajustado conforme necessário
            2'b01: BranchCtrlMUXtoWriteCondAND = LTorZero_toBranchCtrl;
            2'b10: BranchCtrlMUXtoWriteCondAND = zero_in_ALU ;
            2'b11: BranchCtrlMUXtoWriteCondAND = GTtoBranchMUX;
            // default: BranchCtrlMUXtoWriteCondAND = 1'b0; // Pode ser necessário um valor padrão específico
        endcase
    end

endmodule
