I) Componentes:

Unidade de Processamento	


Descrição das Entidades	


Load size	


Store size	


Controlador	


The box	


The box 


Mult	


Div	


Registrador PC	


Registrador Address RG	


Registrador EPC	


Registrador A	


Registrador B	


Registrador ALUOut	


Registrador MDR (Memory Data Register)	


Registrador High	


Registrador Low	




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

III) Descrição das Operações e dos Estados de Controle:

Modelo:


Instrução: ADDI e ADDIU


Objetivo: Faz o cálculo da soma do immediate estendido para 32 bits com o valor armazenado no registrador A. A diferença entre os dois é que o ADDIU ignora exceção de overflow.


Funcionamento: O valor que está armazenado no registrador A passa para a ALU e vai ser somado com o IMMEDIATE após esse passar pelo sign extend e passar a ter 32 bits. O resultado vai sair da ALU e ser gravado em ALUOut para no próximo ciclo ser armazenado no registrador rt.
Descrição do estado: O valor de IMMEDIATE é direcionado até o SignExtend (16 para 32 bits). Esse valor e o valor do registrador A são direcionados à ULA, que estará com a operação 001 (soma) e esse valor é salvo em ALUOut. No caso do ADDI, no próximo clock, será feita uma análise para descobrir se a soma deu overflow; caso não, o valor é escrito em RT com Reg_WR = 1. 
