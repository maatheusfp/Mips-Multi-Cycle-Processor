module signExtend_8x32 (
  input [7:0] MDA,
  output reg [31:0] EPC
);

  always @(*) begin
    if (MDA[7] == 1) // Check if the 8th bit (most significant bit) is 1 = negative
      EPC = {24'b111111111111111111111111, MDA};
    else // Positive number
      EPC = {24'b000000000000000000000000, MDA};
  end

endmodule


// testbench
// `timescale 1ns / 1ps

// module testbench;
//     reg [7:0] MDA;
//     wire [31:0] EPC;

//     // Instanciando o módulo signExtend_8x32
//     signExtend_8x32 uut (
//         .MDA(MDA),
//         .EPC(EPC)
//     );

//     initial begin
//         // Testando com um número positivo
//         MDA = 8'b00000001;
//         #10;
//         $display("MDA = %b, EPC = %b", MDA, EPC);

//         // Testando com um número negativo
//         MDA = 8'b10000001;
//         #10;
//         $display("MDA = %b, EPC = %b", MDA, EPC);

//         // Testando com zero
//         MDA = 8'b00000000;
//         #10;
//         $display("MDA = %b, EPC = %b", MDA, EPC);

//         // Testando com todos os bits setados
//         MDA = 8'b11111111;
//         #10;
//         $display("MDA = %b, EPC = %b", MDA, EPC);

//         $finish;
//     end
// endmodule

// MDA = 00000001, EPC = 00000000000000000000000000000001
// MDA = 10000001, EPC = 11111111111111111111111110000001
// MDA = 00000000, EPC = 00000000000000000000000000000000
// MDA = 11111111, EPC = 11111111111111111111111111111111