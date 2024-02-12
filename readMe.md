I) Componentes:

Memory OK


Registrador IR OK


Registrador de Deslocamento OK


CPU


Registrador PC	


mux 1


mux 2


mux 3


mux 4


mux 5


mux 6


mux 7


mux 8


mux 9


mux 10


mux 11


mux 12


mux 13


Registrador MDR (Memory Data Register)


Word Cracker


Sign Extend 8-32


ok Registers


Registrador A	


Registrador B	


Load size	


Store size	


Control Unit


ok ALU


ALU Out


Mult	


Div	


Registrador EPC	


Registrador High	


Registrador Low	


Shift Left 2


ALU Control


Sign extend reverse 32-5


-----------------------

II) Instruções:

https://drive.google.com/file/d/1IJCvickKM6niHK258HWu5_G05WjWhzXH/view - pág 7

1. Operações do tipo R:


add

and

div


mult


jr


mfhi


mflo


sll


sllv


slt


sra


srv


srl


sub


break


rte


xchg

2. Operações do tipo I:

addi


addiu


beq


bne


ble


bgt


sram


lb


lw


lui


sb


sh


slti


sw

3. Operações do tipo J:

j 


jal

-------------------------

III) Descrição das Operações e dos Estados de Controle:

Modelo:


Instrução: ADDI e ADDIU


Objetivo: Faz o cálculo da soma do immediate estendido para 32 bits com o valor armazenado no registrador A. A diferença entre os dois é que o ADDIU ignora exceção de overflow.


Funcionamento: O valor que está armazenado no registrador A passa para a ALU e vai ser somado com o IMMEDIATE após esse passar pelo sign extend e passar a ter 32 bits. O resultado vai sair da ALU e ser gravado em ALUOut para no próximo ciclo ser armazenado no registrador rt.
Descrição do estado: O valor de IMMEDIATE é direcionado até o SignExtend (16 para 32 bits). Esse valor e o valor do registrador A são direcionados à ULA, que estará com a operação 001 (soma) e esse valor é salvo em ALUOut. No caso do ADDI, no próximo clock, será feita uma análise para descobrir se a soma deu overflow; caso não, o valor é escrito em RT com Reg_WR = 1. 
