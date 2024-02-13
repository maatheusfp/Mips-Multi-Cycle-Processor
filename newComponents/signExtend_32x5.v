module signExtend_32x5 ( // takes the 5 most significant bits of a 32 bit number 
  input [31:0] rdcCtrlMUX_toSE32_5,
  output reg [4:0] se32x5ToShift_ctrlMUX
);

  always @(*) begin
    if (rdcCtrlMUX_toSE32_5[31] == 1) // verify if the 32th bit (most significant bit) is 1 = negative
      se32x5ToShift_ctrlMUX = {27'b11111, rdcCtrlMUX_toSE32_5[31:27]}; 
    else
      se32x5ToShift_ctrlMUX = {27'b00000, rdcCtrlMUX_toSE32_5[31:27]};
  end

endmodule


// testbench:
// `timescale 1ns / 1ps

// module testbench;
//     reg [31:0] in;
//     wire [4:0] se32x5ToShift_ctrlMUX;

//     // Instanciando o módulo signExtend_32x5
//     signExtend_32x5 uut (
//         .in(in),
//         .se32x5ToShift_ctrlMUX(se32x5ToShift_ctrlMUX)
//     );

//     initial begin
//         // Testando com um número positivo
//         in = 32'b00000000000000000000000000000001;
//         #10;
//         $display("in = %b (%d), se32x5ToShift_ctrlMUX = %b (%d)", in, in, se32x5ToShift_ctrlMUX, se32x5ToShift_ctrlMUX);

//         // Testando com um número negativo
//         in = 32'b10000000000000000000000000000001;
//         #10;
//         $display("in = %b (%d), se32x5ToShift_ctrlMUX = %b (%d)", in, in, se32x5ToShift_ctrlMUX, se32x5ToShift_ctrlMUX);

//         // Testando com zero
//         in = 32'b00000000000000000000000000000000;
//         #10;
//         $display("in = %b (%d), se32x5ToShift_ctrlMUX = %b (%d)", in, in, se32x5ToShift_ctrlMUX, se32x5ToShift_ctrlMUX);

//         // Testando com todos os bits setados
//         in = 32'b11111111111111111111111111111111;
//         #10;
//         $display("in = %b (%d), se32x5ToShift_ctrlMUX = %b (%d)", in, in, se32x5ToShift_ctrlMUX, se32x5ToShift_ctrlMUX);

//         $finish;
//     end
// endmodule


// in = 00000000000000000000000000000001 (         1), se32x5ToShift_ctrlMUX = 00000 ( 0)
// in = 10000000000000000000000000000001 (2147483649), se32x5ToShift_ctrlMUX = 10000 (16)
// in = 00000000000000000000000000000000 (         0), se32x5ToShift_ctrlMUX = 00000 ( 0)
// in = 11111111111111111111111111111111 (4294967295), se32x5ToShift_ctrlMUX = 11111 (31)