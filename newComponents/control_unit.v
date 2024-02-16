module control_unit(
    input wire clk,
    input wire reset,

    input wire [5:0] OPCODE,
    input wire [5:0] FUNCT,

    input wire Overflow, //checar se tá certo
    input wire DivZero,
    input wire GT,

    // multiplexadores 

    output reg [2:0] IorD,
    output reg WriteDataCtrl,
    output reg [2:0] RegDst,
    output reg [3:0] MemtoReg,
    output reg ReduceCtrl,
    output reg [1:0] ShiftCtrl,
    output reg [1:0] EntryCtrl,
    output reg ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg ignore,
    output reg DivMultCtrl,
    output reg [1:0] BranchControl,
    output reg [1:0] PCSource,

    // escrevendo em registradores

    output reg PCWriteCond, // checar
    output reg PCWrite,
    output reg MDRwrite,
    output reg ENDwrite,
    output reg IRwrite,
    output reg RegWrite, 
    output reg SHIPTOp3,
    output reg Awrite,
    output reg Bwrite,
    output reg HiCtrl,
    output reg LoCtrl,
    output reg ALUOutCtrl,
    output reg EPCControl,

    // ctrls de componentes

    output reg [1:0] WordCrackerCtrl,
    output reg MemRead_Write, 
    output reg [1:0] LoadControl,
    output reg [2:0] ALUOp,
    output reg DivCtrl,
    output reg MultCtrl,

    // reset

    output reg reset_out // olhar

);

// Opcodes Parameters

// R instructions
parameter R_OPCODE = 6'h0;
parameter ADD_FUNCT = 6'h20;
parameter AND_FUNCT = 6'h24;
parameter DIV_FUNCT = 6'h1a;
parameter MULT_FUNCT = 6'h18;
parameter JR_FUNCT = 6'h8;
parameter MFHI_FUNCT = 6'h10;
parameter MFLO_FUNCT = 6'h12;
parameter SLL_FUNCT = 6'h0;
parameter SLLV_FUNCT = 6'h4;
parameter SLT_FUNCT = 6'h2a;
parameter SRA_FUNCT = 6'h3;
parameter SRAV_FUNCT = 6'h7;
parameter SRL_FUNCT = 6'h2;
parameter SUB_FUNCT = 6'h22;
parameter BREAK_FUNCT = 6'hd;
parameter RTE_FUNCT = 6'h13;
parameter XCHG_FUNCT = 6'h5;


// I instructions
parameter ADDI = 6'h8;
parameter ADDIU = 6'h9;
parameter BEQ = 6'h4;
parameter BNE = 6'h5;
parameter BLE = 6'h6;
parameter BGT = 6'h7;
parameter SRAM = 6'h1;
parameter LB = 6'h20;
parameter LH = 6'h21;
parameter LUI = 6'hf;
parameter LW = 6'h23;
parameter SB = 6'h28;
parameter SH = 6'h29;
parameter SLTI = 6'ha;
parameter SW = 6'h2b;

// J instructions
parameter J = 6'h2; 
parameter JAL = 6'h3; 

// States Paramaters

parameter state_reset = 7'd0;
parameter state_fetch1 = 7'd1;
parameter state_fetch2 = 7'd2;
parameter state_decode = 7'd3;

parameter state_jump = 7'd4;
parameter state_jal1 = 7'd5;
parameter state_jal2 = 7'd6;
parameter state_jal3 = 7'd7;
parameter state_jal4 = 7'd8;
parameter state_jal5 = 7'd79;
parameter state_jal6 = 7'd80;
parameter wait1 = 7'd9;

parameter state_aluout = 7'd10; 

parameter state_sram1 = 7'd11; 
parameter state_sram2 = 7'd12;
parameter state_sram3 = 7'd13;
parameter state_sram4 = 7'd14;
parameter state_sram5 = 7'd15;

parameter state_RDBR = 7'd16;

parameter wait2 = 7'd17;

parameter state_break1 = 7'd18;
parameter state_break2 = 7'd19;
parameter state_break3 = 7'd20;

parameter state_rte = 7'd21;

parameter state_lui = 7'd22;

parameter state_srav = 7'd23;

parameter state_sllv = 7'd24;

parameter state_addi_slti1 = 7'd25;
parameter state_addi_slti2 = 7'd26;
parameter state_slti3 = 7'd27;
parameter state_addi_addiu3 = 7'd28;

parameter state_addiu1 = 7'd29;
parameter state_addiu2 = 7'd30;

parameter state_sra1 = 7'd31;
parameter state_sra2 = 7'd32;

parameter state_srl1 = 7'd33;
parameter state_srl2 = 7'd34;

parameter state_sll1 = 7'd35;
parameter state_sll2 = 7'd36;

