module mult_tb;

reg clock;
reg reset;
reg signed [31:0] multiplicant;
reg signed [31:0] multiplier;
wire signed [31:0] hi_mult;
wire signed [31:0] lo_mult;

// Instância do módulo mult
mult uut (
    .clock(clock),
    .reset(reset),
    .multiplicant(multiplicant),
    .multiplier(multiplier),
    .hi_mult(hi_mult),
    .lo_mult(lo_mult)
);

// Clock de teste
always #5 clock = ~clock;

// Teste inicial
initial begin
    clock = 0;
    reset = 1;
    multiplicant = 32'sd0;
    multiplier = 32'sd0;
    #10 reset = 0;
    #20 reset = 1;
    #10 reset = 0;
    #10 multiplicant = 32'sd10;
    #10 multiplier = 32'sd5;
    #100 $finish;
end

// Exibir resultados
always @(posedge clock) begin
    $display("Multiplicand: %d", multiplicant);
    $display("Multiplier: %d", multiplier);
    $display("Result (hi_mult): %d", hi_mult);
    $display("Result (lo_mult): %d", lo_mult);
end

endmodulemodule mult_tb;

reg clock;
reg reset;
reg signed [31:0] multiplicant;
reg signed [31:0] multiplier;
wire signed [31:0] hi_mult;
wire signed [31:0] lo_mult;

// Instância do módulo mult
Mult uut (
    .A_Out(multiplicant),
    .B_Out(multiplier),
    .clk(clock),
    .Reset_Out(reset),
    .MultInit(1'b1),
    .MultStop(),
    .Mult_High_Out(hi_mult),
    .Mult_Low_Out(lo_mult)
);

// Clock de teste
always #5 clock = ~clock;

// Teste inicial
initial begin
    clock = 0;
    reset = 1;
    multiplicant = 32'sd0;
    multiplier = 32'sd0;
    #10 reset = 0;
    #20 reset = 1;
    #10 reset = 0;
    #10 multiplicant = 32'sd10;
    #10 multiplier = 32'sd5;
    #100 $finish;
end

// Exibir resultados
always @(posedge clock) begin
    $display("Multiplicand: %d", multiplicant);
    $display("Multiplier: %d", multiplier);
    $display("Result (hi_mult): %d", hi_mult);
    $display("Result (lo_mult): %d", lo_mult);
end

endmodule