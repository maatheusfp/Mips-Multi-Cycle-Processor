module EPC(
    input wire [31:0] ENDtoEPC, 
    input wire EPCControl,
    output reg [31:0] EPCtoPCSourceMUX
);

    always @(EPCControl or ENDtoEPC) begin
        if (EPCControl == 1) begin
            EPCtoPCSourceMUX <= ENDtoEPC;
        end
        else begin
            EPCtoPCSourceMUX <= 32'b0;
        end
    end

endmodule
