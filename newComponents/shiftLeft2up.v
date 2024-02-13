//  shift left 2 = multiplies by 4 (2**2)
module shiftLeft2(
    input wire IR15_0toShiftLeft [15:0],  // input 32 bits
    output reg SLtoPCSourceMYX [31:0]// output 32 bits
    );
    
    assign SLtoPCSourceMYX = IR15_0toShiftLeft << 2; // shift left 2 = multiplies by 4 (2**2)

endmodule

// testbench:
// `timescale 1ns / 1ps

// module testbench;
//     reg [31:0] in;
//     wire [31:0] out;

//     // Instanciando o módulo shiftLeft2
//     shiftLeft2 uut (
//         .in(in),
//         .out(out)
//     );

//     initial begin
//         // Testando com o valor 1
//         in = 32'b00000000000000000000000000000001;
//         #10;
//         $display("in = %b (%d), out = %b (%d)", in, in, out, out);

//         // Testando com o valor 2
//         in = 32'b00000000000000000000000000000010;
//         #10;
//         $display("in = %b (%d), out = %b (%d)", in, in, out, out);

//         // Testando com o valor 10
//         in = 32'b00000000000000000000000000001010;
//         #10;
//         $display("in = %b (%d), out = %b (%d)", in, in, out, out);

//         $finish;
//     end
// endmodule

// in = 00000000000000000000000000000001 (         1), out = 00000000000000000000000000000100 (         4)
// in = 00000000000000000000000000000010 (         2), out = 00000000000000000000000000001000 (         8)
// in = 00000000000000000000000000001010 (        10), out = 00000000000000000000000000101000 (        40)