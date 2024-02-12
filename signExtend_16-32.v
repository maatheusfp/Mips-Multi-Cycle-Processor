module signExtend_16x32 (
  input [15:0] IR,
  output reg [31:0] shiftLeft // output reg = variable in verilog to be used in a always loops
);

  always @(*) begin  // changes every time ir changes
    if (IR[15] == 1)  // verify if the 16th bit (most significant bit) is 1 = negative
        begin
        shiftLeft = {16'b1111111111111111, IR};
        end 
    else  // postive number
        begin
        shiftLeft = {16'b0000000000000000, IR};
        end
  end

endmodule

// testbench:

// `timescale 1ns / 1ps

// module testbench;
//     reg [15:0] IR;
//     wire [31:0] shiftLeft;

//     // Instanciar o módulo que queremos testar
//     signExtend_16x32 uut (
//         .IR(IR), 
//         .shiftLeft(shiftLeft)
//     );

//     initial begin
//         // Teste com um número positivo
//         IR = 16'b0000000000000001;
//         #10; // Espera 10 unidades de tempo
//         $display("IR = %b, shiftLeft = %b", IR, shiftLeft);

//         // Teste com um número negativo
//         IR = 16'b1000000000000000;
//         #10; // Espera 10 unidades de tempo
//         $display("IR = %b, shiftLeft = %b", IR, shiftLeft);

//         // Finaliza a simulação
//         $finish;
//     end
// endmodule

// IR = 0000000000000001, shiftLeft = 00000000000000000000000000000001
// IR = 1000000000000000, shiftLeft = 11111111111111111000000000000000