// alforítmo da multiplicação binária sinalidade de Booth
//  realiza corretamente a multiplicacao de dois numeros binarios de 32 bits, com sinal
//  retorna o resultado da multiplicacao, um número de 64 bits, também com sinal
// são precisos 32 ciclos pra realizar essa operação -> aceito até 40 ciclos

// input [31:0] a, b;
// input clk, rst; (globais)
// output [63:0] mult;

// o reset deve limpar todos os registradores internos do multiplicador, inclusive registradores temporários e os registradores de resultado
// é importante que haja uma comunicaçã bidirecional entre a unidade de controle e o multiplicador, para que a unidade de controle possa controlar o multiplicador e o multiplicador possa informar a unidade de controle sobre o fim da operação

//  mult rs, rt: realiza a multiplicação entre rs e rt, armazenando internamente (em dois registradores próprios - hi e lo?) o resultado
// mfhi rd: copia a parte alta do resultado da multiplicação (32 bits mais significativos) para o registrador rd
// mflo rd: copia a parte baixa do resultado da multiplicação (32 bits menos significativos) para o registrador rd

// importante: o resultado da multiplicação inteira deve ser armazenado em dois registradores de 32 bits, hi e lo. O HI deve conter os 32 bits mais signiifcativos e o LO os 32 bits menos significativos

// utilizar um contador para controlar o número de ciclos?

// algorítmo de booth:
// 1. inicializa o multiplicador (multiplier) com o número que vc deseja multiplicar
// 2. inicializa o acumulador (acc) com 0
// 3. verificar o bit menos significativo do multiplicador (leastBit_multiplier)
//  se multiplier[0] e leastBit_multiplier são 00 ou 11, então n faça nada
//  se multiplier[0] e leastBit_multiplier são 01, então acc = acc - multiplicando
//  se multiplier[0] e leastBit_multiplier são 10, então acc = acc + multiplicando

// 4. sra (>>) no multiplicador (multiplier), no acumulador (acc) e no leastBit_multiplier pra direita
// isso significa que o bit mais significativo de acc é copiado para o bit mais significativo da nova acc, o bit menos significativo de acc é copiado para o bit mais significativo de multiplier e o bit menos significativo de multiplier é copiado para o bit mais significativo de leastBit_multiplier

// repete 3 e 4 até que o contador, inicializado inicialmente com o número de bits do multiplicador, seja 0
// complemento de dois de A transforma subtracao em adicao que eh menos custosa para o HW
// O complemento de dois de um número binário é obtido invertendo todos os bits do número (o que é chamado de complemento de um) e então adicionando um ao resultado. Quando você adiciona um número e seu complemento de dois, você obtém zero, o que é exatamente o que você quer quando está subtraindo um número de si mesmo.
//  em vez de subtrair A do acumulador, o algoritmo de Booth adiciona o complemento de dois de A ao acumulador. Isso tem o mesmo efeito que a subtração, mas é mais fácil de implementar em hardware
`timescale 1ns/1ps
`timescale 1ns / 1ps
module mult (
  input wire [31:0] A, B,
  input wire clk, start, rst,
  output reg [31:0] HI, LO
);

  reg [31:0] multiplier; // multiplicador
  reg [31:0] acc; // acumulador
  reg leastBit_multiplier; // bit menos significativo do multiplicador multiplier
  reg [5:0] counter; // inicializado com 32, decrementado a cada ciclo -> quando chegar em 0, a multiplicação terminou
  reg [31:0] complementoB; // usado na subtracao do passo 3 (acc = acc - multiplicando)

  // Always block para a lógica do multiplicador
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      multiplier <= 32'd0;
      acc <= 32'd0;
      leastBit_multiplier <= 1'b0;
      counter <= 6'd0;
      HI <= 32'd0;
      LO <= 32'd0;
    end 
    else begin
      if (start) begin
        multiplier <= A;
        acc <= 32'd0;
        leastBit_multiplier <= 1'b0;
        counter <= 6'd32;
        complementoB <= ~B + 1;
        HI <= 32'd0;
        LO <= 32'd0;
      end 
      else if (counter > 6'd0) begin
        if (multiplier[0] == 1'b0 && leastBit_multiplier == 1'b1)
          acc <= acc + B;
        else if (multiplier[0] == 1'b1 && leastBit_multiplier == 1'b0)
          acc <= acc + complementoB;

        {acc, multiplier, leastBit_multiplier} <= {acc, multiplier, leastBit_multiplier} >> 1;  // concatenando os valores de acc, multiplier e leastBit_multiplier em um único valor binário, realizando um deslocamento à direita nesse valor e, em seguida, atribuindo os resultados de volta a Acc, A, leastBit_multiplier
        
        counter <= counter - 6'd1;

        if (acc[31] == 1'b1) 
          acc[31] <= 1'b0; 
      end
    end
  end

  //tratamento de overflow?

  // Atribui valores a HI e LO
  always @(*) begin
    if (counter == 6'd0) begin
      HI <= acc;
      LO <= multiplier;
    end
  end

endmodule
