module EPC(
    input wire [31:0] ENDtoEPC, 
    input wire EPCControl; 
    output reg [31:0] EPCtoPCSourceMUX;
);

    always @(*) begin
        if (EPCControl == 1){
            EPCtoPCSourceMUX = ENDtoEPC;
        }
        else {
            EPCtoPCSourceMUX = 16'b0;
        }
    end
    
endmodule