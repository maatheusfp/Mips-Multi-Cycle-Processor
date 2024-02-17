// hi -> used on mult and div
// recives DivCtrlMUXtoHI  [31:0]
// uses HiCtrl to take the 16 most significant bits of the result
module hi (
    input wire [31:0] DivCtrlMUXtoHI,
    input wire HiCtrl,
    output reg [15:0] HItoMemtoRegMUX
);
    
        always @(*) begin
            if (HiCtrl == 1) // if HiCtrl is 1, take the 16 most significant bits of the result
                HItoMemtoRegMUX = DivCtrlMUXtoHI[31:16];
            else
                HItoMemtoRegMUX = 16'b0; // if HiCtrl is 0, set HI to 0
        end
    
endmodule