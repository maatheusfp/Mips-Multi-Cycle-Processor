module mult (
    input wire clock,
    input wire reset,
    input wire signed [31:0] multiplicant,
    input wire signed [31:0] multiplier,
    output reg signed [31:0] hi_mult,
    output reg signed [31:0] lo_mult
);

reg signed [31:0] A, Q, M;
reg [1:0] Q_1;
reg [5:0] count;
reg [1:0] booth_sel;
reg signed [31:0] shift_value; 

always @(posedge clock or posedge reset) begin
    if (reset) begin
        A <= 32'b0;
        Q <= 32'b0;
        M <= 32'b0;
        Q_1 <= 2'b0;
        count <= 6'b0;
    end
    else begin
        if (count == 0) begin
            A <= 32'b0;
            M <= multiplier;
            Q <= multiplicant;
            count <= count + 1;
        end
        else if (count < 33) begin
            booth_sel[1] = Q[0] ^ Q_1[1];
            booth_sel[0] = Q[0] ^ Q_1[0];
   
            shift_value = {M, 1'b0};

            if (booth_sel == 2'b01) begin
                A <= A - shift_value;
            end
            else if (booth_sel == 2'b10) begin
                A <= A + shift_value;
            end

            Q_1 <= Q[1:0];
            Q <= {Q[30:1], A[0]}; // Correção aqui
            A <= {A[30:0], A[31]};
            count <= count + 1;

        end        
    end
end

assign hi_mult = A;
assign lo_mult = Q;

endmodule

`timescale 1ns/1ns

module mult_tb;

    // Inputs
    reg signed [31:0] a;
    reg signed [31:0] b;

    // Outputs
    wire signed [31:0] result;

    // Instantiate the module under test
    mult dut (
        .clock(),
        .reset(),
        .multiplicant(a),
        .multiplier(b),
        .hi_mult(),
        .lo_mult()
    );

    // Clock generation
    reg clk;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        clk = 0;
        a = 8;
        b = 5;

        #10;

        $display("Result: %d", result);

        #10;
        $finish;
    end

endmodule
