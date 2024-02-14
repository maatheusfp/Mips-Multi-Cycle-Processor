module ENDFeature(
    input wire [31:0] PCtoEND;
    output reg [31:0] ENDtoEPC;
);
    always @(*) begin
            ENDtoEPC = PCtoEND;
    end

endmodule