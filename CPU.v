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
wire MemWrite; 
wire IRwrite; 
wire RegWrite; 

// sinais de escolha de fonte de dados
wire PCSource [3:0];
wire ALUSrcA [1:0];
wire ALUsrcB [3:0];
wire IorD [5:0];
wire RegDst [2:0];
wire MemtoReg [3:0];

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

// excecoes
wire Ignore [1:0];
wire Overflow;

// Os proximos fios nomeei a partir de onde saem e pra onde vao

// PC
wire PCtoMUX [31:0];
// PCtoShift left (concatena)

//Memory
wire MemDatatoIR [31:0];
wire MemDatatoMDR [31:0];

// IR
wire IR31_26toShiftLeft [5:0];
wire IR25_21toMUXReg [4:0];
wire IR25_21toShiftLeft [4:0];
wire IR25_21toReg [4:0];
wire IR20_16toShiftLeft [4:0];
wire IR20_16toReg [4:0];
wire IR20_16toMUXReg [4:0];
wire IR10_16toMUXRD [4:0];
wire IR15_0toSingExtend [15:0];
wire IR15_0toMUXReg [15:0];
wire IR15_0toALUControl [15:0];
wire IR15_0toShiftLeft [15:0];
wire IR15_0toMUXRD [15:0];

// Registradores - Falta a quantidade de bits
wire ReadData1toA [15:0];
wire ReadData2toB [15:0]; 

// Registrador A
wire AtoALUSrcA [15:0]; // nao tenho ctz da qtd de bits
wire AtoEntryCtrl [15:0];
wire AtoDiv [15:0];
wire AtoMult [15:0];

// Registrador B 
wire BtoALUSrcB [15:0];
wire BtoDiv [15:0];
wire BtoMult [15:0];
wire BtoRdcCtrlMUX [31:0];
wire BtoEntryCtrlMUX [15:0];
wire BtoWriteDataCtrlMUX [31:0]; 

// ULA
wire ALUtoALUOut [31:0];
wire ZerotoBranchMUX;
wire ZerotoALUOR;
wire LTtoSignExtend;
wire LTtoALUOR;
wire GTtoALUPCOR; // esse ta usando o mesmo fio do diagrama, verificar se ta certo
wire GTtoBranchMUX;


// MDR
wire MDRtoWordCracker [31:0];
wire MDRtoSignExtend [7:0];
wire MDRtoLoadSize [31:0]; // nao tenho ctz
wire MDRtoMemtoRegMUX [31:0];
wire MDRtoRdcCtrlMUX [31:0];

// Word Cracker
wire WCtoWriteDataCtrlMUX; // nao lembro qtos bits

// Load Size
wire LoadSizetoMemtoRegMUX [31:0];

//Registrador de Deslocamento
wire RDtoMemtoRegMUX [31:0];
wire RDtoIorDMUX [31:0];

// DIV
wire DivtoMultCtrlMUX [31:0];
wire DivtoDivCtrlMUX [31:0];

// MULT
wire MulttoMultCtrlMUX [31:0];
wire MulttoDivCtrlMUX [31:0];

// AluOut:
wire ALUOuttoPCSourceMUX [31:0];
wire ALUOuttoMemtoRegMUX [31:0]; 

// EPC: 
wire EPCtoPCSourceMUX [31:0]; // não tenho ctz 

// PC:
wire PCtoEND [31:0];

// DIV: 
wire DivtoDivCtrlMUX [31:0];
wire DivtoMultCtrlMUX [31:0];

// Mult:
wire MulttoDivCtrlMUX [31:0];
wire MulttoMultCtrlMUX [31:0]; 

// HI/LO:
wire HItoMemtoRegMUX; // nao lembro a qtd de bits 
wire LOtoMemtoRegMUX; 

// SHIFTLEFT:
wire SLtoAluSrcBMUX [31:0];
wire SLtoPCSourceMYX [31:0];

// END:
wire ENDtoEPC [31:0]; // nao tenho ctz 

// SignExtend(16 - 32):
wire SE16_32toALUsrcB [31:0];
wire SE16_32SL [31:0];

// SignExtend (1 - 32);
wire SE1_32toMemtoRegMUX [31:0];

// SignExtend (8-32);
wire SE8_32toPCSource [31:0];

------------------------------
// MUXES:
// IorD:
wire IorDMUXtoMem [31:0];

// WriteDataCtrlMUX:
wire WriteDataCtrlMUXtoMem [31:0] // nao tenho ctz;

// RegDst;
wire RegDstMUXtoReg [5:0];

// MemtoReg;
wire MemtoRegMUXtoIR [31:0]; 

// ReduceCtrl:
wire ReduceCtrlMUXto32_5 [31:0];

// ShiftCtrl:
wire ShiftCtrlMUXtoRD [15:0];

// EntryCtrl:
wire EntryCtrlMUXtoRD [15:0];

// Div/MultCtrl:
wire DivCtrlMUXtoHI;
wire MultCtrlMUXtoLO; 

// ALUSrcA/B:
wire ALUSrcAMUXtoALU;
wire ALUSrcBMUXtoALU;

// PCSource:
wire PCSourceMUXtoPC [31:0];

// BranchControl:
wire BranchCtrlMUXtoWriteCondAND;

// Ignore:
wire IgnoreMUXtoUC; 

// Registradores padrão
wire [31:0] reg253; // check how many bits this register has
wire [31:0] reg254;
wire [31:0] reg255;
wire [31:0] reg31;
wire [31:0] reg29;
wire [31:0] reg227;


// portas logicas
//         .
//         .


// modulos 