parameter state_load1 = 7'd37;
parameter state_load2 = 7'd38;
parameter state_load3 = 7'd39;
parameter state_load4 = 7'd40;
parameter state_load5 = 7'd41;
parameter state_load6 = 7'd42;

parameter state_store1 = 7'd43;
parameter state_store2 = 7'd44;
parameter state_store3 = 7'd45;
parameter state_store4 = 7'd46;
parameter state_store5 = 7'd47;
parameter state_store6 = 7'd48;
parameter wait3 = 7'd49;

parameter state_ula = 7'd50;

parameter state_aluout2 = 7'd51;

parameter state_bgt = 7'd53;

parameter state_bne = 7'd54;

parameter state_ble = 7'd55;

parameter state_beq = 7'd56;

parameter state_div = 7'd57;
parameter wait4 = 7'd58;

parameter state_divzero1 = 7'd59;
parameter state_divzero2 = 7'd60;
parameter state_divzero3 = 7'd61;

parameter state_mult = 7'd62;
parameter wait5 = 7'd63;

parameter state_jr = 7'd64;
parameter wait6 = 7'd65;

parameter state_slt = 7'd66;

parameter state_add_sub_and = 7'd67;

parameter state_overflow1 = 7'd68;
parameter state_overflow2 = 7'd69;
parameter state_overflow3 = 7'd70;

parameter state_opcode_error1 = 7'd71;
parameter state_opcode_error2 = 7'd72;
parameter state_opcode_error3 = 7'd73;

parameter state_mflo = 7'd74;

parameter state_mfhi = 7'd75;

parameter state_xchg1 = 7'd76;
parameter state_xchg2 = 7'd77;
parameter state_xchg3 = 7'd78;

reg [6:0] counter;
reg [6:0] state;
reg [5:0] shiftmode;

initial begin
    reset_out = 1;
    state = state_reset;
end

always @(posedge clk) begin
    if (reset == 1'b1 || state == state_reset) begin
        // pegando o próximo estado
        state <= state_fetch1;
        // resetando os sinais
        IorD <= 3'b0;
        WriteDataCtrl <= 0;
        RegDst <= 3'b0;
        MemtoReg <= 4'b0;
        ReduceCtrl <= 0;
        ShiftCtrl <= 2'b0;
        EntryCtrl <= 2'b0;
        ALUSrcA <= 0;
        ALUSrcB <= 2'b0;
        ignore <= 0;
        DivMultCtrl <= 0;
        BranchControl <= 2'b0;
        PCSource <= 2'b0;
        PCWriteCond <= 0;
        PCWrite <= 0;
        MDRwrite <= 0;
        ENDwrite <= 0; 
        IRwrite <= 0;
        RegWrite <= 0;  
        SHIPTOp3 <= 0; 
        Awrite <= 0; 
        Bwrite <= 0; 
        HiCtrl <= 0; 
        LoCtrl <= 0; 
        ALUOutCtrl <= 0; 
        EPCControl <= 0; 
        WordCrackerCtrl <= 2'b0;
        MemRead_Write <= 0; 
        LoadControl <= 2'b0;
        ALUOp <= 3'b0;
        DivCtrl <= 0; 
        MultCtrl <= 0; 
        reset_out <= 0;
        // resetando a pilha
        RegDst <= 3'b010;
        MemtoReg <= 4'b0101;
        regwrite <= 1;
    end 
    else begin
        case(state)

            state_fetch1:begin
                IorD <= 3'b000;
                MemRead_Write <= 0;
                ALUSrcA <= 0;
                ALUsrcB <= 2'b01;
                ALUOp <= 3'b001;
                state <= state_fetch2;
            end
            state_fetch2:begin
                PCSource <= 2'b10;
                PCWrite <= 1;
                IRwrite <= 1;
                state <= state_decode;
            end
            state_decode: begin
                ALUSrcA <= 0;
                ALUSrcB <= 2'b11;
                ALUOp <= 3'b000;
                case (OPCODE)

                    default: begin
                        state <= state_aluout;
                    end

                    J: begin 
                        state <= state_jump;
                    end

                    JAL: begin
                        state <= state_jal1;
                    end

                endcase
            end
            state_jump: begin
                PCSource <= 2'b00;
                PCWrite <= 1;
                state <= state_fetch1;
            end
            state_jal1: begin
                ALUSrcA <= 0;
                ALUOp <= 3'b000;
                state <= state_jal2;
            end
            state_jal2: begin
                ALUCtrl <= 1;
                state <= state_jal3;
            end
            state_jal3: begin 
                ALUOutCtrl <= 1;
                RegDst <= 3'b001;
                MemtoReg <= 3'b000;
                RegWrite = 1;
                state <= state_jal4;
            end
            state_jal4: begin
                state <= state_jal5;
            end
            state_jal5: begin
                state <= state_jal6;
            end
            state_jal6: begin
                
                state <= wait1;
            end