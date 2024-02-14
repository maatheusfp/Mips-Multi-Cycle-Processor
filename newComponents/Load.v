module Load(
    input wire [31:0] CRESULT, input wire [1:0] CTRL, #CRESULT = Mudança de resultado (32 bits de entrada), CTRL = Sinal de controle (2 bits de entrada)
    output reg [31:0] OUT #OUT = Saída (32 bits de saída)
);

always @ (*) begin
    OUT = (CTRL == 2'b00) ? CRESULT :
           (CTRL == 2'b01) ? {16'b0, CRESULT[15:0]} :
           (CTRL == 2'b10) ? {24'b0, CRESULT[7:0]} :
                             CRESULT;
end

endmodule
