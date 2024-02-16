module div (
    input wire clock,
    input wire reset,
    input wire [31:0] dividend,
    input wire [31:0] divisor,
    output reg [31:0] hi_div,
    output reg [31:0] lo_div,
    output reg division_by_zero
);

reg [31:0] remainder;
reg [31:0] quotient;
reg [31:0] temp;
reg [5:0] counter;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        hi_div <= 32'b0;
        lo_div <= 32'b0;
        remainder <= 32'b0;
        quotient <= 32'b0;
        division_by_zero <= 1'b0;
        counter <= 6'b0;
    end
    else begin
        if (divisor == 32'b0) begin
            hi_div <= 32'b0;
            lo_div <= 32'b0;
            division_by_zero <= 1'b1;
        end
        else begin

            if (counter == 0) begin
                remainder <= dividend;
                quotient <= 32'b0;
                division_by_zero <= 1'b0;
            end

            else if (counter < 32) begin
                temp = {remainder[31], remainder} - (divisor << (31 - counter));
                
                if (temp[31] == 0) begin
                    remainder <= temp;
                    quotient[counter] <= 1'b1;
                end
                else begin
                    quotient[counter] <= 1'b0;
                end
                counter <= counter + 1;
            end
            
            hi_div <= remainder;
            lo_div <= quotient;
            counter <= 6'b0;

        end
    end
end

endmodule
