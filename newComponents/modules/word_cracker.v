module WordCracker(
  input wire [31:0] word,
  input wire [31:0] memory,
  input wire [1:0] WordCrackerCtrl,
  output reg [31:0] out
);

  always @ (*) begin
    case (WordCrackerCtrl)
       2'b00: out = word; 
       2'b01: out = {memory[31:16],word[15:0]};
       2'b10: out = {memory[31:8],word[7:0]};
       default: out = word;
    endcase
  end

endmodule