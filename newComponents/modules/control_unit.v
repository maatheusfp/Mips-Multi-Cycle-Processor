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
    output reg ShiftOp3,
    output reg Awrite,
    output reg Bwrite,
    output reg HiCtrl,
    output reg LoCtrl,
    output reg ALUOutCtrl,
    output reg EPCControl,

    // ctrls de componentes

    output reg [1:0] WordCrackerCtrl, // 00 = word, 01 = half , 10 = byte
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
parameter state_sram6 = 7'd92;
parameter state_sram7 = 7'd93;

parameter state_RDBR = 7'd16;
parameter state_RTBR = 7'd99;

parameter wait2 = 7'd17;

parameter state_break1 = 7'd18;
parameter state_break2 = 7'd19;
parameter state_break3 = 7'd20;

parameter state_rte = 7'd21;

parameter state_lui = 7'd22;

parameter state_srav = 7'd23;

parameter state_sllv = 7'd24;

parameter state_addi1 = 7'd25;
parameter state_addi2_addiu2 = 7'd26;
parameter state_slti1 = 7'd87;
parameter state_slti2 = 7'd88; 
parameter state_slti3 = 7'd27;
parameter state_addiu1 = 7'd28;
parameter state_addi3_addiu3 = 7'd89

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
parameter state_lw = 7'd41;
parameter state_lb = 7'd94;
parameter state_lh = 7'd95;
parameter state_load6 = 7'd42;

parameter state_sw = 7'd43;  // 1, 2, 3, 4, 5, 6, separa, escrita na memoria 
parameter state_sh = 7'd49;
parameter state_sb = 7'd96;

parameter state_store1 = 7'd97;
parameter state_store2 = 7'd44;
parameter state_store3 = 7'd45;
parameter state_store4 = 7'd46;
parameter state_store5 = 7'd47;
parameter state_store6 = 7'd48;
parameter state_store8 = 7'd98;


parameter state_ula = 7'd50;

parameter state_aluout2 = 7'd51;
parameter state_aluout3 = 7'd84;

parameter state_branch1 = 7'd90;
parameter state_branch2 = 7'd91;

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
parameter state_jr2 = 7'd85;
parameter wait6 = 7'd65;

parameter state_slt = 7'd66;
parameter state_slt2 = 7'd86;

parameter state_and_sub_and = 7'd67; // separou state_add_sub_and pq cada um tem um aluOp diferente
parameter state_add = 7'd81;
parameter state_sub = 7'd82;
parameter state_and = 7'd83;


parameter state_overflow1 = 7'd68;
parameter state_overflow2 = 7'd69;
parameter state_overflow3 = 7'd70;

