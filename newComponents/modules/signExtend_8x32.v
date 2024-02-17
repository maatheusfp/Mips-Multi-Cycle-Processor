module signExtend_8x32 (
  input wire [7:0] MDRtoSignExtend,
  output reg [31:0] SE8_32toPCSource
);

  always @(*) begin
    if (MDRtoSignExtend[7] == 1) // Check if the 8th bit (most significant bit) is 1 = negative
      SE8_32toPCSource = {24'b111111111111111111111111, MDRtoSignExtend};
    else // Positive number
      SE8_32toPCSource = {24'b000000000000000000000000, MDRtoSignExtend};
  end

endmodule


// testbench
// `timescale 1ns / 1ps

// module testbench;
//     reg [7:0] MDRtoSignExtend;
//     wire [31:0] SE8_32toPCSource;

//     // Instanciando o módulo signExtend_8x32
//     signExtend_8x32 uut (
//         .MDRtoSignExtend(MDRtoSignExtend),
//         .SE8_32toPCSource(SE8_32toPCSource)
//     );

//     initial begin
//         // Testando com um número positivo
//         MDRtoSignExtend = 8'b00000001;
//         #10;
//         $display("MDRtoSignExtend = %b, SE8_32toPCSource = %b", MDRtoSignExtend, SE8_32toPCSource);

//         // Testando com um número negativo
//         MDRtoSignExtend = 8'b10000001;
//         #10;
//         $display("MDRtoSignExtend = %b, SE8_32toPCSource = %b", MDRtoSignExtend, SE8_32toPCSource);

//         // Testando com zero
//         MDRtoSignExtend = 8'b00000000;
//         #10;
//         $display("MDRtoSignExtend = %b, SE8_32toPCSource = %b", MDRtoSignExtend, SE8_32toPCSource);

//         // Testando com todos os bits setados
//         MDRtoSignExtend = 8'b11111111;
//         #10;
//         $display("MDRtoSignExtend = %b, SE8_32toPCSource = %b", MDRtoSignExtend, SE8_32toPCSource);

//         $finish;
//     end
// endmodule

// MDRtoSignExtend = 00000001, SE8_32toPCSource = 00000000000000000000000000000001
// MDRtoSignExtend = 10000001, SE8_32toPCSource = 11111111111111111111111110000001
// MDRtoSignExtend = 00000000, SE8_32toPCSource = 00000000000000000000000000000000
// MDRtoSignExtend = 11111111, SE8_32toPCSource = 11111111111111111111111111111111