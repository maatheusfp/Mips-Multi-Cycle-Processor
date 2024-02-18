module MDR(
    input wire [31:0] MemDatatoMDR,
    input wire MDRWrite,
    output reg [31:0] MDROut,
    output reg [7:0] MDROutByte
);
    always @(*) begin
        case (MDRWrite)
            MDROut <= MemDatatoMDR;
            MDROutByte <= MemDatatoMDR[7:0];
        endcase           
    end
endmodule