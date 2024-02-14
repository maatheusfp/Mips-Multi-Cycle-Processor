// lo -> used on mult and div
// recives MultCtrlMUXtoLO  [31:0]
// takes the 16 least significant bits of the result using HiCtrl
module lo (
    input wire [31:0] MultCtrlMUXtoLO,
    input wire LoCtrl,
    output reg [15:0] LOtoMemtoRegMUX
);
    
        always @(*) begin
            if (LoCtrl == 1) // if LoCtrl is 1, take the 16 least significant bits of the result
                LOtoMemtoRegMUX = MultCtrlMUXtoLO[15:0];
            else
                LOtoMemtoRegMUX = 16'b0; // if LoCtrl is 0, set LO to 0
        end
    
endmodule