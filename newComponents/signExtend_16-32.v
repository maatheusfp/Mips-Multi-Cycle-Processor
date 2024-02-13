module signExtend_16x32 (
  input [15:0]  IR15_0toSingExtend,
  output reg [31:0] SE16_32SL // output reg = variable in verilog to be used in a always loops
);

  always @(*) begin  // changes every time  IR15_0toSingExtend changes
    if ( IR15_0toSingExtend[15] == 1)  // verify if the 16th bit (most significant bit) is 1 = negative
        begin
        SE16_32SL = {16'b1111111111111111,  IR15_0toSingExtend};
        end 
    else  // postive number
        begin
        SE16_32SL = {16'b0000000000000000,  IR15_0toSingExtend};
        end
  end

endmodule

// test:
//  IR15_0toSingExtend = 0000000000000001, SE16_32SL = 00000000000000000000000000000001
//  IR15_0toSingExtend = 1000000000000000, SE16_32SL = 11111111111111111000000000000000