# Renesas V850E2S (CSW30)

## Operações
|Código(MSB)|Instrução|Funcionalidade|
|---|---|---|
|0000|NOP||
|0001|???||
|0010|ADD imm7, reg2|GR[reg2] + sign-extend(imm7) -> GR[reg2]|
|0011|ADD imm7, reg2|GR[reg2] + GR[reg1] -> GR[reg2]|
|0100|SUB reg1, reg2|GR[reg2] - GR[reg1] -> GR[reg2]|
|0101|SUBR reg1, reg2|GR[reg1] - GR[reg2] -> GR[reg1]|
|0110|MUL imm7, reg2, reg3|GR[reg2] * sign-extend(imm7) -> GR[reg3]|
|0111|MUL reg1, reg2, reg3|GR[reg2] * GR[reg1] -> GR[reg3]|
|1000|CMP imm7, reg2|GR[reg2] - sign-extend(imm7) -> result|
|1001|CMP reg1, reg2|GR[reg2] - GR[reg1] -> result|
|1010|MOV imm7, reg2|sign-extend(imm7) -> GR[reg2]|
|1011|MOV reg1, reg2|GR[reg1] -> GR[reg2]|
|1100|LD.W disp7[reg1], reg2|1- GR[reg1] + sign-extend(disp7) -> addr/2- loadmem(addr,Word) -> GR[reg2]|
|1101|ST.W reg2, disp7[reg1]|1- GR[reg1] + sign-extend(disp7) -> addr/2- storemem(addr,GR[reg2],Word)|
|1110|Bcond disp7|disp7 + PC -> PC (se cumprir as condições)|
|1111|JMP disp7[reg1]|disp7 + GR[reg1] -> PC|
>A instrução de jump (JMP) não foi implementada do mesmo jeito que está descrito no datasheet do processador

## Formatos OPCODE:
1. NOP
```
00000000000000000
```
2. ADD imm7, reg2
```
0010iiiiiii000RRR

    i - imm7
    R - reg2
```
3. ADD reg1, reg2
```
00110000000rrrRRR

    r - reg1
    R - reg2
```
4. SUB reg1, reg2
```
01000000000rrrRRR

    i - imm7
    R - reg2
```
5. SUBR reg1, reg2
```
01010000000rrrRRR

    r - reg1
    R - reg2
```
6. MUL imm7, reg2, reg3
```
0110iiiiiiirrrRRR

    i - imm7
    r - reg2
    R - reg3
```
7. MUL reg1, reg2, reg3
```
01110000gggrrrRRR

    g - reg1
    r - reg2
    R - reg3
```
8. CMP imm7, reg2
```
1000iiiiiii000RRR

    i - imm7
    R - reg2
```
9. CMP reg1, reg2
```
10010000000rrrRRR

    r - reg1
    R - reg2
```
10. MOV imm7, reg2
```
1010iiiiiii000RRR

    i - imm7
    R - reg2
```
11. MOV reg1, reg2
```
10110000000rrrRRR

    r - reg1
    R - reg2
```
12. LD.W disp7[reg1], reg2
```
1100dddddddrrrRRR

    d - disp7
    r - reg1
    R - reg2
```
13. ST.W reg2, disp7[reg1]
```
1101dddddddrrrRRR

    d - disp7
    r - reg1
    R - reg2
```
14. Bcond disp7
```
1110ddddddd000bbb

    d - disp7
    b - tipo de Branch
```
#### Tipos de condições
- BE (Branch if Equal): bbb = 000
  - verifica se flag zero = 1
- BNE (Branch if Not Equal): bbb = 001
  - verifica se flag zero = 0
- BL (Branch if Lower): bbb = 010
  - verifica a flag carry = 1
- BNL (Branch if Not Lower): bbb = 011
  - verifica se flag carry = 0
- BN (Branch if Negative): bbb = 100
  - verifica se flag negativo = 1
- BP (Branch if Positive): bbb = 101
  - verifica se flag negativo = 0
15. JMP disp7[reg1]
```
1111ddddddd000000

    d - disp7
```
>Como não foi implementado 100% igual, o reg1 fica setado para o R0, fazendo com que somente o disp7 seja efetivamente o tamanho do desvio

## Registradores
|Renesas V850E2S|Registradores desse processador|
|---|---|
|r0|r0 (000)|
|r6|r1 (001)|
|r7|r2 (010)|
|r8|r3 (011)|
|r9|r4 (100)|
|r10|r5 (101)|
|r11|r6 (110)|
|r12|r7 (111)|

>No Renesas V850E2S, o r2 pode ser também utilizado, mas tem operações do sistema que utilizam o mesmo, então deixamos ele de lado
