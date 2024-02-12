module signExtend_1x32 (
  input LT, // LT = Less Than. does it has to be input wire?
  output reg [31:0] mux // output reg = variable in verilog to be used in a always loops
);

  always @(*) 
  begin
    if (LT == 1)  
        begin
            mux = {31'b0, LT};  // Set the output to 00000000000000000000000000000001
        end 
    else 
        begin
            mux = 0;
        end
  end

endmodule


// // testbench:
// `timescale 1ns / 1ps

// module testbench;
//     reg LT;
//     wire [31:0] mux;

//     // Instanciar o módulo que queremos testar
//     signExtend_1x32 uut (
//         .LT(LT), 
//         .mux(mux)
//     );

//     initial begin
//         // Teste com LT = 1
//         LT = 1;
//         #10; // Espera 10 unidades de tempo
//         $display("LT = %b, mux = %b", LT, mux);

//         // Teste com LT = 0
//         LT = 0;
//         #10; // Espera 10 unidades de tempo
//         $display("LT = %b, mux = %b", LT, mux);

//         // Finaliza a simulação
//         $finish;
//     end
// endmodule


// LT = 1, mux = 01111111111111111111111111111111
// LT = 0, mux = 00000000000000000000000000000000