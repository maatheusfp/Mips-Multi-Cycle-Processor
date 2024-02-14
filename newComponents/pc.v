module PC(
    input wire [31:0] PCSourceMUXtoPC, 
    input wire PCWriteORtoPC; 
    output reg [31:0] PCtoIordMUX;
    output reg [31:0] PCtoEND;
);

    always @(*) begin
        if (PCWriteORtoPC == 1){
            PCtoIordMUX = PCSourceMUXtoPC; 
            PCtoEND = PCSourceMUXtoPC; 
        }
        else {
            PCtoIordMUX = 16'b0; 
            PCtoEND = 16'b0;
        }
    end

endmodule
