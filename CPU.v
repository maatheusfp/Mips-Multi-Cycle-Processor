/* `include "newComponents/muxes/MemtoRegMUX.v"  // verificar se o import eh necessario (no de fred ta comentado)
`include "newComponents/muxes/aluToPc.v"
`include "newComponents/muxes/aToAlu.v"
`include "newComponents/muxes/aToReg_desloc.v"
`include "newComponents/muxes/bToAlu.v"
`include "newComponents/muxes/epcToPc.v"
`include "newComponents/muxes/hi.v"
`include "newComponents/muxes/irToReg.v"
`include "newComponents/muxes/lo.v"
`include "newComponents/muxes/mdaToSign32_5.v"
`include "newComponents/muxes/overflowToControl_unit.v"
`include "newComponents/muxes/pcToMem.v"
`include "newComponents/muxes/sign32_5ToReg_desloc.v"
`include "newComponents/muxes/wcToMem.v"
`include "newComponents/muxes/MemControl.v"

`include "componentesFornecidos/Registrador.vhd"
`include "componentesFornecidos/Memoria.vhd"
`include "componentesFornecidos/Instr_Reg.vhd"
`include "componentesFornecidos/Banco_reg.vhd"

`include "newComponents/modules/hi.v"
`include "newComponents/modules/lo.v"
`include "newComponents/modules/Load.v"
`include "newComponents/modules/shiftLeft2"
`include "newComponents/modules/singExtend_1x32.v"
`include "newComponents/modules/singExtend_8x32.v"
`include "newComponents/modules/singExtend_16x32.v"
`include "newComponents/modules/singExtend_32x5.v"
`include "newComponents/modules/word_cracker.v"
`include "newComponents/modules/mult.v"
`include "newComponents/modules/div.v"
`include "newComponents/modules/mdr.v" */

module CPU(
    input wire clock,
    input wire reset
);

