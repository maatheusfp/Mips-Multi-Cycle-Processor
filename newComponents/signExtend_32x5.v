module signExtend_32x5 ( // takes the 5 most significant bits of a 32 bit number 
  input [31:0] in,
  output reg [4:0] out
);

  always @(*) begin
    if (in[31] == 1) // verify if the 32th bit (most significant bit) is 1 = negative
      out = {27'b11111, in[31:27]}; 
    else
      out = {27'b00000, in[31:27]};
  end

endmodule


// testbench:
// `timescale 1ns / 1ps

// module testbench;
//     reg [31:0] in;
//     wire [4:0] out;

//     // Instanciando o módulo signExtend_32x5
//     signExtend_32x5 uut (
//         .in(in),
//         .out(out)
//     );

//     initial begin
//         // Testando com um número positivo
//         in = 32'b00000000000000000000000000000001;
//         #10;
//         $display("in = %b (%d), out = %b (%d)", in, in, out, out);

//         // Testando com um número negativo
//         in = 32'b10000000000000000000000000000001;
//         #10;
//         $display("in = %b (%d), out = %b (%d)", in, in, out, out);

//         // Testando com zero
//         in = 32'b00000000000000000000000000000000;
//         #10;
//         $display("in = %b (%d), out = %b (%d)", in, in, out, out);

//         // Testando com todos os bits setados
//         in = 32'b11111111111111111111111111111111;
//         #10;
//         $display("in = %b (%d), out = %b (%d)", in, in, out, out);

//         $finish;
//     end
// endmodule


// in = 00000000000000000000000000000001 (         1), out = 00000 ( 0)
// in = 10000000000000000000000000000001 (2147483649), out = 10000 (16)
// in = 00000000000000000000000000000000 (         0), out = 00000 ( 0)
// in = 11111111111111111111111111111111 (4294967295), out = 11111 (31)