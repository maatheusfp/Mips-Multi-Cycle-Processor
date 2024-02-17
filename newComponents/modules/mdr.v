module MDR(
    input wire [31:0] MemDatatoMDR;
    output reg [31:0] MDRtoWordCracker;
    output reg [7:0] MDRtoSignExtend;
    output reg [31:0] MDRtoLoadSize; 
    output reg [31:0] MDRtoMemtoRegMUX;
    output reg [31:0] MDRtoRdcCtrlMUX;
);
    always @(*) begin
            MDRtoWordCracker = MemDatatoMDR;
            MDRtoSignExtend = MemDatatoMDR[7:0];
            MDRtoLoadSize = MemDatatoMDR; 
            MDRtoMemtoRegMUX = MemDatatoMDR;
            MDRtoRdcCtrlMUX = MemDatatoMDR;
    end

endmodule