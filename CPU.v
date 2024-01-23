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
wire RegDst [4:0];
wire MemtoReg [6:0];

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


// portas logicas
//         .
//         .
//         .


// modulos 