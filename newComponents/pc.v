module PC(
    input wire [31:0] PCSourceMUXtoPC, 
    input wire PCWriteORtoPC, 
    output reg [31:0] PCtoIordMUX,
    output reg [31:0] PCtoEND
);

    always @(*) begin
        if (PCWriteORtoPC == 1) begin
            PCtoIordMUX = PCSourceMUXtoPC; 
            PCtoEND = PCSourceMUXtoPC; 
        end
        else begin
            PCtoIordMUX = 32'b0; 
            PCtoEND = 32'b0; // Ajustado para 32 bits
        end
    end

endmodule
