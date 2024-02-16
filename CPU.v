`include "newComponents/muxes/MemtoRegMUX.v"
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

module CPU(
    input wire clock,
    input wire reset
);

// sinais de controle: 

    // Reset
    wire Reset;

    // sinais de escrita
    wire PCWriteCond;
    wire PCWrite;
    wire MemWrite_Read;  // lida = 0, escrita = 1
    wire IRwrite; 
    wire RegWrite; 

    // sinais de escolha de fonte de dados
    wire PCSource [3:0];
    wire ALUSrcA [1:0];
    wire ALUsrcB [1:0];
    wire IorD [5:0];
    wire RegDst [2:0];
    wire MemtoReg [3:0];
    wire divCtrl [1:0];
    wire multCtrl [1:0];
    wire ShiftCtrl [1:0];
    wire ignore [1:0];
    wire BranchCtrl [1:0];

    // sinais Ctrl
    wire SHIPTOp3 [1:0];
    wire LoadControl;
    wire BranchControl [3:0];
    wire EPCControl;
    wire ALUOp;
    wire WriteDataCtrl [1:0];
    wire WordCrackerCtrl;
    wire ShiftCtrl [2:0];
    wire EntryCtrl [2:0];
    wire ReduceCtrl [2:0];
    wire HiCtrl;
    wire LoCtrl;
    wire ALUOutCtrl;
    // div e mult ctrl tem em dois lugares (talvez dois diferentes para o mux?)

    // Loads
    wire AB_Load;
    wire MDR_Load;
    wire END_Load;

    // excecoes
    wire Ignore [1:0];
    wire Overflow;

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
    wire Zero;
    wire LT; // Lower than
    wire GT; // greater than
    wire ET; // equal to
    wire Negative; 

    // MDR
    wire MDR [31:0];

    // Word Cracker
    wire WordCracker; // nao lembro qtos bits

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

    // SHIFTLEFT:
    wire SLOut [31:0];

    // END:
    wire ENDtoEPC [31:0]; // nao tenho ctz 

    // SignExtend(16 - 32):
    wire SE16_32 [31:0];

    // SignExtend (1 - 32);
    wire SE1_32 [31:0];

    // SignExtend (8-32);
    wire SE8_32 [31:0];

    // SignExtend (32 - 5);
    wire se32_5 [4:0] ;

    ------------------------------
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
    or(LT, Zero, LTZerotoBranchMUX);

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
        AB_Load,
        ReadData1,
        RegA
    );

    Registrador B(
        clock,
        reset,
        AB_Load,
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

    Registrador MDRReg(  // em uma das saídas do mdr ele envia apenas 8 bits, verificar como faze isso
        clock,
        reset,
        MDR_Load,
        MemOut,
        MDR
    );

    Registrador EPC(
        clock,
        reset,
        EPCControl,
        ENDtoEPC,
        EPC
    );

    Registrador ENDReg(
        clock, 
        reset,
        END_Load,
        PCOut,
        ENDtoEPC
    );

    Memoria MEM_(
        clock,
        reset,
        MemWrite_Read,
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
        IR15_0  //Fica faltando o 10_6 pq nao tem no IR pronto
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
        MDR,
        ALUOut,
        LO,
        HI,
        reg227,
        LoadSize,
        MemtoReg,
        RegDstMUXOut
    );
    
    aluToPc BranchCtrlMUX(
        zero,
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
        reg4,
        SE16_32,
        SLOut,
        ALUsrcB,
        ALUSrcAMUXOut
    ); 

    epcToPc PCSourceMUX(
        SLOut,
        EPC,
        ALUOut,
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
        MDR,
        RegB,
        RdcCtrl,
        ReduceCtrlMUXOut
    );

    overflowToControl_unit IgnoreMUX(
        zero,
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
        WordCracker,
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