parameter state_opcode_error1 = 7'd71; // opcode inxeistente?
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
        ShiftOp3 <= 0; 
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

            state_fetch1:begin // valor de pc + leitura de memory + calculo de (pc + 4)
                IorD <= 3'b000;
                MemRead_Write <= 0;
                ALUSrcA <= 0;
                ALUsrcB <= 2'b01;
                ALUOp <= 3'b001;
                state <= state_fetch2;
            end
            state_fetch2:begin // sai da memoria e escreve no IR
                PCSource <= 2'b10;
                PCWrite <= 1;
                IRwrite <= 1;
                state <= state_decode;
            end
            state_decode: begin // leitura, decodificação e escrita
                ALUSrcA <= 0;
                ALUSrcB <= 2'b11;
                ALUOp <= 3'b000; // carregamento -> essa operacao tem que mudar pra executar outra instrucao, como fazer essa verificacao antes de mandar pro estado de aluout?
                Awrite <= 1;
                Bwrite <= 1;
                case (OPCODE)

                    default: begin
                        state <= state_aluout; // coloca em aluOut
                    end

                    J: begin 
                        state <= state_jump; // pula para o estado de jump
                    end

                    JAL: begin
                        state <= state_jal1; // pula para o estado de jal
                    end

                endcase
            end
            state_jump: begin // ok
                PCSource <= 2'b00;
                PCWrite <= 1;
                state <= state_fetch1;
            end
            state_jal1: begin // ok
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
            
            state_aluout: begin // ver aluOut 2
                ALUOutCtrl <= 1;

                case(OPCODE)
                    default: begin
                        state <= state_opcode_error1;
                    end
                    R_OPCODE: begin
                        case(FUNCT)

                            // intruções tipo R
                            ADD_FUNCT: begin
                                state <= state_add; 
                            end
                            AND_FUNCT: begin
                                state <= state_and; 
                            end
                            DIV_FUNCT: begin
                                state <= state_div; 
                            end
                            MULT_FUNCT: begin
                                state <= state_mult; 
                            end
                            JR_FUNCT: begin
                                state <= state_jr; 
                            end
                            MFHI_FUNCT: begin
                                state <= state_mfhi; 
                            end
                            MFLO_FUNCT: begin
                                state <= state_mflo; 
                            end
                            SLL_FUNCT: begin
                                state <= state_sll1; 
                            end
                            SLLV_FUNCT: begin
                                state <= state_sllv; 
                            end
                            SLT_FUNCT: begin
                                state <= state_slt; 
                            end
                            SRA_FUNCT: begin
                                state <= state_sra1; 
                            end
                            SRAV_FUNCT: begin
                                state <= state_srav; 
                            end
                            SRL_FUNCT: begin
                                state <= state_srl1; 
                            end
                            SUB_FUNCT: begin
                                state <= state_sub; 
                            end
                            BREAK_FUNCT: begin
                                state <= state_break1; 
                            end
                            RTE_FUNCT: begin
                                state <= state_rte; 
                            end
                            XCHG_FUNCT: begin
                                state <= state_xchg1; 
                            end
                        endcase
                    end
                    // instruções tipo I
                    ADDI: begin
                        state <= state_addi1;
                    end
                    ADDIU: begin
                        state <= state_addiu1;
                    end
                    BEQ: begin
                        state <= state_branch1;
                    end
                    BNE: begin
                        state <= state_branch1;
                    end
                    BLE: begin
                        state <= state_branch1;
                    end
                    BGT: begin
                        state <= state_branch1;
                    end
                    SRAM: begin
                        state <= state_store1;
                    end
                    LB: begin
                        state <= state_load1;
                    end
                    LH: begin
                        state <= state_load1;
                    end
                    LUI: begin
                        state <= state_lui;
                    end
                    LW: begin
                        state <= state_load1;
                    end
                    SB: begin
                        state <= state_store1;
                    end
                    SH: begin
                        state <= state_store1;
                    end
                    SLTI: begin
                        state <= state_slti1;
                    end
                    SW: begin
                        state <= state_store1;
                    end
                endcase               
            end 
            state_add: begin // operação com  ULA
                ALUSrcA <= 1;
                ALUSrcB <= 2'b00;
                ALUOp <= 3'b001;
                state <= state_aluout2;
            end
            state_and: begin
                ALUSrcA <= 1;
                ALUSrcB <= 2'b00;
                ALUOp <= 3'b011;
                state <= state_aluout2;
            end
            state_sub: begin
                ALUSrcA <= 1;
                ALUSrcB <= 2'b00;
                ALUOp <= 3'b010;
                state <= state_aluout2;
            end
            // checar se houve overflow e então ir para o estado de overflow, se não, ir para o estado de escrita (state_add_sub_and)
            state_aluout2: begin // colocando em ALUOut
                ALUOutCtrl <= 1;
            end
            state_add_sub_and: begin
                RegDst = 3'b011;
                MemtoReg = 4'b0000; // 000 001 010 011 100 101 110 111
                RegWrite = 1;
                state <= wait1;
            end
            wait1: begin
                state <= state_fetch1; // checar se ele realiza um ciclo antes de mudar pra fetch1
            end


            // state_div: begin
            //     DivCtrl <= 1;
            //     state <= wait1;
            // end
            // state_mult: begin
            //     MultCtrl <= 1;
            //     state <= wait1;
            // end

            state_jr: begin // operacao com a ULA
                ALUSrcA <= 1;
                ALUSrcB <= 2'b00;
                ALUOp <= 3'b000; // carregamento
                state <= wait1;
            end

            state_aluout3: begin // colocando em ALUOut
                ALUOutCtrl <= 1;
            end

            state_jr2: begin // atualizacao do pc
                PCSource <= 2'b10;
                PCWrite <= 1;
                state <= wait1;
            end

            // todos a partir de agora ja passaram pelo estado 4 (colocando em aluOUt)
            state_mfhi: begin // carregamento: hi -> rd
                RegDst <= 3'b011;
                MemtoReg <= 4'b0110;
                RegWrite <= 1;
                state <= wait1;
            end
            state_mflo: begin // carregamento: lo -> rd
                RegDst <= 3'b011;
                MemtoReg <= 4'b1000;
                RegWrite <= 1;
                state <= wait1;
            end

            state_sll1: begin // load shamt no registrador de deslocamento
                ShiftCtrl <= 2'b10;
                EntryCtrl <= 2'b01;
                ShiftOp3 <= 3'b001; // load
                state <= state_sll2;
            end

            state_sll2: begin // deslocamento
                ShiftCtrl <= 2'b10;
                EntryCtrl <= 2'b01;
                ShiftOp3 <= 3'b010; // shift
                state <= state_RDBR;
            end

            state_sllv: begin // leva o q vem de A e B para o RD
                EntryCtrl <= 2'b10;
                ReduceCtrl <= 0;
                ShiftCtrl <= 2'b00;
                ShiftOp3 <= 3'b010; 
                state <= state_RDBR;
            end

            // slt
            state_slt: begin // operacao com a ULA
                ALUSrcA <= 1;
                ALUSrcB <= 2'b00;
                ALUOp <= 3'b111;
                state <= state_slt2;
            end

            state_slt2: begin
                RegDst <= 3'b011;
                RegWrite <= 1;
                MemtoReg <= 4'b0100;
                state <= wait1;
            end 

            state_sra1: begin
                ShiftCtrl <= 2'b10;
                EntryCtrl <= 2'b01;
                ShiftOp3 <= 3'b001;
                state <= state_sra2;
            end

            state_sra2: begin
                ShiftCtrl <= 2'b10;
                EntryCtrl <= 2'b01;
                ShiftOp3 <= 3'b100;
                state <= state_RDBR;
            end

            state_srav: begin
                ShiftCtrl <= 2'b00;
                ReduceCtrl <= 0;
                EntryCtrl <= 2'b10;
                ShiftOp3 <= 3'b100;
                state <= state_RDBR;
            end

            state_srl1: begin 
                ShiftCtrl <= 2'b10;
                EntryCtrl <= 2'b01;
                ShiftOp3 <= 3'b001;
                state <= state_srl2;
            end 

            state_srl2: begin
                ShiftCtrl <= 2'b10;
                EntryCtrl <= 2'b01;
                ShiftOp3 <= 3'011;
                state <= state_RDBR;
            end

            state_break1: begin 
                ALUSrcA <= 0;
                ALUSrcB <= 2'b01;
                ALUOp <= 3'b010;
                state <= state_break2;
            end

            state_break2: begin 
                ALUOutCtrl <= 1;
                state <= state_break3;
            end 

            state_break3: begin
                PCWrite <= 1;
                PCSource <= 2'b10;
                state <= state_fetch1;
            end

            state_rte: begin
                PCSource <= 2'b01;
                PCWrite <= 1;
                state <= state_fetch1;
            end

            state_xchg1: begin 
                RegDst <= 3'b100;
                MemtoReg <= 4'b0111;
                RegWrite <= 1;
                ALUSrcA <= 1;
                ALUOp <= 3'b000;
                state <= state_xchg3;
            end 

            state_xchg2: begin 
                ALUOutCtrl <= 1;
                state_xchg3;
            end

            state_xchg3: begin
                RegDst <= 3'b000;
                MemtoReg <= 4'b0000;
                RegWrite <= 1;
                state <= state_fetch1;
            end

            state_addi1: begin 
                ALUSrcA <= 1;
                ALUSrcB <= 2'b10;
                ALUOp <= 3'b001;
                state <= state_addi2_addiu2;
            
            end

            state_addi2_addiu2: begin
                ALUOutCtrl <= 1;
                state <= state_addi3_addiu3;
            end

            state_addi3_addiu3: begin 
                RegDst <= 2'b00;
                RegWrite <= 1;
                MemtoReg <= 4'b0000;
                state <= state_fetch1;
            end

            state_addiu1: begin
                ALUSrcA <= 1;
                ALUSrcB <= 2'b10;
                ALUOp <= 3'b001;
                ignore <= 1;
                state <= state_addi2_addiu2;
            end 

            state_branch1: begin
                ALUSrcA <= 1;
                ALUSrcB <= 2'b00;
                ALUOp <= 3'b111;
                state <= state_branch2;
            end

            state_branch2: begin
                ALUOutCtrl <= 1;
                case(OPCODE)
                    BEQ: begin
                        state <= state_beq;
                    end
                    BNE: begin
                        state <= state_bne;
                    end
                    BLE: begin
                        state <= state_ble;
                    end
                    BGT: begin
                        state <= state_bgt;
                    end
                endcase
            end

            state_beq: begin
                PCSource <= 2'10;
                PCWriteCond <= 1;
                BranchControl <= 2'b10;
                state <= state_fetch1;
            end

            state_bne: begin 
                PCSource <= 2'10;
                PCWriteCond <= 1;
                BranchControl <= 2'b00;
                state <= state_fetch1;
            end

            state_ble: begin
                PCSource <= 2'10;
                PCWriteCond <= 1;
                BranchControl <= 2'b01;
                state <= state_fetch1;
            end

            state_bgt: begin
                PCSource <= 2'10;
                PCWriteCond <= 1;
                BranchControl <= 2'b00;
                state <= state_fetch1;
            end
            
            state_sram1: begin
                ALUSrcA <= 1;
                ALUSrcB <= 2'b10;
                ALUOp <= 3'b001;
                state <= state_sram1;
            end

            state_sram2: begin
                ALUOutCtrl <= 1;
                state <= state_sram3;
            end

            state_sram3: begin
                MemRead_Write <= 0;
                IorD <= 3'b101;
                state <= state_sram4;
            end

            state_sram4: begin
                state <= state_sram5;
            end

            state_sram5: begin
                state <= state_sram6;
            end

            state_sram6: begin
                MDRwrite <= 1;
                state <= state_sram7;
            end

            state_sram7: begin
                ReduceCtrl <= 1;
                ShiftCtrl <= 2'b00;
                EntryCtrl <= 2'b01;
                ShiftOp3 <= 3'b100;
                state <= state_RTBR;
            end

            state_load1: begin
                ALUSrcA <= 1;
                ALUSrcB <= 2'b10;
                ALUOp <= 3'b001;
            end

            state_load2: begin 
                ALUOutCtrl <= 1;
                state <= state_load3;
            end

            state_load3: begin
                IorD <= 3'b101;
                MemWrite_Read <= 0;
                state <= state_load4;
            end
            
            state_load4: begin
                MDR <= 1;
                case(OPCODE)
                    LW: begin
                        state <= state_lw;
                    end
                    LH: begin
                        state <= state_lh;
                    end
                    LB: begin
                        state <= state_lb.;
                    end
                endcase
            end

            state_lw: begin 
                MemtoReg <= 4'b0001;
                LoadControl <= 2'b00;
                state <= state_load6;
            end

            state_lb: begin 
                MemtoReg <= 4'b0001;
                LoadControl <= 2'b10;
                state <= state_load6;
            end

            state_lh: begin 
                MemtoReg <= 4'b0001;
                LoadControl <= 2'b01;
                state <= state_load6;
            end
            
            state_load6: begin 
                RegDst <= 2'b00;
                RegWrite <= 1;
                state <= state_fetch1;
            end

            state_lui: begin 
                EntryCtrl <= 2'b00;
                ShiftCtrl <= 2'b01;
                ShiftOp3 <= 3'010;
                state <= state_RTBR;
            end

            state_slti1: begin 
                ALUSrcA <= 1;
                ALUSrcB <= 2'b10;
                ALUOp <= 3'b111;
                state <= state_slti2;
            end

            state_slti2: begin
                ALUOutCtrl <= 1;
                state <= state_slti3;
            end

            state_slti3: begin 
                RegDst <= 2'b00;
                RegWrite <= 1;
                MemtoReg <= 4'b0100;
                state <= state_fetch1;
            end 

            state_store1: begin
                ALUSrcA <= 1;
                ALUSrcB <= 2'b10;
                ALUOp  <= 3'001;
                state <= state_store2;
            end
            
            state_store2: begin
                ALUOutCtrl <= 1;
                state <= state_store3;
            end

            state_store3: begin
                MemWrite_Read <= 0;
                IorD <= 3'b101;
                state <= state_store4;
            end

            state_store4: begin
                state <= state_store5;
            end

            state_store5: begin 
                state <= state_store6;
            end

            state_store6: begin 
                MDRwrite <= 1;
                case(OPCODE)
                    SW: begin
                        state <= state_sw;
                    end
                    SB: begin 
                        state <= state_sb;
                    end
                    SH: begin 
                        state <= state_sh;
                    end
                endcase
            end

            state_sw: begin
                WordCrackerCtrl <= 00;
                state <= state_store8;
            end

            state_sb: begin
                WordCrackerCtrl <= 10;
                state <= state_store8;
            end

            state_sh: begin
                WordCrackerCtrl <= 01;
                state <= state_store8;
            end

            state_store8: begin 
                WriteDataCtrl <= 1;
                MemRead_Write <= 1;
                state <= wait1;
            end 

            state_RDBR: begin 
                MemtoReg <= 4'b0011;
                RegDst <= 3'b011;
                RegWrite <= 1;
                state <= wait1;
            end

            state_RTBR: begin 
                MemtoReg <= 4'b0011;
                RegDst <= 3'b000;
                RegWrite <= 1;
                state <= wait1;
            end

            wait1: begin 
                state <= state_fetch1;
            end
            







                









            




            
            


            