module mux6x1 ( // mux IorD (pc -> mem)
  input wire [31:0] PCSource, 
  input wire [31:0] reg253, // check what is the function of this register
  input wire [31:0] reg254, // check what is the function of this register
  input wire [31:0] reg255, // check what is the function of this register  
  input wire [31:0] RDtoIorDMUX, // is it 32 bits or 5 bits?
  input wire [2:0] IorD, // 3-bit input to select between 6 inputs
  output reg [31:0] IorDMUXtoMem
);

always @* // changes every time one of the inputs changes
begin 
  case (IorD) // case statement to select the correct input
    3'b000: IorDMUXtoMem = PCSource; // If IorD is 000, IorDMUXtoMem = PCSource
    3'b001: IorDMUXtoMem = reg253; // If IorD is 001, IorDMUXtoMem = reg253
    3'b010: IorDMUXtoMem = reg254; // If IorD is 010, IorDMUXtoMem = reg254
    3'b011: IorDMUXtoMem = reg255; // If IorD is 011, IorDMUXtoMem = reg255
    3'b100: IorDMUXtoMem = RDtoIorDMUX; // If IorD is 100, IorDMUXtoMem = RDtoIorDMUX
    default: IorDMUXtoMem = 32'b0; // Default case if IorD is invalid -> 111, 101, 110
  endcase
end

endmodule