// sinais de controle: 

        // 1 bit
    wire Reset;  // ainda nao achei funcionalidade
    wire PCWriteCond;
    wire PCWrite;
    wire MDRwrite;
    wire ENDwrite;
    wire IRwrite;
    wire RegWrite;
    wire ShiftOp3;
    wire Awrite;
    wire Bwrite;
    wire HiCtrl;
    wire LoCtrl;
    wire ALUOutCtrl;
    wire EPCControl;
    wire ignore;
    wire DivMultCtrl;
    wire MemRead_Write;
    wire DivCtrl;
    wire MultCtrl;
    wire reset_out;    
    wire Overflow;

    // 2 bits
    wire WriteDataCtrl;
    wire [1:0] ALUSrcB;
    wire [1:0] EntryCtrl;
    wire [1:0] WordCrackerCtrl;
    wire [1:0] BranchControl;
    wire [1:0] PCSource;
    wire [1:0] ShiftCtrl;
    wire [1:0] LoadControl;

    // 3 bits
    wire [2:0] IorD;
    wire [2:0] RegDst;
    wire [2:0] ALUOp;

    // 4 bits
    wire [3:0] MemtoReg;

    // Os proximos fios nomeei a partir de onde saem

    // Sai de PC
    wire PCOut [31:0];

    //Sai de Memory 
    wire MemOut [31:0];

    // IR
    wire IR31_26 [5:0];
    wire IR25_21 [4:0];
    wire IR20_16 [4:0];
    wire IR10_6 [4:0];
    wire IR15_0 [15:0];

    // Registradores - Falta a quantidade de bits
    wire ReadData1 [31:0];
    wire ReadData2 [31:0]; 

    // Registrador A
    wire RegA [15:0]; // nao tenho ctz da qtd de bits

    // Registrador B 
    wire RegB [15:0];

    // ULA
    wire ALU [31:0];
    wire ZeroULA;
    wire ZeroMux;
    wire LT; // Lower than
    wire GT; // greater than
    wire ET; // equal to
    wire Negative; 

    // MDROut
    wire MDROut [31:0];
    wire MDROut [7:0];

    // Word Cracker
    wire WordCrackerOUT [31:0]; // nao lembro qtos bits

    // Load Size
    wire LoadSize [31:0];

    //Registrador de Deslocamento
    wire RD [31:0];

    // DIV
    wire Div [31:0];

    // MULT
    wire Mult [31:0];

    // AluOut:
    wire ALUOut [31:0];

    // EPC: 
    wire EPC [31:0]; 

    // HI/LO:
    wire HI [15:0]; 
    wire LO [15:0]; 

    // SHIFTLEFTCIMA:
    wire SLOutCIMA [31:0];
    wire SLOutBAIXO [31:0];

    // END:
    wire ENDtoEPC [31:0]; // nao tenho ctz 

    // SignExtend(16 - 32):
    wire SE16_32 [31:0];

    // SignExtend (1 - 32);
    wire SE1_32 [31:0];

    // SignExtend (8-32);
    wire SE8_32 [31:0];

    // SignExtend (32 - 5);
    wire SE32_5 [4:0];

    // MUXES:
    // IorD:
    wire IorDMUXOut [31:0];

    // WriteDataCtrlMUX:
    wire WriteDataCtrlMUXOut [31:0] // nao tenho ctz;

    // RegDst;
    wire RegDstMUXOut [4:0];

    // MemtoReg;
    wire MemtoRegMUXOut [31:0]; 

    // ReduceCtrl:
    wire ReduceCtrlMUXOut [31:0];

    // ShiftCtrl:
    wire ShiftCtrlMUXOut [15:0];

    // EntryCtrl:
    wire EntryCtrlMUXOut [15:0];

    // Div/MultCtrl:
    wire DivCtrlMUXOut [31:0];
    wire MultCtrlMUXOut [31:0]; 

    // ALUSrcA/B:
    wire ALUSrcAMUXOut [31:0];
    wire ALUSrcBMUXOut [31:0];

    // PCSource:
    wire PCSourceMUXOut [31:0];

    // BranchControl:
    wire BranchCtrlMUXOut;

    // MemControl
    wire MemControlMUXOut [31:0];

    // Ignore:
    wire IgnoreMUXOut; 

    // Registradores padrão
    wire [31:0] reg253; // check how many bits this register has
    wire [31:0] reg254;
    wire [31:0] reg255;
    wire [31:0] reg31;
    wire [31:0] reg29;
    wire [31:0] reg227;
    wire [31:0] reg4;
    wire [31:0] reg16;

    //saida das portas logicas
    wire WriteCondANDtoPCWriteOR; 
    wire PCWriteORtoPC;
    wire LTGTORtoBranchMUX;
    wire LTZerotoBranchMUX;

    // portas logicas
    and(BranchCtrlMUXOut, PCWriteCond, WriteCondANDtoPCWriteOR); // (input, input, output)
    or(WriteCondANDtoPCWriteOR, PCWrite, PCWriteORtoPC);
    or(LT,GT, LTGTORtoBranchMUX);
    or(LT, ZeroULA, LTZerotoBranchMUX);

    Registrador PC(
        clock,
        reset, // reset minusculo
        PCWriteORtoPC,
        PCSourceMUXOut,
        PCOut
    );

    Registrador A(
        clock,
        reset,
        Awrite,
        ReadData1,
        RegA
    );

    Registrador B(
        clock,
        reset,
        Bwrite,
        ReadData2,
        RegB
    );

    Registrador ALUOutReg(
        clock,
        reset,
        ALUOutCtrl,
        ALU,
        ALUOut
    );

    MDR MDRReg(
        MemOut,
        MDRWrite,
        MDROut,
        MDROutByte
    );

    /* Registrador MDRReg(  // em uma das saídas do mdr ele envia apenas 8 bits, verificar como faz isso
        clock,
        reset,
        MDRwrite,
        MemOut,
        MDROut
    ); */

    Registrador EPCReg(
        clock,
        reset,
        EPCControl,
        ENDtoEPC,
        EPC
    );

    Registrador ENDReg(
        clock, 
        reset,
        ENDwrite,
        PCOut,
        ENDtoEPC
    );

    Memoria MEM_(
        clock,
        reset,
        MemRead_Write,
        MemControlMUXOut, 
        MemOut
    );

    Instr_Reg IR_(
        clock,
        reset,
        IRwrite,
        MemOut,
        IR31_26,
        IR25_21,
        IR20_16,
        IR15_0[10:6]  //Fica faltando o 10_6 pq nao tem no IR pronto
    );

    Banco_reg BR(
        clock,
        reset,
        RegWrite,
        IR25_21,
        IR20_16,
        RegDstMUXOut,
        MemtoRegMUXOut,
        ReadData1,
        ReadData2
    );

  // muxes
    MemtoRegMUX MEMTOREGMUX(
        RD,
        SE1_32,
        MDROut,
        ALUOut,
        LO,
        HI,
        reg227,
        LoadSize,
        MemtoReg,
        MemtoRegMUXOut
    );
    
    aluToPc BranchCtrlMUX(
        ZeroULA,
        GT,
        LT,
        LTGTORtoBranchMUX,
        BranchCtrl,
        BranchCtrlMUXOut
    );

    aToAlu ALUSrcAMUX(
        RegA,
        PCOut,
        ALUSrcA,
        ALUSrcAMUXOut
    );

    aToReg_desloc EntryCtrlMUX(
        RegA,
        RegB,
        IR15_0,
        EntryCtrl
        EntryCtrlMUXOut
    );

    bToAlu ALUSrcBMUX(
        RegB,
        reg4, // valor 4
        SE16_32,
        SLOutBAIXO,
        ALUsrcB,
        ALUSrcAMUXOut
    ); 

    epcToPc PCSourceMUX(
        SLOutCIMA,
        EPC,
        ALUOut,
        SE8_32,
        PCSource,
        PCSourceMUXOut
    );

    hi DivCtrlMUX(
        Div,
        Mult,
        divCtrl,
        DivCtrlMUXOut
    );

    irToReg RegDstMUX(
        reg31,
        reg29,
        IR15_0,
        IR20_16,
        IR25_21,
        RegDst,
        RegDstMUXOut
    );

    lo MultCtrlMUX(
        Div,
        Mult,
        multCtrl,
        MultCtrlMUXOut
    );

    mdaToSign32_5 ReduceCtrlMUX(
        MDROut,
        RegB,
        RdcCtrl,
        ReduceCtrlMUXOut
    );

    overflowToControl_unit IgnoreMUX(
        ZeroMux,
        Overflow,
        ignore,
        IgnoreMUXOut
    );

    pcToMem IorDMUX(
        AluOut,
        PCOut,
        reg253,
        reg254,
        reg255,
        RD,
        IorD,
        IorDMUXOut
    );

    sign32_5ToReg_desloc ShiftCtrlMUX(
        se32_5,
        reg16,
        IR10_6,
        ShiftCtrl,
        ShiftCtrlMUXOut
    );

    wcToMem WriteDataCtrlMUX(
        WordCrackerOUT,
        RegB,
        WriteDataCtrl,
        WriteDataCtrlMUXOutj
    );

    MemControl MemControlMUX(
        IorDMUXOut,
        WriteDataCtrlMUXOut,
        MemWrite_Read,
        MemControlMUXOut
    );

    hi HIReg(
        DivCtrlMUXOut,
        HiCtrl,
        HI
    );

    lo LOReg(
        MultCtrlMUXOut,
        LoCtrl,
        LO
    );

    Load LoadSizeReg(
        MDROut,
        LoadControl,
        LoadSize
    );

    shiftLeft2 ShifLeftCIMA( // na parte de cima do circuito
        IR15_0,
        SLOutCIMA,
    );

    shiftLeft2 ShifLeftBAIXO(
        IR15_0,
        SLOutBAIXO
    );

    signExtend_1x32 SE1_32Reg(
        LT,
        SE1_32
    );

    singExtend_8x32 SE8_32Reg(
        MDROut, // mdr aqui eh so 8 bits
        SE8_32
    );

    singExtend_16x32 SE16_32Reg(
        IR15_0,
        SE16_32
    );

    singExtend_32x5 SE32_5Reg(
        ReduceCtrlMUXOut,
        SE32_5
    );

    WordCracker WC(
        RegB,
        MDROut,
        WordCrackerCtrl,
        WordCrackerOUT
    );

    /* mult multReg(
        clock,
        reset,
        RegA,
        RegB,
    ) */

    control_unit Control_Unit(
        .clk(clock),
        .reset(reset),

        .OPCODE(IR31_26),
        .FUNCT(IR15_0[5:0]),

        .Overflow(Overflow), // nao entendi bem a funcionalidade
        /* .DivZero(),
        .GT() */

        .IorD(IorD),
        .WriteDataCtrl(WriteDataCtrl),
        .RegDst(RegDst),
        .MemtoReg(MemtoReg),
        .ReduceCtrl(ReduceCtrl),
        .ShiftCtrl(ShiftCtrl),
        .EntryCtrl(EntryCtrl),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ignore(ignore),
        .DivMultCtrl(DivMultCtrl),
        .BranchControl(BranchControl),
        .PCSource(PCSource),

        .PCWriteCond(PCWriteCond),
        .PCWrite(PCWrite),
        .MDRWrite(MDRWrite),
        .ENDwrite(ENDwrite),
        .IRwrite(IRwrite),
        .RegWrite(RegWrite),
        .ShiftOp3(ShiftOp3),
        .Awrite(Awrite),
        .Bwrite(Bwrite),
        .HiCtrl(HiCtrl),
        .LoCtrl(LoCtrl),
        .ALUOutCtrl(ALUOutCtrl),
        .EPCControl(EPCControl),

        .WordCrackerCtrl(WordCrackerCtrl),
        .MemRead_Write(MemRead_Write),
        .LoadControl(LoadControl),
        .ALUOp(ALUOp),
        .DivCtrl(DivCtrl),
        .MultCtrl(MultCtrl)

        .reset_out(reset_out)
    );

endmodule 