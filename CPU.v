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
    wire ALUSrcA;

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
    // PCOut:
    wire [31:0] PCOut;

    // MemOut:
    wire [31:0] MemOut;

    // IR:
    wire [5:0] IR31_26;
    wire [4:0] IR25_21;
    wire [4:0] IR20_16;
    wire [4:0] IR10_6;
    wire [15:0] IR15_0;

    // Registradores - Falta a quantidade de bits
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // Registrador A
    wire [31:0] RegA; // nao tenho ctz da qtd de bits

    // Registrador B 
    wire [31:0] RegB;

    // ULA
    wire [31:0] ALU;
    wire ZeroULA;
    wire LT; // Lower than
    wire GT; // greater than
    wire ET; // equal to
    wire Negative; 

    // MDROut
    wire [31:0] MDROut;

    // Word Cracker
    wire [31:0] WordCrackerOUT; // nao lembro qtos bits

    // Load Size
    wire [31:0] LoadSize;

    //Registrador de Deslocamento
    wire [31:0] RD;

    // DIV
    wire [31:0] Div;

    // MULT
    wire [31:0] Mult;

    // AluOut:
    wire [31:0] ALUOut;

    // EPC: 
    wire [31:0] EPC; 

    // HI/LO:
    wire [15:0] HI; 
    wire [15:0] LO; 

    // SHIFTLEFTCIMA:
    wire [31:0] SLOutCIMA;
    wire [31:0] SLOutBAIXO;

    // END:
    wire [31:0] ENDtoEPC; // nao tenho ctz 

    // SignExtend(16 - 32):
    wire [31:0] SE16_32;

    // SignExtend (1 - 32);
    wire [31:0] SE1_32;

    // SignExtend (8-32);
    wire [31:0] SE8_32;

    // SignExtend (32 - 5);
    wire [4:0] SE32_5;

    // MUXES:
    // IorD:
    wire [31:0] IorDMUXOut;

    // WriteDataCtrlMUX:
    wire [31:0] WriteDataCtrlMUXOut; // nao tenho ctz;

    // RegDst;
    wire [4:0] RegDstMUXOut;

    // MemtoReg;
    wire [31:0] MemtoRegMUXOut; 

    // ReduceCtrl:
    wire [31:0] ReduceCtrlMUXOut;

    // ShiftCtrl:
    wire [15:0] ShiftCtrlMUXOut;

    // EntryCtrl:
    wire [15:0] EntryCtrlMUXOut;

    // Div/MultCtrl:
    wire [31:0] HiCtrlMUXOut;
    wire [31:0] LOCtrlMUXOut; 

    // ALUSrcA/B:
    wire [31:0] ALUSrcAMUXOut;
    wire [31:0] ALUSrcBMUXOut;

    // PCSource:
    wire [31:0] PCSourceMUXOut;

    // BranchControl:
    wire BranchCtrlMUXOut;

    // MemControl
    wire [31:0] MemControlMUXOut;

    // Ignore:
    wire IgnoreMUXOut; 

    // Registradores padrão
    wire [31:0] reg253; // check how many bits this register has
    wire [31:0] reg254;
    wire [31:0] reg255;
    wire [31:0] reg31;
    wire [31:0] reg29;
    wire [31:0] reg227;
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

    Registrador MDRReg(
        clock,
        reset,
        MDRwrite,
        MemOut,
        MDROut
    );

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
        IorDMUXOut,
        clock,
        MemRead_Write,
        WriteDataCtrlMUXOut, 
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
        ALUOut,
        LoadSize,
        MDROut,
        RD,
        SE1_32,
        reg227,
        RegB,
        HI,
        LO,
        MemtoReg,
        MemtoRegMUXOut
    );
    
    aluToPc BranchCtrlMUX(
        LTGTORtoBranchMUX,
        LT,
        ZeroULA,
        GT,
        BranchCtrl,
        BranchCtrlMUXOut
    );

    aToAlu ALUSrcAMUX(
        PCOut,
        RegA,
        ALUSrcA,
        ALUSrcAMUXOut
    );

    aToReg_desloc EntryCtrlMUX(
        RegA,
        RegB,
        IR15_0,
        EntryCtrl,
        EntryCtrlMUXOut
    );

    bToAlu ALUSrcBMUX(
        RegB,
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

    hi HICtrlMUX(
        Div,
        Mult,
        DivMultCtrl,
        HiCtrlMUXOut
    );

    irToReg RegDstMUX(
        IR20_16,
        IR15_0[15:11],
        IR25_21,
        RegDst,
        RegDstMUXOut
    );

    lo LOCtrlMUX(
        Div,
        Mult,
        multCtrl,
        LOCtrlMUXOut
    );

    mdaToSign32_5 ReduceCtrlMUX(
        MDROut,
        RegB,
        RdcCtrl,
        ReduceCtrlMUXOut
    );

    overflowToControl_unit IgnoreMUX(
        Overflow,
        ignore,
        IgnoreMUXOut
    );

    pcToMem IorDMUX(
        PCOut,
        RD,
        AluOut,
        IorD,
        IorDMUXOut
    );

    sign32_5ToReg_desloc ShiftCtrlMUX(
        se32_5,
        IR15_0[10:6],
        ShiftCtrl,
        ShiftCtrlMUXOut
    );

    wcToMem WriteDataCtrlMUX(
        RegB,
        WordCrackerOUT,
        WriteDataCtrl,
        WriteDataCtrlMUXOutj
    );

    /* MemControl MemControlMUX(
        IorDMUXOut,
        WriteDataCtrlMUXOut,
        MemWrite_Read,
        MemControlMUXOut
    ); */



    /* hi HIReg(
        HiCtrlMUXOut,
        HiCtrl,
        HI
    );

    lo LOReg(
        LOCtrlMUXOut,
        LoCtrl,
        LO
    ); */

    Registrador HiReg(
        clock,
        reset,
        HiCtrl,
        HiCtrlMUXOut,
        HI
    );

    Registrador LOReg(
        clock,
        reset,
        LoCtrl,
        LOCtrlMUXOut,
        LO
    );

    Load LoadSizeReg(
        MDROut,
        LoadControl,
        LoadSize
    );

    shiftLeft2up ShifLeftCIMA( // na parte de cima do circuito
        {IR25_21, IR20_16, IR15_0}, // 25_0
        PCOut[31:28],
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

    signExtend_8x32 SE8_32Reg(
        MDROut[7:0], // mdr aqui eh so 8 bits
        SE8_32
    );

    signExtend_16x32 SE16_32Reg(
        IR15_0,
        SE16_32
    );

    signExtend_32x5 SE32_5Reg(
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
        .MultCtrl(MultCtrl),

        .reset_out(reset_out)
    );

endmodule 