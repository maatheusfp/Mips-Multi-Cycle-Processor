module mux5x1 (
  input [31:0] PC, 
  input [31:0] reg253, // check what is the function of this register
  input [31:0] reg254, // check what is the function of this register
  input [31:0] regDesloc, // is it 32 bits or 5 bits?
  input [1:0] controlUnit, // name it better?
  output reg [31:0] mem
);

always @* // changes every time one of the inputs changes
begin 
  case (controlUnit) // case statement to select the correct input
    2'b00: mem = PC; // If controlUnit is 00, mem = PC
    2'b01: mem = reg253; // If controlUnit is 01, mem = reg253
    2'b10: mem = reg254; // If controlUnit is 10, mem = reg254
    2'b11: mem = regDesloc; // If controlUnit is 11, mem = regDesloc
    default: mem = 32'b0; // Default case if controlUnit is invalid
  endcase
end

endmodule
