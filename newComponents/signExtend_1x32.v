module signExtend_1x32 (
  input wire LTtoSignExtend, // LTtoSignExtend = Less Than. does it has to be input wire?
  output reg [31:0] SE1_32toMemtoRegMUX // output reg = variable in verilog to be used in a always loops
);

  always @(*) 
  begin
    if (LTtoSignExtend == 1)  
        begin
            SE1_32toMemtoRegMUX = {31'b0, LTtoSignExtend};  // Set the output to 00000000000000000000000000000001
        end 
    else 
        begin
            SE1_32toMemtoRegMUX = 0;
        end
  end

endmodule


// // testbench:
// `timescale 1ns / 1ps

// module testbench;
//     reg LTtoSignExtend;
//     wire [31:0] SE1_32toMemtoRegMUX;

//     // Instanciar o módulo que queremos testar
//     signExtend_1x32 uut (
//         .LTtoSignExtend(LTtoSignExtend), 
//         .SE1_32toMemtoRegMUX(SE1_32toMemtoRegMUX)
//     );

//     initial begin
//         // Teste com LTtoSignExtend = 1
//         LTtoSignExtend = 1;
//         #10; // Espera 10 unidades de tempo
//         $display("LTtoSignExtend = %b, SE1_32toMemtoRegMUX = %b", LTtoSignExtend, SE1_32toMemtoRegMUX);

//         // Teste com LTtoSignExtend = 0
//         LTtoSignExtend = 0;
//         #10; // Espera 10 unidades de tempo
//         $display("LTtoSignExtend = %b, SE1_32toMemtoRegMUX = %b", LTtoSignExtend, SE1_32toMemtoRegMUX);

//         // Finaliza a simulação
//         $finish;
//     end
// endmodule


// LTtoSignExtend = 1, SE1_32toMemtoRegMUX = 01111111111111111111111111111111
// LTtoSignExtend = 0, SE1_32toMemtoRegMUX = 00000000000000000000000000000000