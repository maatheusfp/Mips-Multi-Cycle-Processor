module MDR(
    input wire [31:0] MemDatatoMDR,
    input wire MDRWrite,
    output reg [31:0] MDROut,
    output reg [7:0] MDROutByte
);
    always @(*) begin
        case (MDRWrite)
            1'b1: begin
                MDROut = MemDatatoMDR;
                MDROutByte = MemDatatoMDR[7:0];
            end
            default: begin
               
                MDROut = 32'b0;        // Defina MDROut como zero
                MDROutByte = 8'b0;     // Defina MDROutByte como zero

            end
        endcase
    end
endmodule
