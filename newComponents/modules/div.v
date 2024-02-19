module div (
  input wire clk, reset, start,
  input wire [31:0] dividendo,
  input wire [31:0] divisor,
  output reg divzero,
  output reg [31:0] Hi, Lo
);

  reg [63:0] div; 
  reg [63:0] resto; 
  reg [31:0] quociente;
  reg [5:0] counter;

  always @(posedge clk) begin
    if (reset == 1'b1 || start == 1'b1) begin
      if (divisor == 32'd0) begin 
        divzero = 1'b1;
      end 
      else begin

        if (dividendo[31] == 1'b1) begin
          resto[31:0] = ~dividendo + 1'b1; 
        end else begin
          resto[31:0] = dividendo;
        end
  
        if (divisor[31] == 1'b1) begin
          div[63:32] = ~divisor + 1'b1; 
        end else begin
          div[63:32] = divisor;
        end

        div[31:0] = 32'd0;
        resto[63:32] = 32'd0;
        quociente = 32'd0;
        Hi = 32'd0;
        Lo = 32'd0;
        divzero = 1'b0;
        counter = 6'd33;
        
      end
      
    end else begin 
      if (divzero != 1'b1 && counter != 6'd0) begin
        resto = resto - div;
        
        if (resto[63] == 1'b1) begin
          resto = resto + div;
          quociente = {quociente[30:0], 1'b0};
        end else begin
          quociente = {quociente[30:0], 1'b1};
        end

        div = div >> 1'b1;

        counter = counter - 6'd1;

        if (counter == 6'd0) begin 
          if (divisor[31] != dividendo[31]) begin 
            if (divisor[31] == 1'b1) begin 
              Hi = resto[31:0];
              Lo = ~quociente + 1'b1; 
            end else begin 
              Hi = ~resto[31:0] + 1'b1; 
              Lo = ~quociente + 1'b1; 
            end
          end else begin 
            if (divisor[31] == 1'b1) begin 
              Hi = ~resto[31:0] + 1'b1;
              Lo = quociente;
            end else begin 
              Hi = resto[31:0];
              Lo = quociente;
            end
          end
        end
      end
    end
  end
endmodule
